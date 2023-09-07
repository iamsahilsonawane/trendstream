import 'package:latest_movies/core/config/config.dart';
import 'package:latest_movies/core/services/http/http_service.dart';
import 'package:latest_movies/features/movies/models/movie/movie.dart';
import 'package:latest_movies/core/models/paginated_response.dart';
import 'package:latest_movies/features/movies/models/movie_v2/movie_v2.dart';
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
        'append_to_response': 'credits',
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

  @override
  Future<List<MovieV2>> fetchMoviesV2({bool forceRefresh = false}) async {
    final responseData = await httpService.get(
      'http://51.222.14.111:8080/api-tv-movies/app/movies/getMovies',
      forceRefresh: forceRefresh,
      queryParameters: {
        "language": "en",
      },
    );

    return List<MovieV2>.from(responseData.map((x) => MovieV2.fromJson(x)));
  }

  @override
  Future<MovieV2> fetchMovieDetailsV2(
      {bool forceRefresh = false, required int movieId}) async {
    final responseData = await httpService.get(
      'http://51.222.14.111:8080/api-tv-movies/app/movies/getMovieDetail',
      forceRefresh: forceRefresh,
      queryParameters: {
        "id_movie": movieId,
        "language": "en",
      },
    );

    return MovieV2.fromJson(responseData);
  }
}
