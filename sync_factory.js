const fs = require('fs');
const path = require('path');

const srcSmali = 'F:/piupiupiu/_decode/smali/com/piupiupiu';
const srcManifest = 'F:/piupiupiu/_decode/AndroidManifest.xml';
const bases = [
  'F:/piupiupiu/piupiupiu-Server/app/app/Factory/piupiupiu',
  'F:/piupiupiu/piupiupiu-Server/dist/win-unpacked/resources/app.asar.unpacked/app/Factory/piupiupiu'
];

let count = 0;
function cpDir(src, dest) {
  fs.mkdirSync(dest, { recursive: true });
  for (const e of fs.readdirSync(src, { withFileTypes: true })) {
    const s = path.join(src, e.name);
    const d = path.join(dest, e.name);
    if (e.isDirectory()) cpDir(s, d);
    else { fs.copyFileSync(s, d); count++; }
  }
}

for (const b of bases) {
  const smaliDest = path.join(b, 'smali/com/piupiupiu');
  fs.mkdirSync(smaliDest, { recursive: true });
  cpDir(srcSmali, smaliDest);
  fs.copyFileSync(srcManifest, path.join(b, 'AndroidManifest.xml'));
  console.log('synced:', b);
}
console.log('copied smali files:', count);
