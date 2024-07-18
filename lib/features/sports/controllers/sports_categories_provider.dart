import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/sports/models/sports_category.dart';
import 'package:latest_movies/features/sports/repositories/sports_repository.dart';

final sportsCategoryProvider = FutureProvider<List<SportsCategory>>((ref) async {
  return ref.read(sportsRepositoryProvider).getSportsCategories();
});

final selectedCategoryProvider = StateProvider<SportsCategory?>((ref) {
  return null;
});