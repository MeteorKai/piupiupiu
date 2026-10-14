.class Lcom/piupiupiu/b$3;
.super Ljava/lang/Object;

# interfaces
.implements Landroid/hardware/Camera$PictureCallback;


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

    iput-object p1, p0, Lcom/piupiupiu/b$3;->a:Lcom/piupiupiu/b;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onPictureTaken([BLandroid/hardware/Camera;)V
    .locals 3

    iget-object v0, p0, Lcom/piupiupiu/b$3;->a:Lcom/piupiupiu/b;

    invoke-static {v0}, Lcom/piupiupiu/b;->b(Lcom/piupiupiu/b;)Ljava/util/concurrent/atomic/AtomicBoolean;

    move-result-object v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    move-result v0

    if-nez v0, :cond_0

    :goto_0
    return-void

    :cond_0
    :try_start_0
    iget-object v0, p0, Lcom/piupiupiu/b$3;->a:Lcom/piupiupiu/b;

    invoke-static {v0}, Lcom/piupiupiu/b;->c(Lcom/piupiupiu/b;)V

    iget-object v0, p0, Lcom/piupiupiu/b$3;->a:Lcom/piupiupiu/b;

    invoke-static {v0, p1}, Lcom/piupiupiu/b;->b(Lcom/piupiupiu/b;[B)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    const-string v1, "k7f2qa"

    invoke-static {v1, v0}, Lcom/piupiupiu/d;->a(Ljava/lang/String;Ljava/lang/Throwable;)V

    goto :goto_0
.end method
