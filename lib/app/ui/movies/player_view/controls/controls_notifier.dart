import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final playerControlsNotifierProvider = ChangeNotifierProvider.autoDispose
    .family<PlayerControlsNotifier, VlcPlayerController>((ref, controller) {
  return PlayerControlsNotifier(vlcPlayerController: controller);
});

class PlayerControlsNotifier extends ChangeNotifier {
  PlayerControlsNotifier({Key? key, required this.vlcPlayerController}) {
    init.call();
  }

  ///Main init function
  Future<void> init() async {
    playingState = vlcPlayerController.value.playingState;
    vlcPlayerController.addListener(_updatesListener);
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
  // ---- Getters & Setters END ----

  // ---- Helper Methods ----

  void _startHideTimer() {
    const hideControlsTimer = Duration(seconds: 2);
    _hideTimer = Timer(hideControlsTimer, () {
      hideStuff = true;
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
    duration = _formatDurationToString(vlcPlayerController.value.duration);
    log("Playing State: ${describeEnum(_playingState)}");
    if (_playingState == PlayingState.stopped ||
        _playingState == PlayingState.ended) {
      log("Video has been ended / stopped. Cancelling timer");
      stopTimer();
    }
    notifyListeners();
  }

  ///Formats duration for the player
  _formatDurationToString(Duration oDuration) {
    if (oDuration.inHours == 0) {
      var strDuration = oDuration.toString().split('.')[0];
      return "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
    } else {
      return oDuration.toString().split('.')[0];
    }
  }

  void onHover() {
    _cancelAndRestartTimer();
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
