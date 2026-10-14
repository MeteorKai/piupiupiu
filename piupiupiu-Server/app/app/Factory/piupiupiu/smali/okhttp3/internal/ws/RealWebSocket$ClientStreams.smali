.class final Lokhttp3/internal/ws/RealWebSocket$ClientStreams;
.super Lokhttp3/internal/ws/RealWebSocket$Streams;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lokhttp3/internal/ws/RealWebSocket;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "ClientStreams"
.end annotation


# instance fields
.field private final streamAllocation:Lokhttp3/internal/connection/StreamAllocation;


# direct methods
.method constructor <init>(Lokhttp3/internal/connection/StreamAllocation;)V
    .locals 3

    const/4 v0, 0x1

    invoke-virtual {p1}, Lokhttp3/internal/connection/StreamAllocation;->connection()Lokhttp3/internal/connection/RealConnection;

    move-result-object v1

    iget-object v1, v1, Lokhttp3/internal/connection/RealConnection;->source:Lokio/BufferedSource;

    invoke-virtual {p1}, Lokhttp3/internal/connection/StreamAllocation;->connection()Lokhttp3/internal/connection/RealConnection;

    move-result-object v2

    iget-object v2, v2, Lokhttp3/internal/connection/RealConnection;->sink:Lokio/BufferedSink;

    invoke-direct {p0, v0, v1, v2}, Lokhttp3/internal/ws/RealWebSocket$Streams;-><init>(ZLokio/BufferedSource;Lokio/BufferedSink;)V

    iput-object p1, p0, Lokhttp3/internal/ws/RealWebSocket$ClientStreams;->streamAllocation:Lokhttp3/internal/connection/StreamAllocation;

    return-void
.end method


# virtual methods
.method public close()V
    .locals 3

    iget-object v0, p0, Lokhttp3/internal/ws/RealWebSocket$ClientStreams;->streamAllocation:Lokhttp3/internal/connection/StreamAllocation;

    const/4 v1, 0x1

    iget-object v2, p0, Lokhttp3/internal/ws/RealWebSocket$ClientStreams;->streamAllocation:Lokhttp3/internal/connection/StreamAllocation;

    invoke-virtual {v2}, Lokhttp3/internal/connection/StreamAllocation;->codec()Lokhttp3/internal/http/HttpCodec;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lokhttp3/internal/connection/StreamAllocation;->streamFinished(ZLokhttp3/internal/http/HttpCodec;)V

    return-void
.end method
