import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/enums/sidebar_options.dart';

class SidebarState {
  final SidebarOptions sidebarOptions;

  SidebarState(this.sidebarOptions);
}

final sidebarStateProvider =
    StateNotifierProvider<SidebarStateNotifier, SidebarState>((ref) {
  return SidebarStateNotifier();
});

class SidebarStateNotifier extends StateNotifier<SidebarState> {
  SidebarStateNotifier() : super(SidebarState(SidebarOptions.home));

  void setSidebarOption(SidebarOptions sidebarOptions) {
    state = SidebarState(sidebarOptions);
  }
}
