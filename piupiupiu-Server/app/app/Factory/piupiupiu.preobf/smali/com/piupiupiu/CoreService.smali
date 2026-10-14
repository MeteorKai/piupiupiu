.class public Lcom/piupiupiu/CoreService;
.super Landroid/app/Service;
.source "CoreService.java"


# static fields
.field private static contextOfApplication:Landroid/content/Context;


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 9
    invoke-direct {p0}, Landroid/app/Service;-><init>()V

    return-void
.end method

.method public static getContextOfApplication()Landroid/content/Context;
    .locals 1

    .prologue
    .line 31
    sget-object v0, Lcom/piupiupiu/CoreService;->contextOfApplication:Landroid/content/Context;

    return-object v0
.end method


# virtual methods
.method public onBind(Landroid/content/Intent;)Landroid/os/IBinder;
    .locals 1
    .param p1, "intent"    # Landroid/content/Intent;

    .prologue
    .line 15
    const/4 v0, 0x0

    return-object v0
.end method

.method public onDestroy()V
    .locals 0

    .prologue
    .line 27
    invoke-super {p0}, Landroid/app/Service;->onDestroy()V

    .line 28
    return-void
.end method

.method public onStartCommand(Landroid/content/Intent;II)I
    .locals 1
    .param p1, "intent"    # Landroid/content/Intent;
    .param p2, "flags"    # I
    .param p3, "startId"    # I

    .prologue
    .line 20
    sput-object p0, Lcom/piupiupiu/CoreService;->contextOfApplication:Landroid/content/Context;

    .line 21
    invoke-static {p0}, Lcom/piupiupiu/Dispatcher;->startAsync(Landroid/content/Context;)V

    .line 22
    const/4 v0, 0x1

    return v0
.end method
