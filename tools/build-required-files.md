# 编译所需文件清单（2026-10-14 核对）

> 本文档核对对象：如果想重新编译/打包本项目，哪些文件是必需的、哪些可清理。
> 结论均经实地检查（含模板引用扫描、smali 同步一致性核对、构建环境探测）。

---

## 一、客户端 APK（piupiupiu-Client）→ app-release.apk

### 必需文件（均在 piupiupiu-Client/ 下）
| 文件 | 说明 |
|---|---|
| `build.gradle` | 根构建脚本（AGP 2.3.3 + 阿里云镜像） |
| `settings.gradle` | 声明 :app 模块（15 B） |
| `app/build.gradle` | 签名配置 + ProGuard 开关 + okhttp 3.5.0 依赖 |
| `app/proguard-rules.pro` | 混淆规则（AppConfig/StrCodec/okhttp 保留规则） |
| `app/src/**`（27 个文件） | Java 源码 + res + AndroidManifest.xml |
| `gradle/wrapper/gradle-wrapper.jar` + `gradle-wrapper.properties` | Gradle 3.3 wrapper |
| `keystore.properties` + 根目录 `piupiupiu.keystore` | release 签名（缺失时自动回退 debug 签名，能编但不适合分发） |
| `local.properties` | 本机 SDK 路径（换机器需改） |

### ⚠️ 目前缺的：gradlew / gradlew.bat
rebrand 整理时丢失。命令行构建可直接用已下载好的 Gradle 3.3 发行版：

```
cd F:/piupiupiu/piupiupiu-Client
C:\Users\TY\.gradle\wrapper\dists\gradle-3.3-all\55gk2rcmfc6p2dg9u9ohc3hw9\gradle-3.3\bin\gradle.bat assembleRelease
```

（或补回标准 gradlew 脚本后用 `gradlew assembleRelease`）

### 环境（本机已全部具备 ✓）
- **JDK 8**：本机 PATH 中 java 1.8.0_202（AGP 2.3.3 不兼容高版本 JDK）
- **Android SDK**：build-tools **25.0.0** ✓ + platform **android-24** ✓（另有 34/36/37 不相关）
- Gradle 3.3 caches 已有缓存，可离线构建

### 产物
`app/build/outputs/apk/app-release.apk`（+ `outputs/mapping/release/mapping.txt` 混淆映射，反混淆排错用）

### 与编译无关（可清）
`.gradle/`、`build/`、`app/build/`（重编自动重建）、`*.log`、`piupiupiu.iml`、`.settings/`

---

## 二、服务端 Electron（piupiupiu-Server）→ 运行 + 打包

### 运行/打包必需
| 文件/目录 | 说明 |
|---|---|
| `package.json` + `package-lock.json` | electron 9 + electron-builder 22 及打包配置 |
| `build/icon.ico`（+ `icon.icns`、`icons/`） | electron-builder 打包图标（package.json 里 `win.icon` 引用） |
| `app/main.js`、`app/package.json` | Electron 主进程 + 运行时依赖声明 |
| `app/assets/cert/key.pem`、`cert.pem` | HTTPS 自签证书（与客户端 C2 配对；asarUnpack 必须） |
| `app/app/index.html`、`lab.html`、`notification.html`、`views/` | 面板界面 |
| `app/app/assets/`（css / img / js） | 前端逻辑：`Constants.js`、Controllers（含 patchC2 与 Build 流程）、model |
| `app/app/Factory/apktool.jar`（15.6 MB）+ `sign.jar` | 面板 Build 时 `java -jar` 重打包 + 签名（AppCtrl.js 调用） |
| `app/app/Factory/piupiupiu/` | **当前唯一被引用的 APK 模板**（smali 259 个 + res + AndroidManifest + apktool.yml + original/） |
| `node_modules/` + `app/node_modules/` | 依赖已装齐（electron/electron-builder + angular、ws、geoip-lite、fs-extra 等）；删了需重装 |

### 命令
```
cd F:/piupiupiu/piupiupiu-Server
npm start            # 从源码运行面板
npm run dist:win     # 打包（= build:win64，输出到 dist/）
```
运行面板的机器需要装 **Java**（Build 按钮调用 apktool.jar / sign.jar）。

