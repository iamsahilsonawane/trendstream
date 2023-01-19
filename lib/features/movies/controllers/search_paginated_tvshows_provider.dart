import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/controllers/search_paginated_movies_provider.dart';
import 'package:latest_movies/features/movies/repositories/tv_shows_repository.dart';

import '../../../core/models/paginated_response.dart';
import '../models/tv_show/tv_show.dart';

final paginatedSearchTvShowsProvider = FutureProvider.family<
    PaginatedResponse<TvShow>, PaginatedSearchProviderArgs>(
  (ref, args) async {
    final showsRepository = ref.watch(tvShowsRepositoryProvider);

    return showsRepository.searchTvShow(
      query: args.query,
      page: args.page + 1,
    );
  },
);
