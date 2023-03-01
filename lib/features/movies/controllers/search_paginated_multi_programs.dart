import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/controllers/search_paginated_movies_provider.dart';
import 'package:latest_movies/features/movies/repositories/multi_programs_repository.dart';
import '../../../core/models/paginated_response.dart';

/// Returns dynamic list containing [Movie] and [TvShow] objects.
final paginatedMultiProgramsProvider = FutureProvider.family<
    PaginatedResponse<dynamic>, PaginatedSearchProviderArgs>(
  (ref, args) async {
    final multiRepository = ref.watch(multiProgramsRepositoryProvider);

    return multiRepository.searchMultiPrograms(
      query: args.query,
      page: args.page + 1,
      includeAdult: false,
    );
  },
);
