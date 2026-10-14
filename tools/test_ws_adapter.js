// 单测 main.js 里的 wrapSocket 适配器 —— 这是方案 B 服务端唯一的新逻辑，
// 也是"LabCtrl.js 能一行不改"的全部依据。它一错，7 个命令全废但不报错。
//
// 不启动 Electron（main.js 一 require('electron') 就炸），改为把 wrapSocket
// 源码从 main.js 里切出来 eval —— 和 test_patch_c2_ws.js 同一个套路。
//
// 用法: node tools/test_ws_adapter.js
const fs = require('fs');
const path = require('path');
const { EventEmitter } = require('events');

const root = path.join(__dirname, '..');
const CONSTANTS = require(path.join(root, 'piupiupiu-Server', 'app', 'app', 'assets', 'js', 'Constants.js'));

// ---- 切出 wrapSocket ----
const src = fs.readFileSync(path.join(root, 'piupiupiu-Server', 'app', 'main.js'), 'utf8');
const start = src.indexOf('function wrapSocket(wsConn) {');
if (start < 0) { console.error('FAIL: 找不到 wrapSocket'); process.exit(1); }
const end = src.indexOf('\n}\n', start);
eval(src.slice(start, end + '\n}\n'.length));

let pass = 0, fail = 0;
function check(name, cond, extra) {
  if (cond) { pass++; console.log('  PASS  ' + name); }
  else { fail++; console.log('  FAIL  ' + name + (extra ? '  -> ' + extra : '')); }
}

// ---- 假的 ws 连接：只实现适配器用到的 readyState/send/close + 事件 ----
function makeFakeConn() {
  const conn = new EventEmitter();
  conn.readyState = 1;
  conn.sent = [];
  conn.send = (s) => { conn.sent.push(s); };
  conn.closed = false;
  conn.close = () => { conn.closed = true; };
  return conn;
}

console.log('[*] wrapSocket 适配器单测');
console.log('');

// ---------- 1. 下行：LabCtrl 的旧写法 emit(ORDER, {order:X, ...}) ----------
{
  const conn = makeFakeConn();
  const socket = wrapSocket(conn);
  // LabCtrl 实际就是这样调的：统一走 ORDER 事件，命令码藏在 payload.order 里
  socket.emit(CONSTANTS.order, { order: 'k7f2qa', extra: 'camList' });

  check('emit 发出了 1 条帧', conn.sent.length === 1, JSON.stringify(conn.sent));
  const frame = JSON.parse(conn.sent[0]);

  check('帧类型 = 命令码本身', frame[CONSTANTS.frameType] === 'k7f2qa', JSON.stringify(frame));
  check('载荷保留了 extra', frame[CONSTANTS.framePayload].extra === 'camList', JSON.stringify(frame[CONSTANTS.framePayload]));
  check('载荷里已剔除 order 字段（去特征）', !('order' in frame[CONSTANTS.framePayload]), JSON.stringify(frame[CONSTANTS.framePayload]));
  check('线上不含字面量 "order"', !conn.sent[0].includes('order'), conn.sent[0]);
}

// ---------- 2. 下行：不带 order 的普通 emit ----------
{
  const conn = makeFakeConn();
  const socket = wrapSocket(conn);
  socket.emit('c2h6vn', { hello: 1 });
  const frame = JSON.parse(conn.sent[0]);
  check('普通 emit: 帧类型直接取 type', frame[CONSTANTS.frameType] === 'c2h6vn');
  check('普通 emit: 载荷原样透传', frame[CONSTANTS.framePayload].hello === 1);
}

// ---------- 3. 上行：按帧类型路由到监听器 ----------
{
  const conn = makeFakeConn();
  const socket = wrapSocket(conn);
  let got = null;
  socket.on('m3b8tz', (data) => { got = data; });

  conn.emit('message', JSON.stringify({ t: 'm3b8tz', x: { files: ['a', 'b'] } }));
  check('上行帧路由到对应命令码的监听器', got !== null);
  check('监听器收到的是载荷本身（不含 t/x 外壳）', got && got.files && got.files.length === 2, JSON.stringify(got));
}

// ---------- 4. 二进制兼容：base64 自动还原成 Buffer ----------
{
  // LabCtrl 里写的是 new Uint8Array(data.buffer) / fs.outputFile(path, data.buffer)，
  // 两者都要求 data.buffer 是 Buffer/类数组，不能是字符串。
  const conn = makeFakeConn();
  const socket = wrapSocket(conn);
  let got = null;
  socket.on('k7f2qa', (data) => { got = data; });

  const orig = Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]); // PNG 头
  conn.emit('message', JSON.stringify({ t: 'k7f2qa', x: { image: true, buffer: orig.toString('base64') } }));

  check('二进制字段被还原成 Buffer', got && Buffer.isBuffer(got.buffer), typeof (got && got.buffer));
  check('还原后字节完全一致', got && got.buffer && Buffer.compare(got.buffer, orig) === 0);
  check('new Uint8Array(buffer) 可用（LabCtrl 摄像头分支依赖）',
    got && got.buffer && new Uint8Array(got.buffer)[0] === 0x89);
}

// ---------- 5. removeAllListeners ----------
{
  const conn = makeFakeConn();
  const socket = wrapSocket(conn);
  let calls = 0;
  socket.on('s9d4wx', () => { calls++; });

  conn.emit('message', JSON.stringify({ t: 's9d4wx', x: {} }));
  check('注销前有回调', calls === 1, 'calls=' + calls);

  socket.removeAllListeners('s9d4wx');
  conn.emit('message', JSON.stringify({ t: 's9d4wx', x: {} }));
  check('removeAllListeners 后不再回调', calls === 1, 'calls=' + calls);
}

// ---------- 6. 异常输入不能把进程带崩 ----------
{
  const conn = makeFakeConn();
  const socket = wrapSocket(conn);
  socket.on('aaa', () => { throw new Error('boom'); });
  let crashed = false;
  try {
    conn.emit('message', 'not json at all');
    conn.emit('message', JSON.stringify({ x: 1 }));        // 缺 t
    conn.emit('message', JSON.stringify({ t: 'aaa', x: null })); // 监听器抛异常
  } catch (e) { crashed = true; }
  check('非法/残缺帧与监听器异常均被吞掉', !crashed);
}

// ---------- 7. 断线后 emit 不应抛异常 ----------
{
  const conn = makeFakeConn();
  const socket = wrapSocket(conn);
  let threw = false;
  conn.readyState = 3; // CLOSED
  try { socket.emit('k7f2qa', {}); } catch (e) { threw = true; }
  check('连接关闭时 emit 静默丢弃', !threw && conn.sent.length === 0);
}

console.log('');
console.log('结果: PASS ' + pass + ' / FAIL ' + fail);
process.exit(fail === 0 ? 0 : 1);
