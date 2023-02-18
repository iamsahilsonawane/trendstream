import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/services/http/http_service_provider.dart';

import 'http_tv_guide_repository.dart';

final sportsRepositoryProvider = Provider<SportsRepository>(
  (ref) {
    final httpService = ref.watch(httpServiceProvider);

    return HttpSportsRepository(httpService);
  },
);

abstract class SportsRepository {
  String get path;

  String get apiKey;
}
