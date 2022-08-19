import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'dio_http_service.dart';
import 'http_service.dart';

final httpServiceProvider = Provider<HttpService>((ref) {
  return DioHttpService();
});
