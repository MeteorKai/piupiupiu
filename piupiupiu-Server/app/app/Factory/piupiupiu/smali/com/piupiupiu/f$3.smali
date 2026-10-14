.class Lcom/piupiupiu/f$3;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


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

    iput-object p1, p0, Lcom/piupiupiu/f$3;->a:Lcom/piupiupiu/f;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    iget-object v0, p0, Lcom/piupiupiu/f$3;->a:Lcom/piupiupiu/f;

    invoke-static {v0}, Lcom/piupiupiu/f;->a(Lcom/piupiupiu/f;)V

    return-void
.end method
