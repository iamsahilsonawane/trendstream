import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/repositories/movies_repository.dart';

import '../models/movie_video/movie_video.dart';

final movieVideosProvider =
    FutureProvider.family<List<MovieVideo>, int>((ref, movieId) async {
  return ref.watch(moviesRepositoryProvider).fetchMovieVideos(movieId: movieId);
});
