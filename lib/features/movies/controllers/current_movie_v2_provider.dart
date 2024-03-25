import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/models/movie_v2/movie_v2.dart';

import '../models/movie_v3/movie_v3.dart';


final currentMovieV2Provider = Provider<AsyncValue<MovieV2>>((ref) {
  throw UnimplementedError();
});

final currentMovieV3Provider = Provider<AsyncValue<MovieV3>>((ref) {
  throw UnimplementedError();
});
