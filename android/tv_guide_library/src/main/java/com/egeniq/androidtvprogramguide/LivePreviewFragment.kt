package com.egeniq.androidtvprogramguide

import android.annotation.SuppressLint
import android.graphics.Color
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.LinearLayout
import androidx.fragment.app.Fragment
import androidx.media3.common.C.TRACK_TYPE_AUDIO
import androidx.media3.common.C.TRACK_TYPE_TEXT
import androidx.media3.common.C.TRACK_TYPE_VIDEO
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.common.Tracks
import androidx.media3.exoplayer.DefaultRenderersFactory
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.source.TrackGroupArray
import androidx.media3.exoplayer.trackselection.DefaultTrackSelector
import androidx.media3.exoplayer.trackselection.MappingTrackSelector
import androidx.media3.exoplayer.util.EventLogger
import androidx.media3.ui.PlayerView
import androidx.media3.ui.TrackSelectionDialogBuilder
import java.util.Objects


/**
 * A simple [Fragment] subclass.
 * Use the [LivePreviewFragment.newInstance] factory method to
 * create an instance of this fragment.
 */
class LivePreviewFragment : Fragment() {
    private var player: ExoPlayer? = null
    private var playerView: PlayerView? = null
    private var trackSelector: DefaultTrackSelector? = null;

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

    @SuppressLint("UnsafeOptInUsageError")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        Log.d("TRACKSTUFF", "onViewCreated: new changes updated")

        // Create a player for playing m3u8 file.
        // player = context?.let { ExoPlayer.Builder(it).build() }
        trackSelector = DefaultTrackSelector(requireContext())
        player = ExoPlayer.Builder(requireContext(), DefaultRenderersFactory(requireContext()).setExtensionRendererMode(DefaultRenderersFactory.EXTENSION_RENDERER_MODE_PREFER))
                .setTrackSelector(trackSelector!!)
                .build()

        playerView = view.findViewById(R.id.idExoPlayerLiveView)

        // Find and initialize views related to ExoPlayer
//        debugRootView = view.findViewById<LinearLayout>(R.id.controls_root)

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
                .build()


        player?.setMediaItem(mediaItem)

        // Prepare the player.
        player?.prepare()

        player?.addListener(object : Player.Listener {
            override fun onPlaybackStateChanged(playbackState: Int) {
                //updateButtonVisibilities();
                super.onPlaybackStateChanged(playbackState)
            }
            override fun onTracksChanged(tracks: Tracks) {
                //updateButtonVisibilities();
                super.onTracksChanged(tracks);
            }

            override fun onPlayerError(error: PlaybackException) {
                // This method is called when there is an error in the player.
                // If the error message contains "Top bit not zero",

                // This method is called when there is an error in the player.
                // If the error message contains "Top bit not zero",
                if (Objects.requireNonNull(error.message)?.contains("Top bit not zero:") == true) {
                    // Remove all views from the overlay frame layout.
                    Objects.requireNonNull(playerView!!.overlayFrameLayout)?.removeAllViews()
                    // Release the player and set it to null.
                    if (player != null) {
                        player!!.release()
                        player = null
                    }
                } else {
                    // If the error message does not contain "Top bit not zero",
                    // Update the button visibilities.
                    updateButtonVisibilities()
                }
                super.onPlayerError(error)
            }
        })

        player?.addAnalyticsListener(EventLogger())

        // Start the playback.
        player?.play()

