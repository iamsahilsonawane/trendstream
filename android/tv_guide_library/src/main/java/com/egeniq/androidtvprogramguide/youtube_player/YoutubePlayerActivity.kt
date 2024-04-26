package com.egeniq.androidtvprogramguide.youtube_player

import android.os.Bundle
import android.util.Log
import android.view.KeyEvent
import android.widget.Button
import android.widget.TextView
import android.content.pm.ActivityInfo
import android.content.res.Configuration
import android.view.View
import android.view.ViewGroup
import androidx.activity.OnBackPressedCallback
import androidx.appcompat.app.AppCompatActivity
import com.egeniq.androidtvprogramguide.R
import com.jakewharton.threetenabp.AndroidThreeTen
import com.pierfrancescosoffritti.androidyoutubeplayer.core.customui.DefaultPlayerUiController
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.PlayerConstants
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.PlayerConstants.PlayerState
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.YouTubePlayer
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.listeners.AbstractYouTubePlayerListener
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.listeners.FullscreenListener
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.listeners.YouTubePlayerListener
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.options.IFramePlayerOptions
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.utils.YouTubePlayerTracker
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.utils.loadOrCueVideo
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.views.YouTubePlayerView
import kotlin.math.max
import kotlin.math.min


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
                //list of videos
                val listOfVids = listOf("4SCjXcBeW1E", "Jokpt_LJpbw", "73_1biulkYk", "NC0DNl82Cgg", "N6DmjhcSt8Q");
                val videoId = listOfVids.random()
                youTubePlayer.loadVideo(videoId, 0f)
                mYoutubePlayer = youTubePlayer;
                mYoutubePlayer?.addListener(youTubePlayerTracker);
                val defaultPlayerUiController = DefaultPlayerUiController(youTubePlayerView, youTubePlayer)
                youTubePlayerView.setCustomPlayerUi(defaultPlayerUiController.rootView)
            }
        })

        val onBackPressCallback = object:OnBackPressedCallback(true){
            override fun handleOnBackPressed() {
                Log.d("YOUTUBEPLAYERACTIVITY", "handleOnBackPressed: handled")
                finish()
            }
        }

        onBackPressedDispatcher.addCallback(this, onBackPressCallback)

        supportActionBar?.hide()
    }

    override fun onBackPressed() {
        onBackPressedDispatcher.onBackPressed()
        super.onBackPressed();

    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        Log.d("YOUTUBEPLAYERACTIVITY", "onKeyDown: $keyCode = before");
        if (mYoutubePlayer != null && youTubePlayerTracker != null) {
            Log.d("YOUTUBEPLAYERACTIVITY", "onKeyDown: $keyCode = after");
            when (keyCode) {
                KeyEvent.KEYCODE_MEDIA_PLAY,
                KeyEvent.KEYCODE_MEDIA_PAUSE,
                KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE,
                KeyEvent.KEYCODE_DPAD_CENTER,
                KeyEvent.KEYCODE_BUTTON_SELECT -> {
                    Log.d("YOUTUBEPLAYERACTIVITY", "onKeyDown: play/pause");
                    if (youTubePlayerTracker.state !== PlayerState.PLAYING) {
                        mYoutubePlayer!!.play()
                    } else {
                        mYoutubePlayer!!.pause()
                    }
                    return true
                }

                KeyEvent.KEYCODE_DPAD_RIGHT,
                KeyEvent.KEYCODE_BUTTON_R2,
                KeyEvent.KEYCODE_MEDIA_FAST_FORWARD -> {
                    Log.d("YOUTUBEPLAYERACTIVITY", "onKeyDown: Forward");
                    mYoutubePlayer!!.seekTo(min((youTubePlayerTracker.currentSecond + 10.0).toFloat(),  youTubePlayerTracker.videoDuration));
                    return true
                }

                KeyEvent.KEYCODE_DPAD_LEFT ,
                KeyEvent.KEYCODE_BUTTON_L2,
                KeyEvent.KEYCODE_MEDIA_REWIND -> {
                    Log.d("YOUTUBEPLAYERACTIVITY", "onKeyDown: Rewind");
                    mYoutubePlayer!!.seekTo(max((youTubePlayerTracker.currentSecond - 10.0).toFloat(),  0.0.toFloat()));
                    return true
                }

                KeyEvent.KEYCODE_BACK ->
                   onBackPressedDispatcher.run { onBackPressed() }

            }
        }
        return false
    }

