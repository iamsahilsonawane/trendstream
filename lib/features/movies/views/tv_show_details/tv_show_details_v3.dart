import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/router/router.dart';
import 'package:latest_movies/core/shared_widgets/app_loader.dart';
import 'package:latest_movies/core/shared_widgets/error_view.dart';
import 'package:latest_movies/core/shared_widgets/image.dart';
import 'package:latest_movies/core/utilities/app_utility.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/features/movies/models/season_details_args/season_details_args.dart';
import 'package:latest_movies/features/movies/models/tv_show_details/season.dart';
import 'package:latest_movies/features/movies/models/tv_show_details/tv_show_details.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/config/config.dart';
import '../../../../core/shared_widgets/button.dart';
import '../../../../core/shared_widgets/default_app_padding.dart';
import '../../../../core/utilities/debouncer.dart';
import '../../controllers/tv_show_season_details_provider.dart';
import '../../controllers/tv_shows_provider_v3.dart';
import '../../models/season_details/episode.dart';
import '../../models/tv_show_v3/urls_image.dart';
import '../movie_details/all_cast_crew_v3_view.dart';
import '../movie_details/movie_details.dart' as md;

class TvShowDetailsViewV3 extends HookConsumerWidget {
  const TvShowDetailsViewV3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showId =
        useMemoized(() => ModalRoute.of(context)!.settings.arguments as int);
    final tvShowDetailsAsync = ref.watch(tvShowDetailsV3Provider(showId));

    final posterContainerHeight = MediaQuery.of(context).size.height * 0.85;

    // States
    final uniqueMainCrew = useState(<String, String>{});

