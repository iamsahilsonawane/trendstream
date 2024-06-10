import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/services/http/http_service_provider.dart';
import 'package:latest_movies/core/shared_providers/locale_provider.dart';
import 'package:latest_movies/features/movies/models/season_details/season_details.dart';
import 'package:latest_movies/features/movies/models/season_details_v3/episode.dart';
import 'package:latest_movies/features/movies/models/tv_show/tv_show.dart';
import 'package:latest_movies/features/movies/repositories/http_tv_shows_repository.dart';

import '../../../core/models/paginated_response.dart';
import '../models/season_details_v3/season_details_v3.dart';
import '../models/tv_show_details/tv_show_details.dart';
import '../models/tv_show_v3/tv_show_v3.dart';

final tvShowsRepositoryProvider = Provider<TvShowsRepository>(
  (ref) {
    final httpService = ref.watch(httpServiceProvider);
    final locale = ref.watch(localeProvider);

    return HttpTvShowsRepository(httpService, locale);
  },
);

abstract class TvShowsRepository {
  String get path;

  String get apiKey;

  Future<PaginatedResponse<TvShow>> getPopularTvShows({
    int page = 1,
    bool forceRefresh = false,
  });

  Future<PaginatedResponse<TvShow>> searchTvShow({
    required String query,
    int page = 1,
    bool forceRefresh = false,
  });

  Future<TvShowDetails> fetchTvShowDetails({
    required int tvShowId,
    bool forceRefresh = false,
  });

  Future<SeasonDetails> fetchTvShowSeasonDetails({
    required int tvShowId,
    required int seasonNumber,
    bool forceRefresh = false,
  });

  Future<List<TvShowV3>> getTvShowsV3({
    bool forceRefresh = false,
  });

  Future<List<Episode>> fetchEpisodesForSeasonV3({
    required int seasonId,
    bool forceRefresh = false,
  });

  Future<TvShowV3> getTvShowDetailsV3({
    required int tvShowId,
    bool forceRefresh = false,
  });

  Future<SeasonDetailsV3> getTvShowSeasonDetailsV3({
    required int tvShowId,
    bool forceRefresh = false,
  });

  Future<List<SeasonDetailsV3>> fetchAllTvShowSeasonsV3({
    required int tvShowId,
    bool forceRefresh = false,
  });
}
