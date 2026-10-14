// 列出 piupiupiu 面板产物目录，并输出每个 apk 的大小/修改时间
const fs = require('fs');
const path = require('path');
const os = require('os');

const dirs = [
  path.join(os.homedir(), 'piupiupiu'),
  path.join(os.homedir(), 'piupiupiu', 'Output'),
  path.join(os.homedir(), 'piupiupiu', 'Downloads'),
];

const out = [];
out.push('homedir() = ' + os.homedir());
for (const d of dirs) {
  out.push('');
  out.push('== ' + d + ' ==');
  if (!fs.existsSync(d)) { out.push('  (not exists)'); continue; }
  for (const n of fs.readdirSync(d)) {
    const p = path.join(d, n);
    const st = fs.statSync(p);
    out.push('  ' + (st.isDirectory() ? '[DIR] ' : '      ') + n +
      '  ' + st.size + ' B  ' + st.mtime.toISOString());
  }
}
fs.writeFileSync(__dirname + '\\_check_output.txt', out.join('\n'), 'utf8');
console.log('done');
