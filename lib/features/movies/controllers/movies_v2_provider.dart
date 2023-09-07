import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/models/movie_v2/movie_v2.dart';
import 'package:latest_movies/features/movies/repositories/movies_repository.dart';


final moviesV2Provider = FutureProvider<List<MovieV2>>((ref) async {
  return await ref.watch(moviesRepositoryProvider).fetchMoviesV2();
});
