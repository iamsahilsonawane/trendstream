import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/models/season_details_args/season_details_args.dart';
import 'package:latest_movies/features/movies/repositories/tv_shows_repository.dart';

import '../models/season_details/season_details.dart';
import '../models/tv_show/tv_show.dart';
import '../models/tv_show_details/tv_show_details.dart';

// /// A provider that overrides the current selected season arg required for [seasonDetailsProvider].
// ///
// /// Used as a listener for trigger the season details provider which indeed fetches the episodes of that season.
// final currentSeasonArgsProvider = StateProvider<SeasonDetailsArgs>((ref) {
//   throw UnimplementedError(
//       "currentSeasonArgsProvider isn't implemented. Override the value first");
// });

final currentSeasonDetailsProvider = Provider<AsyncValue<SeasonDetails>>((ref) {
  throw UnimplementedError(
      "currnetSeasonDetailsProvider isn't implemented. Override the value first");
});

final seasonDetailsProvider =
    FutureProvider.family<SeasonDetails, SeasonDetailsArgs>((ref, args) async {
  // final args =
  //     ref.watch(currentSeasonArgsProvider); // listen to the current season args
  return ref.watch(tvShowsRepositoryProvider).fetchTvShowSeasonDetails(
        tvShowId: args.tvShowId,
        seasonNumber: args.seasonNumber,
      );
});

final allSeasonDetailsProvider = StateNotifierProvider.autoDispose
    .family<AllSeasonDetailsNotifier, List<SeasonDetails>, TvShowDetails>((ref,
            show) =>
        AllSeasonDetailsNotifier(ref.read(tvShowsRepositoryProvider), show));

class AllSeasonDetailsNotifier extends StateNotifier<List<SeasonDetails>> {
  AllSeasonDetailsNotifier(this._tvShowsRepository, this.show) : super([]);

  final TvShowDetails show;
  final TvShowsRepository _tvShowsRepository;

  int currentSeason = 0;
  bool _isFetching = false;

  Future<void> fetchAllSeasons(TvShowDetails show) async {
    try {
      // Set loading state
      // Fetch all seasons
      final results = <SeasonDetails>[];
      for (var season in show.seasons!) {
        results.add(await _tvShowsRepository.fetchTvShowSeasonDetails(
            tvShowId: show.id!, seasonNumber: season.seasonNumber!));
      }
      // Remove loading state and set results
      state = results;
    } catch (error) {
      // Handle error state
    }
  }

  Future<void> fetchNextPage() async {
    try {
      if (_isFetching) return;
      if (currentSeason > show.seasons!.last.seasonNumber!) return;
      _isFetching = true;

      if (currentSeason == 0) {
        //if seasons contains 0 the only use 0 other wise use 1
        if (show.seasons!
            .where((element) => element.seasonNumber == 0)
            .isNotEmpty) {
          currentSeason = 0;
        } else {
          currentSeason = 1;
        }
      }

      final results = <SeasonDetails>[];

      final season = show.seasons!
          .firstWhere((element) => element.seasonNumber == currentSeason);

      results.add(await _tvShowsRepository.fetchTvShowSeasonDetails(
          tvShowId: show.id!, seasonNumber: season.seasonNumber!));

      _isFetching = false;
      // Remove loading state and append results
      state = [...state, ...results];
      currentSeason++;
    } catch (error) {
      print("error fetching next page: ${error}");
      // Handle error state
    }
  }
}
