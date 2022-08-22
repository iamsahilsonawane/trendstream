import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/models/paginated_response.dart';
import '../models/movie/movie.dart';
import '../repositories/movies_repository.dart';

final paginatedPopularMoviesProvider =
    FutureProvider.family<PaginatedResponse<Movie>, int>(
  (ref, int pageIndex) async {
    final moviesRepository = ref.watch(moviesRepositoryProvider);

    return moviesRepository.getPopularMovies(
      page: pageIndex + 1,
    );
  },
);
