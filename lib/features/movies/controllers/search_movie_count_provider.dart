import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/controllers/movie_search_controller.dart';
import 'package:latest_movies/features/movies/controllers/search_paginated_movies_provider.dart';
import 'package:latest_movies/features/movies/models/movie/movie.dart';

import '../../../core/models/paginated_response.dart';

final searchMovieCountProvider = Provider<AsyncValue<int>>((ref) {
  final keyword = ref.watch(searchKeywordProvider);

  return ref
      .watch(paginatedSearchMoviesProvider(
          PaginatedSearchProviderArgs(page: 0, query: keyword)))
      .whenData(
        (PaginatedResponse<Movie> pageData) => pageData.totalResults,
      );
});
