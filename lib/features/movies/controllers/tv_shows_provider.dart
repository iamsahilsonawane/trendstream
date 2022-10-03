import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/models/tv_show/tv_show.dart';
import 'package:latest_movies/features/movies/repositories/tv_shows_repository.dart';

import '../../../core/models/paginated_response.dart';
import '../models/tv_show_details/tv_show_details.dart';

final popularTvShowsCountProvider = Provider<AsyncValue<int>>((ref) {
  return ref.watch(paginatedPopularTvShowsProvider(0)).whenData(
        (PaginatedResponse<TvShow> pageData) => pageData.totalResults,
      );
});

final paginatedPopularTvShowsProvider =
    FutureProvider.family<PaginatedResponse<TvShow>, int>(
  (ref, int pageIndex) async {
    final moviesRepository = ref.watch(tvShowsRepositoryProvider);

    return moviesRepository.getPopularTvShows(page: pageIndex + 1);
  },
);

final currentPopularTvShowProvider = Provider<AsyncValue<TvShow>>((ref) {
  throw UnimplementedError();
});

final tvShowDetailsProvider =
    FutureProvider.family<TvShowDetails, int>((ref, tvShowId) async {
  return ref
      .watch(tvShowsRepositoryProvider)
      .fetchTvShowDetails(tvShowId: tvShowId);
});
