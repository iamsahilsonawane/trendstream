package com.example.latest_movies

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.util.Log
import com.egeniq.androidtvprogramguide.player.PlayerActivity
import com.egeniq.androidtvprogramguide.youtube_player.YoutubePlayerActivity
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
            } else  if (call.method == "navigateToGuide") {
                val intent = Intent(this, GuideActivity::class.java)
                startActivity(intent)
                result.success(null)
            } else  if (call.method == "navigateToPlayer") {
                val intent = Intent(context, PlayerActivity::class.java)
                intent.putExtra("url", "http://23.237.117.10/testmax1080.mkv")
                startActivity(intent)
                result.success(null)
            }  else  if (call.method == "navigateToYoutubePlayer") {
                val args = call.arguments as Map<*, *>;
                val intent = Intent(context, YoutubePlayerActivity::class.java)
                if (args["video_id"] != null) {
                    Log.d("MainActivity", "configureFlutterEngine: Video id received: ${args["video_id"]}")
                    intent.putExtra("video_id", args["video_id"].toString())
                } else {
                    Log.d("MainActivity", "configureFlutterEngine: Video id not received")
                }
                startActivity(intent)
                result.success(null)
            }  else {
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
