import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/services/http/http_service_provider.dart';
import 'package:latest_movies/features/tv_guide/models/program_guide/program_guide.dart';
import 'package:latest_movies/features/tv_guide/repositories/http_tv_guide_repository.dart';

final tvGuideRepositoryProvider = Provider<TvGuideRepository>(
  (ref) {
    final httpService = ref.watch(httpServiceProvider);

    return HttpTvGuideRepository(httpService);
  },
);

abstract class TvGuideRepository {
  String get path;

  String get apiKey;

  Future<ProgramGuide> getProgramGuide({bool forceRefresh = false});
}
