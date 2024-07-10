import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/models/season_details_v3/episode.dart';
import 'package:latest_movies/features/movies/models/tv_show_v3/tv_show_v3.dart';
import 'package:latest_movies/features/movies/repositories/tv_shows_repository.dart';
import '../models/season_details_v3/season_details_v3.dart';

final showsV3Provider = FutureProvider.autoDispose<List<TvShowV3>>((ref) async {
  return await ref.watch(tvShowsRepositoryProvider).getTvShowsV3();
});

final currentTvShowProvider = Provider<AsyncValue<TvShowV3>>((ref) {
  throw UnimplementedError();
});

final tvShowDetailsV3Provider =
    FutureProvider.family<TvShowV3, int>((ref, tvShowId) async {
  return ref
      .watch(tvShowsRepositoryProvider)
      .getTvShowDetailsV3(tvShowId: tvShowId);
});

final tvShowAllSeasonsV3Provider =
    FutureProvider.family<List<SeasonDetailsV3>, int>((ref, tvShowId) async {
  return ref
      .watch(tvShowsRepositoryProvider)
      .fetchAllTvShowSeasonsV3(tvShowId: tvShowId);
});

final currentSeasonDetailsV3Provider = Provider<Future<SeasonDetailsV3>>((ref) {
  throw UnimplementedError(
      "currnetSeasonDetailsV3Provider isn't implemented. Override the value first");
});

final episodesForSeasonProvider =
    FutureProvider.family<List<Episode>, int>((ref, seasonId) async {
  return ref
      .watch(tvShowsRepositoryProvider)
      .fetchEpisodesForSeasonV3(seasonId: seasonId);
});

final episodesForTvShowProvider =
    FutureProvider.family<List<Episode>, int>((ref, tvShowId) async {
  return ref
      .watch(tvShowsRepositoryProvider)
      .fetchEpisodesForTvShowV3(tvShowId: tvShowId);
});
