import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/features/movies/models/season_details_v3/season_details_v3.dart';
import '../../../core/shared_widgets/image.dart';
import '../../../core/utilities/design_utility.dart';
import '../models/season_details_v3/episode.dart';
import '../models/season_details_v3/urls_image.dart';

class SeasonEpisodesListV3 extends HookConsumerWidget {
  const SeasonEpisodesListV3(
      {Key? key, this.showSeasonNumber = false, required this.seasonDetails})
      : super(key: key);

  final bool showSeasonNumber;
  final SeasonDetailsV3 seasonDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      key: const Key('seasonEpisodesList'),
      itemCount: seasonDetails.episodes?.length ?? 0,
      itemBuilder: (context, index) {
        final episode = seasonDetails.episodes![index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: EpisodeTileV3(
              episode: episode, showSeasonNumber: showSeasonNumber),
        );
      },
    );
  }
}

class AllSeasonEpisodesListV3 extends StatelessWidget {
  const AllSeasonEpisodesListV3({Key? key, required this.seasons})
      : super(key: key);

  final List<SeasonDetailsV3> seasons;

  @override
  Widget build(BuildContext context) {
    final allEpisodes = seasons.expand((e) => e.episodes ?? []).toList();

    return ListView.builder(
      key: const Key('allSeasonsList'),
      itemCount: allEpisodes.length,
      itemBuilder: (context, index) {
        final episode = allEpisodes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: EpisodeTileV3(
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
        //           child: EpisodeTileV3(
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

class EpisodeTileV3 extends StatelessWidget {
  const EpisodeTileV3({
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
                    imageUrl: "http://15.235.12.125:8081/${episode.still?.urlsImage
                            ?.firstWhere((img) => img.size?.value == "original",
                                orElse: () => const UrlsImage(url: ""))
                            .url ??
                        ""}",
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
        );
      }),
    );
  }
}
