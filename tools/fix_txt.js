// 把 PowerShell `*>` 写出的 UTF-16 文本转成 UTF-8 纯文本
// 用法: node tools/fix_txt.js <in> <out>
const fs = require('fs');
const inp = process.argv[2];
const outp = process.argv[3];
let buf = fs.readFileSync(inp);
let s;
if (buf.length >= 2 && buf[0] === 0xFF && buf[1] === 0xFE) {
  s = buf.toString('utf16le').slice(1);
} else if (buf.length >= 3 && buf[0] === 0xEF && buf[1] === 0xBB && buf[2] === 0xBF) {
  s = buf.toString('utf8').slice(1);
} else {
  s = buf.toString('utf8');
}
const lines = s.split(/\r?\n/).filter(l => l.trim() !== '');
fs.writeFileSync(outp, lines.join('\n'), 'utf8');
console.log('lines=' + lines.length);
