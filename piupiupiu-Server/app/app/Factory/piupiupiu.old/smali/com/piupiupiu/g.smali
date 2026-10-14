.class public Lcom/piupiupiu/g;
.super Ljava/lang/Object;

# interfaces
.implements Landroid/location/LocationListener;


# instance fields
.field a:Z

.field b:Z

.field c:Z

.field d:Landroid/location/Location;

.field e:D

.field f:D

.field protected g:Landroid/location/LocationManager;

.field private final h:Landroid/content/Context;


# direct methods
.method public constructor <init>()V
    .locals 1

    const/4 v0, 0x0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-boolean v0, p0, Lcom/piupiupiu/g;->a:Z

    iput-boolean v0, p0, Lcom/piupiupiu/g;->b:Z

    iput-boolean v0, p0, Lcom/piupiupiu/g;->c:Z

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/piupiupiu/g;->h:Landroid/content/Context;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    const/4 v0, 0x0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-boolean v0, p0, Lcom/piupiupiu/g;->a:Z

    iput-boolean v0, p0, Lcom/piupiupiu/g;->b:Z

    iput-boolean v0, p0, Lcom/piupiupiu/g;->c:Z

    iput-object p1, p0, Lcom/piupiupiu/g;->h:Landroid/content/Context;

    invoke-virtual {p0}, Lcom/piupiupiu/g;->a()Landroid/location/Location;

    return-void
.end method


# virtual methods
.method public a()Landroid/location/Location;
    .locals 6

    :try_start_0
    iget-object v0, p0, Lcom/piupiupiu/g;->h:Landroid/content/Context;

    const-string v1, "location"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/location/LocationManager;

    iput-object v0, p0, Lcom/piupiupiu/g;->g:Landroid/location/LocationManager;

    iget-object v0, p0, Lcom/piupiupiu/g;->g:Landroid/location/LocationManager;

    const-string v1, "gps"

    invoke-virtual {v0, v1}, Landroid/location/LocationManager;->isProviderEnabled(Ljava/lang/String;)Z

    move-result v0

    iput-boolean v0, p0, Lcom/piupiupiu/g;->a:Z

    iget-object v0, p0, Lcom/piupiupiu/g;->g:Landroid/location/LocationManager;

    const-string v1, "network"

    invoke-virtual {v0, v1}, Landroid/location/LocationManager;->isProviderEnabled(Ljava/lang/String;)Z

    move-result v0

    iput-boolean v0, p0, Lcom/piupiupiu/g;->b:Z

    iget-boolean v0, p0, Lcom/piupiupiu/g;->a:Z

    if-nez v0, :cond_0

    iget-boolean v0, p0, Lcom/piupiupiu/g;->b:Z

    if-eqz v0, :cond_2

    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/piupiupiu/g;->c:Z

    iget-boolean v0, p0, Lcom/piupiupiu/g;->b:Z

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/piupiupiu/g;->g:Landroid/location/LocationManager;

    const-string v1, "network"

    const-wide/32 v2, 0xea60

    const/high16 v4, 0x41200000    # 10.0f

    move-object v5, p0

    invoke-virtual/range {v0 .. v5}, Landroid/location/LocationManager;->requestLocationUpdates(Ljava/lang/String;JFLandroid/location/LocationListener;)V

    const-string v0, "Network"

    const-string v1, "Network"

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v0, p0, Lcom/piupiupiu/g;->g:Landroid/location/LocationManager;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/piupiupiu/g;->g:Landroid/location/LocationManager;

    const-string v1, "network"

    invoke-virtual {v0, v1}, Landroid/location/LocationManager;->getLastKnownLocation(Ljava/lang/String;)Landroid/location/Location;

    move-result-object v0

    iput-object v0, p0, Lcom/piupiupiu/g;->d:Landroid/location/Location;

    iget-object v0, p0, Lcom/piupiupiu/g;->d:Landroid/location/Location;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/piupiupiu/g;->d:Landroid/location/Location;

    invoke-virtual {v0}, Landroid/location/Location;->getLatitude()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/piupiupiu/g;->e:D

    iget-object v0, p0, Lcom/piupiupiu/g;->d:Landroid/location/Location;

    invoke-virtual {v0}, Landroid/location/Location;->getLongitude()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/piupiupiu/g;->f:D

    :cond_1
    iget-boolean v0, p0, Lcom/piupiupiu/g;->a:Z

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/piupiupiu/g;->d:Landroid/location/Location;

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/piupiupiu/g;->g:Landroid/location/LocationManager;

    const-string v1, "gps"

    const-wide/32 v2, 0xea60

    const/high16 v4, 0x41200000    # 10.0f

    move-object v5, p0

    invoke-virtual/range {v0 .. v5}, Landroid/location/LocationManager;->requestLocationUpdates(Ljava/lang/String;JFLandroid/location/LocationListener;)V

    iget-object v0, p0, Lcom/piupiupiu/g;->g:Landroid/location/LocationManager;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/piupiupiu/g;->g:Landroid/location/LocationManager;

    const-string v1, "gps"

    invoke-virtual {v0, v1}, Landroid/location/LocationManager;->getLastKnownLocation(Ljava/lang/String;)Landroid/location/Location;

    move-result-object v0

    iput-object v0, p0, Lcom/piupiupiu/g;->d:Landroid/location/Location;

    iget-object v0, p0, Lcom/piupiupiu/g;->d:Landroid/location/Location;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/piupiupiu/g;->d:Landroid/location/Location;

    invoke-virtual {v0}, Landroid/location/Location;->getLatitude()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/piupiupiu/g;->e:D

    iget-object v0, p0, Lcom/piupiupiu/g;->d:Landroid/location/Location;

    invoke-virtual {v0}, Landroid/location/Location;->getLongitude()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/piupiupiu/g;->f:D
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :cond_2
    :goto_0
    invoke-virtual {p0}, Lcom/piupiupiu/g;->b()V

    iget-object v0, p0, Lcom/piupiupiu/g;->d:Landroid/location/Location;

    return-object v0

    :catch_0
    move-exception v0

    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method public b()V
    .locals 1

    iget-object v0, p0, Lcom/piupiupiu/g;->g:Landroid/location/LocationManager;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/piupiupiu/g;->g:Landroid/location/LocationManager;

    invoke-virtual {v0, p0}, Landroid/location/LocationManager;->removeUpdates(Landroid/location/LocationListener;)V

    :cond_0
    return-void
