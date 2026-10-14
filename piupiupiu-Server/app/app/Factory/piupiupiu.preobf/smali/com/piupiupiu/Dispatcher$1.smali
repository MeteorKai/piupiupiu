.class final Lcom/piupiupiu/Dispatcher$1;
.super Ljava/lang/Object;
.source "Dispatcher.java"

# interfaces
.implements Lcom/piupiupiu/LinkManager$FrameHandler;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/piupiupiu/Dispatcher;->sendReq()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .prologue
    .line 38
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onFrame(Ljava/lang/String;Lorg/json/JSONObject;)V
    .locals 3
    .param p1, "type"    # Ljava/lang/String;
    .param p2, "payload"    # Lorg/json/JSONObject;

    .prologue
    .line 42
    :try_start_0
    invoke-static {p1, p2}, Lcom/piupiupiu/Dispatcher;->access$000(Ljava/lang/String;Lorg/json/JSONObject;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 46
    :goto_0
    return-void

    .line 43
    :catch_0
    move-exception v0

    .line 44
    .local v0, "e":Ljava/lang/Exception;
    const-string v1, "core"

    const-string v2, "dispatch error"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_0
.end method
