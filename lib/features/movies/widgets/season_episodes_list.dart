import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/features/movies/controllers/tv_show_season_details_provider.dart';
import 'package:latest_movies/features/movies/models/season_details/episode.dart';
import 'package:latest_movies/features/movies/models/tv_show/tv_show.dart';

import '../../../core/config/config.dart';
import '../../../core/utilities/design_utility.dart';
import '../models/tv_show_details/tv_show_details.dart';

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
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: EpisodeTile(
                  episode: episode, showSeasonNumber: showSeasonNumber),
            );
          },
        );
      },
      error: (err, st) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}

class AllSeasonEpisodesList extends HookConsumerWidget {
  const AllSeasonEpisodesList({Key? key, required this.show}) : super(key: key);

  final TvShowDetails show;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tvShowSeasonDetailsAsync = ref.watch(allSeasonDetailsProvider(show));
    return tvShowSeasonDetailsAsync.when(
      data: (allSeasons) {
        return ListView.builder(
          key: const Key('allSeasonsList'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: allSeasons.length,
          itemBuilder: (context, index) {
            final seasonDetails = allSeasons[index];
            return ListView.builder(
              key: const Key('seasonAllEpisodesList'),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: seasonDetails.episodes?.length ?? 0,
              itemBuilder: (context, index) {
                final episode = seasonDetails.episodes![index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: EpisodeTile(episode: episode, showSeasonNumber: true),
                );
              },
            );
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

    return InkWell(
      onTap: () {
        log("tapped");
      },
      child: Builder(builder: (context) {
        final hasFocus = Focus.of(context).hasPrimaryFocus;
        return SizedBox(
          height: 160,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: hasFocus
                        ? kPrimaryAccentColor.withOpacity(.1)
                        : Colors.transparent,
                    border: Border.all(
                        color: hasFocus ? Colors.white : Colors.transparent,
                        width: 3),
                  ),
                  child: Image.network(
                    "${Configs.baseImagePath}${episode.stillPath}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.hide_image),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
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
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
