import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/sports/controllers/sports_categories_provider.dart';
import 'package:latest_movies/features/sports/models/sports_event/sports_event.dart';
import 'package:latest_movies/features/sports/repositories/sports_repository.dart';

final sportsEventsProvider =
    FutureProvider.autoDispose<List<SportsEvent>>((ref) async {
  final selectedCategory = ref.watch(selectedCategoryProvider);

  if (selectedCategory == null || selectedCategory.id == null) {
    return ref.read(sportsRepositoryProvider).getSportsEvents();
  }

  return ref
      .read(sportsRepositoryProvider)
      .getSportsEventsByCategory(categoryId: selectedCategory.id!);
});