    // Function to run some code after movie is fetched. This will only be called once the movie is changed and not on every build method
    useEffect(() {
      tvShowDetailsAsync.whenData((tvShowDetails) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final mainCrew = tvShowDetails.casts ?? [];

          // Create a map to store unique names and their corresponding jobs
          final uniqueNames = <String, String>{};

          // Iterate over the crew members and merge their jobs for duplicate names
          for (final crewMember in mainCrew) {
            if (uniqueNames.length == 5) break;
            final name = crewMember.name!;
            final job = crewMember.knownForDepartment ?? "N/A";

            if (uniqueNames.containsKey(name)) {
              // Merge the job with the existing entry
              uniqueNames[name] = '${uniqueNames[name]}, $job';
            } else {
              // Add the new entry
              uniqueNames[name] = job;
            }
          }

          uniqueMainCrew.value = uniqueNames;
        });
      });
      return null;
    }, [tvShowDetailsAsync]);

    return Scaffold(
      body: tvShowDetailsAsync.when(
        data: (show) {
          return DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  show.backdrop?.urlsImage
                          ?.firstWhere((img) => img.size?.value == "original",
                              orElse: () => const UrlsImage(url: ""))
                          .url ??
                      "",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: SizedBox.expand(
                child: ColoredBox(
                  color: Colors.black.withOpacity(.8),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: TextButton.icon(
                              onPressed: () {
                                Debouncer(
                                        delay:
                                            const Duration(milliseconds: 500))
                                    .call(() {
                                  AppRouter.pop();
                                });
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.arrow_back),
                              label: const Text("Back")),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          height: posterContainerHeight,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: posterContainerHeight,
                                // width: 250,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(.7),
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: AppImage(
                                      placeholder: (context, hash) =>
                                          const SizedBox(
                                              width: 230, child: AppLoader()),
                                      imageUrl: show.poster?.urlsImage
                                              ?.firstWhere(
                                                  (img) =>
                                                      img.size?.value ==
                                                      "original",
                                                  orElse: () =>
                                                      const UrlsImage(url: ""))
                                              .url ??
                                          "",
                                      //todo: add a not available image in case there's no image
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        validString(show.originalName),
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    if (show.name?.isNotEmpty ?? false)
                                      Text(
                                        validString(show.name),
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    const SizedBox(height: 20),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              (show.voteAverage ?? 0.0)
                                                  .toStringAsFixed(2),
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "(${show.voteCount})",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${show.genres?.map((e) => e.name).join(" / ")} | ${show.numberOfSeasons} ${show.numberOfSeasons == 1 ? "Season" : "Seasons"}",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    const Row(
                                      children: [
                                        Icon(Icons.info_outline,
                                            color: Colors.grey, size: 14),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            "Click on the overview text to read more",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    verticalSpaceTiny,
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    kBackgroundColor,
                                                title: const Text(
                                                  "Overview",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                content: SingleChildScrollView(
                                                  child: Text(
                                                    validString(show.overview),
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  AppButton(
                                                    autofocus: true,
                                                    text: "Close",
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Builder(builder: (context) {
                                          final hasPrimaryFocus =
                                              Focus.of(context).hasPrimaryFocus;
                                          return Container(
                                            decoration: hasPrimaryFocus
                                                ? BoxDecoration(
                                                    color: kPrimaryAccentColor
                                                        .withOpacity(.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  )
                                                : null,
                                            child: Text(
                                              validString(show.overview),
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                overflow: TextOverflow.fade,
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Wrap(
                                      spacing: 20,
                                      runSpacing: 10,
                                      children: [
                                        ...uniqueMainCrew.value.entries.map(
                                            (entry) => md.CreatorItem(
                                                name: entry.key,
                                                job: entry.value)),
                                      ],
                                    ),
                                    verticalSpaceSmall,
                                    Row(
                                      children: [
                                        Expanded(child: _buildWatchButtons()),
                                        AppButton(
                                          autofocus: true,
                                          text: "All Seasons",
                                          onTap: () async {
                                            AppRouter.navigateToPage(
                                              Routes.tvShowSeasonsV3,
                                              arguments: show,
                                            );
                                            return;
                                          },
                                          prefix: const Icon(
                                            Icons.movie_creation_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              verticalSpaceMedium,
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Cast",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    verticalSpaceMedium,
                                    SizedBox(
                                      height: 230,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            min(show.casts?.length ?? 10, 10) +
                                                1,
                                        clipBehavior: Clip.none,
                                        itemBuilder: (context, index) {
                                          //if item is last
                                          if (index ==
                                              min(show.casts?.length ?? 10,
                                                  10)) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: TextButton.icon(
                                                  onPressed: () {
                                                    final bgPath = show
                                                            .backdrop?.urlsImage
                                                            ?.firstWhere(
                                                                (img) =>
                                                                    img.size
                                                                        ?.value ==
                                                                    "original",
                                                                orElse: () =>
                                                                    const UrlsImage(
                                                                        url:
                                                                            ""))
                                                            .url ??
                                                        "";

                                                    AppRouter.navigateToPage(
                                                      Routes
                                                          .allMovieCastAndCrewV3,
                                                      arguments:
                                                          AllClassAndCrewV3Args(
                                                        casts: show.casts ?? [],
                                                        backdropPath: bgPath,
                                                      ),
                                                    );
                                                  },
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                  ),
                                                  icon: const Icon(
                                                      Icons.arrow_forward),
                                                  label:
                                                      const Text("View all")),
                                            );
                                          }
                                          final cast = show.casts?[index];
                                          return md.CastTile(
                                              name: cast?.name,
                                              character: cast?.characterName,
                                              profilePath: cast?.profilePath);
                                        },
                                      ),
                                    ),
                                  ]),
                              verticalSpaceMedium,

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Stats",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  verticalSpaceMedium,
                                  Focus(
                                    child: Builder(builder: (context) {
                                      return Container(
                                        padding: const EdgeInsets.all(14.0),
                                        decoration: BoxDecoration(
                                          color: kPrimaryAccentColor
                                              .withOpacity(.2),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            md.StatsItem(
                                              stat: "Status",
                                              value: show.status ?? "N/A",
                                            ),
                                            verticalSpaceRegular,
                                            md.StatsItem(
                                              stat: "Network",
                                              value: show.network ?? "N/A",
                                            ),
                                            //     verticalSpaceRegular,
                                            //     md.StatsItem(
                                            //       stat: "Original Language",
                                            //       value: show.spokenLanguages
                                            //               ?.firstWhere(
                                            //                   (element) =>
                                            //                       element.iso6391 ==
                                            //                       show
                                            //                           .originalLanguage,
                                            //                   orElse: () =>
                                            //                       const SpokenLanguage(
                                            //                           name:
                                            //                               "English"))
                                            //               .name ??
                                            //           "N/A",
                                            //     ),
                                          ],
                                        ),
                                      );
                                    }),
                                  )
                                ],
                              ),

                              // Row(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Expanded(
                              //       child:,
                              //     ),
                              //     horizontalSpaceLarge,
                              //     SizedBox(
                              //       width: 200,
                              //       child:   ),
                              //   ],
                              // ),
                              verticalSpaceMedium,
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
        },
        loading: () => const AppLoader(),
        error: (error, stack) => const ErrorView(),
      ),
    );
  }

  Row _buildWatchButtons() {
    return Row(
      children: [
        AppButton(
          autofocus: true,
          text: "Watch Now",
          onTap: () async {
            const platform = MethodChannel('com.example.latest_movies/channel');
            await platform.invokeMethod("navigateToPlayer");
            // AppRouter.navigateToPage(Routes.playerView);
          },
          prefix: const Icon(
            Icons.play_circle,
            color: Colors.white,
          ),
        ),
        horizontalSpaceRegular,
        AppButton(
          text: "Watch Trailer",
          onTap: () async {
            const platform = MethodChannel('com.example.latest_movies/channel');
            await platform.invokeMethod("navigateToYoutubePlayer");
          },
        ),
        // Builder(
        //   builder: (context) {
        //     final hasTrailer = (show.videos?.results?.any((element) =>
        //             element.type == "Trailer" &&
        //             (element.official ?? false) &&
        //             element.site == "YouTube") ??
        //         false);

        //     return AppButton(
        //       text: "Watch Trailer",
        //       onTap: !hasTrailer
        //           ? null
        //           : () async {
        //               final firstTrailer = show.videos!.results!.firstWhere(
        //                 (element) {
        //                   return element.type == "Trailer" &&
        //                       (element.official ?? false) &&
        //                       element.site == "YouTube";
        //                 },
        //               );

        //               if (!await launchUrl(Uri.parse(
        //                   "https://youtube.com/watch?v=${firstTrailer.key}"))) {
        //                 AppUtils.showSnackBar(null,
        //                     message: "This TV does not support opening URLs");
        //               }
        //             },
        //     );
        //   },
        // ),
      ],
    );
  }
}

class SeasonPickerDialog extends StatefulWidget {
  const SeasonPickerDialog({
    Key? key,
    required this.seasons,
    required this.tvShowId,
    required this.selectedSeasonId,
  }) : super(key: key);

  final List<Season> seasons;
  final int tvShowId;
  final int selectedSeasonId;

  @override
  State<SeasonPickerDialog> createState() => _SeasonPickerDialogState();
}

class _SeasonPickerDialogState extends State<SeasonPickerDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kBackgroundColor,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultAppPadding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Season",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                        text: "View all episodes",
                        onTap: () {
                          AppRouter.navigateToPage(Routes.tvShowAllEpisodes,
                              arguments: widget.tvShowId);
                        },
                      ),
                      horizontalSpaceRegular,
                      AppButton(
                        text: "Cancel",
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.seasons.length,
                itemBuilder: (context, index) {
                  final season = widget.seasons[index];

                  return InkWell(
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      final result = await showDialog(
                        context: context,
                        builder: (context) => EpisodePickerDialog(
                          selectedSeason: season,
                          tvShowId: widget.tvShowId,
                        ),
                      );
                      if (result == null) return;
                      switch (result.runtimeType) {
                        case bool:
                          navigator.pop(season);
                          break;
                        case Episode:
                          navigator.pop(result);
                          break;
                        default:
                          break;
                      }
                    },
                    child: ColoredBox(
                      color: season.id == widget.selectedSeasonId
                          ? kPrimaryAccentColor.withOpacity(.2)
                          : Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(
                              "${Configs.largeBaseImagePath}${season.posterPath}",
                              width: 100,
                              height: 100,
                              errorBuilder: (context, error, stack) {
                                return const SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Center(
                                    child: Icon(Icons.hide_image),
                                  ),
                                );
                              },
                            ),
                            horizontalSpaceSmall,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    validString(season.name),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (season.overview?.isNotEmpty ?? false) ...[
                                    verticalSpaceSmall,
                                    Text(
                                      validString(season.overview),
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
                            horizontalSpaceSmall,
                            const Icon(Icons.keyboard_arrow_right),
                            horizontalSpaceSmall,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EpisodePickerDialog extends HookConsumerWidget {
  final int tvShowId;
  final Season selectedSeason;

  const EpisodePickerDialog(
      {Key? key, required this.selectedSeason, required this.tvShowId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonDetailsAsync = ref.watch(seasonDetailsProvider(
        SeasonDetailsArgs(tvShowId, selectedSeason.seasonNumber!)));

    return Dialog(
      backgroundColor: kBackgroundColor,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: seasonDetailsAsync.when(
          data: (data) {
            final episodes = data.episodes;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultAppPadding(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${selectedSeason.name} - Episodes",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      AppButton(
                        text: "Back",
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ),
                Center(
                  child: AppButton(
                    text: "Select this season",
                    prefix: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
                verticalSpaceSmall,
                Expanded(
                  child: ListView.builder(
                    itemCount: episodes?.length ?? 0,
                    itemBuilder: (context, index) {
                      final episode = episodes![index];

                      return InkWell(
                        onTap: () {
                          // Do something with the selected episode
                          Navigator.pop(context, episode);
                        },
                        child: ColoredBox(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  "${Configs.largeBaseImagePath}${episode.stillPath}",
                                  width: 100,
                                  errorBuilder: (context, error, stack) {
                                    return const SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Center(
                                        child: Icon(Icons.hide_image),
                                      ),
                                    );
                                  },
                                ),
                                horizontalSpaceRegular,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        validString(episode.name),
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (episode.overview?.isNotEmpty ??
                                          false) ...[
                                        verticalSpaceSmall,
                                        Text(
                                          validString(episode.overview),
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
                      );
                    },
                  ),
                ),
              ],
            );
          },
          error: (err, st) => const ErrorView(),
          loading: () => const AppLoader(),
        ),
      ),
    );
  }
}
