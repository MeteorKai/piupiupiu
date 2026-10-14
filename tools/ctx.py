# -*- coding: utf-8 -*-
"""打印某个关键字在 APK(解压后)里每次出现位置的前后文，用可打印字符显示。"""
import io
import sys
import zipfile

path, kw = sys.argv[1], sys.argv[2]
z = zipfile.ZipFile(path)
buf = io.BytesIO()
for n in z.namelist():
    buf.write(z.read(n))
data = buf.getvalue()

enc = kw.encode('utf-8')
out = []
pos, cnt = 0, 0
while True:
    i = data.find(enc, pos)
    if i < 0:
        break
    cnt += 1
    lo = max(0, i - 70)
    hi = min(len(data), i + len(enc) + 70)
    chunk = data[lo:hi]
    shown = ''.join(chr(b) if 32 <= b < 127 else '.' for b in chunk)
    out.append("#%d @%d  ...%s..." % (cnt, i, shown))
    pos = i + 1
out.insert(0, "[*] %s  关键字 %r  命中 %d 次" % (path, kw, cnt))
txt = "\n".join(out)
open(__file__.rsplit('\\', 1)[0] + '\\_ctx_out.txt', 'w', encoding='utf-8').write(txt)
print("ok")
