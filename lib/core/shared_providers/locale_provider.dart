import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/services/shared_preferences_service.dart';
import 'package:latest_movies/core/utilities/app_utility.dart';

final localeProvider = StateProvider((ref) {
  final prefs = ref.watch(sharedPreferencesServiceProvider);
  return AppUtils.getLocaleFromString(
      prefs.getCurrentLocale() ?? Platform.localeName);
});
