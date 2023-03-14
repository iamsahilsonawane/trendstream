import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/config.dart';
import '../../../../core/router/router.dart';
import '../../../../core/shared_widgets/app_loader.dart';
import '../../../../core/shared_widgets/default_app_padding.dart';
import '../../../../core/shared_widgets/error_view.dart';
import '../../../../core/shared_widgets/image.dart';
import '../../../../core/utilities/debouncer.dart';
import '../../../../core/utilities/design_utility.dart';
import '../../controllers/tv_show_season_details_provider.dart';
import '../../controllers/tv_shows_provider.dart';
import '../../models/season_details_args/season_details_args.dart';
import '../../models/tv_show_details/season.dart';
import '../../widgets/season_episodes_list.dart';

class TvShowSeasons extends HookConsumerWidget {
  const TvShowSeasons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showId =
        useMemoized(() => ModalRoute.of(context)!.settings.arguments as int);
    final tvShowDetailsAsync = ref.watch(tvShowDetailsProvider(showId));
    final currentSeason = useState<int>(1);

    return Scaffold(
      body: tvShowDetailsAsync.when(
        data: (show) {
          final allEpisodesCount = show.seasons!
              .fold<int>(0, (acc, season) => acc + (season.episodeCount ?? 0));

          final seasons = [
            ...show.seasons!,
            Season(
                name: "All Seasons",
                seasonNumber: -1,
                episodeCount: allEpisodesCount)
          ];
          return DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "${Configs.baseImagePath}${show.posterPath}",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: SizedBox.expand(
                child: ColoredBox(
                  color: Colors.black.withOpacity(.8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextButton.icon(
                          onPressed: () {
                            Debouncer(delay: const Duration(milliseconds: 500))
                                .call(() => AppRouter.pop());
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text("Back"),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DefaultAppPadding.horizontal(
                                    child: Row(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              "${Configs.baseImagePath}${show.posterPath}",
                                          height: 100,
                                          maxHeightDiskCache: 100,
                                          fit: BoxFit.cover,
                                        ),
                                        horizontalSpaceSmall,
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              show.name ?? "N/A",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            verticalSpaceRegular,
                                            Text(
                                              "${show.seasons!.length} Seasons",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                            verticalSpaceTiny,
                                            if (show.firstAirDate != null &&
                                                show.lastAirDate != null)
                                              Text(
                                                "${DateFormat("dd MMM, yyyy").format(DateTime.parse(show.firstAirDate!))} - ${DateFormat("dd MMM, yyyy").format(DateTime.parse(show.lastAirDate!))}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                  verticalSpaceMedium,
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: DefaultAppPadding(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            for (int i = 0;
                                                i < seasons.length;
                                                i++)
                                              Builder(builder: (context) {
                                                final s = seasons[i];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: SeasonSelectionButton(
                                                    autofocus: i == 0,
                                                    seasonText: s.name ?? "N/A",
                                                    totalNumberOfEpisodes:
                                                        s.episodeCount ?? 0,
                                                    onTap: () {
                                                      currentSeason.value =
                                                          s.seasonNumber!;
                                                    },
                                                  ),
                                                );
                                              }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            horizontalSpaceSmall,
                            Expanded(
                              flex: 8,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    verticalSpaceMedium,
                                    if (currentSeason.value != -1)
                                      ProviderScope(
                                        overrides: [
                                          currentSeasonDetailsProvider
                                              .overrideWithValue(
                                            ref.watch(seasonDetailsProvider(
                                                SeasonDetailsArgs(
                                              show.id!,
                                              currentSeason.value,
                                            ))),
                                          ),
                                        ],
                                        child: const SeasonEpisodesList(
                                            showSeasonNumber: true),
                                      )
                                    else
                                      AllSeasonEpisodesList(show: show)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
}

class SeasonSelectionButton extends StatelessWidget {
  const SeasonSelectionButton({
    super.key,
    required this.seasonText,
    required this.totalNumberOfEpisodes,
    required this.onTap,
    this.autofocus = false,
  });

  final String seasonText;
  final int totalNumberOfEpisodes;
  final VoidCallback onTap;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: onTap,
      autofocus: autofocus,
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasPrimaryFocus;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: isFocused ? Colors.grey : Colors.transparent,
                  width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Text(
                  seasonText,
                  style: TextStyle(
                    fontWeight: isFocused ? FontWeight.bold : FontWeight.normal,
                    color: isFocused ? Colors.white : Colors.grey,
                  ),
                ),
                const Spacer(),
                if (isFocused)
                  Text(
                    "$totalNumberOfEpisodes Episodes",
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