        // Hide the play/pause button.q
        playerView?.hideController()
    }

    @SuppressLint("UnsafeOptInUsageError")
    private fun updateButtonVisibilities() {

        // Remove all views from the debugRootView. This is typically done to clear any previously added views for debugging purposes.
//        debugRootView?.removeAllViews()

        // Check if the player object is null. If it is null, there is nothing to do, so return from the method.
        if (player == null) {
            return
        }

        // Get the current MappedTrackInfo from the trackSelector. This object provides information about the available tracks for the media being played or streamed.
        val mappedTrackInfoMain: MappingTrackSelector.MappedTrackInfo = trackSelector!!.currentMappedTrackInfo ?: return

        // Check if the mappedTrackInfo object is null. If it is null, it means that there is no track information available. In this case, the method returns and exits, as there is nothing else to be done. This is a way to handle cases where there is no track information available, indicating that there may be an issue with the media being played or streamed.

        // Loop through each renderer (e.g., video, audio, subtitles) in the mappedTrackInfo.
        for (i in 0 until mappedTrackInfoMain.rendererCount) {
            // Get the track groups for the current renderer. A track group represents a set of tracks that belong to the same category, such as video tracks or audio tracks. For example, a video renderer may have multiple video track groups representing different resolutions or formats.
            val trackGroups: TrackGroupArray = mappedTrackInfoMain.getTrackGroups(i)

            // Check if there are any track groups available.
            if (trackGroups.length != 0) {
                // Create a new Button object. This button will be used to display the available track options to the user.
                Log.d("", "updateButtonVisibilities: ${trackGroups[i]}")
                val button = Button(context)
                var label: String = when (player!!.getRendererType(i)) {
                    TRACK_TYPE_AUDIO ->                         // If the renderer type is audio, set the label variable to the resource ID of the audio track selection title string.
                        "Audio"

                    TRACK_TYPE_VIDEO ->                         // If the renderer type is video, set the label variable to the resource ID of the video track selection title string.
                        "Video"

                    TRACK_TYPE_TEXT ->                         // If the renderer type is text, set the label variable to the resource ID of the text track selection title string.
                        "Subtitles"

                    else ->                         // If the renderer type is not one of the above, skip to the next iteration of the loop.
                        continue
                }
                // Set the text of the button to the value of the `label` variable, which represents the track selection title string.
                button.text = label
                // Set the text color of the button to white.
                button.setTextColor(Color.WHITE)
                // Set the tag of the button to the index `i`.
                button.tag = i
                // Set the background color of the button to transparent.
                button.setBackgroundColor(resources.getColor(R.color.transparent))
                // Set an OnClickListener on the button to handle button click events.
                button.setOnClickListener(View.OnClickListener {
                    if (it == null) {
                        return@OnClickListener;
                    }
                        // Check if the view's parent is the debugRootView
                        if (true) {//it.parent ===debugRootView) {
                            // Get the current mapped track information from the track selector
                            val mappedTrackInfo: MappingTrackSelector.MappedTrackInfo? = trackSelector!!.currentMappedTrackInfo
                            if (mappedTrackInfo != null) {
                                // Get the text (title) of the button view
                                val title = (it as Button).text
                                // Get the renderer index associated with the view
                                val rendererIndex = it.getTag() as Int
                                // Get the renderer type for the given renderer index
                                val rendererType: Int = mappedTrackInfo.getRendererType(rendererIndex)
                                // Check if adaptive selections are allowed
                                val allowAdaptiveSelections = (rendererType == TRACK_TYPE_VIDEO
                                        || (rendererType == TRACK_TYPE_AUDIO
                                        && mappedTrackInfo.getTypeSupport(TRACK_TYPE_VIDEO)
                                        == MappingTrackSelector.MappedTrackInfo.RENDERER_SUPPORT_NO_TRACKS))

                                // Create a new TrackSelectionDialogBuilder instance
                                val build = TrackSelectionDialogBuilder(requireContext(), title, player!!, rendererIndex)

                                // Set whether adaptive selections are allowed for the track selection dialog
                                build.setAllowAdaptiveSelections(allowAdaptiveSelections)
                                // Set whether to show the disable option in the track selection dialog
                                build.setShowDisableOption(true)
                                // Build the track selection dialog and show it
                                build.build().show()
                            }
                    }

                })
                button.onFocusChangeListener = View.OnFocusChangeListener { v: View?, hasFocus: Boolean ->
                    // Set an OnFocusChangeListener on the button to handle focus change events.
                    if (hasFocus) {
                        // If the button gains focus, change the background color to the default card background color.
                        button.setBackgroundColor(resources.getColor(R.color.default_card_background_color))
                    } else {
                        // If the button loses focus, change the background color back to transparent.
                        button.setBackgroundColor(resources.getColor(R.color.transparent))
                    }
                }
                // Add the button to the debugRootView, which is a container for the debug views.
//                debugRootView?.addView(button)
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()

        player?.release()
    }
}

