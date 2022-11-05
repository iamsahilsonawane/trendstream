import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/tv_guide/models/program_guide/program.dart';

final currentFocusedProgramProvider = StateProvider<Program?>((ref) {
  return null;
});
