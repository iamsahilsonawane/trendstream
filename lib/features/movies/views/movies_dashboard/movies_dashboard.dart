import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/shared_widgets/default_app_padding.dart';
import 'package:latest_movies/features/movies/enums/sidebar_options.dart';
import 'package:latest_movies/features/movies/views/movies_dashboard/search/search_page.dart';
import 'package:latest_movies/features/movies/widgets/movies_grid.dart';

import '../../../../core/utilities/design_utility.dart';
import '../../controllers/side_bar_controller.dart';
import '../../widgets/dashboard_sidebar.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sidebarState = ref.watch(sidebarStateProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
            ),
          ),
          const SizedBox(width: 10),
        ],
        title: Row(
          children: const [
            FlutterLogo(),
            horizontalSpaceSmall,
            Text("Latest Movies")
          ],
        ),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: FocusTraversalGroup(child: const DashboardSideBar())),
          Expanded(
            flex: 8,
            child: DefaultAppPadding(
              child: sidebarState.sidebarOptions == SidebarOptions.home
                  ? const MoviesGrid()
                  : const SearchPage(),

              // IndexedStack(
              //   index: sidebarState.sidebarOptions.index,
              //   children: [
              //     FocusTraversalGroup(child: const MoviesGrid()),
              //     const SearchPage(),
              //   ],
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
