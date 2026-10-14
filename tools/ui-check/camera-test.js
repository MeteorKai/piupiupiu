/* camera-test.js —— camera 拍照/保存全流程实测
 * 步骤：打开 Lab → Camera → 假设备返回相机列表 → 点击 Snap（假设备返回一张真实 PNG）
 *       → 检查画面/保存按钮/日志 → 点击 Save → 检查日志与磁盘落盘 + 字节比对
 */
const { app, BrowserWindow } = require('electron');
const fs = require('fs');
const path = require('path');

const APP_DIR = process.env.LAB_APP_DIR || 'F:/piupiupiu/piupiupiu-Server/app';
const OUT = process.env.UI_CHECK_OUT || 'F:/piupiupiu/tools/ui-check/shots-camera';
const CAM_MODE = process.env.CAM_MODE || 'two';   // two | one | zero —— 模拟 双摄 / 单摄 / 无摄像头 设备
fs.mkdirSync(OUT, { recursive: true });
const DL = path.join(process.env.USERPROFILE || 'C:/Users/TY', 'piupiupiu', 'Downloads');

const PNG = fs.readFileSync(APP_DIR + '/app/assets/img/icon.png'); // 用真实 PNG 当“照片”载荷
const FLOWS = [];
const log = (s) => FLOWS.push(s);
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

function listDir(p) {
  try { return fs.readdirSync(p).map((f) => ({ f, size: fs.statSync(path.join(p, f)).size })); }
  catch (e) { return { err: e.message }; }
}

function makeFakeVictim(id) {
  var handlers = {};
  // 与真客户端 findCameraList 一致的顺序（按 camera id 排列）
  var camList = CAM_MODE === 'zero' ? []
              : CAM_MODE === 'one' ? [{ name: 'Back', id: 0 }]
              : [{ name: 'Back', id: 0 }, { name: 'Front', id: 1 }];
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
        if (body.op === 'cv') {
          deliver('k7f2qa', { cv: true, list: camList });
        } else if (body.op === 0 || body.op === 1) {
          log('  假设备拍照（op=' + body.op + '），回传 ' + PNG.length + ' 字节 PNG');
          deliver('k7f2qa', { image: true, buffer: PNG });
        } else {
          // 真客户端行为：op 缺失/非法时 getString 抛 JSONException → 命令被静默丢弃，不回任何包
          log('  [模拟真机] op 缺失/非法(' + JSON.stringify(body.op) + ')，客户端直接丢弃，无响应');
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

const SNAP_STATE = `
(() => {
  const logs = [...document.querySelectorAll('#logy .log')].map(e => e.textContent.replace(/\\s+/g, ' ').trim());
  const r = document.querySelector('.ui.red.ribbon.label');
  let ribbon = 'missing';
  if (r) { const b = r.getBoundingClientRect(); const cs = getComputedStyle(r);
    ribbon = { display: cs.display, visible: b.width > 0 && b.height > 0, x: +b.x.toFixed(1), y: +b.y.toFixed(1), w: +b.width.toFixed(1), h: +b.height.toFixed(1) }; }
  const img = document.querySelector('.ui.image img');
  const st = img ? { srcPrefix: (img.getAttribute('src') || '').slice(0, 34), naturalW: img.naturalWidth, naturalH: img.naturalHeight } : null;
  const dropdown = document.querySelector('select');
  // 最后一条日志是否完整落在终端可视区内（验证滚动修复）
  const lg = document.querySelector('#logy');
  const last = lg ? [...lg.querySelectorAll('.log')].pop() : null;
  let lastLog = null;
  if (lg && last) {
    const rb = last.getBoundingClientRect(), lb = lg.getBoundingClientRect();
    lastLog = {
      text: last.textContent.replace(/\\s+/g, ' ').trim().slice(0, 90),
      fullyVisible: rb.bottom <= lb.bottom + 0.5 && rb.top >= lb.top - 0.5,
      overflowBottomPx: +(rb.bottom - lb.bottom).toFixed(1),
      panelScroll: { top: lg.scrollTop, sh: lg.scrollHeight, ch: lg.clientHeight }
    };
  }
  return { logs, ribbon, img: st, dropdownValue: dropdown ? dropdown.value : null, lastLog };
})()
`;

async function main() {
  app.disableHardwareAcceleration();
  await app.whenReady();
  const child = new BrowserWindow({ width: 600, height: 650, darkTheme: true, transparent: true, resizable: false, frame: false, show: false, webPreferences: { nodeIntegration: true } });
  child.webContents.victim = makeFakeVictim('cam-test');
  child.once('ready-to-show', () => child.show());

  const report = { downloadDir: DL, before: listDir(DL) };
  const shot = async (name) => { const img = await child.webContents.capturePage(); fs.writeFileSync(path.join(OUT, name), img.toPNG()); log('shot ' + name); };

  await child.loadURL('file:///' + APP_DIR + '/app/lab.html');
  await sleep(1000);

  // 打开 Camera
  await child.webContents.executeJavaScript(`(()=>{const it=[...document.querySelectorAll('.ui.menu .item')].find(e=>/Camera/i.test(e.textContent)); it&&it.click(); return !!it;})()`);
  await sleep(1300);
  report.stepA_cameraList = await child.webContents.executeJavaScript(SNAP_STATE);
  await shot('cam-A-list.png');

  // 点击 Snap
  const clickSnap = await child.webContents.executeJavaScript(`(()=>{const b=[...document.querySelectorAll('button')].find(x=>/Snap/i.test(x.textContent)); if(b){b.click();return true;} return false;})()`);
  log('点击 Snap: ' + clickSnap);
  await sleep(900);
  report.stepB_snapped = await child.webContents.executeJavaScript(SNAP_STATE);
  await shot('cam-B-snapped.png');

  // 点击保存按钮（红色 ribbon）
  const clickSave = await child.webContents.executeJavaScript(`(()=>{const r=document.querySelector('.ui.red.ribbon.label'); if(r){r.click();return true;} return false;})()`);
  log('点击 Save: ' + clickSave);
  await sleep(1200);
  report.stepC_saved = await child.webContents.executeJavaScript(SNAP_STATE);
  await shot('cam-C-saved.png');

  // 磁盘核对
  report.after = listDir(DL);
  try {
    const beforeNames = (Array.isArray(report.before) ? report.before : []).map((x) => x.f);
    const created = (Array.isArray(report.after) ? report.after : []).filter((x) => !beforeNames.includes(x.f));
    report.createdFiles = created.map((c) => {
      const full = path.join(DL, c.f);
      const buf = fs.readFileSync(full);
      return { name: c.f, size: c.size, bytesMatchSourcePng: Buffer.compare(buf, PNG) === 0 };
    });
  } catch (e) { report.createdFiles = { err: e.message }; }

  fs.writeFileSync(path.join(OUT, 'camera-report.json'), JSON.stringify(report, null, 2));
  fs.writeFileSync(path.join(OUT, 'flows.log'), FLOWS.join('\n'));
  app.exit(0);
}

const guard = setTimeout(() => { log('超时'); fs.writeFileSync(path.join(OUT, 'flows.log'), FLOWS.join('\n')); app.exit(2); }, 30000);
main().catch((e) => { log('失败: ' + (e && e.stack || e)); clearTimeout(guard); fs.writeFileSync(path.join(OUT, 'flows.log'), FLOWS.join('\n')); app.exit(1); });
