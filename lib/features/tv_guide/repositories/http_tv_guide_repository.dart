import 'package:latest_movies/core/config/config.dart';
import 'package:latest_movies/core/services/http/http_service.dart';
import 'package:latest_movies/features/tv_guide/models/program_guide/program_guide.dart';
import 'package:latest_movies/features/tv_guide/repositories/tv_guide_repository.dart';

class HttpTvGuideRepository implements TvGuideRepository {
  final HttpService httpService;

  HttpTvGuideRepository(this.httpService);

  @override
  String get apiKey => Configs.apiKey;

  @override
  String get path => "https://iptv-org.github.io/epg/guides";

  @override
  Future<ProgramGuide> getProgramGuide({bool forceRefresh = false}) async {
    final responseData = await httpService.get(
      '$path/us/myafn.dodmedia.osd.mil.epg.json',
      // https://iptv-org.github.io/epg/guides/us/directv.com.epg.json
      forceRefresh: forceRefresh,
      queryParameters: {},
    );

    return ProgramGuide.fromJson(responseData);
  }
}
