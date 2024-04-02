import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/repositories/movies_repository.dart';

import '../models/movie/movie.dart';
import '../models/movie_v2/movie_v2.dart';
import '../models/movie_v3/movie_v3.dart';

final movieDetailsProvider =
    FutureProvider.family<Movie, int>((ref, movieId) async {
  return ref
      .watch(moviesRepositoryProvider)
      .fetchMovieDetails(movieId: movieId);
});

final movieDetailsV2Provider =
    FutureProvider.autoDispose.family<MovieV2, int>((ref, movieId) async {
  return ref
      .watch(moviesRepositoryProvider)
      .fetchMovieDetailsV2(movieId: movieId);
});

final movieDetailsV3Provider =
    FutureProvider.autoDispose.family<MovieV3, int>((ref, movieId) async {
  return ref
      .watch(moviesRepositoryProvider)
      .fetchMovieDetailsV3(movieId: movieId);
});
