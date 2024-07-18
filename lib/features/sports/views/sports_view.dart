import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latest_movies/core/shared_widgets/clock.dart';
import 'package:latest_movies/core/shared_widgets/error_view.dart';
import 'package:latest_movies/core/utilities/debouncer.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/features/sports/controllers/current_focused_program_controller.dart';
import 'package:latest_movies/features/sports/controllers/events_provider.dart';
import 'package:latest_movies/features/sports/widgtes/category_selector.dart';
import 'package:latest_movies/features/sports/widgtes/current_sports_details.dart';
import 'package:latest_movies/features/sports/widgtes/sports_program_list_tile.dart';
import 'package:video_player/video_player.dart';

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

  final Function(VideoPlayerController controller)? onControllerInitialized;

  @override
  State<LivePreviewPlayer> createState() => _LivePreviewPlayerState();
}

class _LivePreviewPlayerState extends State<LivePreviewPlayer> {
  late VideoPlayerController _videoPlayerController;
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<bool> _isPlaying = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
          'http://sample.vodobox.com/big_buck_bunny_4k/big_buck_bunny_4k.m3u8'),
    )..initialize().then(
        (_) {
          setState(() {});
          _videoPlayerController.setVolume(0);
          _videoPlayerController.play();
        },
      );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _isPlaying.value = false;
      print("Video paused");
    } else {
      _videoPlayerController.play();
      _isPlaying.value = true;
      print("Video playing");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusNode: _focusNode,
      onFocusChange: (hasFocus) {
        setState(() {});
      },
      onTap: () {
        print("Player tapped");
        _togglePlayPause();
      },
      child: Stack(
        children: [
          _videoPlayerController.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                )
              : Container(),
          if (_focusNode.hasFocus)
            Positioned(
              bottom: 10,
              right: 10,
              child: FloatingActionButton(
                onPressed: _togglePlayPause,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isPlaying,
                  builder: (context, isPlaying, child) {
                    return Icon(isPlaying ? Icons.pause : Icons.play_arrow);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
