import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/sports/models/sports_event/sports_event.dart';

final currentFocusedEventController = StateProvider<SportsEvent?>((ref) {
  return null;
});
