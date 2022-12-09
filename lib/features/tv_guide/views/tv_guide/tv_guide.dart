import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/shared_widgets/app_loader.dart';
import 'package:latest_movies/core/shared_widgets/default_app_padding.dart';
import 'package:latest_movies/core/shared_widgets/error_view.dart';

import 'package:latest_movies/core/router/router.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/features/tv_guide/models/program_guide/program_guide.dart';
import '../../../../core/shared_widgets/image.dart';
import '../../controllers/current_focused_program_controller.dart';
import '../../controllers/us_epg_controller.dart';
import '../../models/program_guide/program.dart';
import '../../models/program_guide/title.dart';

const int tvGuideSlotWidth = 200;

String get logChanneld => "AFNFamily.us";

class TvGuide extends StatefulHookConsumerWidget {
  const TvGuide({Key? key}) : super(key: key);

  @override
  ConsumerState<TvGuide> createState() => _TvGuideState();
}

class _TvGuideState extends ConsumerState<TvGuide> {
  final upperTimeStopsScrollController = ScrollController();
  final programsScrollController = ScrollController();
  final verticalScrollController = ScrollController();

  int currentHour = DateTime.now().hour, currentMinute = DateTime.now().minute;
  double currentHourPosition = 0, currentMinutePosition = 0;
  double currentPosition = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        scrollToCurrentTime();
        timer = Timer.periodic(const Duration(minutes: 1), (timer) {
          setState(() {
            _updatePosition();
          });
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  /// Scrolls to the current time
  void scrollToCurrentTime() {
    _updatePosition();

    if (programsScrollController.hasClients) {
      programsScrollController.animateTo(
        currentHourPosition.toDouble(),
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeInOut,
      );
    }
    setState(() {});
  }

  void _updatePosition() {
    currentHour = DateTime.now().toLocal().hour;
    currentMinute = DateTime.now().toLocal().minute;

    currentHourPosition = (currentHour * tvGuideSlotWidth).toDouble();
    currentMinutePosition = (currentMinute / 60) * tvGuideSlotWidth;

    currentPosition = currentHourPosition + currentMinutePosition;
  }

  @override
  Widget build(BuildContext context) {
    final usEpgGuideAsync = ref.watch(usEpgProvider);
    ref.listen<AsyncValue<ProgramGuide>>(usEpgProvider, (previous, next) {
      if (next is AsyncData<ProgramGuide>) {
        Future.delayed(const Duration(milliseconds: 500), () {
          scrollToCurrentTime();
        });
      }
    });

    return Scaffold(
      body: FocusTraversalGroup(
        child: DefaultAppPadding.horizontal(
          child: usEpgGuideAsync.when(
            data: (epg) {
              final channels = epg.channels ?? [];
              final programsToChannels = epg.programsToChannels ?? {};

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpaceSmall,
                  //program image, title, description and tags
                  Consumer(
                    builder: (context, ref, child) {
                      final currentFocusedProgram =
                          ref.watch(currentFocusedProgramProvider);
                      if (currentFocusedProgram != null) {
                        return CurrentProgramInfo(
                            currentFocusedProgram: currentFocusedProgram);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  verticalSpaceSmall,
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (upperTimeStopsScrollController
                                .position.maxScrollExtent <
                            programsScrollController.offset) {
                          upperTimeStopsScrollController.jumpTo(
                              upperTimeStopsScrollController
                                  .position.maxScrollExtent);
                        } else {
                          upperTimeStopsScrollController
                              .jumpTo(programsScrollController.offset);
                        }
                        return true;
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 30,
                                width: 200,
                                margin: const EdgeInsets.only(right: 3.0),
                                color: kPrimaryColor,
                                child: const Center(
                                    child: Text(
                                  "Timeframe",
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: upperTimeStopsScrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                      24,
                                      (index) {
                                        return Container(
                                          width: tvGuideSlotWidth.toDouble(),
                                          height: 30,
                                          decoration: BoxDecoration(
                                            border: const Border(
                                              left: BorderSide(
                                                color: kBackgroundColor,
                                                width: 1.5,
                                              ),
                                              right: BorderSide(
                                                color: kBackgroundColor,
                                                width: 1.5,
                                              ),
                                            ),
                                            color: index == currentHour
                                                ? kPrimaryColor
                                                : kPrimaryAccentColor
                                                    .withOpacity(.2),
                                          ),
                                          child: Center(
                                              child: Text(
                                            "${index.toString().padLeft(2, '0')}:00",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              controller: verticalScrollController,
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...List.generate(
                                        channels.length,
                                        (index) {
                                          final channel = channels[index];

                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 3.0),
                                              _Channel(
                                                logo: channel.logo,
                                                channelName: channel.id ??
                                                    "Channel ${index + 1}",
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      controller: programsScrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: Stack(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ...List.generate(
                                                channels.length,
                                                (i) => _ChannelPrograms(
                                                  programs: programsToChannels[
                                                          channels[i].id] ??
                                                      [],
                                                  shouldHaveInitialFocus:
                                                      i == 0,
                                                  onProgramFocused: (program) {
                                                    ref
                                                        .read(
                                                            currentFocusedProgramProvider
                                                                .state)
                                                        .state = program;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          Positioned(
                                            top: 3,
                                            left: currentPosition,
                                            child: Container(
                                              height: (10 * 70) + (10 * 3.0),
                                              width: 2,
                                              color: Colors.red,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            error: (err, st) => const ErrorView(),
            loading: () => const AppLoader(),
          ),
        ),
      ),
    );
  }
}

class CurrentProgramInfo extends StatelessWidget {
  const CurrentProgramInfo({
    Key? key,
    required this.currentFocusedProgram,
  }) : super(key: key);

  final Program currentFocusedProgram;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: const AppImage(
                  imageUrl:
                      r"https://m.media-amazon.com/images/M/MV5BYTRiNDQwYzAtMzVlZS00NTI5LWJjYjUtMzkwNTUzMWMxZTllXkEyXkFqcGdeQXVyNDIzMzcwNjc@._V1_.jpg",
                  fit: BoxFit.fitHeight,
                ),
              ),
              horizontalSpaceMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentFocusedProgram.titles!.first.value!,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    verticalSpaceSmall,
                    Text(
                      (currentFocusedProgram.descriptions?.isNotEmpty ?? false)
                          ? currentFocusedProgram.descriptions!.first['value']
                          : "No description",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.fade,
                    ),
                    verticalSpaceSmall,
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                          currentFocusedProgram.categories?.length ?? 0, (i) {
                        final cat = currentFocusedProgram.categories![i];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: kPrimaryAccentColor,
                          ),
                          child: Text(
                            cat['value'] ?? "N/A",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // const PreviewPlayer(),
                      const AspectRatio(
                        aspectRatio: 16 / 9,
                        child: SizedBox.expand(
                          child: ColoredBox(color: Colors.black),
                        ),
                      ),
                      Container(
                        color: kPrimaryColor,
                        padding: const EdgeInsets.all(5),
                        child: const Text("Preview"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PreviewPlayer extends StatefulWidget {
  const PreviewPlayer({super.key});

  @override
  State<PreviewPlayer> createState() => _PreviewPlayerState();
}

class _PreviewPlayerState extends State<PreviewPlayer> {
  late VlcPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VlcPlayerController.network(
      'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
      // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        subtitle: VlcSubtitleOptions([
          VlcSubtitleOptions.boldStyle(true),
          VlcSubtitleOptions.fontSize(30),
          VlcSubtitleOptions.color(VlcSubtitleColor.white),
        ]),
        http: VlcHttpOptions([
          VlcHttpOptions.httpReconnect(true),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _videoPlayerController.setVolume(0);
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: kPrimaryColor, width: 3),
      ),
      child: VlcPlayer(
        controller: _videoPlayerController,
        aspectRatio: 16 / 9,
        placeholder: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ChannelPrograms extends StatefulWidget {
  const _ChannelPrograms(
      {Key? key,
      required this.programs,
      this.shouldHaveInitialFocus = false,
      required this.onProgramFocused})
      : super(key: key);

  final List<Program> programs;

  /// Set true for the first row
  final bool shouldHaveInitialFocus;
  final void Function(Program program) onProgramFocused;

  @override
  State<_ChannelPrograms> createState() => __ChannelProgramsState();
}

class __ChannelProgramsState extends State<_ChannelPrograms> {
  /// Keeps track of width for each program
  ///
  /// Format: `{program: width}`
  final programWidthMap = <Program, double>{};

  /// Keeps track of total width, all programs make up
  double totalWidth = 0;

  List<Program> _programs = [];

  @override
  void initState() {
    super.initState();
    // arrangements = _getRandomArrangements();
    _programs = widget.programs;

    if (_programs.isNotEmpty) {
      _fixTimeGapsIfAvailable();
      // debugPrint(
      //     "Channel: ${_programs.first.channel} | Duplicates Length: ${_programs.map((e) => e.titles).toList().duplicates.length}");
      // log("CH:${_programs.first.channel} ${_programs.map((e) => "${DateTime.fromMillisecondsSinceEpoch(e.start!).toLocal()} | ${DateTime.fromMillisecondsSinceEpoch(e.stop!).toLocal()}").toList().join("\n")}");
    }
    setState(() {});
  }

  /// Calculates width for given start and end date (in milliseconds)
  ///
  /// Returns width in pixels
  double _calculateWidthFromStartAndEndTime(int start, int end) {
    final startTime = DateTime.fromMillisecondsSinceEpoch(start).toLocal();
    final endTime = DateTime.fromMillisecondsSinceEpoch(end).toLocal();
    // debugPrint("Start: $startTime ($start), End: $endTime ($end)");
    final difference = endTime.difference(startTime).inMinutes / 60;
    return (difference * tvGuideSlotWidth).toDouble();
  }

  /// Fixes time gaps if available
  ///
  /// For example, if a program starts at 10:00 and ends at 10:30, then the next program should start at 10:30
  ///
  /// This function makes sure that happens. If not, it will add a break
  void _fixTimeGapsIfAvailable() {
    for (int i = 0; i < _programs.length; i++) {
      final isLast = i == _programs.length - 1;

      // If not start from midnight, then add a break
      final now = DateTime.now();
      final todayMidnight = DateTime(now.year, now.month, now.day)
          .toLocal()
          .millisecondsSinceEpoch;

      if (i == 0 && _programs[i].start != todayMidnight) {
        final breakProgram = Program(
          start: todayMidnight,
          stop: _programs[0].start,
          channel: _programs[i].channel,
          titles: const [ProgramTitle(value: "Not Data Found", lang: "en")],
        );
        _programs.insert(0, breakProgram);
      }

      _calculateAndSaveWidth(_programs[i], shouldFillRest: isLast);

      // If not corresponding, then add a break
      if ((!isLast) &&
          _programs[i].stop != _programs[i + 1].start &&
          (_programs[i + 1].start! > _programs[i].stop!)) {
        _programs.insert(
          i + 1,
          Program(
            start: _programs[i].stop,
            stop: _programs[i + 1].start,
            channel: _programs[i].channel,
            titles: const [ProgramTitle(value: "Not Data Found", lang: "en")],
          ),
        );
      }
    }
  }

  /// Gets width for given program and save it to [programWidthMap]
  ///
  /// [shouldFillRest] is used to fill the width of the program with the rest of the width available - to cover entirely
  void _calculateAndSaveWidth(Program program, {required bool shouldFillRest}) {
    // print(program.channel);
    double width = 0.0;

    if (shouldFillRest) {
      final double combinedWidth = programWidthMap.isNotEmpty
          ? programWidthMap.values.reduce((value, element) => value + element)
          : 0;
      final remainingWidth = (tvGuideSlotWidth * 24) - combinedWidth;

      width = remainingWidth;
    } else {
      width = _calculateWidthFromStartAndEndTime(program.start!, program.stop!);
    }

    if (width < 0) {
      // debugPrint("Width is negative: $width");
    }

    totalWidth += width;

    programWidthMap[program] = width;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 3.0),
        Row(
          children: List.generate(
            // 24 < _programs.length ? 24 : _programs.length,
            _programs.length,
            (index) => Builder(builder: (context) {
              final program = _programs[index];
              final width = programWidthMap[program];

              final isProgramCurrentlyOnGoing = program.start! <=
                      DateTime.now().toLocal().millisecondsSinceEpoch &&
                  program.stop! >=
                      DateTime.now().toLocal().millisecondsSinceEpoch;

              if (isProgramCurrentlyOnGoing) {
                // debugPrint(
                //     "Program: ${program.titles!.first.value} | Start: ${DateTime.fromMillisecondsSinceEpoch(program.start!)} | Stop: ${DateTime.fromMillisecondsSinceEpoch(program.stop!)}");
              }

              return _Program(
                // name:
                //     "Program: ${program.titles!.first.value} | Start: ${DateTime.fromMillisecondsSinceEpoch(program.start!)} | Stop: ${DateTime.fromMillisecondsSinceEpoch(program.stop!)}",
                name: program.titles!.first.value!,
                onTap: () {
                  AppRouter.navigateToPage(Routes.livePlayerView);
                },
                onFocusChanged: () {
                  // Scrollable.ensureVisible(context,
                  //     alignment: 0.1,
                  //     duration: const Duration(milliseconds: 50));
                  widget.onProgramFocused(program);
                },
                width: width!,
                autofocus:
                    widget.shouldHaveInitialFocus && isProgramCurrentlyOnGoing,
                programType: isProgramCurrentlyOnGoing
                    ? ProgramType.onGoing
                    : program.start! >
                            DateTime.now().toLocal().millisecondsSinceEpoch
                        ? ProgramType.upcoming
                        : ProgramType.past,
              );
            }),
          ),
        ),
      ],
    );
  }
}

enum ProgramType { onGoing, upcoming, past }

class _Program extends StatefulWidget {
  const _Program({
    Key? key,
    required this.name,
    required this.onTap,
    required this.onFocusChanged,
    required this.width,
    required this.autofocus,
    required this.programType,
  }) : super(key: key);

  final String name;
  final VoidCallback? onTap;
  final VoidCallback? onFocusChanged;
  final double width;
  final bool autofocus;
  final ProgramType programType;

  @override
  State<_Program> createState() => _ProgramState();
}

class _ProgramState extends State<_Program> {
  bool isFocused = false;

  void setIsFocused(bool value) {
    if (isFocused == value) return;
    setState(() => isFocused = value);
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey[800]!;
    switch (widget.programType) {
      case ProgramType.onGoing:
        color = kPrimaryColor;
        break;
      case ProgramType.upcoming:
        color = kPrimaryAccentColor.withOpacity(.2);
        break;
      case ProgramType.past:
        color = kPrimaryAccentColor.withOpacity(.1);
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(right: 0.0),
      child: InkWell(
        onTap: widget.onTap,
        focusColor: Colors.white,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        autofocus: widget.autofocus,
        onFocusChange: (isFocused) {
          setIsFocused(isFocused);
          if (isFocused) {
            widget.onFocusChanged?.call();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isFocused ? Colors.white : color,
            border: const Border(
              left: BorderSide(
                color: kBackgroundColor,
                width: 1.5,
              ),
              right: BorderSide(
                color: kBackgroundColor,
                width: 1.5,
              ),
            ),
          ),
          width: widget.width,
          height: 40,
          padding: const EdgeInsets.all(5),
          child: Center(
            child: Text(
              widget.name,
              style: TextStyle(
                fontSize: 12,
                color: isFocused ? Colors.grey[800] : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Channel extends StatelessWidget {
  const _Channel({required this.channelName, this.logo});

  final String channelName;
  final String? logo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 3.0),
      child: Container(
        width: 200,
        height: 40,
        // color: kPrimaryColor,
        color: kPrimaryColor,
        child: Row(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 6),
              height: double.infinity,
              child: Image.network(
                logo ?? "",
                errorBuilder: (context, error, stackTrace) => SizedBox(
                  height: 50,
                  width: 50,
                  child:
                      Icon(Icons.image_not_supported, color: Colors.grey[600]),
                ),
                width: 50,
                height: 50,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  channelName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
