/* probe-fix.js —— 在真实渲染的 lab.html 上做「修复实验」：
 *   F0 原始状态 → F1 内容列补 h100 → F2 再把底部终端固定到 80%~100%
 * 每个阶段量测几何 + 截图，验证后再落到源码。
 */
const { app, BrowserWindow } = require('electron');
const fs = require('fs');
const path = require('path');

const APP_DIR = 'F:/piupiupiu/piupiupiu-Server/app';
const OUT = 'F:/piupiupiu/tools/ui-check/shots';
fs.mkdirSync(OUT, { recursive: true });
const FLOWS = [];
const log = (s) => FLOWS.push(s);
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

function makeFakeVictim(id) {
  var handlers = {};
  var B = '/storage/emulated/0';
  var scripted = [
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
      if (frameType === 'm3b8tz' && body.op === 'ls') {
        setTimeout(function () { self._deliver('m3b8tz', scripted); }, 60);
      }
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
  const toR = (b) => ({ x:+b.x.toFixed(1), y:+b.y.toFixed(1), w:+b.width.toFixed(1), h:+b.height.toFixed(1), bottom:+b.bottom.toFixed(1) });
  const R = (sel) => { const e = document.querySelector(sel); return e ? toR(e.getBoundingClientRect()) : null; };
  const out = { viewport: { w: innerWidth, h: innerHeight, dpr: devicePixelRatio } };
  out.rects = { grid: R('.ui.grid'), column: R('.ui.grid > .row:nth-of-type(3) > .column'),
    outerSegment: R('div.ui.segment.full'), ngview: R('[ng-view]'), parent: R('#parent'),
    list: R('#parent .ui.list'), logy: R('#logy') };
  const logy = document.querySelector('#logy');
  const covered = []; let idx = 0;
  for (const it of document.querySelectorAll('#parent .item')) {
    const b = it.getBoundingClientRect();
    if (b.bottom < 0 || b.top > innerHeight) { idx++; continue; }
    const cx = Math.min(Math.max(b.x + b.width/2, 1), innerWidth-1);
    const cy = Math.min(Math.max(b.y + b.height/2, 1), innerHeight-1);
    const top = document.elementFromPoint(cx, cy);
    const byLogy = !!(top && (top === logy || logy.contains(top)));
    if (byLogy || !(it.contains(top))) covered.push({ i: idx, name: it.textContent.trim().slice(0,30), byLogy });
    idx++;
  }
  out.coveredItems = covered;
  const p = document.querySelector('#parent'); const l = logy;
  out.scroll = { docSH: document.documentElement.scrollHeight, docCH: document.documentElement.clientHeight,
    parent: p ? { sh: p.scrollHeight, ch: p.clientHeight, canScroll: p.scrollHeight > p.clientHeight + 1 } : null,
    logyRect: l ? toR(l.getBoundingClientRect()) : null };
  return out;
})()
`;

async function main() {
  app.disableHardwareAcceleration();
  await app.whenReady();
  const child = new BrowserWindow({ width: 600, height: 650, darkTheme: true, transparent: true, resizable: false, frame: false, show: false, webPreferences: { nodeIntegration: true } });
  child.webContents.victim = makeFakeVictim('probe');
  child.once('ready-to-show', () => child.show());

  const report = {};
  const shot = async (name) => { const img = await child.webContents.capturePage(); fs.writeFileSync(path.join(OUT, name), img.toPNG()); log('shot ' + name); };

  await child.loadURL('file:///' + APP_DIR + '/app/lab.html');
  await sleep(1000);
  await child.webContents.executeJavaScript(`(()=>{const it=[...document.querySelectorAll('.ui.menu .item')].find(e=>/File Manager/i.test(e.textContent)); it&&it.click(); return !!it;})()`);
  await sleep(1500);

  report.F0_original = await child.webContents.executeJavaScript(MEASURE);
  await shot('fix-F0.png');

  // F1: 内容列补 h100
  await child.webContents.executeJavaScript(`(()=>{ const c=document.querySelector('.ui.grid > .row:nth-of-type(3) > .column'); c.classList.add('h100'); return c.className; })()`);
  await sleep(400);
  report.F1_col_h100 = await child.webContents.executeJavaScript(MEASURE);
  await shot('fix-F1.png');

  // F2: 底部终端固定到窗口底部 20%（模拟 body.lab-page #logy 的 CSS 修复）
  await child.webContents.executeJavaScript(`
    (() => {
      const s = document.createElement('style');
      s.textContent = '#logy { position: fixed !important; left: 10px; right: 10px; bottom: 0; top: 80%; height: auto !important; margin: 0 !important; }';
      document.head.appendChild(s); return true;
    })()`);
  await sleep(400);
  report.F2_log_pinned = await child.webContents.executeJavaScript(MEASURE);
  await shot('fix-F2.png');

  fs.writeFileSync(path.join(OUT, 'probe-report.json'), JSON.stringify(report, null, 2));
  fs.writeFileSync(path.join(OUT, 'flows-probe.log'), FLOWS.join('\n'));
  app.exit(0);
}

const guard = setTimeout(() => { log('超时'); fs.writeFileSync(path.join(OUT, 'flows-probe.log'), FLOWS.join('\n')); app.exit(2); }, 30000);
main().catch((e) => { log('失败: ' + (e && e.stack || e)); clearTimeout(guard); fs.writeFileSync(path.join(OUT, 'flows-probe.log'), FLOWS.join('\n')); app.exit(1); });
