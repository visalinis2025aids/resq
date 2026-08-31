package com.visalini.safebee

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.telephony.SmsManager
import android.util.Log
import androidx.core.content.ContextCompat

object SmsHelper {

    fun sendSMS(
        context: Context,
        phoneNumber: String,
        message: String
    ) {

        val permissionCheck = ContextCompat.checkSelfPermission(
            context,
            Manifest.permission.SEND_SMS
        )

        if (permissionCheck != PackageManager.PERMISSION_GRANTED) {
            throw Exception("SEND_SMS Permission Denied")
        }

        try {

            Log.d(
                "SAFEBEE_SMS",
                "===================================="
            )
            Log.d(
                "SAFEBEE_SMS",
                "Sending SMS..."
            )
            Log.d(
                "SAFEBEE_SMS",
                "Phone Number : $phoneNumber"
            )
            Log.d(
                "SAFEBEE_SMS",
                "Message : $message"
            )

            val smsManager = context.getSystemService(
                SmsManager::class.java
            )

            smsManager.sendTextMessage(
                phoneNumber,
                null,
                message,
                null,
                null
            )

            Log.d(
                "SAFEBEE_SMS",
                "SMS Sent Successfully"
            )
            Log.d(
                "SAFEBEE_SMS",
                "===================================="
            )

        } catch (e: Exception) {

            Log.e(
                "SAFEBEE_SMS",
                "SMS Failed : ${e.message}"
            )

            throw Exception(
                "Failed to send SMS : ${e.message}"
            )
        }
    }
}