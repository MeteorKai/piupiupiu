package com.piupiupiu;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.IBinder;


public class CoreService extends Service {

    private static Context contextOfApplication;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        contextOfApplication = this;
        Dispatcher.startAsync(this);
        return Service.START_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    public static Context getContextOfApplication() {
        return contextOfApplication;
    }
}
