import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/extensions/context_extension.dart';
import 'package:latest_movies/features/movies/controllers/tv_show_season_details_provider.dart';
import 'package:latest_movies/features/movies/models/season_details/episode.dart';
import 'package:latest_movies/features/movies/models/tv_show/tv_show.dart';

import '../../../core/config/config.dart';
import '../../../core/shared_widgets/image.dart';
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
          // shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
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

class AllSeasonEpisodesList extends ConsumerStatefulWidget {
  const AllSeasonEpisodesList({Key? key, required this.show}) : super(key: key);

  final TvShowDetails show;

  @override
  _AllSeasonEpisodesListState createState() => _AllSeasonEpisodesListState();
}

class _AllSeasonEpisodesListState extends ConsumerState<AllSeasonEpisodesList> {
  final _scrollController = ScrollController();

  late final _seasonsNotifier =
      ref.watch(allSeasonDetailsProvider(widget.show).notifier);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    _seasonsNotifier.fetchNextPage();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _seasonsNotifier.fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final seasons = ref.watch(allSeasonDetailsProvider(widget.show));
    final allEpisodes = seasons.expand((e) => e.episodes ?? []).toList();

    return ListView.builder(
      key: const Key('allSeasonsList'),
      controller: _scrollController,
      itemCount: allEpisodes.length,
      itemBuilder: (context, index) {
        final episode = allEpisodes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: EpisodeTile(
            episode: episode,
            showSeasonNumber: true,
          ),
        );

        // final season = seasons[index];

        // return Column(
        //   children: [
        //     ListTile(
        //       title: Text('Season ${season.seasonNumber}'),
        //     ),
        //     ListView.builder(
        //       key: Key('season${season.seasonNumber}EpisodesList'),
        //       shrinkWrap: true,
        //       physics: const NeverScrollableScrollPhysics(),
        //       itemCount: season.episodes!.length,
        //       itemBuilder: (context, index) {
        //         final episode = season.episodes![index];
        //         return Padding(
        //           padding: const EdgeInsets.only(bottom: 12.0),
        //           child: EpisodeTile(
        //             episode: episode,
        //             showSeasonNumber: true,
        //           ),
        //         );
        //       },
        //     ),
        //   ],
        // );
      },
    );
  }
}

class EpisodeTile extends StatelessWidget {
  const EpisodeTile({
    Key? key,
    required this.episode,
    this.showSeasonNumber = false,
  }) : super(key: key);

  final Episode episode;
  final bool showSeasonNumber;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Builder(builder: (context) {
        final hasFocus = Focus.of(context).hasPrimaryFocus;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 150,
              child: AspectRatio(
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
                  child: AppImage(
                    imageUrl:
                        "${Configs.mediumBaseImagePath}${episode.stillPath}",
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.hide_image),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        "${context.localisations.season} ${episode.seasonNumber}",
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
        );
      }),
    );
  }
}
