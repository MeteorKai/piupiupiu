/* lab-test-main.js —— 用真实 Electron 渲染 lab.html，复现「输出终端挡住文件列表」问题
 *
 * 做法：完整的 main 进程外壳，伪造 victim socket（接口与 main.js 的 makeRestVictim 一致），
 * 脚本化投递一份 /storage/emulated/0/ 的文件列表，然后量测几何关系 + 截图。
 *
 * 运行：
 *   electron.exe lab-test-main.js
 * 产物：shots/report.json  shots/fm-*.png  shots/flows.log
 */
const { app, BrowserWindow } = require('electron');
const fs = require('fs');
const path = require('path');

const APP_DIR = 'F:/piupiupiu/piupiupiu-Server/app';
const OUT = 'F:/piupiupiu/tools/ui-check/shots';
fs.mkdirSync(OUT, { recursive: true });

const FLOWS = [];
function log(s) { FLOWS.push(`[${new Date().toISOString().slice(11, 23)}] ${s}`); }

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

// ---------- 伪造 victim：接口与 main.js 的 makeRestVictim 相同 ----------
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
      var frameType = type;
      var body = payload;
      if (payload && typeof payload === 'object' && payload.order) {
        frameType = payload.order;
        body = {};
        for (var k in payload) if (k !== 'order' && Object.prototype.hasOwnProperty.call(payload, k)) body[k] = payload[k];
      }
      log('emit -> ' + JSON.stringify({ t: frameType, x: body }));
      var self = api;
      if (frameType === 'm3b8tz' && body.op === 'ls') {           // fileManager
        setTimeout(function () { self._deliver('m3b8tz', scripted); }, 60);
      }
    },
    on: function (type, cb) { if (!handlers[type]) handlers[type] = []; handlers[type].push(cb); },
    removeAllListeners: function (type) { if (type) delete handlers[type]; else handlers = {}; },
    _deliver: function (type, payload) {
      var arr = handlers[type];
      if (!arr) { log('deliver: 无监听器 ' + type); return; }
      for (var i = 0; i < arr.length; i++) { try { arr[i](payload); } catch (e) { log('handler err: ' + e.message); } }
    },
    _touch: function () {}, _idle: function () { return false; }, _pop: function () { return null; },
  };
  return api;
}

// ---------- 页面内量测脚本 ----------
const MEASURE = `
(() => {
  const toR = (b) => ({ x: +b.x.toFixed(1), y: +b.y.toFixed(1), w: +b.width.toFixed(1), h: +b.height.toFixed(1), bottom: +b.bottom.toFixed(1) });
  const R = (sel) => { const e = document.querySelector(sel); return e ? toR(e.getBoundingClientRect()) : null; };
  const CS = (sel, prop) => { const e = document.querySelector(sel); return e ? getComputedStyle(e)[prop] : null; };

  const out = { viewport: { w: innerWidth, h: innerHeight, dpr: devicePixelRatio } };
  out.rects = {
    grid: R('.ui.grid'), rowHeader: R('.ui.grid > .row:nth-of-type(1)'),
    rowMenu: R('.ui.grid > .row:nth-of-type(2)'), rowContent: R('.ui.grid > .row:nth-of-type(3)'),
    column: R('.ui.grid > .row:nth-of-type(3) > .column'),
    outerSegment: R('div.ui.segment.full'), ngview: R('[ng-view]'),
    parent: R('#parent'), list: R('#parent .ui.list'),
    firstItem: R('#parent .item'), lastItem: (() => { const els = document.querySelectorAll('#parent .item'); return els.length ? toR(els[els.length-1].getBoundingClientRect()) : null; })(),
    logy: R('#logy'),
  };
  out.itemCount = document.querySelectorAll('#parent .item').length;
  out.computedHeights = {
    grid: CS('.ui.grid', 'height'), rowContent: CS('.ui.grid > .row:nth-of-type(3)', 'height'),
    parent: CS('#parent', 'height'), logy: CS('#logy', 'height'), body: CS('body', 'height'),
  };

  // 逐个 item：谁盖住了它（elementFromPoint 判定）
  const logy = document.querySelector('#logy');
  const covered = []; let idx = 0;
  for (const it of document.querySelectorAll('#parent .item')) {
    const b = it.getBoundingClientRect();
    if (b.bottom < 0 || b.top > innerHeight) { idx++; continue; }
    const cx = Math.min(Math.max(b.x + b.width / 2, 1), innerWidth - 1);
    const cy = Math.min(Math.max(b.y + b.height / 2, 1), innerHeight - 1);
    const top = document.elementFromPoint(cx, cy);
    const byLogy = !!(top && (top === logy || logy.contains(top)));
    if (byLogy || !(it.contains(top))) {
      covered.push({ i: idx, name: it.textContent.trim().slice(0, 30), byLogy,
        topEl: top ? (top.id || String(top.className).slice(0, 44)) : 'null' });
    }
    idx++;
  }
  out.coveredItems = covered;

  // 沿文件列中心线纵向扫描：每一段 y 的最上层元素（找覆盖区间）
  const px = out.rects.parent ? Math.round(out.rects.parent.x + 80) : 80;
  const scan = [];
  for (let y = 4; y < innerHeight; y += 12) {
    const el = document.elementFromPoint(px, y);
    scan.push(y + ':' + (el ? (el.id || (typeof el.className === 'string' && el.className.slice(0, 36)) || el.tagName) : 'null'));
  }
  out.scanColumnAtX = px; out.scan = scan;

  // 滚动信息
  const p = document.querySelector('#parent'); const l = logy;
  out.scroll = {
    docSH: document.documentElement.scrollHeight, docCH: document.documentElement.clientHeight,
    winY: window.scrollY,
    parent: p ? { sh: p.scrollHeight, ch: p.clientHeight, st: p.scrollTop, ov: getComputedStyle(p).overflowY } : null,
    logy: l ? { sh: l.scrollHeight, ch: l.clientHeight, ov: getComputedStyle(l).overflowY } : null,
  };

  // 重叠量（正值 = 重叠 px 数）
  const g = document.querySelector('.ui.grid').getBoundingClientRect();
  const lb = logy.getBoundingClientRect();
  const pb = p.getBoundingClientRect();
  out.overlap = {
    logy_vs_grid: +Math.max(0, Math.min(g.bottom, lb.bottom) - Math.max(g.top, lb.top)).toFixed(1),
    logy_covers_grid_bottom: +Math.max(0, g.bottom - lb.top).toFixed(1),
    parent_vs_logy: +Math.max(0, Math.min(pb.bottom, lb.bottom) - Math.max(pb.top, lb.top)).toFixed(1),
    parent_bottom_vs_grid_bottom: +(pb.bottom - g.bottom).toFixed(1),
  };
  return out;
})()
`;

