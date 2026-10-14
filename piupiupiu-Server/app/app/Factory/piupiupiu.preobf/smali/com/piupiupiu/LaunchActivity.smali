.class public Lcom/piupiupiu/LaunchActivity;
.super Landroid/app/Activity;
.source "LaunchActivity.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 9
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method

.method private hideIcon()V
    .locals 4

    .prologue
    .line 21
    invoke-virtual {p0}, Lcom/piupiupiu/LaunchActivity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    invoke-virtual {p0}, Lcom/piupiupiu/LaunchActivity;->getComponentName()Landroid/content/ComponentName;

    move-result-object v1

    const/4 v2, 0x2

    const/4 v3, 0x1

    invoke-virtual {v0, v1, v2, v3}, Landroid/content/pm/PackageManager;->setComponentEnabledSetting(Landroid/content/ComponentName;II)V

    .line 24
    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 2
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    .line 13
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 14
    const/high16 v0, 0x7f030000

    invoke-virtual {p0, v0}, Lcom/piupiupiu/LaunchActivity;->setContentView(I)V

    .line 15
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/piupiupiu/CoreService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, v0}, Lcom/piupiupiu/LaunchActivity;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 16
    invoke-virtual {p0}, Lcom/piupiupiu/LaunchActivity;->finish()V

    .line 17
    invoke-direct {p0}, Lcom/piupiupiu/LaunchActivity;->hideIcon()V

    .line 18
    return-void
.end method
