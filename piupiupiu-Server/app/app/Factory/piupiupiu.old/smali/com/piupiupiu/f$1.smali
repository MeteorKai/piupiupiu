.class Lcom/piupiupiu/f$1;
.super Lokhttp3/WebSocketListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/piupiupiu/f;->b()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic a:Lcom/piupiupiu/f;


# direct methods
.method constructor <init>(Lcom/piupiupiu/f;)V
    .locals 0

    iput-object p1, p0, Lcom/piupiupiu/f$1;->a:Lcom/piupiupiu/f;

    invoke-direct {p0}, Lokhttp3/WebSocketListener;-><init>()V

    return-void
.end method


# virtual methods
.method public onClosed(Lokhttp3/WebSocket;ILjava/lang/String;)V
    .locals 2

    iget-object v0, p0, Lcom/piupiupiu/f$1;->a:Lcom/piupiupiu/f;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/piupiupiu/f;->a(Lcom/piupiupiu/f;Lokhttp3/WebSocket;)Lokhttp3/WebSocket;

    return-void
.end method

.method public onFailure(Lokhttp3/WebSocket;Ljava/lang/Throwable;Lokhttp3/Response;)V
    .locals 2

    const-string v0, "core"

    const-string v1, "link failure"

    invoke-static {v0, v1, p2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    iget-object v0, p0, Lcom/piupiupiu/f$1;->a:Lcom/piupiupiu/f;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/piupiupiu/f;->a(Lcom/piupiupiu/f;Lokhttp3/WebSocket;)Lokhttp3/WebSocket;

    iget-object v0, p0, Lcom/piupiupiu/f$1;->a:Lcom/piupiupiu/f;

    invoke-static {v0}, Lcom/piupiupiu/f;->b(Lcom/piupiupiu/f;)V

    return-void
.end method

.method public onMessage(Lokhttp3/WebSocket;Ljava/lang/String;)V
    .locals 4

    iget-object v0, p0, Lcom/piupiupiu/f$1;->a:Lcom/piupiupiu/f;

    invoke-static {v0}, Lcom/piupiupiu/f;->a(Lcom/piupiupiu/f;)Lcom/piupiupiu/f$a;

    move-result-object v1

    if-nez v1, :cond_1

    :cond_0
    :goto_0
    return-void

    :cond_1
    :try_start_0
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0, p2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v2, "t"

    const-string v3, ""

    invoke-virtual {v0, v2, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v3

    if-eqz v3, :cond_0

    const-string v3, "x"

    invoke-virtual {v0, v3}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    if-nez v0, :cond_2

    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    :cond_2
    invoke-interface {v1, v2, v0}, Lcom/piupiupiu/f$a;->a(Ljava/lang/String;Lorg/json/JSONObject;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    const-string v1, "core"

    const-string v2, "bad frame"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_0
.end method

.method public onOpen(Lokhttp3/WebSocket;Lokhttp3/Response;)V
    .locals 2

    const-string v0, "core"

    const-string v1, "connected"

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v0, p0, Lcom/piupiupiu/f$1;->a:Lcom/piupiupiu/f;

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lcom/piupiupiu/f;->a(Lcom/piupiupiu/f;I)I

    return-void
.end method
