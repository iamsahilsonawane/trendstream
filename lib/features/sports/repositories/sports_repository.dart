import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/services/http/http_service_provider.dart';
import 'package:latest_movies/core/shared_providers/locale_provider.dart';
import 'package:latest_movies/features/sports/models/sports_category.dart';
import 'package:latest_movies/features/sports/models/sports_event/sports_event.dart';

import 'http_sports_repository.dart';

final sportsRepositoryProvider = Provider<SportsRepository>(
  (ref) {
    final httpService = ref.watch(httpServiceProvider);
    final locale = ref.watch(localeProvider);

    return HttpSportsRepository(httpService, locale);
  },
);

abstract class SportsRepository {
  String get path;

  String get apiKey;

  Future<List<SportsCategory>> getSportsCategories({bool forceRefresh = false});
  Future<List<SportsEvent>> getSportsEvents({bool forceRefresh = false});
  Future<List<SportsEvent>> getSportsEventsByCategory({bool forceRefresh = false, required int categoryId});
}
