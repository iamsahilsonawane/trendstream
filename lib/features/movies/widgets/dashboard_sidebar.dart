import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/services/shared_preferences_service.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/features/movies/controllers/side_bar_controller.dart';
import 'package:latest_movies/features/movies/widgets/enter_passcode_dialog.dart';
import 'package:latest_movies/features/movies/widgets/set_passcode_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/router/router.dart';
import '../enums/sidebar_options.dart';

class DashboardSideBar extends HookConsumerWidget {
  const DashboardSideBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sidebarState = ref.watch(sidebarStateProvider);
    final sidebarStateNotifier = ref.watch(sidebarStateProvider.notifier);

    final platformInfo = useMemoized(() => PackageInfo.fromPlatform());

    return SizedBox(
      height: double.infinity,
      child: Ink(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 18, 19, 21),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView(
            key: GlobalKey(debugLabel: "dashboardSideBar"),
            shrinkWrap: true,
            controller: ScrollController(),
            children: <Widget>[
              DrawerItem(
                title: 'Movies',
                iconData: Icons.home_outlined,
                selectedIconData: Icons.home,
                isSelected: sidebarState.sidebarOptions == SidebarOptions.home,
                onTap: () {
                  sidebarStateNotifier.setSidebarOption(SidebarOptions.home);
                },
              ),
              DrawerItem(
                title: 'TV Shows',
                iconData: Icons.tv_outlined,
                selectedIconData: Icons.tv,
                isSelected:
                    sidebarState.sidebarOptions == SidebarOptions.tvShows,
                onTap: () {
                  sidebarStateNotifier.setSidebarOption(SidebarOptions.tvShows);
                },
              ),
              DrawerItem(
                title: 'TV Guide',
                iconData: Icons.live_tv_outlined,
                selectedIconData: Icons.live_tv,
                isSelected:
                    sidebarState.sidebarOptions == SidebarOptions.tvGuide,
                onTap: () async {
                  // sidebarStateNotifier
                  //     .setSidebarOption(SidebarOptions.tvGuide);
                  // AppRouter.navigateToPage(Routes.tvGuide);
                  const platform =
                      MethodChannel('com.example.latest_movies/channel');
                  await platform.invokeMethod("navigateToGuide");
                },
              ),
              DrawerItem(
                title: 'TV Guide (L)',
                iconData: Icons.live_tv_outlined,
                selectedIconData: Icons.live_tv,
                isSelected:
                    sidebarState.sidebarOptions == SidebarOptions.tvGuideLegacy,
                onTap: () {
                  // sidebarStateNotifier
                  //     .setSidebarOption(SidebarOptions.tvGuideLegacy);
                  AppRouter.navigateToPage(Routes.tvGuide);
                },
              ),
              DrawerItem(
                title: 'Adult',
                iconData: Icons.eighteen_up_rating_outlined,
                selectedIconData: Icons.eighteen_up_rating,
                isSelected: sidebarState.sidebarOptions == SidebarOptions.adult,
                onTap: () async {
                  if (sidebarState.sidebarOptions == SidebarOptions.adult) {
                    return;
                  }
                  final bool isPasscodeSet = ref
                          .read(sharedPreferencesServiceProvider)
                          .sharedPreferences
                          .getBool(SharedPreferencesService.isPasscodeSet) ??
                      false;

                  if (isPasscodeSet) {
                    bool? shouldNavigate = await showDialog(
                      context: context,
                      builder: (context) => const EnterPasscodeDialog(),
                    );
                    shouldNavigate ??= false;
                    if (shouldNavigate) {
                      sidebarStateNotifier
                          .setSidebarOption(SidebarOptions.adult);
                    } else {
                      // AppUtils.showSnackBar(
                      //   AppRouter.navigatorKey.currentContext,
                      //   message: 'Incorrect passcode',
                      //   color: Colors.white,
                      //   icon: const Icon(Icons.error_outline,
                      //       color: Colors.black),
                      // );
                    }
                  } else {
                    bool? shouldNavigate = await showDialog(
                      context: context,
                      builder: (context) => const SetPasscodeDialog(),
                    );
                    shouldNavigate ??= false;
                    if (shouldNavigate) {
                      sidebarStateNotifier
                          .setSidebarOption(SidebarOptions.adult);
                    }
                  }
                },
              ),
              DrawerItem(
                title: 'Search',
                iconData: Icons.search_outlined,
                selectedIconData: Icons.search,
                isSelected:
                    sidebarState.sidebarOptions == SidebarOptions.search,
                onTap: () {
                  sidebarStateNotifier.setSidebarOption(SidebarOptions.search);
                },
              ),
              DrawerItem(
                title: 'Sports',
                iconData: Icons.sports_basketball_outlined,
                selectedIconData: Icons.sports_basketball,
                isSelected:
                    sidebarState.sidebarOptions == SidebarOptions.sports,
                onTap: () {
                  sidebarStateNotifier.setSidebarOption(SidebarOptions.sports);
                },
              ),
              DrawerItem(
                title: 'Favorites',
                iconData: Icons.favorite_border,
                selectedIconData: Icons.favorite,
                isSelected:
                    sidebarState.sidebarOptions == SidebarOptions.favorites,
                onTap: () {},
              ),
              DrawerItem(
                title: 'Watchlist',
                iconData: Icons.list_outlined,
                selectedIconData: Icons.list,
                isSelected:
                    sidebarState.sidebarOptions == SidebarOptions.watchlist,
                onTap: () {},
              ),
              DrawerItem(
                title: 'Reset',
                iconData: Icons.refresh,
                selectedIconData: Icons.refresh,
                isSelected: false,
                onTap: () async {
                  Future.wait([
                    ref
                        .read(sharedPreferencesServiceProvider)
                        .sharedPreferences
                        .remove(SharedPreferencesService.isPasscodeSet),
                    ref
                        .read(sharedPreferencesServiceProvider)
                        .sharedPreferences
                        .remove(SharedPreferencesService.adultContentPasscode),
                  ]);
                },
              ),
              verticalSpaceRegular,
              FutureBuilder(
                future: platformInfo,
                builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
                  if (snapshot.hasData) {
                    return DrawerItem(
                      title:
                          'App Version: v${snapshot.data?.version} #${snapshot.data?.buildNumber}',
                      iconData: Icons.info,
                      selectedIconData: Icons.info,
                      isSelected: false,
                      onTap: null,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              //logout button
              // Consumer(
              //   builder: (context, ref, child) => ListTile(
              //     leading: const Icon(Icons.exit_to_app),
              //     title: const Text('Logout'),
              //     selected: false,
              //     onTap: () {
              //       // ref.read(authVMProvider).logout();
              //     },
              //     selectedTileColor: Colors.grey[800],
              //     textColor: Colors.white,
              //     selectedColor: Colors.white,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem(
      {Key? key,
      required this.isSelected,
      required this.onTap,
      required this.title,
      required this.iconData,
      required this.selectedIconData})
      : super(key: key);

  final bool isSelected;
  final VoidCallback? onTap;
  final String title;
  final IconData iconData;
  final IconData selectedIconData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(isSelected ? selectedIconData : iconData, size: 20),
      title: Text(title),
      horizontalTitleGap: 5,
      style: ListTileStyle.drawer,
      selectedTileColor: kPrimaryColor.withOpacity(.6),
      selected: isSelected,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      onTap: onTap,
      textColor: Colors.white,
    );
  }
}
