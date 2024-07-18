import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/shared_widgets/clock.dart';
import 'package:latest_movies/core/shared_widgets/error_view.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/features/sports/controllers/current_focused_program_controller.dart';
import 'package:latest_movies/features/sports/controllers/events_provider.dart';
import 'package:latest_movies/features/sports/widgtes/category_selector.dart';
import 'package:latest_movies/features/sports/widgtes/current_sports_details.dart';
import 'package:latest_movies/features/sports/widgtes/sports_program_list_tile.dart';

import '../../../core/router/router.dart';

class SportsPage extends ConsumerStatefulWidget {
  const SportsPage({super.key});

  @override
  ConsumerState<SportsPage> createState() => _SportsPageState();
}

class _SportsPageState extends ConsumerState<SportsPage> {
  late VlcPlayerController previewController;

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(sportsEventsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CurrentSportsDetails(),
        verticalSpaceMedium,
        const SizedBox(
          height: 30,
          child: Row(
            children: [
              Clock(),
              horizontalSpaceMedium,
              Expanded(
                child: CategorySelector(),
              ),
            ],
          ),
        ),
        verticalSpaceRegular,
        Expanded(
          child: eventAsync.when(
            data: (events) {
              return ListView.separated(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return SportsProgramListTile(
                    title:
                        "${DateFormat("HH:mm a").format(event.eventDate!)} - ${event.name ?? "N/A"}",
                    icon: Icons.sports_football,
                    autofocus: index == 0,
                    onFocused: () {
                      ref
                          .read(currentFocusedEventController.notifier)
                          .update((state) => event);
                    },
                    onTap: () async {
                      if (previewController.value.isBuffering ||
                          previewController.value.isPlaying) {
                        previewController.pause();
                      }
                      await AppRouter.navigateToPage(Routes.playerView,
                          arguments:
                              "http://x.lamtv.tv:8080/live/test/test/130.m3u8");
                      if (mounted) {
                        previewController
                          ..seekTo(const Duration(days: 3))
                          ..play();
                      }
                    },
                  );
                },
                separatorBuilder: (contetxt, _) => const Divider(height: 0),
              );
            },
            error: (err, st) => ErrorView(error: err.toString()),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }
}



class LivePreviewPlayer extends StatefulWidget {
  const LivePreviewPlayer({super.key, this.onControllerInitialized});

  final Function(VlcPlayerController controller)? onControllerInitialized;

  @override
  State<LivePreviewPlayer> createState() => _LivePreviewPlayerState();
}

class _LivePreviewPlayerState extends State<LivePreviewPlayer> {
  late VlcPlayerController _videoPlayerController;

  void initListener() {
    if (_videoPlayerController.value.isInitialized) {
      _videoPlayerController.setVolume(0);
    }
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VlcPlayerController.network(
      'http://x.lamtv.tv:8080/live/test/test/130.m3u8',
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
    widget.onControllerInitialized?.call(_videoPlayerController);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _videoPlayerController.addOnInitListener(initListener);
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
