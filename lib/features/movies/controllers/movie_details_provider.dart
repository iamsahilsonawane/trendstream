import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/repositories/movies_repository.dart';

import '../models/movie/movie.dart';

final movieDetailsProvider =
    FutureProvider.family<Movie, int>((ref, movieId) async {
  return ref
      .watch(moviesRepositoryProvider)
      .fetchMovieDetails(movieId: movieId);
});
