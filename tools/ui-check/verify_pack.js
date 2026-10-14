/*
 * verify_pack.js — 发布包一致性校验（2026-10-14 新增）
 *
 * 背景：面板的 Build 流程直接用 dist/win-unpacked/resources/app.asar.unpacked/
 * 下的 Factory（Constants.js 里 path.join(...).replace("app.asar", "app.asar.unpacked")），
 * sync_factory.js 只覆盖「文件内容」。本工具用于打包后核对：
 *
 *   header  模式：解析 app.asar 头部清单，检查 Factory 关键 smali 是否在清单里
 *                （判断 asar 清单与 unpacked 目录是否同步）。
 *   compare 模式：按相对路径 + 大小 + md5 逐文件对比两个目录，验证发布目录与源目录一致。
 *
 * 用法：
 *   node verify_pack.js header  "<...>/dist/win-unpacked/resources/app.asar"
 *   node verify_pack.js compare "<...>/app/app/Factory" "<...>/dist/win-unpacked/resources/app.asar.unpacked/app/Factory"
 */
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

function parseAsarHeader(asarPath) {
  const fd = fs.openSync(asarPath, 'r');
  const head = Buffer.alloc(16);
  fs.readSync(fd, head, 0, 16, 0);
  // 实测结构：@4 = header pickle 总大小；@12 = JSON 文本长度；JSON 从 16 开始；数据区 = 8 + @4
  const jsonSize = head.readUInt32LE(12);
  const jsonBuf = Buffer.alloc(jsonSize);
  fs.readSync(fd, jsonBuf, 0, jsonSize, 16);
  fs.closeSync(fd);
  return JSON.parse(jsonBuf.toString('utf8'));
}

function walkAsar(node, prefix, out) {
  const files = node.files || {};
  for (const key of Object.keys(files)) {
    const f = files[key];
    const p = prefix + '/' + key;
    if (f.files) walkAsar(f, p, out);
    else out.push({ p: p, unpacked: !!f.unpacked });
  }
}

function headerMode(asarPath) {
  console.log('asar:', asarPath);
  let json;
  try {
    json = parseAsarHeader(asarPath);
  } catch (e) {
    console.log('!! asar 头部解析失败:', e.message);
    process.exit(2);
  }
  const all = [];
  walkAsar(json, '', all);
  const factory = all.filter((x) => x.p.indexOf('Factory/') >= 0);
  const smali = factory.filter((x) => x.p.indexOf('Factory/piupiupiu/smali/com/piupiupiu/') >= 0);
  console.log('asar 头部条目总数:', all.length);
  console.log('Factory 条目数:', factory.length, '（其中 unpacked 标记:', factory.filter((x) => x.unpacked).length, '）');
  console.log('Factory/piupiupiu/smali/com/piupiupiu 条目数:', smali.length);
  const names = ['AppConfig.smali', 'b.smali', 'b$1.smali', 'b$2.smali', 'd.smali', 'i.smali', 'f.smali'];
  for (const n of names) {
    const hit = smali.find((x) => x.p.endsWith('/' + n));
    console.log('   ' + n.padEnd(18) + (hit ? '在清单中' + (hit.unpacked ? '（unpacked）' : '（packed）') : '不在清单中'));
  }
}

function md5(p) {
  return crypto.createHash('md5').update(fs.readFileSync(p)).digest('hex');
}

function listFiles(root) {
  const out = [];
  (function w(dir, rel) {
    for (const name of fs.readdirSync(dir)) {
      const full = path.join(dir, name);
      const r = rel ? rel + '/' + name : name;
      const st = fs.lstatSync(full);
      if (st.isDirectory()) w(full, r);
      else out.push({ rel: r, size: st.size, hash: md5(full) });
    }
  })(root, '');
  return out;
}

function compareMode(a, b) {
  console.log('源目录  :', a);
  console.log('发布目录:', b);
  if (!fs.existsSync(a)) { console.log('!! 源目录不存在'); process.exit(2); }
  if (!fs.existsSync(b)) { console.log('!! 发布目录不存在'); process.exit(2); }
  const A = listFiles(a);
  const B = listFiles(b);
  const mA = new Map(A.map((x) => [x.rel, x]));
  const mB = new Map(B.map((x) => [x.rel, x]));
  const onlyA = A.filter((x) => !mB.has(x.rel)).map((x) => x.rel);
  const onlyB = B.filter((x) => !mA.has(x.rel)).map((x) => x.rel);
  const diff = [];
  for (const x of A) {
    const y = mB.get(x.rel);
    if (y && (y.size !== x.size || y.hash !== x.hash)) {
      diff.push(x.rel + '（源 ' + x.size + 'B vs 发布 ' + y.size + 'B）');
    }
  }
  console.log('文件数: 源 =', A.length, ' 发布 =', B.length);
  console.log('仅源有  :', onlyA.length, onlyA.slice(0, 12).join(', '));
  console.log('仅发布有:', onlyB.length, onlyB.slice(0, 12).join(', '));
  console.log('内容不一致:', diff.length, diff.slice(0, 12).join('; '));
  if (!onlyA.length && !onlyB.length && !diff.length) console.log('== 两目录完全一致 ==');
}

const mode = process.argv[2];
if (mode === 'header') {
  headerMode(process.argv[3]);
} else if (mode === 'compare') {
  compareMode(process.argv[3], process.argv[4]);
} else {
  console.log('用法: node verify_pack.js header <app.asar>');
  console.log('  或: node verify_pack.js compare <源目录> <发布目录>');
}
