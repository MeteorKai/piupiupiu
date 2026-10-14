.class Lcom/piupiupiu/f$2;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/piupiupiu/f;->c()V
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

    iput-object p1, p0, Lcom/piupiupiu/f$2;->a:Lcom/piupiupiu/f;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 5

    const/4 v4, 0x0

    :goto_0
    :try_start_0
    iget-object v0, p0, Lcom/piupiupiu/f$2;->a:Lcom/piupiupiu/f;

    invoke-static {v0}, Lcom/piupiupiu/f;->c(Lcom/piupiupiu/f;)Lokhttp3/WebSocket;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-result-object v0

    if-nez v0, :cond_1

    :try_start_1
    iget-object v0, p0, Lcom/piupiupiu/f$2;->a:Lcom/piupiupiu/f;

    invoke-static {v0}, Lcom/piupiupiu/f;->d(Lcom/piupiupiu/f;)I

    move-result v0

    int-to-long v0, v0

    const-wide/16 v2, 0x3e8

    mul-long/2addr v0, v2

    invoke-static {v0, v1}, Ljava/lang/Thread;->sleep(J)V
    :try_end_1
    .catch Ljava/lang/InterruptedException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :try_start_2
    iget-object v0, p0, Lcom/piupiupiu/f$2;->a:Lcom/piupiupiu/f;

    invoke-static {v0}, Lcom/piupiupiu/f;->c(Lcom/piupiupiu/f;)Lokhttp3/WebSocket;
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    move-result-object v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/piupiupiu/f$2;->a:Lcom/piupiupiu/f;

    invoke-static {v0, v4}, Lcom/piupiupiu/f;->a(Lcom/piupiupiu/f;Z)Z

    :goto_1
    return-void

    :catch_0
    move-exception v0

    iget-object v0, p0, Lcom/piupiupiu/f$2;->a:Lcom/piupiupiu/f;

    invoke-static {v0, v4}, Lcom/piupiupiu/f;->a(Lcom/piupiupiu/f;Z)Z

    goto :goto_1

    :cond_0
    :try_start_3
    iget-object v0, p0, Lcom/piupiupiu/f$2;->a:Lcom/piupiupiu/f;

    invoke-virtual {v0}, Lcom/piupiupiu/f;->b()V

    iget-object v0, p0, Lcom/piupiupiu/f$2;->a:Lcom/piupiupiu/f;

    iget-object v1, p0, Lcom/piupiupiu/f$2;->a:Lcom/piupiupiu/f;

    invoke-static {v1}, Lcom/piupiupiu/f;->d(Lcom/piupiupiu/f;)I

    move-result v1

    mul-int/lit8 v1, v1, 0x2

    const/16 v2, 0x3c

    invoke-static {v1, v2}, Ljava/lang/Math;->min(II)I

    move-result v1

    invoke-static {v0, v1}, Lcom/piupiupiu/f;->a(Lcom/piupiupiu/f;I)I
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception v0

    iget-object v1, p0, Lcom/piupiupiu/f$2;->a:Lcom/piupiupiu/f;

    invoke-static {v1, v4}, Lcom/piupiupiu/f;->a(Lcom/piupiupiu/f;Z)Z

    throw v0

    :cond_1
    iget-object v0, p0, Lcom/piupiupiu/f$2;->a:Lcom/piupiupiu/f;

    invoke-static {v0, v4}, Lcom/piupiupiu/f;->a(Lcom/piupiupiu/f;Z)Z

    goto :goto_1
.end method
