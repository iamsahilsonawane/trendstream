import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/controllers/popular_paginated_movies_provider.dart';
import 'package:latest_movies/features/movies/models/movie/movie.dart';

import '../../../core/models/paginated_response.dart';

final popularMoviesCountProvider = Provider<AsyncValue<int>>((ref) {
  return ref.watch(paginatedPopularMoviesProvider(0)).whenData(
        (PaginatedResponse<Movie> pageData) => pageData.totalResults,
      );
});
