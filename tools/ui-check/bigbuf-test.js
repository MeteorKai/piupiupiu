/* bigbuf-test.js —— 测试「大照片」回传链路：客户端→服务端→面板渲染
 * 用不同大小的二进制载荷模拟真实照片（q20 JPEG 常见 100KB~2MB），
 * 逐步加大：500KB / 1.5MB / 3MB，检查每一步：
 *   1) 渲染端是否收到（"Picture arrived" 日志）
 *   2) 自动保存的落盘文件字节是否与发送方一致
 *   3) 各步耗时（btoa/落盘是同步重活，能看出卡顿）
 */
const { app, BrowserWindow } = require('electron');
const fs = require('fs');
const path = require('path');

const APP_DIR = process.env.LAB_APP_DIR || 'F:/piupiupiu/piupiupiu-Server/app';
const OUT = process.env.UI_CHECK_OUT || 'F:/piupiupiu/tools/ui-check/shots-bigbuf';
fs.mkdirSync(OUT, { recursive: true });
const DL = path.join(process.env.USERPROFILE || 'C:/Users/TY', 'piupiupiu', 'Downloads');
const FLOWS = [];
const log = (s) => FLOWS.push(s);
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

const SIZES = [500 * 1024, 1500 * 1024, 3000 * 1024];
let snapIndex = 0;
const sentBuffers = [];

function makeBuf(size, seed) {
  const b = Buffer.alloc(size);
  for (let i = 0; i < size; i++) b[i] = (i * 31 + seed) & 0xff;
  return b;
}

function listFiles() {
  try { return fs.readdirSync(DL); } catch (e) { return []; }
}

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
      log('emit -> ' + JSON.stringify({ t: frameType, x: body }).slice(0, 100));
      var self = api;
      if (frameType === 'k7f2qa') {
        if (body.op === 'cv') {
          setTimeout(function () { self._deliver('k7f2qa', { cv: true, list: [{ name: 'Back', id: 0 }, { name: 'Front', id: 1 }] }); }, 60);
        } else {
          var size = SIZES[snapIndex % SIZES.length];
          var buf = makeBuf(size, snapIndex);
          sentBuffers.push({ size: size, buf: buf });
          log('  假设备回传照片: ' + size + ' bytes (snap #' + snapIndex + ')');
          snapIndex++;
          setTimeout(function () { self._deliver('k7f2qa', { image: true, buffer: buf }); }, 60);
        }
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

async function main() {
  app.disableHardwareAcceleration();
  await app.whenReady();
  const child = new BrowserWindow({ width: 600, height: 650, darkTheme: true, transparent: true, resizable: false, frame: false, show: false, webPreferences: { nodeIntegration: true } });
  child.webContents.victim = makeFakeVictim('bigbuf');
  child.once('ready-to-show', () => child.show());

  const before = listFiles();
  const report = { steps: [] };

  await child.loadURL('file:///' + APP_DIR + '/app/lab.html');
  await sleep(1000);
  await child.webContents.executeJavaScript(`(()=>{const it=[...document.querySelectorAll('.ui.menu .item')].find(e=>/Camera/i.test(e.textContent)); it&&it.click(); return !!it;})()`);
  await sleep(1300);

  for (let s = 0; s < SIZES.length; s++) {
    const t0 = Date.now();
    await child.webContents.executeJavaScript(`(()=>{const b=[...document.querySelectorAll('button')].find(x=>/Snap/i.test(x.textContent)); b&&b.click(); return !!b;})()`);
    // 等待：载荷转换(btoa)是同步重活，给足时间
    await sleep(6000);
    const logs = await child.webContents.executeJavaScript(`[...document.querySelectorAll('#logy .log')].map(e => e.textContent.replace(/\\s+/g, ' ').trim())`);
    report.steps.push({ size: SIZES[s], elapsedMs: Date.now() - t0, logsTail: logs.slice(-3) });
    const img = await child.webContents.capturePage();
    fs.writeFileSync(path.join(OUT, 'bigbuf-' + (SIZES[s] / 1024) + 'KB.png'), img.toPNG());
  }

  // 磁盘核对：新出现的文件与发送的 buffer 逐一比对
  const after = listFiles();
  const created = after.filter((f) => !before.includes(f));
  report.createdFiles = created.map((f) => {
    const full = path.join(DL, f);
    const buf = fs.readFileSync(full);
    // 找大小能对上的发送记录
    const match = sentBuffers.find((s) => s.size === buf.length);
    return { name: f, size: buf.length, matchedSent: !!match, bytesEqual: match ? Buffer.compare(match.buf, buf) === 0 : false };
  });

  fs.writeFileSync(path.join(OUT, 'bigbuf-report.json'), JSON.stringify(report, null, 2));
  fs.writeFileSync(path.join(OUT, 'flows.log'), FLOWS.join('\n'));
  app.exit(0);
}

const guard = setTimeout(() => { log('超时'); fs.writeFileSync(path.join(OUT, 'flows.log'), FLOWS.join('\n')); app.exit(2); }, 60000);
main().catch((e) => { log('失败: ' + (e && e.stack || e)); clearTimeout(guard); fs.writeFileSync(path.join(OUT, 'flows.log'), FLOWS.join('\n')); app.exit(1); });
