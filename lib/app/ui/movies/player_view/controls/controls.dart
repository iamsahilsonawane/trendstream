import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:focus_notifier/focus_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/app/ui/movies/player_view/controls/focus_scope_node_hook.dart';
import 'package:latest_movies/app/utilities/design_utility.dart';

import '../../../../../router/router.dart';
import 'controls_notifier.dart';

import 'dart:async';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      log("Cancelling the timer");
    }
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class PlayerControls extends HookConsumerWidget {
  const PlayerControls({Key? key, required this.vlcPlayerController})
      : super(key: key);

  final VlcPlayerController vlcPlayerController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlsModel =
        ref.watch(playerControlsNotifierProvider(vlcPlayerController));

    final sliderFocusNode =
        useFocusNode(canRequestFocus: true, skipTraversal: false);

    final sliderControllerFocusNode =
        useFocusNode(canRequestFocus: true, skipTraversal: true);

    final focusScopeNode = useFocusScopeNode();

    //debouncers - (used to prevent multiple clicks issue) sometimes one click on the dpad registers multiple clicks
    final sliderChangeDebouncer =
        useMemoized(() => Debouncer(milliseconds: 50));
    final upDebouncer = useMemoized(() => Debouncer(milliseconds: 50));
    final downDebouncer = useMemoized(() => Debouncer(milliseconds: 50));

    //counters to fix slider issue (passing down the focus from slider on up and down dpad buttons)
    final upCounter = useRef(0);
    final downCounter = useRef(0);

    final isSubtitlesAdded = useRef(false);

    useEffect(() {
      subtitlesInitListener() async {
        await vlcPlayerController.addSubtitleFromNetwork(
            "https://gist.githubusercontent.com/iamsahilsonawane/7ea2c530d96dd4837f27527a6f31aed9/raw/9959e9e37d72195e642130bd0dcc6b8d81420ae5/test.srt");
        // await vlcPlayerController.setSpuTrack(0);
      }

      vlcPlayerController.addOnInitListener(subtitlesInitListener);
      focusScopeNode.addListener(() {
        if (focusScopeNode.hasFocus) {
          log("Focus Scope Node has focus");
          controlsModel.hideStuff = false;
        }
      });
      sliderFocusNode.addListener(() {
        if (sliderFocusNode.hasFocus) {
          controlsModel.hideStuff = false;
        } else {}
      });
      return () {
        sliderFocusNode.dispose();
        vlcPlayerController.removeOnInitListener(subtitlesInitListener);
      };
    }, [sliderFocusNode]);

    return AnimatedOpacity(
      opacity: controlsModel.hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: MouseRegion(
        onHover: (_) {
          // controlsModel.onHover();
        },
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.5),
          body: NotificationListener<FocusNotification>(
            onNotification: (notification) {
              debugPrint(
                  "New widget focused: ${notification.childKey.toString()}");
              // controlsModel.stopTimer();
              return true;
            },
            child: FocusScope(
              autofocus: true,
              node: focusScopeNode,
              child: Stack(
                children: [
                  Align(
                    alignment: const Alignment(-0.98, -0.95),
                    child: FocusNotifier(
                      key: const Key("navigateBack"),
                      builder: (context, node) => IconButton(
                        autofocus: true,
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
                              builder: (context, node) => buildPlaybackControl(
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
                        Row(
                          children: [
                            Expanded(
                              child: SliderTheme(
                                data: Theme.of(context)
                                    .sliderTheme
                                    .copyWith(trackHeight: 5),
                                child: Focus(
                                  descendantsAreFocusable: true,
                                  descendantsAreTraversable: true,
                                  canRequestFocus: false,
                                  child: RawKeyboardListener(
                                    focusNode: sliderControllerFocusNode,
                                    onKey: (e) {
                                      if (e.physicalKey ==
                                          PhysicalKeyboardKey.arrowRight) {
                                        if (sliderFocusNode.hasPrimaryFocus) {
                                          log("Right arrow pressed");
                                          sliderChangeDebouncer.run(() {
                                            controlsModel.seekForward(
                                                seconds: 5);
                                          });
                                        }
                                      } else if (e.physicalKey ==
                                          PhysicalKeyboardKey.arrowLeft) {
                                        if (sliderFocusNode.hasPrimaryFocus) {
                                          log("Left arrow pressed");
                                          upDebouncer.run(() {
                                            controlsModel.seekBackward(
                                                seconds: 5);
                                          });
                                        }
                                      } else if (e.physicalKey ==
                                          PhysicalKeyboardKey.arrowUp) {
                                        if (sliderFocusNode.hasPrimaryFocus) {
                                          upDebouncer.run(() {
                                            if (upCounter.value < 3) {
                                              upCounter.value++;
                                            }
                                            if (upCounter.value == 3) {
                                              focusScopeNode.previousFocus();
                                              upCounter.value = 0;
                                            }
                                          });
                                        }
                                      } else if (e.physicalKey ==
                                          PhysicalKeyboardKey.arrowDown) {
                                        if (sliderFocusNode.hasPrimaryFocus) {
                                          downDebouncer.run(() {
                                            if (downCounter.value < 3) {
                                              downCounter.value++;
                                            }
                                            if (downCounter.value == 3) {
                                              focusScopeNode.nextFocus();
                                              downCounter.value = 0;
                                            }
                                          });
                                        }
                                      }
                                    },
                                    child: Slider(
                                      focusNode: sliderFocusNode,
                                      activeColor: Colors.redAccent,
                                      inactiveColor: Colors.white70,
                                      value: controlsModel
                                          .playbackPosition.inSeconds
                                          .toDouble(),
                                      min: 0.0,
                                      max: vlcPlayerController
                                          .value.duration.inSeconds
                                          .toDouble(),
                                      onChanged: (_) {},
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // horizontalSpaceSmall,
                            Text(
                              controlsModel.duration,
                              style: const TextStyle(color: Colors.white),
                            ),
                            horizontalSpaceSmall,
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              tooltip: 'Get Subtitle Tracks',
                              icon: const Icon(Icons.closed_caption),
                              color: Colors.white,
                              onPressed: () => _getSubtitleTracks(
                                  context, isSubtitlesAdded.value),
                            ),
                            IconButton(
                              tooltip: 'Get Audio Tracks',
                              icon: const Icon(Icons.audiotrack),
                              color: Colors.white,
                              onPressed: () => _getAudioTracks(context),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _getSubtitleTracks(BuildContext context, bool isSubtitlesAdded) async {
    if (!vlcPlayerController.value.isPlaying) return;

    var subtitleTracks = await vlcPlayerController.getSpuTracks();
    log("Found Subtitle Tracks: ${subtitleTracks.length}");

    if (subtitleTracks.isNotEmpty) {
      var selectedSubId = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Subtitle'),
            content: SizedBox(
              width: double.maxFinite,
              height: 250,
              child: ListView.builder(
                itemCount: subtitleTracks.keys.length + 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      index < subtitleTracks.keys.length
                          ? subtitleTracks.values.elementAt(index).toString()
                          : 'Disable',
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                        index < subtitleTracks.keys.length
                            ? subtitleTracks.keys.elementAt(index)
                            : -1,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
      if (selectedSubId != null) {
        await vlcPlayerController.setSpuTrack(selectedSubId);
      }
    }
  }

  void _getAudioTracks(BuildContext context) async {
    // if (!vlcPlayerController.value.isPlaying) return;

    var audioTracks = await vlcPlayerController.getAudioTracks();

    if (audioTracks.isNotEmpty) {
      var selectedAudioTrackId = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Audio'),
            content: SizedBox(
              width: double.maxFinite,
              height: 250,
              child: ListView.builder(
                itemCount: audioTracks.keys.length + 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      index < audioTracks.keys.length
                          ? audioTracks.values.elementAt(index).toString()
                          : 'Disable',
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                        index < audioTracks.keys.length
                            ? audioTracks.keys.elementAt(index)
                            : -1,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
      if (selectedAudioTrackId != null) {
        await vlcPlayerController.setAudioTrack(selectedAudioTrackId);
      }
    }
  }

  Widget buildPlaybackControl(PlayingState playingState,
      PlayerControlsNotifier controlsNotifier, FocusNode node) {
    switch (playingState) {
      case PlayingState.initialized:
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
      case PlayingState.stopped:
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
