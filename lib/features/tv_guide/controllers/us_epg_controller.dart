

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/tv_guide/models/program_guide/program_guide.dart';
import 'package:latest_movies/features/tv_guide/repositories/tv_guide_repository.dart';

/// Electronic Program Guide (EPG) Controller for the United States (US)
final usEpgProvider = FutureProvider<ProgramGuide>((ref) async {
  return ref.watch(tvGuideRepositoryProvider).getProgramGuide();
});