import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/extensions/context_extension.dart';
import 'package:latest_movies/features/movies/models/season_details_v3/season_details_v3.dart';
import 'package:latest_movies/features/movies/models/tv_show_v3/tv_show_v3.dart';

import '../../../../core/router/router.dart';
import '../../../../core/shared_widgets/app_loader.dart';
import '../../../../core/shared_widgets/default_app_padding.dart';
import '../../../../core/shared_widgets/error_view.dart';
import '../../../../core/utilities/debouncer.dart';
import '../../../../core/utilities/design_utility.dart';
import '../../controllers/tv_shows_provider_v3.dart';
import '../../models/tv_show_v3/urls_image.dart';
import '../../widgets/season_episodes_list_v3.dart';

class TvShowSeasonsV3 extends HookConsumerWidget {
  const TvShowSeasonsV3({super.key, required this.tvShow});

  final TvShowV3 tvShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tvShowSeasonsAsync =
        ref.watch(tvShowAllSeasonsV3Provider(tvShow.id!));
    final allSeasonDetailsAsync =
        ref.watch(tvShowAllSeasonsV3Provider(tvShow.id!));

    final currentSeason = useState<int>(1);

    return Scaffold(
      body: tvShowSeasonsAsync.when(
        data: (allSeasons) {
          final allEpisodesCount = allSeasons.fold<int>(
              0, (acc, season) => acc + (season.numberOfEpisodes ?? 0));

          final seasons = <SeasonDetailsV3>[
            ...allSeasons,
            SeasonDetailsV3(
                name: context.localisations.allSeasons,
                seasonNumber: -1,
                numberOfEpisodes: allEpisodesCount)
          ];
          return DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  tvShow.poster?.urlsImage
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
                                          tvShow.originalName ?? "N/A",
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
                                          "${allSeasons.length} ${context.localisations.seasons}",
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
                                                        s.numberOfEpisodes ?? 0,
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
                              child: allSeasonDetailsAsync.when(
                                data: (data) {
                                  if (currentSeason.value != -1) {
                                    final cs = data.firstWhere((element) =>
                                        element.seasonNumber ==
                                        currentSeason.value);
                                    return SeasonEpisodesListV3(
                                        seasonDetails: cs,
                                        showSeasonNumber: true);
                                  } else {
                                    return AllSeasonEpisodesListV3(
                                        tvShowId: tvShow.id!);
                                  }
                                },
                                error: (err, st) => const SizedBox.shrink(),
                                loading: () => const SizedBox.shrink(),
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
