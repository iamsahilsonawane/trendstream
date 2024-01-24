package com.egeniq.androidtvprogramguide

import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.media3.common.MediaItem
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.ui.PlayerView

/**
 * A simple [Fragment] subclass.
 * Use the [LivePreviewFragment.newInstance] factory method to
 * create an instance of this fragment.
 */
class LivePreviewFragment : Fragment() {
    private var player: ExoPlayer? = null
    private var playerView: PlayerView? = null

    companion object {
        fun newInstance(bundle: Bundle): LivePreviewFragment {
            val fragment = LivePreviewFragment()
            fragment.arguments = bundle
            return fragment
        }
    }


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_live_preview, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // Create a player for playing m3u8 file.
        player = context?.let { ExoPlayer.Builder(it).build() }
        playerView = view.findViewById(R.id.idExoPlayerLiveView)

        // Attach player to the view.
        playerView?.player = player

        var url  = arguments?.getString("url")
        //if url is null, set url to the live preview
        if (url == null) {
            Log.d("LivePreviewFragment", "url is null")
            url = "http://x.lamtv.tv:8080/live/test/test/130.m3u8"
        }
        else {
            Log.d("LivePreviewFragment", url)
        }

        // Set the media item to be played.
        val mediaItem =
            MediaItem.Builder()
                .setUri(url)
                .setLiveConfiguration(
                    MediaItem.LiveConfiguration.Builder().setMaxPlaybackSpeed(1.02f).build()
                )
                .build()

        player?.setMediaItem(mediaItem)

        // Prepare the player.
        player?.prepare()

        // Start the playback.
        player?.play()

        // Hide the play/pause button.q
        playerView?.hideController()
    }


    override fun onDestroy() {
        super.onDestroy()

        player?.release()
    }
}