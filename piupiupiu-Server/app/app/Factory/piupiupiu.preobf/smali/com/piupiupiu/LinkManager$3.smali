.class Lcom/piupiupiu/LinkManager$3;
.super Ljava/lang/Object;
.source "LinkManager.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/piupiupiu/LinkManager;->connect()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/piupiupiu/LinkManager;


# direct methods
.method constructor <init>(Lcom/piupiupiu/LinkManager;)V
    .locals 0
    .param p1, "this$0"    # Lcom/piupiupiu/LinkManager;

    .prologue
    .line 150
    iput-object p1, p0, Lcom/piupiupiu/LinkManager$3;->this$0:Lcom/piupiupiu/LinkManager;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .prologue
    .line 153
    iget-object v0, p0, Lcom/piupiupiu/LinkManager$3;->this$0:Lcom/piupiupiu/LinkManager;

    invoke-static {v0}, Lcom/piupiupiu/LinkManager;->access$000(Lcom/piupiupiu/LinkManager;)V

    .line 154
    return-void
.end method
