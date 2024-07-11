import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/extensions/context_extension.dart';

import '../../../../core/config/config.dart';
import '../../../../core/router/router.dart';
import '../../../../core/shared_widgets/app_loader.dart';
import '../../../../core/shared_widgets/default_app_padding.dart';
import '../../../../core/shared_widgets/error_view.dart';
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
                name: context.localisations.allSeasons,
                seasonNumber: -1,
                episodeCount: allEpisodesCount)
          ];
          return DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "${Configs.largeBaseImagePath}${show.posterPath}",
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
                          label: Text(context.localisations.back),
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
                                        verticalSpaceSmall,
                                        Text(
                                          "${show.seasons!.length} ${context.localisations.seasons}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
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
                                                    isSelected:
                                                        currentSeason.value ==
                                                            s.seasonNumber,
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
                              child: currentSeason.value != -1
                                  ? ProviderScope(
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
                                  : AllSeasonEpisodesList(show: show),
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
    required this.isSelected,
    this.autofocus = false,
  });

  final String seasonText;
  final int totalNumberOfEpisodes;
  final bool isSelected;
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
          final isFocused = Focus.of(context).hasPrimaryFocus || isSelected;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: isFocused
                      ? isSelected
                          ? kPrimaryAccentColor
                          : Colors.grey
                      : Colors.transparent,
                  width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    seasonText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight:
                          isFocused ? FontWeight.bold : FontWeight.normal,
                      color: isFocused
                          ? isSelected
                              ? kPrimaryAccentColor
                              : Colors.white
                          : Colors.grey,
                    ),
                  ),
                ),
                if (isFocused)
                  Text(
                    "$totalNumberOfEpisodes ${context.localisations.episodes}",
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
