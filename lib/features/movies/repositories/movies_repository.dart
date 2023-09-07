import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/services/http/http_service_provider.dart';
import 'package:latest_movies/features/movies/models/movie_v2/movie_v2.dart';
import 'package:latest_movies/features/movies/repositories/http_movies_repository.dart';

import '../../../core/models/paginated_response.dart';
import '../models/movie/movie.dart';
import '../models/movie_video/movie_video.dart';

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

  Future<List<MovieV2>> fetchMoviesV2({bool forceRefresh = false});

  Future<MovieV2> fetchMovieDetailsV2(
      {bool forceRefresh = false, required int movieId});

  Future<PaginatedResponse<Movie>> searchMovie({
    required String query,
    int page = 1,
    bool forceRefresh = false,
  });

  Future<Movie> fetchMovieDetails({
    required int movieId,
    bool forceRefresh = false,
  });

  Future<List<MovieVideo>> fetchMovieVideos({
    required int movieId,
    bool forceRefresh = false,
  });
}
