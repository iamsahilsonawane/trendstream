package com.egeniq.androidtvprogramguide.youtube_player;

import android.annotation.SuppressLint;
import android.content.res.Configuration;
import android.graphics.Color;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.widget.HorizontalScrollView;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.egeniq.androidtvprogramguide.R;
//import com.egeniq.androidtvprogramguide.player.CustomDefaultTimeBar;
//import com.egeniq.androidtvprogramguide.player.Utils;
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.PlayerConstants;
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.YouTubePlayer;
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.listeners.AbstractYouTubePlayerListener;
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.listeners.YouTubePlayerListener;
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.options.IFramePlayerOptions;
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.utils.YouTubePlayerTracker;
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.utils.YouTubePlayerUtils;
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.views.YouTubePlayerView;

import java.util.Objects;

public class CustomUiActivity extends AppCompatActivity {

  private YouTubePlayerView youTubePlayerView;
  private YouTubePlayer mYoutubePlayer;
  private final YouTubePlayerTracker youTubePlayerTracker = new YouTubePlayerTracker();

    @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_youtube_player);
    Objects.requireNonNull(getSupportActionBar()).hide();

    youTubePlayerView = findViewById(R.id.youtube_player_view);
    getLifecycle().addObserver(youTubePlayerView);

    View customPlayerUi = youTubePlayerView.inflateCustomPlayerUi(R.layout.empty_youtube_player_ui);

    YouTubePlayerListener listener = new AbstractYouTubePlayerListener() {
      @Override
      public void onReady(@NonNull YouTubePlayer youTubePlayer) {
//        CustomPlayerUiController customPlayerUiController = new CustomPlayerUiController(CustomUiActivity.this, customPlayerUi, youTubePlayer, youTubePlayerView);
//        youTubePlayer.addListener(customPlayerUiController);
        mYoutubePlayer = youTubePlayer;
        YouTubePlayerUtils.loadOrCueVideo(
                youTubePlayer, getLifecycle(),
                "HFYv-rk4v9Y", 0f
        );
      }
    };

    // disable web ui
    IFramePlayerOptions options = new IFramePlayerOptions.Builder().controls(0).build();

    youTubePlayerView.initialize(listener, options);

//    final HorizontalScrollView horizontalScrollView = (HorizontalScrollView) getLayoutInflater().inflate(R.layout.controls, null);
//    final LinearLayout controls = horizontalScrollView.findViewById(R.id.controls);
    //CustomDefaultTimeBar timeBar = playerView.findViewById(R.id.exo_progress);
    //timeBar.setAdMarkerColor(Color.argb(0x00, 0xFF, 0xFF, 0xFF));
    //timeBar.setPlayedAdMarkerColor(Color.argb(0x98, 0xFF, 0xFF, 0xFF));
  }

  @Override
  public boolean onKeyDown(int keyCode, KeyEvent event) {
    Log.d("onKeyDown", "onKeyDown: keyCode=" + keyCode + ", event=" + event);
    if (mYoutubePlayer != null && youTubePlayerTracker != null) {
      Log.d("onKeyDown", "onKeyDown: mYoutubePlayer != null && youTubePlayerTracker != null");
      switch (keyCode) {
        case KeyEvent.KEYCODE_MEDIA_PLAY:
          mYoutubePlayer.play();
          return true;
        case KeyEvent.KEYCODE_MEDIA_PAUSE:
          mYoutubePlayer.pause();
          return true;
        case KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE:
        case KeyEvent.KEYCODE_DPAD_CENTER:
          if (youTubePlayerTracker.getState() != PlayerConstants.PlayerState.PLAYING) {
            mYoutubePlayer.play();
          } else {
            mYoutubePlayer.pause();
          }
          return true;
        case KeyEvent.KEYCODE_DPAD_RIGHT:
          mYoutubePlayer.seekTo(Math.max(youTubePlayerTracker.getCurrentSecond() + 10, youTubePlayerTracker.getVideoDuration()));
          return true;
        case KeyEvent.KEYCODE_DPAD_LEFT:
          mYoutubePlayer.seekTo(Math.min(youTubePlayerTracker.getCurrentSecond() - 10, 0));
          return true;
      }
    }
    return false;
  }

  @Override
  public void onConfigurationChanged(@NonNull Configuration newConfig) {
    super.onConfigurationChanged(newConfig);

    // Checks the orientation of the screen
    if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
      youTubePlayerView.matchParent();
    } else if (newConfig.orientation == Configuration.ORIENTATION_PORTRAIT) {
      youTubePlayerView.wrapContent();
    }
  }
}
