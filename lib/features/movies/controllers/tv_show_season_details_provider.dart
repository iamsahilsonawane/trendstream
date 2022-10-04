import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/models/season_details_args/season_details_args.dart';
import 'package:latest_movies/features/movies/repositories/tv_shows_repository.dart';

import '../models/season_details/season_details.dart';

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

final seasonDetailsProvider = FutureProvider.family<SeasonDetails, SeasonDetailsArgs>((ref, args) async {
  // final args =
  //     ref.watch(currentSeasonArgsProvider); // listen to the current season args
  return ref.watch(tvShowsRepositoryProvider).fetchTvShowSeasonDetails(
        tvShowId: args.tvShowId,
        seasonNumber: args.seasonNumber,
      );
});
