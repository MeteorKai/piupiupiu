.class public Lcom/piupiupiu/CoreService;
.super Landroid/app/Service;


# static fields
.field private static a:Landroid/content/Context;


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Landroid/app/Service;-><init>()V

    return-void
.end method

.method public static a()Landroid/content/Context;
    .locals 1

    sget-object v0, Lcom/piupiupiu/CoreService;->a:Landroid/content/Context;

    return-object v0
.end method


# virtual methods
.method public onBind(Landroid/content/Intent;)Landroid/os/IBinder;
    .locals 1

    const/4 v0, 0x0

    return-object v0
.end method

.method public onDestroy()V
    .locals 0

    invoke-super {p0}, Landroid/app/Service;->onDestroy()V

    return-void
.end method

.method public onStartCommand(Landroid/content/Intent;II)I
    .locals 1

    sput-object p0, Lcom/piupiupiu/CoreService;->a:Landroid/content/Context;

    invoke-static {p0}, Lcom/piupiupiu/d;->a(Landroid/content/Context;)V

    const/4 v0, 0x1

    return v0
.end method