//    private lateinit var youTubePlayerView: YouTubePlayerView
//    private var youTubePlayer: YouTubePlayer? = null
//    private var isFullscreen = false
//
//    private lateinit var fullscreenViewContainer: ViewGroup
//    private lateinit var playerUiContainer: View
//
//    private lateinit var playNextVideoButton: Button
//    private lateinit var playbackSpeedTextView: TextView
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        setContentView(R.layout.activity_complete_example)
//        youTubePlayerView = findViewById(R.id.youtube_player_view)
//
//        fullscreenViewContainer = findViewById(R.id.full_screen_view_container)
//        playerUiContainer = findViewById(R.id.player_ui_container)
//        playNextVideoButton = findViewById(R.id.next_video_button)
//        playbackSpeedTextView = findViewById(R.id.playback_speed_text_view)
//
//        initYouTubePlayerView(youTubePlayerView)
//    }
//
//    override fun onConfigurationChanged(configuration: Configuration) {
//        super.onConfigurationChanged(configuration)
//
//        // Checks the orientation of the screen
//        if (configuration.orientation == Configuration.ORIENTATION_LANDSCAPE) {
//            if (!isFullscreen) {
//                youTubePlayer?.toggleFullscreen()
//            }
//        } else if (configuration.orientation == Configuration.ORIENTATION_PORTRAIT) {
//            if (isFullscreen) {
//                youTubePlayer?.toggleFullscreen()
//            }
//        }
//    }
//
//    override fun onBackPressed() {
//        if (isFullscreen) {
//            youTubePlayer?.toggleFullscreen()
//        } else {
//            super.onBackPressed()
//        }
//    }
//
//    private fun initYouTubePlayerView(youTubePlayerView: YouTubePlayerView) {
//        // The player will automatically release itself when the activity is destroyed.
//        // The player will automatically pause when the activity is stopped
//        // If you don't add YouTubePlayerView as a lifecycle observer, you will have to release it manually.
//        lifecycle.addObserver(youTubePlayerView)
//
//        youTubePlayerView.addFullscreenListener(object : FullscreenListener {
//            override fun onEnterFullscreen(fullscreenView: View, exitFullscreen: () -> Unit) {
//                isFullscreen = true
//
//                // the video will continue playing in fullscreenView
//                playerUiContainer.visibility = View.GONE
//                fullscreenViewContainer.visibility = View.VISIBLE
//                fullscreenViewContainer.addView(fullscreenView)
//
//                if (requestedOrientation != ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE) {
//                    requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE
//                }
//            }
//
//            override fun onExitFullscreen() {
//                isFullscreen = false
//
//                // the video will continue playing in the player
//                playerUiContainer.visibility = View.VISIBLE
//                fullscreenViewContainer.visibility = View.GONE
//                fullscreenViewContainer.removeAllViews()
//
//                if (requestedOrientation != ActivityInfo.SCREEN_ORIENTATION_SENSOR) {
//                    requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_USER_PORTRAIT
//                    requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR
//                }
//            }
//        })
//
//        val youTubePlayerListener = object : AbstractYouTubePlayerListener() {
//            override fun onReady(youTubePlayer: YouTubePlayer) {
//                this@YoutubePlayerActivity.youTubePlayer = youTubePlayer
//                youTubePlayer.loadOrCueVideo(lifecycle, VideoIdsProvider.getNextVideoId(), 0f)
//                setPlayNextVideoButtonClickListener(youTubePlayer)
//                setPlaybackSpeedButtonsClickListeners(youTubePlayer)
//            }
//
//            override fun onPlaybackRateChange(youTubePlayer: YouTubePlayer, playbackRate: PlayerConstants.PlaybackRate) {
//                playbackSpeedTextView.text = "Playback speed: $playbackRate"
//            }
//        }
//
//        val iFramePlayerOptions = IFramePlayerOptions.Builder()
//                .controls(1)
//                .fullscreen(1) // enable full screen button
//                .build()
//
//        youTubePlayerView.enableAutomaticInitialization = false
//        youTubePlayerView.initialize(youTubePlayerListener, iFramePlayerOptions)
//    }
//
//    /**
//     * Set a click listener on the "Play next video" button
//     */
//    private fun setPlayNextVideoButtonClickListener(youTubePlayer: YouTubePlayer) {
//        playNextVideoButton.setOnClickListener {
//            youTubePlayer.loadOrCueVideo(lifecycle, VideoIdsProvider.getNextVideoId(), 0f)
//        }
//    }
//
//    /**
//     * Set the click listeners for the "playback speed" buttons
//     */
//    private fun setPlaybackSpeedButtonsClickListeners(youTubePlayer: YouTubePlayer) {
//        val playbackSpeed_0_25 = findViewById<Button>(R.id.playback_speed_0_25)
//        val playbackSpeed_1 = findViewById<Button>(R.id.playback_speed_1)
//        val playbackSpeed_2 = findViewById<Button>(R.id.playback_speed_2)
//        playbackSpeed_0_25.setOnClickListener { youTubePlayer.setPlaybackRate(PlayerConstants.PlaybackRate.RATE_0_25) }
//        playbackSpeed_1.setOnClickListener { youTubePlayer.setPlaybackRate(PlayerConstants.PlaybackRate.RATE_1) }
//        playbackSpeed_2.setOnClickListener { youTubePlayer.setPlaybackRate(PlayerConstants.PlaybackRate.RATE_2) }
//    }
}