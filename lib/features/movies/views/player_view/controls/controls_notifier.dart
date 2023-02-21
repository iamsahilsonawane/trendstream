import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final playerControlsNotifierProvider = ChangeNotifierProvider.autoDispose
    .family<PlayerControlsNotifier, VlcPlayerController>((ref, controller) {
  return PlayerControlsNotifier(vlcPlayerController: controller);
});

enum ControlsOverlayVisibility {
  visible,
  hidden,
}

class PlayerControlsNotifier extends ChangeNotifier {
  PlayerControlsNotifier({Key? key, required this.vlcPlayerController}) {
    init.call();
  }

  ///Main init function
  Future<void> init() async {
    playingState = vlcPlayerController.value.playingState;
    vlcPlayerController.addListener(_updatesListener);
    if (vlcPlayerController.autoPlay) {
      _cancelAndRestartTimer();
    }
  }

  @override
  void dispose() {
    vlcPlayerController.removeListener(_updatesListener);
    _hideTimer?.cancel();
    _controlsVisibilityController.close();
    super.dispose();
  }

  final VlcPlayerController vlcPlayerController;
  String duration = "00:00";

  // ---- Getters & Setters ----

  Timer? _hideTimer;
  bool _hideStuff = false;
  bool get hideStuff => _hideStuff;
  set hideStuff(bool newVal) {
    if (newVal == _hideStuff) return;
    _hideStuff = newVal;
    _controlsVisibilityController.add(_hideStuff
        ? ControlsOverlayVisibility.hidden
        : ControlsOverlayVisibility.visible);
    notifyListeners();
  }

  PlayingState _playingState = PlayingState.initializing;
  PlayingState get playingState => _playingState;
  set playingState(PlayingState newState) {
    if (newState == _playingState) return;
    _playingState = newState;
    notifyListeners();
  }

  Duration _playbackPosition = Duration.zero;
  Duration get playbackPosition => _playbackPosition;
  set playbackPosition(Duration newState) {
    if (newState.inSeconds == playbackPosition.inSeconds) return;
    _playbackPosition = newState;
    notifyListeners();
  }

  bool _forceStopped = false;

  bool get forceStopped => _forceStopped;

  set forceStopped(bool newVal) {
    if (newVal == _forceStopped) return;
    _forceStopped = newVal;
  }

  List<double> playbackSpeeds = [0.5, 1.0, 2.0];
  int playbackSpeedIndex = 0;
  double get currentPlaybackSpeed => playbackSpeeds[playbackSpeedIndex];

  int selectedAudioTrackId = 1;
  int selectedSubtitleId = -1;

  // ---- Getters & Setters END ----

  final StreamController<ControlsOverlayVisibility>
      _controlsVisibilityController = StreamController.broadcast();
  Stream<ControlsOverlayVisibility> get controlsVisibilityUpdates =>
      _controlsVisibilityController.stream;

  // ---- Helper Methods ----

  Future<void> setPlaybackSpeed(int playbackIndex) async {
    if (playbackIndex >= playbackSpeeds.length) return;

    playbackSpeedIndex = playbackIndex;
    notifyListeners();

    return await vlcPlayerController
        .setPlaybackSpeed(playbackSpeeds.elementAt(playbackSpeedIndex));
  }

  void _startHideTimer() {
    const hideControlsTimer = Duration(seconds: 4);
    log("_startHideTimer");
    _hideTimer = Timer(hideControlsTimer, () {
      hideStuff = true;
      log("Timer complete");
    });
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    hideStuff = false;
    _startHideTimer();
  }

  void stopTimer() {
    if (_hideTimer?.isActive ?? false) _hideTimer!.cancel();
    _hideStuff = false;
  }

  Future<void> _updatesListener() async {
    //not using setter for all as it would call notifyListeners() each time
    _playingState = vlcPlayerController.value.playingState;
    _playbackPosition = vlcPlayerController.value.position;
    duration = formatDurationToString(vlcPlayerController.value.duration);
    log("Playing State: ${describeEnum(_playingState)}");
    if (playingState == PlayingState.ended) {
      log("Video has been ended / stopped. Cancelling timer");
      stopTimer();
    }
    // } else if (_playingState == PlayingState.playing) {
    //   log("Video is playing. Starting timer");
    //   if (!_hideStuff) {
    //     _startHideTimer();
    //   }
    // } else if (_playingState == PlayingState.paused) {
    //   log("Video is paused. Cancelling timer");
    //   stopTimer();
    // }
    notifyListeners();
  }

  ///Formats duration for the player
  formatDurationToString(Duration oDuration) {
    if (oDuration.inHours == 0) {
      var strDuration = oDuration.toString().split('.')[0];
      return "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
    } else {
      return oDuration.toString().split('.')[0];
    }
  }

  void onHover() {
    if (vlcPlayerController.value.playingState != PlayingState.stopped &&
        vlcPlayerController.value.playingState != PlayingState.ended) {
      if (forceStopped) {
        return;
      }
      _cancelAndRestartTimer();
    }
  }

  // ---- Helper Methods END ----

  // ---- Public Methods ----

  Future<void> play() {
    _cancelAndRestartTimer();
    return vlcPlayerController.play();
  }

  Future<void> replay() async {
    _cancelAndRestartTimer();
    await Future.wait([
      vlcPlayerController.stop(),
      vlcPlayerController.play(),
    ]);
  }

  Future<void> pause() async {
    if (vlcPlayerController.value.isPlaying) {
      _hideTimer?.cancel();
      notifyListeners();
      await vlcPlayerController.pause();
    }
  }

  /// Returns a callback which seeks the video relative to current playing time.
  Future<void> _seekRelative(Duration seekStep) async {
    await vlcPlayerController
        .seekTo(vlcPlayerController.value.position + seekStep);
  }

  Future<void> seekForward({int seconds = 15}) async {
    assert(seconds < 100, "Cannot seek over 100 seconds");

    return _seekRelative(Duration(seconds: seconds.abs()));
  }

  Future<void> seekBackward({int seconds = 15}) async {
    assert(seconds < 100, "Cannot seek back 100 seconds");

    return _seekRelative(Duration(seconds: -(seconds.abs())));
  }

  // ---- Public Methods END ----
}
