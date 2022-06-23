import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:focus_notifier/focus_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../router/router.dart';
import 'controls_notifier.dart';

class PlayerControls extends HookConsumerWidget {
  const PlayerControls({Key? key, required this.vlcPlayerController})
      : super(key: key);

  final VlcPlayerController vlcPlayerController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlsModel =
        ref.watch(playerControlsNotifierProvider(vlcPlayerController));

    final sliderFocusNode =
        useFocusNode(canRequestFocus: false, skipTraversal: true);

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
                                  focusColor: Colors.white.withOpacity(0.2),
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
                                  focusColor: Colors.white.withOpacity(0.2),
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
                            data: Theme.of(context).sliderTheme.copyWith(
                                  thumbShape: SliderComponentShape.noThumb,
                                  trackHeight: 5,
                                ),
                            child: Slider(
                              focusNode: sliderFocusNode,
                              activeColor: Colors.redAccent,
                              inactiveColor: Colors.white70,
                              value: controlsModel.playbackPosition.inSeconds
                                  .toDouble(),
                              min: 0.0,
                              max: vlcPlayerController.value.duration.inSeconds
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
