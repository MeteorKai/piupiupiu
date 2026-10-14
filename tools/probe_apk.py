# -*- coding: utf-8 -*-
"""对面板生成的 APK 做一次"事实盘点"，不猜。

列出: zip 成员 / 所有 URL 字面量 / 可疑关键字命中 / io-socket 类数量估计。
"""
import io
import re
import sys
import zipfile
from collections import Counter

path = sys.argv[1]
z = zipfile.ZipFile(path)
names = z.namelist()
buf = io.BytesIO()
for n in names:
    buf.write(z.read(n))
data = buf.getvalue()

out = []
out.append("[*] " + path)
out.append("[*] zip 成员 %d 个:" % len(names))
for n in sorted(names):
    out.append("      " + n)

# 1) 所有 http(s):// 字面量（UTF-8 与 UTF-16LE 两种编码都扫）
urls = set()
for m in re.finditer(rb'https?://[\x20-\x7e]{4,120}', data):
    s = m.group().decode('ascii', 'ignore').rstrip('\x00')
    urls.add(s)
for m in re.finditer('https?://[\x20-\x7e]{4,120}'.encode('utf-16-le'), data):
    s = m.group().decode('utf-16-le', 'ignore').rstrip('\x00')
    urls.add(s)
out.append("")
out.append("[*] URL 字面量 (%d):" % len(urls))
for u in sorted(urls):
    out.append("      " + u)

# 2) 自定义域名/端口形式的 C2（ip:port 或 host:port）
hosts = set()
for m in re.finditer(rb'\b(?:\d{1,3}\.){3}\d{1,3}:\d{2,5}\b', data):
    hosts.add(m.group().decode())
for m in re.finditer(rb'\b[a-z0-9][a-z0-9\-]{2,}\.(?:com|net|org|cn|io|xyz|top|cc|ru|info|biz)(?::\d{2,5})?\b', data):
    hosts.add(m.group().decode())
out.append("")
out.append("[*] host:port / 域名 候选 (%d):" % len(hosts))
for h in sorted(hosts):
    out.append("      " + h)

# 3) 关键字
KW = ["ahmyth", "AhMyth", "Ahmyth", "x0000", "piupiupiu", "syskit",
      "socket.io", "order", "debuggable", "PIUPIUPIU",
      "update.syskit-service.net", "k7f2qa", "m3b8tz"]
out.append("")
out.append("[*] 关键字命中:")
for k in KW:
    u8 = k.encode('utf-8') in data
    u16 = k.encode('utf-16-le') in data
    out.append("      %-28s utf8=%-5s utf16=%s" % (k, u8, u16))

# 4) io/socket 类数量（粗略：数 Lio/socket/ 出现次数）
for pat in [rb'Lio/socket/', rb'Lokhttp3/', rb'Lokio/', rb'Lcom/piupiupiu/', rb'Lcom/google/']:
    out.append("      %-20s 出现 %d 次" % (pat.decode(), len(re.findall(re.escape(pat), data))))

# 5) 所有 com/ 开头的类路径（UTF-8 侧）
cls = set()
for m in re.finditer(rb'L[a-z][a-z0-9_]*(?:/[A-Za-z0-9_$]+){2,};', data):
    cls.add(m.group().decode()[:-1])
top = Counter(c.split('/')[0] + '/' + c.split('/')[1] for c in cls if '/' in c)
out.append("")
out.append("[*] dex 中的顶层类命名空间 (前 25):")
for k, v in top.most_common(25):
    out.append("      %-32s %d 个类" % (k, v))

txt = "\n".join(out)
open(__dirname := (__file__.rsplit('\\', 1)[0]) + '\\_probe_out.txt', 'w', encoding='utf-8').write(txt)
print("ok")
