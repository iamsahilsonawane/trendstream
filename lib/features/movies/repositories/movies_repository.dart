import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/services/http/http_service_provider.dart';
import 'package:latest_movies/features/movies/repositories/http_movies_repository.dart';

import '../../../core/models/paginated_response.dart';
import '../models/movie/movie.dart';

final moviesRepositoryProvider = Provider<MoviesRepository>(
  (ref) {
    final httpService = ref.watch(httpServiceProvider);

    return HttpMoviesRepository(httpService);
  },
);

abstract class MoviesRepository {
  String get path;

  String get apiKey;

  Future<PaginatedResponse<Movie>> getPopularMovies({
    int page = 1,
    bool forceRefresh = false,
  });

  Future<PaginatedResponse<Movie>> searchMovie({
    required String query,
    int page = 1,
    bool forceRefresh = false,
  });
}
