import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/models/movie_v2/movie_v2.dart';
import 'package:latest_movies/features/movies/repositories/movies_repository.dart';

import '../models/movie_v3/movie_v3.dart';

final moviesV2Provider = FutureProvider.autoDispose<List<MovieV2>>((ref) async {
  return await ref.watch(moviesRepositoryProvider).fetchMoviesV2();
});

final moviesV3Provider = FutureProvider.autoDispose<List<MovieV3>>((ref) async {
  return await ref.watch(moviesRepositoryProvider).fetchMoviesV3();
});
