import 'package:latest_movies/core/config/config.dart';
import 'package:latest_movies/core/services/http/http_service.dart';
import 'package:latest_movies/core/models/paginated_response.dart';
import '../models/movie/movie.dart';
import '../models/tv_show/tv_show.dart';
import 'multi_programs_repository.dart';

class HttpMultiProgramsRepository implements MultiProgramsRepository {
  final HttpService httpService;

  HttpMultiProgramsRepository(this.httpService);

  @override
  String get apiKey => Configs.apiKey;

  @override
  String get path => "/movie";

  @override
  Future<PaginatedResponse<dynamic>> searchMultiPrograms(
      {required String query,
      int page = 1,
      bool forceRefresh = false,
      bool includeAdult = false}) async {
    final responseData = await httpService.get(
      '/search/multi',
      forceRefresh: forceRefresh,
      queryParameters: {
        'query': query,
        'page': page,
        'api_key': apiKey,
        'include_adult': includeAdult,
      },
    );

    final filteredList = responseData['results']
        .where((x) => x['media_type'] != 'person')
        .toList();

    return PaginatedResponse.fromJson(
      responseData,
      results: List<dynamic>.from(
        filteredList.map(
          (x) {
            if (x['media_type'] == 'movie') return Movie.fromJson(x);
            return TvShow.fromJson(x);
          },
        ),
      ),
    );
  }
}
