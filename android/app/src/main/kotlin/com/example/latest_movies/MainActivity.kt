package com.example.latest_movies

import io.flutter.embedding.android.FlutterActivity
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "com.example.latest_movies/channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->
            if (call.method == "checkForRequestPackageInstalls") {
                val hasPermission = getPermissionStatus()
                result.success(hasPermission)

            } else {
                result.notImplemented()
            }
        }
    }


    private fun getPermissionStatus(): Boolean {
        val hasPermission = if (VERSION.SDK_INT >= VERSION_CODES.O) {
            packageManager.canRequestPackageInstalls()
        } else {
            true
        }

        return hasPermission
    }

}