async function main() {
  app.disableHardwareAcceleration();

  await app.whenReady();

  const child = new BrowserWindow({
    width: 600, height: 650,
    darkTheme: true, transparent: true, resizable: false, frame: false,
    show: false,
    webPreferences: { nodeIntegration: true },
  });
  child.webContents.victim = makeFakeVictim('ui-test-device');
  child.once('ready-to-show', () => child.show());

  const shots = [];
  async function shot(name) {
    try {
      const img = await child.webContents.capturePage();
      fs.writeFileSync(path.join(OUT, name), img.toPNG());
      shots.push(name);
      log('shot: ' + name);
    } catch (e) { log('shot 失败 ' + name + ': ' + e.message); }
  }

  const result = { steps: {} };

  await child.loadURL('file:///' + APP_DIR + '/app/lab.html');
  log('lab.html 已加载');
  await sleep(1000);

  // 点「File Manager」菜单项
  const clicked = await child.webContents.executeJavaScript(`
    (() => {
      const items = [...document.querySelectorAll('.ui.menu .item')];
      const names = items.map(el => el.textContent.trim().replace(/\\s+/g, ' '));
      const target = items.find(el => /File Manager/i.test(el.textContent));
      if (target) { target.click(); return { ok: true, names }; }
      return { ok: false, names };
    })()
  `);
  log('点击 File Manager: ' + JSON.stringify(clicked));
  await sleep(1600);                    // 等路由 + 列表投递 + 渲染

  await shot('fm-initial.png');
  result.steps.initial = await child.webContents.executeJavaScript(MEASURE);

  // 在 #parent 内部滚到底（模拟用户找下面的文件）
  const scrolled = await child.webContents.executeJavaScript(`
    (() => { const p = document.querySelector('#parent'); if (!p) return null;
      const before = p.scrollTop; p.scrollTop = p.scrollHeight;
      return { before, after: p.scrollTop, sh: p.scrollHeight, ch: p.clientHeight }; })()
  `);
  log('#parent 内滚动: ' + JSON.stringify(scrolled));
  await sleep(350);
  await shot('fm-parent-scrolled.png');
  result.steps.parentScrolled = await child.webContents.executeJavaScript(MEASURE);

  // 滚动整个文档
  const docScroll = await child.webContents.executeJavaScript(`
    (() => { const before = window.scrollY; window.scrollTo(0, document.documentElement.scrollHeight);
      return { before, after: window.scrollY, sh: document.documentElement.scrollHeight, ch: document.documentElement.clientHeight }; })()
  `);
  log('文档滚动: ' + JSON.stringify(docScroll));
  await sleep(350);
  await shot('fm-doc-scrolled.png');
  result.steps.docScrolled = await child.webContents.executeJavaScript(MEASURE);

  result.shots = shots;
  fs.writeFileSync(path.join(OUT, 'report.json'), JSON.stringify(result, null, 2));
  fs.writeFileSync(path.join(OUT, 'flows.log'), FLOWS.join('\n'));
  app.exit(0);
}

const guard = setTimeout(() => {
  log('超时保护触发');
  fs.writeFileSync(path.join(OUT, 'flows.log'), FLOWS.join('\n'));
  app.exit(2);
}, 30000);

main().catch((e) => {
  log('失败: ' + (e && e.stack || e));
  clearTimeout(guard);
  fs.writeFileSync(path.join(OUT, 'flows.log'), FLOWS.join('\n'));
  app.exit(1);
});
