import 'package:hooks_riverpod/hooks_riverpod.dart';

enum DashboardSidebarStatus {
  expanded,
  collapsed,
}

final dashboardSidebarStatusProvider =
    StateProvider<DashboardSidebarStatus>((ref) {
  return DashboardSidebarStatus.expanded;
});
