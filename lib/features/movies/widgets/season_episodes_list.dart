import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/features/movies/controllers/tv_show_season_details_provider.dart';
import 'package:latest_movies/features/movies/models/season_details/episode.dart';

import '../../../core/config/config.dart';
import '../../../core/utilities/design_utility.dart';

class SeasonEpisodesList extends HookConsumerWidget {
  const SeasonEpisodesList({Key? key, this.showSeasonNumber = false})
      : super(key: key);

  final bool showSeasonNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tvShowSeasonDetailsAsync = ref.watch(currentSeasonDetailsProvider);
    return tvShowSeasonDetailsAsync.when(
      data: (seasonDetails) {
        return ListView.builder(
          key: const Key('seasonEpisodesList'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: seasonDetails.episodes?.length ?? 0,
          itemBuilder: (context, index) {
            final episode = seasonDetails.episodes![index];
            return EpisodeTile(
                episode: episode, showSeasonNumber: showSeasonNumber);
          },
        );
      },
      error: (err, st) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}

class EpisodeTile extends HookWidget {
  const EpisodeTile({
    Key? key,
    required this.episode,
    this.showSeasonNumber = false,
  }) : super(key: key);

  final Episode episode;
  final bool showSeasonNumber;

  @override
  Widget build(BuildContext context) {
    //* NOTE ON THIS WIDGET
    //* for some reasons the focus scope with inkwell is not working as in [MovieTile]
    //* there using hooks for manual control

    const double imageSize = 140;

    final hasFocus = useState(false);
    return Focus(
      onFocusChange: (isFocused) {
        hasFocus.value = isFocused;
      },
      child: InkWell(
        onTap: () {
          log("tapped");
        },
        child: ColoredBox(
          color: hasFocus.value
              ? kPrimaryAccentColor.withOpacity(.1)
              : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  "${Configs.baseImagePath}${episode.stillPath}",
                  width: imageSize,
                  height: imageSize,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      width: imageSize,
                      height: imageSize,
                      child: Center(
                        child: Icon(Icons.hide_image),
                      ),
                    );
                  },
                ),
                horizontalSpaceRegular,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        episode.name ?? "",
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      verticalSpaceSmall,
                      if (showSeasonNumber) ...[
                        Text(
                          "Season ${episode.seasonNumber}",
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        verticalSpaceSmall,
                      ],
                      const Text(
                        "1hr 2m",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      if (episode.overview != null) ...[
                        verticalSpaceSmall,
                        Text(
                          episode.overview!,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
