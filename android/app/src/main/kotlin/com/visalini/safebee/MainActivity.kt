package com.visalini.safebee

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.visalini.safebee.sms"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "sendSMS" -> {

                    val phone = call.argument<String>("phone")
                    val message = call.argument<String>("message")

                    if (phone != null && message != null) {

                        try {
                            SmsHelper.sendSMS(
                                this,
                                phone,
                                message
                            )

                            result.success("SMS Sent")

                        } catch (e: Exception) {

                            result.error(
                                "SMS_ERROR",
                                e.message,
                                null
                            )
                        }

                    } else {

                        result.error(
                            "INVALID_ARGUMENT",
                            "Phone or message is null",
                            null
                        )
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}