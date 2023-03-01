import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/services/http/http_service_provider.dart';

import '../../../core/models/paginated_response.dart';
import 'http_multi_programs_repository.dart';

final multiProgramsRepositoryProvider = Provider<HttpMultiProgramsRepository>(
  (ref) {
    final httpService = ref.watch(httpServiceProvider);

    return HttpMultiProgramsRepository(httpService);
  },
);

abstract class MultiProgramsRepository {
  String get path;

  String get apiKey;

  /// Multi-programs are basically movies and tv shows combined.
  ///
  /// Returns dynamic list containing [Movie] and [TvShow] objects.
  Future<PaginatedResponse<dynamic>> searchMultiPrograms({
    required String query,
    int page = 1,
    bool forceRefresh = false,
  });
}
