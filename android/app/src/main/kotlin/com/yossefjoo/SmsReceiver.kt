package com.rafeeqy.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.telephony.SmsMessage
import android.util.Log

class SmsReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {
        // التحقق من أن البث الخاص بالرسائل هو المقصود
        if (intent?.action == "android.provider.Telephony.SMS_RECEIVED") {
            val bundle = intent.extras
            if (bundle != null) {
                // استخراج البيانات (PDUs) من الرسالة
                val pdus = bundle.get("pdus") as Array<*>
                val format = bundle.getString("format")
                
                for (pdu in pdus) {
                    // تحويل البيانات إلى كائن رسالة
                    val smsMessage = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        SmsMessage.createFromPdu(pdu as ByteArray, format)
                    } else {
                        SmsMessage.createFromPdu(pdu as ByteArray)
                    }

                    val sender = smsMessage.originatingAddress // رقم المرسل
                    val messageBody = smsMessage.messageBody    // نص الرسالة

                    Log.d("SmsReceiver", "وصلت رسالة من: $sender، النص: $messageBody")

                    // ═══════════════ هنا يتم ربطها مع فلاتر ═══════════════
                    // يمكنك هنا إرسال البيانات إلى فلاتر باستخدام EventChannel
                    // أو حفظها في قاعدة بيانات محلية
                }
            }
        }
    }
}