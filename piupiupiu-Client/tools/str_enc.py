#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
StrCodec 密文生成器（与 app/.../StrCodec.java 算法一致）。

用法:
    python tools/str_enc.py "d1" "t" "op" "certificate pin mismatch: "
    python tools/str_enc.py            # 不带参数则打印内置的常用协议字段清单

输出每行: 明文 -> StrCodec.dec("密文")
把 dec("密文") 替换源码里的明文字面量即可。改了 StrCodec 的密钥后必须重跑本脚本。
"""
import base64
import sys

# 必须与 StrCodec.java 的 K 完全一致
KEY = "pP!u9k&2*ZqLm4eR".encode("utf-8")


def enc(plain: str) -> str:
    data = plain.encode("utf-8")
    out = bytes(b ^ KEY[i % len(KEY)] for i, b in enumerate(data))
    return base64.b64encode(out).decode("ascii")


def main():
    if len(sys.argv) > 1:
        strings = sys.argv[1:]
    else:
        strings = [
            # AppConfig 协议字段名
            "d1", "d2", "d3", "d4",
            "t", "x",
            "op", "fp", "rc", "bd", "dur",
            "cv", "ls", "dl", "tx",
            # LinkManager 日志/错误/媒体类型
            "core",
            "application/json; charset=utf-8",
            "poll failed", "report failed",
            "build pinned client failed", "empty cert chain",
            "certificate pin mismatch: ", "pin check failed",
        ]

    for s in strings:
        print('%s -> StrCodec.dec("%s")' % (repr(s), enc(s)))


if __name__ == "__main__":
    main()
