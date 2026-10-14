package com.piupiupiu;

import java.nio.charset.StandardCharsets;

import android.util.Base64;

/**
 * 轻量字符串混淆：把明文字符串从 dex 中剥离。
 *
 * 注意：这只是「阻止字符串静态扫描」的混淆手段，不是加密——密钥随包下发，
 * 反编译者拿到 APK 即可还原。价值在于去掉 dex 里一眼可认的协议字段名/日志，
 * 对 VT 检出率基本无影响（AV 靠包名+权限+框架特征匹配），但能增加逆向成本。
 *
 * 用法：源码里写 StrCodec.dec("<由 tools/str_enc.py 生成的密文>") 替换原明文字面量。
 * 改完源码后用 tools/str_enc.py 重新生成对应密文即可。
 */
public final class StrCodec {

    // 混淆密钥。改密钥后必须重新生成所有密文（见 tools/str_enc.py）。
    private static final byte[] K =
            "pP!u9k&2*ZqLm4eR".getBytes(StandardCharsets.UTF_8);

    private StrCodec() {
    }

    /** 运行时解密：Base64(XOR(K)) -> 明文。 */
    public static String dec(String s) {
        if (s == null) {
            return null;
        }
        byte[] in = Base64.decode(s, Base64.NO_WRAP);
        byte[] out = new byte[in.length];
        for (int i = 0; i < in.length; i++) {
            out[i] = (byte) (in[i] ^ K[i % K.length]);
        }
        return new String(out, StandardCharsets.UTF_8);
    }

    /** 构建期工具用：明文 -> 密文 literal。不参与运行时（会被 ProGuard 裁掉）。 */
    public static String enc(String s) {
        byte[] in = s.getBytes(StandardCharsets.UTF_8);
        byte[] out = new byte[in.length];
        for (int i = 0; i < in.length; i++) {
            out[i] = (byte) (in[i] ^ K[i % K.length]);
        }
        return Base64.encodeToString(out, Base64.NO_WRAP);
    }
}
