import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/shared_widgets/default_app_padding.dart';
import 'package:latest_movies/features/movies/enums/sidebar_options.dart';
import 'package:latest_movies/features/movies/views/movies_dashboard/search/search_page.dart';
import 'package:latest_movies/features/movies/widgets/movies_grid.dart';
import 'package:latest_movies/features/movies/widgets/tvshows_grid.dart';

import '../../../../core/utilities/design_utility.dart';
import '../../controllers/side_bar_controller.dart';
import '../../controllers/update_dowload_providers/update_download_manager_provider.dart';
import '../../widgets/dashboard_sidebar.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sidebarState = ref.watch(sidebarStateProvider);

    useEffect(() {
      ref.read(updateDownloadManagerProvider).checkAndDownloadUpdate(context);
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
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
            flex: 10,
            child: DefaultAppPadding(
              child: Builder(
                builder: (context) {
                  switch (sidebarState.sidebarOptions) {
                    case SidebarOptions.home:
                      return const MoviesGrid();
                    case SidebarOptions.tvShows:
                      return const TvShowsGrid();
                    case SidebarOptions.search:
                      return const SearchPage();
                    default:
                      return const MoviesGrid();
                  }
                }
              ),

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
