import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/shared_widgets/button.dart';
import 'package:latest_movies/core/shared_widgets/default_app_padding.dart';
import 'package:latest_movies/core/shared_widgets/loading_overlay.dart';
import 'package:latest_movies/features/movies/enums/sidebar_options.dart';
import 'package:latest_movies/features/movies/views/movies_dashboard/search/search_page.dart';
import 'package:latest_movies/features/movies/widgets/movies_grid.dart';
import 'package:latest_movies/features/movies/widgets/tvshows_grid.dart';

import '../../../../core/utilities/design_utility.dart';
import '../../../tv_guide/views/tv_guide/tv_guide.dart';
import '../../controllers/side_bar_controller.dart';
import '../../controllers/update_dowload_providers/update_download_manager_provider.dart';
import '../../widgets/dashboard_sidebar.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sidebarState = ref.watch(sidebarStateProvider);
    final showUpdatePrompt = useState(false);

    useEffect(() {
      // ref.read(updateDownloadManagerProvider).checkAndDownloadUpdate(context, askForUpdate: true);
      Future.microtask(() async {
        final result =
            await ref.read(updateDownloadManagerProvider).checkForUpdate();
        showUpdatePrompt.value = result.updateAvailable;
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            const FlutterLogo(),
            horizontalSpaceSmall,
            const Text("Latest Movies"),
            const Spacer(),
            Visibility(
              visible: showUpdatePrompt.value,
              child: Row(children: [
                const Text(
                  "New Update Available",
                  style: TextStyle(fontSize: 12),
                ),
                horizontalSpaceSmall,
                AppButton(
                  text: "Download",
                  onTap: () {
                    ref
                        .read(updateDownloadManagerProvider)
                        .downloadUpdate(LoadingOverlay.of(context));
                  },
                )
              ]),
            )
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
              child: Builder(builder: (context) {
                switch (sidebarState.sidebarOptions) {
                  case SidebarOptions.home:
                    return const MoviesGrid();
                  case SidebarOptions.tvShows:
                    return const TvShowsGrid();
                  case SidebarOptions.tvGuide:
                    return const TvGuide();
                  case SidebarOptions.search:
                    return const SearchPage();
                  default:
                    return const MoviesGrid();
                }
              }),

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
