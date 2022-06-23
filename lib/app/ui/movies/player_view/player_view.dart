import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:focus_notifier/focus_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../router/router.dart';

final playerControlsNotifierProvider = ChangeNotifierProvider.autoDispose
    .family<PlayerControlsNotifier, VlcPlayerController>((ref, controller) {
  return PlayerControlsNotifier(vlcPlayerController: controller);
});

class PlayerControlsNotifier extends ChangeNotifier {
  PlayerControlsNotifier({Key? key, required this.vlcPlayerController}) {
    init.call();
  }

  final VlcPlayerController vlcPlayerController;
  Timer? _hideTimer;
  bool _hideStuff = false;
  bool get hideStuff => _hideStuff;
  set hideStuff(bool newVal) {
    if (newVal == _hideStuff) return;
    _hideStuff = newVal;
    notifyListeners();
  }

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

  Future<void> init() async {
    playingState = vlcPlayerController.value.playingState;
    vlcPlayerController.addListener(() {
      playingState = vlcPlayerController.value.playingState;
      playbackPosition = vlcPlayerController.value.position;
    });
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

  void onHover() {
    _cancelAndRestartTimer();
  }

  void showControlsNoCancel() {
    if (_hideTimer?.isActive ?? false) _hideTimer!.cancel();
    _hideStuff = false;
  }
}

class PlayerView extends StatefulWidget {
  const PlayerView({Key? key}) : super(key: key);

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  late VlcPlayerController _videoPlayerController;
  final sliderFocusNode =
      FocusNode(canRequestFocus: false, skipTraversal: true);

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VlcPlayerController.network(
      'https://media.w3.org/2010/05/sintel/trailer.mp4',
      hwAcc: HwAcc.full,
      autoPlay: false,
    );
  }

  @override
  void dispose() async {
    super.dispose();
    sliderFocusNode.dispose();
    await _videoPlayerController.stopRendererScanning();
    await _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: VlcPlayer(
              controller: _videoPlayerController,
              aspectRatio: 16 / 9,
              placeholder: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
        HookConsumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final controlsModel = ref
                .watch(playerControlsNotifierProvider(_videoPlayerController));

            return Positioned.fill(
              child: AnimatedOpacity(
                opacity: controlsModel.hideStuff ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: MouseRegion(
                  onHover: (_) {
                    controlsModel.onHover();
                  },
                  child: Scaffold(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    body: NotificationListener<FocusNotification>(
                      onNotification: (notification) {
                        debugPrint(
                            "New widget focused: ${notification.childKey.toString()}");
                        controlsModel.showControlsNoCancel();
                        return true;
                      },
                      child: FocusScope(
                        autofocus: true,
                        onFocusChange: (onFocussed) {
                          //only get exec on first time focus to the decendant
                        },
                        child: Stack(
                          children: [
                            Align(
                              alignment: const Alignment(-0.98, -0.95),
                              child: FocusNotifier(
                                key: const Key("navigateBack"),
                                builder: (context, node) => IconButton(
                                  iconSize: 30,
                                  focusNode: node,
                                  focusColor: Colors.white.withOpacity(0.2),
                                  color: Colors.white,
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () => AppRouter.pop(),
                                ),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(0, 0.9),
                              child: Column(
                                children: [
                                  const Expanded(child: SizedBox()),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FocusNotifier(
                                        key: const Key("seekBackward"),
                                        builder: (context, node) => IconButton(
                                          focusNode: node,
                                          iconSize: 30,
                                          focusColor:
                                              Colors.white.withOpacity(0.2),
                                          color: Colors.white,
                                          onPressed: () {
                                            controlsModel.seekBackward();
                                          },
                                          icon: const Icon(Icons.fast_rewind),
                                        ),
                                      ),
                                      FocusNotifier(
                                        key: const Key("playPause"),
                                        builder: (context, node) =>
                                            buildPlaybackControl(
                                                controlsModel.playingState,
                                                controlsModel,
                                                node),
                                      ),
                                      FocusNotifier(
                                        key: const Key("seekForward"),
                                        builder: (context, node) => IconButton(
                                          iconSize: 30,
                                          focusNode: node,
                                          focusColor:
                                              Colors.white.withOpacity(0.2),
                                          color: Colors.white,
                                          onPressed: () {
                                            controlsModel.seekForward();
                                          },
                                          icon: const Icon(Icons.fast_forward),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SliderTheme(
                                    data:
                                        Theme.of(context).sliderTheme.copyWith(
                                              thumbShape:
                                                  SliderComponentShape.noThumb,
                                              trackHeight: 5,
                                            ),
                                    child: Slider(
                                      focusNode: sliderFocusNode,
                                      activeColor: Colors.redAccent,
                                      inactiveColor: Colors.white70,
                                      value: controlsModel
                                          .playbackPosition.inSeconds
                                          .toDouble(),
                                      min: 0.0,
                                      max: _videoPlayerController
                                          .value.duration.inSeconds
                                          .toDouble(),
                                      onChanged: (_) {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ]),
    );
  }

  Widget buildPlaybackControl(PlayingState playingState,
      PlayerControlsNotifier controlsNotifier, FocusNode node) {
    switch (playingState) {
      case PlayingState.initialized:
      case PlayingState.stopped:
      case PlayingState.paused:
        return IconButton(
          onPressed: controlsNotifier.play,
          focusNode: node,
          icon: const Icon(Icons.play_arrow),
          iconSize: 30,
          focusColor: Colors.white.withOpacity(0.2),
          color: Colors.white,
        );
      case PlayingState.buffering:
      case PlayingState.playing:
        return IconButton(
          onPressed: controlsNotifier.pause,
          focusNode: node,
          icon: const Icon(Icons.pause),
          iconSize: 30,
          focusColor: Colors.white.withOpacity(0.2),
          color: Colors.white,
        );
      case PlayingState.ended:
      case PlayingState.error:
        return IconButton(
          onPressed: controlsNotifier.replay,
          focusNode: node,
          icon: const Icon(Icons.replay),
          iconSize: 30,
          focusColor: Colors.white.withOpacity(0.2),
          color: Colors.white,
        );
      default:
        return IconButton(
          onPressed: controlsNotifier.play,
          focusNode: node,
          icon: const Icon(Icons.play_arrow),
          iconSize: 30,
          focusColor: Colors.white.withOpacity(0.2),
          color: Colors.white,
        );
    }
  }
}
