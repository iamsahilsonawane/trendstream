import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/features/movies/controllers/live_channel_controller.dart';
import 'package:latest_movies/features/movies/views/movies_dashboard/search/live_channels_search_grid.dart';

import '../../../../../core/shared_widgets/app_keyboard/app_keyboard.dart';
import '../../../../tv_guide/views/tv_guide/tv_guide.dart';

class LiveChannelSearchPage extends HookConsumerWidget {
  const LiveChannelSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyword = ref.watch(liveChannelQueryProvider);
    final previewController = useRef<VlcPlayerController?>(null);

    return FocusTraversalGroup(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: AppOnScreenKeyboard(
                    onValueChanged: (value) {
                      ref.read(liveChannelQueryProvider.notifier).state = value;
                    },
                    focusColor: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          horizontalSpaceRegular,
          Expanded(
            flex: 6,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: kPrimaryColor.withOpacity(.2),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search),
                            horizontalSpaceSmall,
                            Text(
                              keyword.isEmpty
                                  ? "Search for live channels..."
                                  : keyword,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: keyword.isEmpty
                                      ? Colors.grey[600]
                                      : Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpaceRegular,
                Expanded(
                  child: FocusTraversalGroup(
                    child: const LiveChannelsSearchGrid(),
                  ),
                ),
              ],
            ),
          ),
          horizontalSpaceRegular,
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: PreviewPlayer(
                    onControllerInitialized: (controller) {
                      previewController.value = controller;
                    },
                  ),
                ),
                verticalSpaceSmall,
                const Text("Live Preview")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
