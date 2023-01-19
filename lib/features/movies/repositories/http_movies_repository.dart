import 'package:latest_movies/core/config/config.dart';
import 'package:latest_movies/core/services/http/http_service.dart';
import 'package:latest_movies/features/movies/models/movie/movie.dart';
import 'package:latest_movies/core/models/paginated_response.dart';
import 'package:latest_movies/features/movies/repositories/movies_repository.dart';

import '../models/movie_video/movie_video.dart';

class HttpMoviesRepository implements MoviesRepository {
  final HttpService httpService;

  HttpMoviesRepository(this.httpService);

  @override
  String get apiKey => Configs.apiKey;

  @override
  String get path => "/movie";

  @override
  Future<PaginatedResponse<Movie>> getPopularMovies(
      {int page = 1, bool forceRefresh = false}) async {
    final responseData = await httpService.get(
      '$path/popular',
      forceRefresh: forceRefresh,
      queryParameters: {
        'page': page,
        'api_key': apiKey,
      },
    );

    return PaginatedResponse.fromJson(
      responseData,
      results: List<Movie>.from(
        responseData['results'].map(
          (x) => Movie.fromJson(x),
        ),
      ),
    );
  }

  @override
  Future<PaginatedResponse<Movie>> searchMovie(
      {required String query, int page = 1, bool forceRefresh = false}) async {
    final responseData = await httpService.get(
      '/search/movie',
      forceRefresh: forceRefresh,
      queryParameters: {
        'query': query,
        'page': page,
        'api_key': apiKey,
      },
    );

    return PaginatedResponse.fromJson(
      responseData,
      results: List<Movie>.from(
        responseData['results'].map(
          (x) => Movie.fromJson(x),
        ),
      ),
    );
  }

  @override
  Future<Movie> fetchMovieDetails(
      {required int movieId, bool forceRefresh = false}) async {
    final responseData = await httpService.get(
      '/movie/$movieId',
      forceRefresh: forceRefresh,
      queryParameters: {
        'api_key': apiKey,
      },
    );

    return Movie.fromJson(responseData);
  }

  @override
  Future<List<MovieVideo>> fetchMovieVideos(
      {required int movieId, bool forceRefresh = false}) async {
    final responseData = await httpService.get(
      '/movie/$movieId/videos',
      forceRefresh: forceRefresh,
      queryParameters: {
        'api_key': apiKey,
      },
    );

    return (responseData['results'] as List)
        .map((x) => MovieVideo.fromJson(x))
        .toList();
  }
}