### 明确未被引用的（可清）
- `app/app/Factory/piupiupiu.old/`（2.3 MB）——旧版模板，代码零引用
- `app/app/Factory/piupiupiu.preobf/`（2.9 MB）——未混淆版模板，代码零引用
  （已全项目扫描确认：只有 `Factory/piupiupiu` 被 Constants.js / AppCtrl.js 引用）

### 注意
`dist/` 是打包输出目录，但你的调试流程会往
`dist/win-unpacked/resources/app.asar.unpacked/app/Factory/piupiupiu` 同步模板，
**参与调试期间别删**（重新打包会重建）。

---

## 三、"客户端 → 面板模板" 更新流水线（改客户端后必走）

1. 重编客户端 → `app-release.apk`（见第一节命令）
2. 解码：`apktool d app-release.apk -f -o _decode`
3. 同步：`node sync_factory.js`（项目根目录）
   → 把 `_decode/smali/com/piupiupiu` + `_decode/AndroidManifest.xml` 刷进
   - `piupiupiu-Server/app/app/Factory/piupiupiu/`
   - `dist/win-unpacked/.../app/Factory/piupiupiu/`

**今日核对**：`_decode` = Factory 源模板 = dist 模板，smali 均为 259 个，三方同步一致 ✓

### 辅助工具（不影响编译，改动时才用）

**根目录 `sync_factory.js`（✅ 保留，987 B）**
流水线第 3 步：把 `_decode` 的新 smali（仅 `com/piupiupiu` 包）+ AndroidManifest 刷进 Factory 模板（源 + dist 两处）。
路径写死 `F:/piupiupiu/...`，换目录需改；okhttp3/okio 库代码不在同步范围（模板里已有）。

**`_decode/`（⚠️ 可再生，非必需）**
sync_factory 的输入源；当前与 Factory 模板完全同步（smali 均 259 个，今日 02:36 生成）。
删掉不影响任何编译；需要时用 Factory 里的 apktool.jar 一条命令重生成：
`java -jar piupiupiu-Server/app/app/Factory/apktool.jar d piupiupiu-Client/app/build/outputs/apk/app-release.apk -f -o _decode`
（本地留着省一步；将来发布仓库时可不带，Factory 才是运行必需）

**`tools/` 逐文件判定（2026-10-14 核实）**

| 文件 | 判定 | 说明 |
|---|---|---|
| `e2e_factory_build.js` | ✅ 保留 | patchC2 后 smali 合法性校验（当前版本，今日仍在用） |
| `verify_signatures.py` | ✅ 保留 | 特征残留自检：旧特征应清零、新特征应命中，改客户端后的回归检查 |
| `ui-check/`（脚本 + README） | ✅ 保留 | Lab UI 回归工具；README 记录了打包版复测方法 |
| `ui-check/shots*/`、`asar-extract/` | 🧹 可清 | 验证证据（截图共 ~3.3 MB），功能已验收 |
| `test_ws_adapter.js` | ❌ 已过时 | 测 main.js 里已不存在的 `wrapSocket`（现为 `makeRestVictim`），跑了直接报错 |
| `test_patch_c2_ws.js` | ❌ 已过时 | 断言 `ws://` 写法；当前 patchC2 写 `https://…/sync`，必 FAIL |
| `test_patch_c2.js` | ❌ 已过时 | 更早期 `http://` 版本的断言，已对不上当前代码 |
| `probe_apk.py` / `ctx.py` | 🔸 一次性 | APK 盘点 / 关键字上下文定位工具，可留可删 |
| `check_output.js` / `fix_txt.js` | 🔸 一次性 | 产物目录盘点 / PowerShell 编码转换小工具 |
| `piupiupiu-Client/tools/str_enc.py` | ✅ 保留 | 字符串加密辅助（改动客户端字符串时用） |

---

## 四、现在就能清的、与编译无关的残余

| 项 | 大小 | 备注 |
|---|---|---|
| `piupiupiu-Server/build-fix*.log`、`build-win64.log`、`build-win-zip*.log` | ~108 KB | 日志 |
| `Factory/piupiupiu.old/` + `piupiupiu.preobf/` | ~5.2 MB | 代码零引用 |
| `tools/ui-check/`（截图 + 测试脚本） | 3.3 MB | 截图可清，脚本建议留 |
| 客户端 `.gradle/` + `build/` + `app/build/` | ~9 MB | 重编自动重建（mapping 想留就留） |