.end method

.method public c()D
    .locals 2

    iget-object v0, p0, Lcom/piupiupiu/g;->d:Landroid/location/Location;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/piupiupiu/g;->d:Landroid/location/Location;

    invoke-virtual {v0}, Landroid/location/Location;->getLatitude()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/piupiupiu/g;->e:D

    :cond_0
    iget-wide v0, p0, Lcom/piupiupiu/g;->e:D

    return-wide v0
.end method

.method public d()D
    .locals 2

    iget-object v0, p0, Lcom/piupiupiu/g;->d:Landroid/location/Location;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/piupiupiu/g;->d:Landroid/location/Location;

    invoke-virtual {v0}, Landroid/location/Location;->getLongitude()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/piupiupiu/g;->f:D

    :cond_0
    iget-wide v0, p0, Lcom/piupiupiu/g;->f:D

    return-wide v0
.end method

.method public e()Z
    .locals 1

    iget-boolean v0, p0, Lcom/piupiupiu/g;->c:Z

    return v0
.end method

.method public onLocationChanged(Landroid/location/Location;)V
    .locals 0

    return-void
.end method

.method public onProviderDisabled(Ljava/lang/String;)V
    .locals 0

    return-void
.end method

.method public onProviderEnabled(Ljava/lang/String;)V
    .locals 0

    return-void
.end method

.method public onStatusChanged(Ljava/lang/String;ILandroid/os/Bundle;)V
    .locals 0

    return-void
.end method
