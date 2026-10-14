# ui-check —— Lab 页 UI 布局验证工具

2026-10-14 为排查「输出终端挡住文件管理列表」建立的一次性工具，已归档以便以后 UI 回归复测。

## 怎么跑

```bash
cd tools/ui-check
env -u ELECTRON_RUN_AS_NODE -u NODE_OPTIONS \
  "F:/piupiupiu/piupiupiu-Server/node_modules/electron/dist/electron.exe" testapp --disable-gpu
```

产物在 `shots/`（截图 + json 报告 + flows 日志）。

> ⚠️ 沙箱环境预设 `ELECTRON_RUN_AS_NODE=1`，不 unset 的话 electron 会退化成纯 node，
> 报 `Cannot find module 'electron'`。`testapp/` 是个标准 electron 应用目录（package.json + main.js）。

## 验证打包产物（app.asar 内页面）

`verify-fixed.js / testapp/main.js` 支持两个环境变量，可直接把验收指向打包版页面：

```bash
env -u ELECTRON_RUN_AS_NODE -u NODE_OPTIONS \
  LAB_APP_DIR="F:/piupiupiu/piupiupiu-Server/dist/win-unpacked/resources/app.asar" \
  UI_CHECK_OUT="F:/piupiupiu/tools/ui-check/shots-packed" \
  "F:/piupiupiu/piupiupiu-Server/node_modules/electron/dist/electron.exe" testapp --disable-gpu
```

（`shots-packed/` 就是 2026-10-14 打包后这样复测的结果。）

## 文件说明

| 文件 | 用途 |
|---|---|
| `lab-test-main.js` | 最早的问题复现：打开 lab.html → 点 File Manager → 截图 + 几何量测 + 对比滚动 |
| `probe-fix.js` | 修复实验：F0 原始 → F1 列补 h100 → F2 终端固定底部，逐步量测验证 |
| `verify-fixed.js` | 最终验收：修复后跑 fileManager/contacts/callsLogs/camera + 满屏日志 + 滚到底 |
| `camera-test.js` | Camera 拍照-保存全流程：假设备回传真实 PNG，验证自动保存/日志路径可见性/落盘字节一致（`CAM_MODE=two\|one\|zero` 模拟双摄/单摄/无摄像头） |
| `error-test.js` | 失败回传验证：假设备对所有命令回传 `{"error":"..."}`，检查面板显示 "xxx failed: 原因" |
| `extract_asar.js` | 从 dist/win-unpacked/resources/app.asar 抽出页面与源码对比（验证打包版一致性） |
| `verify_pack.js` | 发布包校验：`header` 查 asar 清单关键 smali（新增类必须重打才会进清单）；`compare` 按 md5 对比源目录与发布目录 |
| `testapp/` | electron 运行壳（main.js 复制自上面某个脚本 + package.json） |
| `shots/` | 截图与报告：`fm-initial.png`=修复前；`verify-*.png`=修复后；`*.json`=几何数据 |

## 复现/量测要点

- 伪造 victim socket：接口与 `piupiupiu-Server/app/main.js` 的 `makeRestVictim` 一致
  （`emit/on/removeAllListeners` + `_deliver`），脚本化投递 `m3b8tz`(文件列表) `n5j1pr`(通讯录)
  `c2h6vn`(通话) `k7f2qa`(相机列表) 的响应数据。
- 量测：`getBoundingClientRect` + `document.elementFromPoint`（判定条目是否被盖住），
  注意只对「滚动容器可见范围内」的条目做命中测试，被滚动裁剪的条目不算被盖。
