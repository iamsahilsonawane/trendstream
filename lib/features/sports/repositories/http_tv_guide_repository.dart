import 'package:latest_movies/core/config/config.dart';
import 'package:latest_movies/core/services/http/http_service.dart';
import 'package:latest_movies/features/sports/repositories/tv_guide_repository.dart';

class HttpSportsRepository implements SportsRepository {
  final HttpService httpService;

  HttpSportsRepository(this.httpService);

  @override
  String get apiKey => Configs.apiKey;

  @override
  String get path => "https://iptv-org.github.io/epg/guides";
}
