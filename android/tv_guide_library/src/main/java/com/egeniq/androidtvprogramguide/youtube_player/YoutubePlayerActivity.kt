package com.egeniq.androidtvprogramguide.youtube_player

import android.os.Bundle
import android.util.Log
import android.view.KeyEvent
import androidx.appcompat.app.AppCompatActivity
import com.egeniq.androidtvprogramguide.R
import com.jakewharton.threetenabp.AndroidThreeTen
import com.pierfrancescosoffritti.androidyoutubeplayer.core.customui.DefaultPlayerUiController
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.PlayerConstants.PlayerState
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.YouTubePlayer
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.listeners.AbstractYouTubePlayerListener
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.listeners.YouTubePlayerListener
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.options.IFramePlayerOptions
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.utils.YouTubePlayerTracker
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.views.YouTubePlayerView


class YoutubePlayerActivity : AppCompatActivity() {

    private var mYoutubePlayer: YouTubePlayer? = null
    private val youTubePlayerTracker = YouTubePlayerTracker()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AndroidThreeTen.init(this)
        setContentView(R.layout.activity_youtube_player)

        val youTubePlayerView = findViewById<YouTubePlayerView>(R.id.youtube_player_view)
        lifecycle.addObserver(youTubePlayerView)

        val listener: YouTubePlayerListener = object : AbstractYouTubePlayerListener() {
            override fun onReady(youTubePlayer: YouTubePlayer) {
                // using pre-made custom ui
                val defaultPlayerUiController = DefaultPlayerUiController(youTubePlayerView, youTubePlayer)
                youTubePlayerView.setCustomPlayerUi(defaultPlayerUiController.rootView)
            }
        }

        // disable iframe ui
        val options: IFramePlayerOptions = IFramePlayerOptions.Builder().controls(0).build()
        youTubePlayerView.initialize(listener, options)

        youTubePlayerView.addYouTubePlayerListener(object : AbstractYouTubePlayerListener() {
            override fun onReady(youTubePlayer: YouTubePlayer) {
                val videoId = "4SCjXcBeW1E"
                youTubePlayer.loadVideo(videoId, 0f)
                mYoutubePlayer = youTubePlayer;

                val defaultPlayerUiController = DefaultPlayerUiController(youTubePlayerView, youTubePlayer)
                youTubePlayerView.setCustomPlayerUi(defaultPlayerUiController.rootView)
            }
        })


        supportActionBar?.hide()
    }

    var currentVolume = 100

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        Log.d("TAG", "onKeyDown: $keyCode = before");
        if (mYoutubePlayer != null && youTubePlayerTracker != null) {
            Log.d("TAG", "onKeyDown: $keyCode = after");
            when (keyCode) {
                KeyEvent.KEYCODE_DPAD_UP -> {
                    currentVolume = Math.max(currentVolume + 5, 100)
                    mYoutubePlayer!!.setVolume(currentVolume)
                    return true
                }

                KeyEvent.KEYCODE_MEDIA_PLAY -> {
                    mYoutubePlayer!!.play()
                    return true
                }

                KeyEvent.KEYCODE_MEDIA_PAUSE -> {
                    mYoutubePlayer!!.pause()
                    return true
                }

                KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE -> {
                    if (youTubePlayerTracker.state !== PlayerState.PLAYING) {
                        mYoutubePlayer!!.play()
                    } else {
                        mYoutubePlayer!!.pause()
                    }
                    return true
                }

                KeyEvent.KEYCODE_DPAD_DOWN -> {
                    currentVolume = Math.min(currentVolume - 5, 0)
                    mYoutubePlayer!!.setVolume(currentVolume)
                    return true
                }

                KeyEvent.KEYCODE_DPAD_RIGHT -> {
                    mYoutubePlayer!!.seekTo((youTubePlayerTracker.currentSecond + 10).coerceAtLeast(youTubePlayerTracker.videoDuration))
                    return true
                }

                KeyEvent.KEYCODE_DPAD_LEFT -> {
                    mYoutubePlayer!!.seekTo((youTubePlayerTracker.currentSecond - 10.0).coerceAtLeast(0.0).toFloat())
                    return true
                }
            }
        }
        return false
    }
}