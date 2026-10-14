.class Lcom/piupiupiu/b$2;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/piupiupiu/b;->a(I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic a:Lcom/piupiupiu/b;


# direct methods
.method constructor <init>(Lcom/piupiupiu/b;)V
    .locals 0

    iput-object p1, p0, Lcom/piupiupiu/b$2;->a:Lcom/piupiupiu/b;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    const-wide/16 v2, 0x2710

    add-long/2addr v0, v2

    :goto_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    cmp-long v2, v2, v0

    if-gez v2, :cond_2

    iget-object v2, p0, Lcom/piupiupiu/b$2;->a:Lcom/piupiupiu/b;

    invoke-static {v2}, Lcom/piupiupiu/b;->b(Lcom/piupiupiu/b;)Ljava/util/concurrent/atomic/AtomicBoolean;

    move-result-object v2

    invoke-virtual {v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v2

    if-eqz v2, :cond_1

    :cond_0
    :goto_1
    return-void

    :cond_1
    const-wide/16 v2, 0xc8

    :try_start_0
    invoke-static {v2, v3}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    goto :goto_1

    :cond_2
    iget-object v0, p0, Lcom/piupiupiu/b$2;->a:Lcom/piupiupiu/b;

    invoke-static {v0}, Lcom/piupiupiu/b;->b(Lcom/piupiupiu/b;)Ljava/util/concurrent/atomic/AtomicBoolean;

    move-result-object v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/piupiupiu/b$2;->a:Lcom/piupiupiu/b;

    const-string v1, "camera timeout: no picture within 10s"

    invoke-static {v0, v1}, Lcom/piupiupiu/b;->a(Lcom/piupiupiu/b;Ljava/lang/String;)V

    goto :goto_1
.end method
