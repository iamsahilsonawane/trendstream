import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/controllers/movie_search_controller.dart';
import 'package:latest_movies/features/movies/controllers/search_paginated_movies_provider.dart';
import 'package:latest_movies/features/movies/controllers/search_paginated_multi_programs.dart';

import '../../../core/exceptions/app_error_codes.dart';
import '../../../core/exceptions/general_exception.dart';
import '../../../core/models/paginated_response.dart';

final searchMultiProgramsCountProvider = Provider<AsyncValue<int>>((ref) {
  final keyword = ref.watch(searchKeywordProvider);

  return ref
      .watch(paginatedMultiProgramsProvider(
          PaginatedSearchProviderArgs(page: 0, query: keyword)))
      .whenData(
    (PaginatedResponse<dynamic> pageData) {
      if (pageData.totalResults == 0) {
        throw GeneralException(
          code: AppErrorCodes.noItems,
          message: keyword.isNotEmpty
              ? "No programs found for your search" //TODO(localisation)
              : "Try searching for a movie or tv show",
        );
      }
      return pageData.totalResults;
    },
  );
});
