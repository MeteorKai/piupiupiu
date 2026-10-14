// 从 app.asar 抽取指定文件并与源码对比（一次性工具）
const fs = require('fs');
const path = require('path');

const ASAR = 'F:/piupiupiu/piupiupiu-Server/dist/win-unpacked/resources/app.asar';
const SRC_ROOT = 'F:/piupiupiu/piupiupiu-Server/app';
const OUT = 'F:/piupiupiu/tools/ui-check/asar-extract';

const targets = [
  'app/lab.html',
  'app/index.html',
  'app/assets/css/mystyle.css',
  'app/views/fileManager.html',
  'app/views/camera.html',
  'app/assets/js/Constants.js',
  'app/assets/js/controllers/LabCtrl.js',
  'app/assets/js/controllers/AppCtrl.js',
];

const fd = fs.openSync(ASAR, 'r');
const head = Buffer.alloc(16);
fs.readSync(fd, head, 0, 16, 0);
// 实测结构：@4 = header pickle 总大小；@12 = JSON 文本长度；JSON 从 16 开始；数据区 = 8 + @4
const headerPickleSize = head.readUInt32LE(4);
const headerJsonSize = head.readUInt32LE(12);
const jsonBuf = Buffer.alloc(headerJsonSize);
fs.readSync(fd, jsonBuf, 0, headerJsonSize, 16);
const json = JSON.parse(jsonBuf.toString('utf8'));
const DATA_BASE = 8 + headerPickleSize;

function lookup(p) {
  const parts = p.split('/').filter(Boolean);
  let node = json;
  for (const part of parts) {
    if (!node.files || !node.files[part]) return null;
    node = node.files[part];
  }
  return node.files ? null : node;
}

fs.mkdirSync(OUT, { recursive: true });
const report = [];
for (const t of targets) {
  const meta = lookup(t);
  if (!meta) { report.push(`${t}: asar 中不存在`); continue; }
  const buf = Buffer.alloc(meta.size);
  fs.readSync(fd, buf, 0, meta.size, DATA_BASE + parseInt(meta.offset, 10));
  const outPath = path.join(OUT, t.replace(/\//g, '__'));
  fs.writeFileSync(outPath, buf);

  const srcPath = path.join(SRC_ROOT, t);
  if (fs.existsSync(srcPath)) {
    const src = fs.readFileSync(srcPath);
    if (Buffer.compare(src, buf) === 0) {
      report.push(`${t}: 一致 (${meta.size}B)`);
    } else {
      // 找到首个差异字节
      let i = 0;
      while (i < Math.min(src.length, buf.length) && src[i] === buf[i]) i++;
      const lineNo = src.toString('utf8', 0, i).split('\n').length;
      report.push(`${t}: 不一致! 源码 ${src.length}B vs 打包 ${buf.length}B, 首差@byte ${i} (约第${lineNo}行)`);
      report.push('   源码: ' + JSON.stringify(src.toString('utf8', Math.max(0, i - 40), i + 80)));
      report.push('   打包: ' + JSON.stringify(buf.toString('utf8', Math.max(0, i - 40), i + 80)));
    }
  } else {
    report.push(`${t}: 源码不存在，已抽出`);
  }
}
fs.closeSync(fd);
const txt = report.join('\n');
console.log(txt);
fs.writeFileSync(path.join(OUT, '_compare.txt'), txt + '\n');
