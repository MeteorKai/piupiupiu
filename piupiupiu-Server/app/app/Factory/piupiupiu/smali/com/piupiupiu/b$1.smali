.class Lcom/piupiupiu/b$1;
.super Ljava/lang/Object;

# interfaces
.implements Landroid/hardware/Camera$PreviewCallback;


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

    iput-object p1, p0, Lcom/piupiupiu/b$1;->a:Lcom/piupiupiu/b;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onPreviewFrame([BLandroid/hardware/Camera;)V
    .locals 1

    if-nez p1, :cond_0

    :goto_0
    return-void

    :cond_0
    iget-object v0, p0, Lcom/piupiupiu/b$1;->a:Lcom/piupiupiu/b;

    invoke-static {v0}, Lcom/piupiupiu/b;->a(Lcom/piupiupiu/b;)I

    iget-object v0, p0, Lcom/piupiupiu/b$1;->a:Lcom/piupiupiu/b;

    invoke-static {v0, p1}, Lcom/piupiupiu/b;->a(Lcom/piupiupiu/b;[B)[B

    goto :goto_0
.end method
