import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:focus_notifier/focus_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/router/router.dart';
import 'package:latest_movies/core/shared_widgets/button.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';

import '../../../../../core/utilities/app_utility.dart';
import '../../../models/player/subtitle_color.dart';
import 'controls_notifier.dart';

import 'dart:async';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      log("Cancelling the timer");
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class PlayerControls extends HookConsumerWidget {
  const PlayerControls({
    Key? key,
    required this.vlcPlayerController,
    required this.onControllerChanged,
  }) : super(key: key);

  final VlcPlayerController vlcPlayerController;
  final ValueChanged<VlcPlayerController> onControllerChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlsModel =
        ref.watch(playerControlsNotifierProvider(vlcPlayerController));

    final sliderFocusNode =
        useFocusNode(canRequestFocus: true, skipTraversal: false);

    final playPauseFocusNode = useFocusNode();

    final sliderControllerFocusNode =
        useFocusNode(canRequestFocus: true, skipTraversal: true);

    final focusScopeNode = useFocusScopeNode();

    final isSubtitlesAdded = useRef(false);

    useEffect(() {
      subtitlesInitListener() async {
        await vlcPlayerController.addSubtitleFromNetwork(
            "https://gist.githubusercontent.com/iamsahilsonawane/7ea2c530d96dd4837f27527a6f31aed9/raw/9959e9e37d72195e642130bd0dcc6b8d81420ae5/test.srt");
        await vlcPlayerController.setSpuTrack(0);
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
          // controlsModel.hideStuff = false;
        } else {}
      });
      controlsModel.controlsVisibilityUpdates.listen((event) {
        if (event == ControlsOverlayVisibility.hidden) {
          if (playPauseFocusNode.canRequestFocus) {
            playPauseFocusNode.requestFocus();
          }
        }
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
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.5),
          body: RawKeyboardListener(
            focusNode: FocusNode(canRequestFocus: false),
            onKey: (event) {
              if (event.isKeyPressed(LogicalKeyboardKey.select) &&
                  sliderFocusNode.hasPrimaryFocus) {
                if (controlsModel.playingState == PlayingState.playing) {
                  controlsModel.pause();
                } else {
                  controlsModel.play();
                }
              }
              controlsModel
                  .onHover(); //restart the timer if any item is focused
            },
            child: NotificationListener<FocusNotification>(
              onNotification: (notification) {
                debugPrint(
                    "New widget focused: ${notification.childKey.toString()}");
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
                          autofocus: false,
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
                              FocusNotifier.customFocusNode(
                                key: const Key("playPause"),
                                focusNode: playPauseFocusNode,
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
                                        if (e.isKeyPressed(
                                            LogicalKeyboardKey.arrowRight)) {
                                          if (sliderFocusNode.hasPrimaryFocus) {
                                            controlsModel.seekForward(
                                                seconds: 5);
                                          }
                                        } else if (e.isKeyPressed(
                                            LogicalKeyboardKey.arrowLeft)) {
                                          if (sliderFocusNode.hasPrimaryFocus) {
                                            controlsModel.seekBackward(
                                                seconds: 5);
                                          }
                                        }
                                      },
                                      child: MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                          navigationMode:
                                              NavigationMode.directional,
                                        ),
                                        child: Slider(
                                          autofocus: true,
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
                              ),
                              // horizontalSpaceSmall,
                              ValueListenableBuilder(
                                valueListenable:
                                    controlsModel.vlcPlayerController,
                                builder: (context, VlcPlayerValue controller,
                                    child) {
                                  return Text(
                                    "${controlsModel.formatDurationToString(controller.position)} / ${controlsModel.duration}",
                                    style: const TextStyle(color: Colors.white),
                                  );
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                tooltip: 'Get Subtitle Tracks',
                                icon: const Icon(Icons.closed_caption),
                                color: Colors.white,
                                onPressed: () => _getSubtitleTracks(
                                    context, isSubtitlesAdded.value,
                                    playerController: controlsModel),
                              ),
                              IconButton(
                                tooltip: 'Get Audio Tracks',
                                icon: const Icon(Icons.audiotrack),
                                color: Colors.white,
                                onPressed: () => _getAudioTracks(context,
                                    playerController: controlsModel),
                              ),
                              IconButton(
                                tooltip: 'Subtitle Options',
                                icon: const Icon(Icons.settings),
                                color: Colors.white,
                                onPressed: () async {
                                  controlsModel.stopTimer();
                                  controlsModel.pause();
                                  controlsModel.forceStopped = true;

                                  final result =
                                      await _setCaptionStyle(controlsModel);

                                  controlsModel.forceStopped = false;
                                  if (result == null) return;

                                  //only remove the subtitle options where the value is not null in result
                                  vlcPlayerController.options?.subtitle?.options
                                      .removeWhere(
                                    (opt) {
                                      if (opt
                                          .contains("--freetype-fontsize=")) {
                                        return result.containsKey("fontSize");
                                      } else if (opt
                                          .contains("--freetype-color=")) {
                                        return result.containsKey("fontColor");
                                      } else if (opt.contains(
                                          "--freetype-background-color=")) {
                                        return result.containsKey("fontColor");
                                      }
                                      return false;
                                    },
                                  );

                                  vlcPlayerController.options?.subtitle?.options
                                      .addAll(
                                    [
                                      if (result.containsKey("fontSize"))
                                        VlcSubtitleOptions.fontSize(
                                            result["fontSize"]),
                                      if (result.containsKey("fontColor"))
                                        VlcSubtitleOptions.color(
                                            result["fontColor"]),
                                      if (result.containsKey("backgroundColor"))
                                        VlcSubtitleOptions.backgroundColor(
                                            result["backgroundColor"]),
                                      if (result.containsKey("backgroundColor"))
                                        VlcSubtitleOptions.backgroundOpacity(
                                            255),
                                      if (result.containsKey("backgroundColor"))
                                        VlcSubtitleOptions.shadowOpacity(0),
                                      if (result.containsKey("backgroundColor"))
                                        VlcSubtitleOptions.boldStyle(false),
                                    ],
                                  );

                                  if (result.containsKey("fontSize")) {
                                    controlsModel.selectedCaptionSize =
                                        result["fontSize"];
                                  }
                                  if (result.containsKey("fontColor")) {
                                    controlsModel.selectedCaptionColor =
                                        SubtitleColor(
                                      color: AppUtils.decimalToColor(
                                          result["fontColor"].value),
                                      backgroundColor: (result
                                              .containsKey("backgroundColor"))
                                          ? AppUtils.decimalToColor(
                                              result["backgroundColor"].value)
                                          : null,
                                    );
                                  }

                                  onControllerChanged.call(vlcPlayerController);
                                },
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Get Playback Speeds',
                                    icon: const Icon(Icons.speed),
                                    color: Colors.white,
                                    onPressed: () => _getPlaybackSpeeds(context,
                                        controlsModel: controlsModel),
                                  ),
                                  Text("${controlsModel.currentPlaybackSpeed}x",
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ],
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
      ),
    );
  }

  void _getPlaybackSpeeds(BuildContext context,
      {required PlayerControlsNotifier controlsModel}) async {
    var playbackSpeeds = controlsModel.playbackSpeeds;
    log("Found Playback Speeds: ${playbackSpeeds.length}");

    if (playbackSpeeds.isNotEmpty) {
      var selectedSpeedIndex = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Playback Speed'),
            content: SizedBox(
              width: double.maxFinite,
              height: 250,
              child: ListView.builder(
                itemCount: playbackSpeeds.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "${playbackSpeeds[index]}x",
                    ),
                    selected: controlsModel.currentPlaybackSpeed ==
                        playbackSpeeds[index],
                    onTap: () {
                      Navigator.pop(
                        context,
                        index,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
      if (selectedSpeedIndex != null) {
        await controlsModel.setPlaybackSpeed(selectedSpeedIndex);
      }
    }
  }

  Future<Map<String, dynamic>?> _setCaptionStyle(
      PlayerControlsNotifier controlsModel) async {
    var subtitleTracks = await vlcPlayerController.getSpuTracks();
    log("Found Subtitle Tracks: ${subtitleTracks.length}");

    final List<SubtitleColor> colors = [
      [VlcSubtitleColor.white, null],
      [VlcSubtitleColor.yellow, null],
      [VlcSubtitleColor.white, VlcSubtitleColor.black],
    ].map((e) {
      return SubtitleColor(
        color: AppUtils.decimalToColor(e[0]!.value),
        backgroundColor:
            e[1] != null ? AppUtils.decimalToColor(e[1]!.value) : null,
      );
    }).toList();

    int? selectedSize;
    SubtitleColor? selectedColor;

    if (subtitleTracks.isNotEmpty) {
      var shouldUpdate = await showDialog(
        context: AppRouter.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: kBackgroundColor,
              title: const Text('Subtitle Style'),
              content: SizedBox(
                width: 400,
                height: 170,
                child: FocusScope(
                  autofocus: true,
                  child: FocusTraversalGroup(
                    policy: OrderedTraversalPolicy(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text("Font Size:",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                            horizontalSpaceRegular,
                            Expanded(
                              child: FocusTraversalGroup(
                                child: Row(
                                  children: List.generate(
                                    3,
                                    (index) {
                                      final cSize = 44 + (index * 4);
                                      final cShowcaseSize = 20 + (index * 4);
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: _CCFontSize(
                                          fontSize: cShowcaseSize.toDouble(),
                                          autofocus: index == 0,
                                          isSelected: selectedSize == cSize
                                              ? true
                                              : selectedSize == null
                                                  ? controlsModel
                                                          .selectedCaptionSize ==
                                                      cSize
                                                  : false,
                                          onTap: () {
                                            setState(() {
                                              selectedSize = cSize;
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        verticalSpaceRegular,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text("Font Color:",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                            horizontalSpaceRegular,
                            Expanded(
                              child: FocusTraversalGroup(
                                child: Row(
                                  children: List.generate(
                                    colors.length,
                                    (index) => Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: _CCFontColor(
                                        color: colors[index].color,
                                        backgroundColor:
                                            colors[index].backgroundColor,
                                        isSelected: selectedColor ==
                                                colors[index]
                                            ? true
                                            : selectedColor == null
                                                ? controlsModel
                                                        .selectedCaptionColor ==
                                                    colors[index]
                                                : false,
                                        onTap: () {
                                          setState(() {
                                            selectedColor = colors[index];
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        verticalSpaceRegular,
                        Row(
                          children: [
                            AppButton(
                              onTap:
                                  selectedColor == null && selectedSize == null
                                      ? null
                                      : () {
                                          Navigator.pop(context, true);
                                        },
                              text: "Apply Changes",
                            ),
                            horizontalSpaceRegular,
                            AppButton(
                              onTap: () => Navigator.pop(context),
                              text: "Cancel",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        },
      );

      if (shouldUpdate ?? false) {
        return {
          if (selectedSize != null) "fontSize": selectedSize,
          if (selectedColor != null)
            "fontColor":
                VlcSubtitleColor(AppUtils.colorToDecimal(selectedColor!.color)),
          if (selectedColor?.backgroundColor != null)
            "backgroundColor": VlcSubtitleColor(
                AppUtils.colorToDecimal(selectedColor!.backgroundColor!)),
        };
      }
    }

    return null;
  }

  void _getSubtitleTracks(BuildContext context, bool isSubtitlesAdded,
      {required PlayerControlsNotifier playerController}) async {
    var subtitleTracks = await vlcPlayerController.getSpuTracks();
    log("Found Subtitle Tracks: ${subtitleTracks.length}");

    var currentTrack = await vlcPlayerController.getSpuTrack();
    log("Current Track: $currentTrack");

    if (subtitleTracks.isNotEmpty) {
      var selectedSubId = await showDialog(
        context: AppRouter.navigatorKey.currentContext!,
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
                    selected: index < subtitleTracks.keys.length
                        ? currentTrack == subtitleTracks.keys.elementAt(index)
                        : currentTrack == -1,
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

  void _getAudioTracks(BuildContext context,
      {required PlayerControlsNotifier playerController}) async {
    // if (!vlcPlayerController.value.isPlaying) return;

    var audioTracks = await vlcPlayerController.getAudioTracks();

    if (audioTracks.isNotEmpty) {
      if (context.mounted) {
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
                      selected: index < audioTracks.keys.length
                          ? playerController.selectedAudioTrackId ==
                              audioTracks.keys.elementAt(index)
                          : playerController.selectedAudioTrackId == -1,
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
          playerController.selectedAudioTrackId = selectedAudioTrackId;
          await vlcPlayerController.setAudioTrack(selectedAudioTrackId);
        }
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

class _CCFontSize extends StatelessWidget {
  const _CCFontSize({
    Key? key,
    required this.fontSize,
    required this.onTap,
    this.autofocus = false,
    this.isSelected = false,
  }) : super(key: key);

  final double fontSize;
  final VoidCallback onTap;
  final bool isSelected;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      autofocus: autofocus,
      splashColor: Colors.transparent,
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasPrimaryFocus;
          return Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              // color: Colors.yellow,
              color: kBackgroundColor,
              borderRadius: BorderRadius.circular(4),
              border: isFocused
                  ? Border.all(
                      color: Colors.grey,
                      width: 2,
                    )
                  : isSelected
                      ? Border.all(
                          color: kPrimaryAccentColor,
                          width: 2,
                        )
                      : null,
            ),
            child: Text(
              "aA",
              style: TextStyle(
                fontSize: fontSize,
                color: isFocused
                    ? Colors.white
                    : isSelected
                        ? kPrimaryAccentColor
                        : Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CCFontColor extends StatelessWidget {
  const _CCFontColor({
    Key? key,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  final Color color;
  final Color? backgroundColor;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasPrimaryFocus;
          return Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              // color: Colors.yellow,
              color: backgroundColor ?? kBackgroundColor,
              borderRadius: BorderRadius.circular(4),
              border: isFocused
                  ? Border.all(
                      color: Colors.grey,
                      width: 2,
                    )
                  : isSelected
                      ? Border.all(
                          color: kPrimaryAccentColor,
                          width: 2,
                        )
                      : null,
            ),
            child: Text(
              "aA",
              style: TextStyle(
                fontSize: 16,
                color: color,
              ),
            ),
          );
        },
      ),
    );
  }
}
