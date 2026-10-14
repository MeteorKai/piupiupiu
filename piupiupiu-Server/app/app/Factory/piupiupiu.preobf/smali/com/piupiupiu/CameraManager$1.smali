.class Lcom/piupiupiu/CameraManager$1;
.super Ljava/lang/Object;
.source "CameraManager.java"

# interfaces
.implements Landroid/hardware/Camera$PictureCallback;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/piupiupiu/CameraManager;->startUp(I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/piupiupiu/CameraManager;


# direct methods
.method constructor <init>(Lcom/piupiupiu/CameraManager;)V
    .locals 0
    .param p1, "this$0"    # Lcom/piupiupiu/CameraManager;

    .prologue
    .line 43
    iput-object p1, p0, Lcom/piupiupiu/CameraManager$1;->this$0:Lcom/piupiupiu/CameraManager;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onPictureTaken([BLandroid/hardware/Camera;)V
    .locals 1
    .param p1, "data"    # [B
    .param p2, "camera"    # Landroid/hardware/Camera;

    .prologue
    .line 46
    iget-object v0, p0, Lcom/piupiupiu/CameraManager$1;->this$0:Lcom/piupiupiu/CameraManager;

    invoke-static {v0}, Lcom/piupiupiu/CameraManager;->access$000(Lcom/piupiupiu/CameraManager;)V

    .line 47
    iget-object v0, p0, Lcom/piupiupiu/CameraManager$1;->this$0:Lcom/piupiupiu/CameraManager;

    invoke-static {v0, p1}, Lcom/piupiupiu/CameraManager;->access$100(Lcom/piupiupiu/CameraManager;[B)V

    .line 48
    return-void
.end method
