import 'package:latest_movies/core/config/config.dart';
import 'package:latest_movies/core/services/http/http_service.dart';
import 'package:latest_movies/core/models/paginated_response.dart';
import 'package:latest_movies/features/movies/models/season_details_v3/season_details_v3.dart';
import 'package:latest_movies/features/movies/models/tv_show/tv_show.dart';
import 'package:latest_movies/features/movies/models/tv_show_details/tv_show_details.dart';
import 'package:latest_movies/features/movies/models/tv_show_v3/tv_show_v3.dart';
import 'package:latest_movies/features/movies/repositories/tv_shows_repository.dart';

import '../models/season_details/season_details.dart';

class HttpTvShowsRepository implements TvShowsRepository {
  final HttpService httpService;

  HttpTvShowsRepository(this.httpService);

  @override
  String get apiKey => Configs.apiKey;

  @override
  String get path => "/tv";

  @override
  Future<PaginatedResponse<TvShow>> getPopularTvShows(
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
      results: List<TvShow>.from(
        responseData['results'].map(
          (x) => TvShow.fromJson(x),
        ),
      ),
    );
  }

  @override
  Future<PaginatedResponse<TvShow>> searchTvShow(
      {required String query, int page = 1, bool forceRefresh = false}) async {
    final responseData = await httpService.get(
      '/search/tv',
      forceRefresh: forceRefresh,
      queryParameters: {
        'query': query,
        'page': page,
        'api_key': apiKey,
      },
    );

    return PaginatedResponse.fromJson(
      responseData,
      results: List<TvShow>.from(
        responseData['results'].map(
          (x) => TvShow.fromJson(x),
        ),
      ),
    );
  }

  @override
  Future<TvShowDetails> fetchTvShowDetails(
      {required int tvShowId, bool forceRefresh = false}) async {
    final responseData = await httpService.get(
      '$path/$tvShowId',
      forceRefresh: forceRefresh,
      queryParameters: {
        'api_key': apiKey,
        'append_to_response': 'videos,credits',
      },
    );

    return TvShowDetails.fromJson(responseData);
  }

  @override
  Future<SeasonDetails> fetchTvShowSeasonDetails({
    required int tvShowId,
    required int seasonNumber,
    bool forceRefresh = false,
  }) async {
    final responseData = await httpService.get(
      '$path/$tvShowId/season/$seasonNumber',
      forceRefresh: forceRefresh,
      queryParameters: {
        'api_key': apiKey,
      },
    );

    return SeasonDetails.fromJson(responseData);
  }

  @override
  Future<TvShowV3> getTvShowDetailsV3(
      {required int tvShowId, bool forceRefresh = false}) async {
    final responseData = await httpService.get(
      'http://15.235.12.125:8081/api-tv-movies/app/tv_shows/getDetailTvShow',
      forceRefresh: forceRefresh,
      queryParameters: {
        'id_tv_show': tvShowId,
        'language': 'en',
      },
    );

    return TvShowV3.fromJson(responseData);
  }

  @override
  Future<SeasonDetailsV3> getTvShowSeasonDetailsV3(
      {required int tvShowId, bool forceRefresh = false}) async {
    final responseData = await httpService.get(
      'http://15.235.12.125:8081/api-tv-movies/app/tv_shows/getSeasons',
      forceRefresh: forceRefresh,
      queryParameters: {
        'id_tv_show': tvShowId,
        'language': 'en',
      },
    );

    return SeasonDetailsV3.fromJson(responseData);
  }

  @override
  Future<List<TvShowV3>> getTvShowsV3({bool forceRefresh = false}) async {
    final responseData = await httpService.get(
      'http://15.235.12.125:8081/api-tv-movies/app/tv_shows/getTvShows',
      forceRefresh: forceRefresh,
      queryParameters: {
        'language': 'en',
      },
    );

    return List<TvShowV3>.from(responseData.map((x) => TvShowV3.fromJson(x)));
  }

  @override
  Future<List<SeasonDetailsV3>> fetchAllTvShowSeasonsV3(
      {required int tvShowId, bool forceRefresh = false}) async {
    final responseData = await httpService.get(
      'http://15.235.12.125:8081/api-tv-movies/app/tv_shows/getSeasons',
      forceRefresh: forceRefresh,
      queryParameters: {
        'id_tv_show': tvShowId,
        'language': 'en',
      },
    );

    return List<SeasonDetailsV3>.from(
        responseData.map((x) => SeasonDetailsV3.fromJson(x)));
  }
}
