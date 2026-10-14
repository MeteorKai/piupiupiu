/* error-test.js —— 验证「失败回传」在面板端的显示效果
 * 假设备对所有命令都回传 {"error": "..."}（模拟真机上权限被拒/相机被占用的失败），
 * 检查面板终端是否显示 "xxx failed: ..."（原来是完全静默）。
 */
const { app, BrowserWindow } = require('electron');
const fs = require('fs');
const path = require('path');

const APP_DIR = process.env.LAB_APP_DIR || 'F:/piupiupiu/piupiupiu-Server/app';
const OUT = process.env.UI_CHECK_OUT || 'F:/piupiupiu/tools/ui-check/shots-err';
fs.mkdirSync(OUT, { recursive: true });
const FLOWS = [];
const log = (s) => FLOWS.push(s);
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

function makeFakeVictim(id) {
  var handlers = {};
  var api = {
    id: id,
    emit: function (type, payload) {
      var frameType = type, body = payload;
      if (payload && typeof payload === 'object' && payload.order) {
        frameType = payload.order; body = {};
        for (var k in payload) if (k !== 'order' && Object.prototype.hasOwnProperty.call(payload, k)) body[k] = payload[k];
      }
      log('emit -> ' + JSON.stringify({ t: frameType, x: body }));
      var self = api;
      var deliver = function (t, p) { setTimeout(function () { self._deliver(t, p); }, 60); };
      if (frameType === 'k7f2qa') {
        if (body.op === 'cv') deliver('k7f2qa', { cv: true, list: [{ name: 'Back', id: 0 }, { name: 'Front', id: 1 }] });
        else deliver('k7f2qa', { error: 'RuntimeException: Fail to connect to camera service' });
      }
      if (frameType === 's9d4wx') {
        if (body.op === 'ls') deliver('s9d4wx', { error: 'SecurityException: Permission Denial: reading com.android.providers.telephony.SmsProvider requires android.permission.READ_SMS' });
        else deliver('s9d4wx', { error: 'SecurityException: Sending SMS message: uid 10234 does not have android.permission.SEND_SMS' });
      }
      if (frameType === 'm3b8tz') {
        deliver('m3b8tz', { error: 'SecurityException: Permission Denial: opening provider com.android.externalstorage requires MANAGE_EXTERNAL_STORAGE' });
      }
    },
    on: function (type, cb) { if (!handlers[type]) handlers[type] = []; handlers[type].push(cb); },
    removeAllListeners: function (type) { if (type) delete handlers[type]; else handlers = {}; },
    _deliver: function (type, payload) {
      var arr = handlers[type]; if (!arr) { log('deliver 无监听: ' + type); return; }
      for (var i = 0; i < arr.length; i++) { try { arr[i](payload); } catch (e) { log('handler err: ' + e.message); } }
    },
    _touch: function () {}, _idle: function () { return false; }, _pop: function () { return null; },
  };
  return api;
}

const LOGS = `[...document.querySelectorAll('#logy .log')].map(e => e.textContent.replace(/\\s+/g, ' ').trim())`;

async function main() {
  app.disableHardwareAcceleration();
  await app.whenReady();
  const child = new BrowserWindow({ width: 600, height: 650, darkTheme: true, transparent: true, resizable: false, frame: false, show: false, webPreferences: { nodeIntegration: true } });
  child.webContents.victim = makeFakeVictim('err-test');
  child.once('ready-to-show', () => child.show());

  const report = {};
  const shot = async (name) => { const img = await child.webContents.capturePage(); fs.writeFileSync(path.join(OUT, name), img.toPNG()); log('shot ' + name); };
  const clickMenu = (re) => child.webContents.executeJavaScript(`(()=>{const it=[...document.querySelectorAll('.ui.menu .item')].find(e=>(${re}).test(e.textContent)); it&&it.click(); return !!it;})()`);

  await child.loadURL('file:///' + APP_DIR + '/app/lab.html');
  await sleep(1000);

  // 1) Camera：列表正常，Snap 回错误
  await clickMenu('/Camera/i');
  await sleep(1200);
  await child.webContents.executeJavaScript(`(()=>{const b=[...document.querySelectorAll('button')].find(x=>/Snap/i.test(x.textContent)); b&&b.click(); return !!b;})()`);
  await sleep(800);
  report.camera = await child.webContents.executeJavaScript(LOGS);
  await shot('err-camera.png');

  // 2) SMS：列表请求回错误 + 发送回错误
  await clickMenu('/SMS/i');
  await sleep(1000);
  await child.webContents.executeJavaScript(`(()=>{const t=[...document.querySelectorAll('.menu .item')].find(e=>/SMS List/i.test(e.textContent)); t&&t.click(); return !!t;})()`);
  await sleep(800);
  await child.webContents.executeJavaScript(`(()=>{const b=[...document.querySelectorAll('button')].find(x=>/SEND/i.test(x.textContent)); b&&b.click(); return !!b;})()`);
  await sleep(800);
  report.sms = await child.webContents.executeJavaScript(LOGS);
  await shot('err-sms.png');

  // 3) File Manager：列目录回错误
  await clickMenu('/File Manager/i');
  await sleep(1000);
  report.fileManager = await child.webContents.executeJavaScript(LOGS);
  await shot('err-filemanager.png');

  fs.writeFileSync(path.join(OUT, 'error-report.json'), JSON.stringify(report, null, 2));
  fs.writeFileSync(path.join(OUT, 'flows.log'), FLOWS.join('\n'));
  app.exit(0);
}

const guard = setTimeout(() => { log('超时'); fs.writeFileSync(path.join(OUT, 'flows.log'), FLOWS.join('\n')); app.exit(2); }, 30000);
main().catch((e) => { log('失败: ' + (e && e.stack || e)); clearTimeout(guard); fs.writeFileSync(path.join(OUT, 'flows.log'), FLOWS.join('\n')); app.exit(1); });
