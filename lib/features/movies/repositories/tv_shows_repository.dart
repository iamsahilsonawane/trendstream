import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/services/http/http_service_provider.dart';
import 'package:latest_movies/features/movies/models/season_details/season_details.dart';
import 'package:latest_movies/features/movies/models/tv_show/tv_show.dart';
import 'package:latest_movies/features/movies/repositories/http_tv_shows_repository.dart';

import '../../../core/models/paginated_response.dart';
import '../models/tv_show_details/tv_show_details.dart';

final tvShowsRepositoryProvider = Provider<TvShowsRepository>(
  (ref) {
    final httpService = ref.watch(httpServiceProvider);

    return HttpTvShowsRepository(httpService);
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
}
