import 'dart:ui';

import 'package:latest_movies/core/config/config.dart';
import 'package:latest_movies/core/services/http/http_service.dart';
import 'package:latest_movies/features/sports/models/sports_category.dart';
import 'package:latest_movies/features/sports/models/sports_event/sports_event.dart';
import 'package:latest_movies/features/sports/repositories/sports_repository.dart';

class HttpSportsRepository implements SportsRepository {
  final HttpService httpService;
  final Locale locale;

  HttpSportsRepository(this.httpService, this.locale);

  @override
  String get apiKey => Configs.apiKey;

  @override
  String get path => "${Configs.v3ApiBaseUrl}/app/sports";

  Map<String, String>  get commonQueryParams => {
    'language': locale.languageCode,
  };

  @override
  Future<List<SportsCategory>> getSportsCategories(
      {bool forceRefresh = false}) async {
    final responseData = await httpService.get(
      '$path/getCategories',
      forceRefresh: forceRefresh,
      queryParameters: {}..addAll(commonQueryParams),
    );

    return List<SportsCategory>.from(responseData.map((x) => SportsCategory.fromJson(x)));
  }

  @override
  Future<List<SportsEvent>> getSportsEvents({bool forceRefresh = false}) async {
    final responseData = await httpService.get(
      '$path/getEvents',
      forceRefresh: forceRefresh,
      queryParameters: {}..addAll(commonQueryParams),
    );

    return List<SportsEvent>.from(responseData.map((x) => SportsEvent.fromJson(x)));
  }

  @override
  Future<List<SportsEvent>> getSportsEventsByCategory(
      {bool forceRefresh = false, required int categoryId}) async {
    final responseData = await httpService.get(
      '$path/getEventsCategory',
      forceRefresh: forceRefresh,
      queryParameters: {
        "id_category": categoryId,
      }..addAll(commonQueryParams),
    );

    return List<SportsEvent>.from(responseData.map((x) => SportsEvent.fromJson(x)));
  }
}
