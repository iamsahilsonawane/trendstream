import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesServiceProvider =
    Provider<SharedPreferencesService>((ref) => throw UnimplementedError());

class SharedPreferencesService {
  SharedPreferencesService(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const isLoggedInKey = 'isLoggedIn';

  //Utilities
  Future<void> setIsLoggedIn() async {
    await sharedPreferences.setBool(isLoggedInKey, true);
  }

  bool isLoggedIn() => sharedPreferences.getBool(isLoggedInKey) ?? false;

  //removes all keys
  Future<void> clear() async {
    await sharedPreferences.clear();
  }
}
