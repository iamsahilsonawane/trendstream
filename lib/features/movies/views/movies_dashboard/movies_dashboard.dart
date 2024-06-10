import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/paths.dart';
import 'package:latest_movies/core/shared_widgets/button.dart';
import 'package:latest_movies/core/shared_widgets/default_app_padding.dart';
import 'package:latest_movies/core/shared_widgets/loading_overlay.dart';
import 'package:latest_movies/core/utilities/app_utility.dart';
import 'package:latest_movies/features/movies/enums/sidebar_options.dart';
import 'package:latest_movies/features/movies/views/movies_dashboard/search/live_channel_search_page.dart';
import 'package:latest_movies/features/movies/views/movies_dashboard/search/search_page.dart';
import 'package:latest_movies/features/movies/widgets/movies_grid.dart';
import 'package:latest_movies/features/movies/widgets/tvshows_grid.dart';
import 'package:latest_movies/features/movies/widgets/tvshows_grid_v3.dart';
import 'package:latest_movies/features/settings/settings_page.dart';
import 'package:latest_movies/features/sports/views/sports_view.dart';

import '../../../../core/utilities/design_utility.dart';
import '../../controllers/dashboard_sidebar_expanded_provider.dart';
import '../../controllers/side_bar_controller.dart';
import '../../controllers/update_dowload_providers/update_download_manager_provider.dart';
import '../../widgets/adult_grid.dart';
import '../../widgets/dashboard_sidebar.dart';
import '../../widgets/movies_v2_grid.dart';
import '../../widgets/movies_v3_grid.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sidebarState = ref.watch(sidebarStateProvider);
    final showUpdatePrompt = useState(false);
    final isMounted = useIsMounted();
    final shouldReAskForUpdate = useState(false);
    final backCounter = useRef(0);

    final isSidebarExpanded = ref.watch(dashboardSidebarStatusProvider) ==
        DashboardSidebarStatus.expanded;

    useEffect(() {
      Future.microtask(() async {
        shouldReAskForUpdate.value = await ref
            .read(updateDownloadManagerProvider)
            .checkAndDownloadUpdate(context,
                askForUpdate: true, isMounted: isMounted);
        //   final result =
        //       await ref.read(updateDownloadManagerProvider).checkForUpdate();
        //   showUpdatePrompt.value = result.updateAvailable;
        // Future.delayed(const Duration(seconds: 5), () async {
        //   const platform = MethodChannel('com.example.latest_movies/channel');
        //   await platform.invokeMethod("navigateToGuide");
        // });
      });
      return null;
    }, []);

    useOnAppLifecycleStateChange((_, state) {
      if (state == AppLifecycleState.resumed && shouldReAskForUpdate.value) {
        ref.read(updateDownloadManagerProvider).checkAndDownloadUpdate(context,
            askForUpdate: true, isMounted: isMounted);
      }
    });

    return WillPopScope(
      onWillPop: () async {
        if (backCounter.value == 0) {
          backCounter.value++;
          AppUtils.showSnackBar(context,
              message: "Press back again to exit the app", color: Colors.white);
          Future.delayed(const Duration(seconds: 3), () {
            backCounter.value = 0;
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Row(
            children: [
              Image.asset(AppPaths.logoWhite, height: 30),
              // horizontalSpaceSmall,
              // const Text("Latest Movies"),
              const Spacer(),
              Visibility(
                visible: showUpdatePrompt.value,
                child: Row(children: [
                  Text(
                    "New Update Available v${FirebaseRemoteConfig.instance.getString('latest_version_code')} #${FirebaseRemoteConfig.instance.getInt('latest_build_number')}",
                    style: const TextStyle(fontSize: 12),
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
            SizedBox(
                height: double.infinity,
                width: isSidebarExpanded ? 200 : 55,
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
                    case SidebarOptions.tvShowsV3:
                      return const TvShowsGridV3();
                    case SidebarOptions.adult:
                      return const AdultGrid();
                    case SidebarOptions.search:
                      return const SearchPage();
                    case SidebarOptions.liveChannelsSearch:
                      return const LiveChannelSearchPage();
                    case SidebarOptions.sports:
                      return const SportsPage();
                    case SidebarOptions.apiMovies:
                      return const MoviesV2Grid();
                    case SidebarOptions.apiMoviesV3:
                      return const MoviesV3Grid();
                    case SidebarOptions.settings:
                      return const SettingsPage();
                    default:
                      return const MoviesGrid();
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
