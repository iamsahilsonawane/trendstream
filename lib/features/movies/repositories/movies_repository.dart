import '../../../core/models/paginated_response.dart';
import '../models/movie.dart';

abstract class MoviesRepository {
  String get path;

  String get apiKey;

  Future<PaginatedResponse<Movie>> getMovies({
    int page = 1,
    bool forceRefresh = false,
  });
}
