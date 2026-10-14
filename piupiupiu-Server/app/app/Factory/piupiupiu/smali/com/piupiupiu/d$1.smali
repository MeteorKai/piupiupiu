.class final Lcom/piupiupiu/d$1;
.super Ljava/lang/Object;

# interfaces
.implements Lcom/piupiupiu/f$a;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/piupiupiu/d;->a()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public a(Ljava/lang/String;Lorg/json/JSONObject;)V
    .locals 3

    :try_start_0
    invoke-static {p1, p2}, Lcom/piupiupiu/d;->a(Ljava/lang/String;Lorg/json/JSONObject;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    return-void

    :catch_0
    move-exception v0

    invoke-static {}, Lcom/piupiupiu/d;->e()Ljava/lang/String;

    move-result-object v1

    const-string v2, "FDlSBVgfRVoKPwM+AkY="

    invoke-static {v2}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    invoke-static {p1, v0}, Lcom/piupiupiu/d;->a(Ljava/lang/String;Ljava/lang/Throwable;)V

    goto :goto_0
.end method
