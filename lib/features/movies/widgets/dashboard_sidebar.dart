import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/extensions/context_extension.dart';
import 'package:latest_movies/core/services/shared_preferences_service.dart';
import 'package:latest_movies/core/shared_providers/device_details_provider.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/features/movies/controllers/side_bar_controller.dart';
import 'package:latest_movies/features/movies/widgets/enter_passcode_dialog.dart';
import 'package:latest_movies/features/movies/widgets/set_passcode_dialog.dart';
import 'package:latest_movies/l10n/app_localisations.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/router/router.dart';
import '../controllers/dashboard_sidebar_expanded_provider.dart';
import '../enums/sidebar_options.dart';

class DashboardSideBar extends HookConsumerWidget {
  const DashboardSideBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listViewKey =
        useMemoized(() => GlobalKey(debugLabel: "dashboardSideBar"));

    final sidebarState = ref.watch(sidebarStateProvider);
    final sidebarStateNotifier = ref.watch(sidebarStateProvider.notifier);

    final platformInfo = useMemoized(() => PackageInfo.fromPlatform());

    final shouldHide = ref.watch(dashboardSidebarStatusProvider) ==
        DashboardSidebarStatus.collapsed;

    final topMostItemNode = useFocusNode();
    final bottomMostItemNode = useFocusNode();

    return SizedBox(
      height: double.infinity,
      child: Ink(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 18, 19, 21),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Focus(
            canRequestFocus: false,
            skipTraversal: true,
            onFocusChange: (isChildrenFocused) {
              if (isChildrenFocused) {
                ref.read(dashboardSidebarStatusProvider.notifier).state =
                    DashboardSidebarStatus.expanded;
              } else {
                ref.read(dashboardSidebarStatusProvider.notifier).state =
                    DashboardSidebarStatus.collapsed;
              }
            },
            onKey: (node, RawKeyEvent event) {
              if (event.runtimeType == RawKeyDownEvent &&
                  (event.isKeyPressed(LogicalKeyboardKey.arrowUp) ||
                      event.isKeyPressed(LogicalKeyboardKey.arrowDown))) {
                if (event.isKeyPressed(LogicalKeyboardKey.arrowDown) &&
                    bottomMostItemNode.hasPrimaryFocus) {
                  return KeyEventResult.handled;
                }
                if (event.isKeyPressed(LogicalKeyboardKey.arrowUp) &&
                    topMostItemNode.hasPrimaryFocus) {
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              }
              return KeyEventResult.ignored;
            },
            child: ListView(
              key: listViewKey,
              shrinkWrap: true,
              children: <Widget>[
                DrawerItem(
                  title: "",
                  iconData: shouldHide
                      ? Icons.arrow_forward_ios
                      : Icons.arrow_back_ios,
                  selectedIconData: shouldHide
                      ? Icons.arrow_forward_ios
                      : Icons.arrow_back_ios,
                  isSelected: false,
                  onlyIcon: false,
                  onTap: () {
                    ref.read(dashboardSidebarStatusProvider.notifier).state =
                        shouldHide
                            ? DashboardSidebarStatus.expanded
                            : DashboardSidebarStatus.collapsed;
                  },
                ),
                DrawerItem(
                  title: context.localisations.movies,
                  // title: AppLocalizations.of(context)!.helloWorld,
                  iconData: Icons.home_outlined,
                  selectedIconData: Icons.home,
                  focusNode: topMostItemNode,
                  isSelected:
                      sidebarState.sidebarOptions == SidebarOptions.home,
                  onlyIcon: shouldHide,
                  onTap: () {
                    sidebarStateNotifier.setSidebarOption(SidebarOptions.home);
                  },
                ),
                DrawerItem(
                  title: context.localisations.tvShows,
                  iconData: Icons.tv_outlined,
                  selectedIconData: Icons.tv,
                  isSelected:
                      sidebarState.sidebarOptions == SidebarOptions.tvShows,
                  onlyIcon: shouldHide,
                  onTap: () {
                    sidebarStateNotifier
                        .setSidebarOption(SidebarOptions.tvShows);
                  },
                ),
                DrawerItem(
                  title: "${context.localisations.tvShows} V3",
                  iconData: Icons.tv_outlined,
                  selectedIconData: Icons.tv,
                  isSelected:
                      sidebarState.sidebarOptions == SidebarOptions.tvShowsV3,
                  onlyIcon: shouldHide,
                  onTap: () {
                    sidebarStateNotifier
                        .setSidebarOption(SidebarOptions.tvShowsV3);
                  },
                ),
                DrawerItem(
                  title: context.localisations.tvGuide,
                  iconData: Icons.live_tv_outlined,
                  selectedIconData: Icons.live_tv,
                  isSelected:
                      sidebarState.sidebarOptions == SidebarOptions.tvGuide,
                  onlyIcon: shouldHide,
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
                  title: "${context.localisations.tvGuide} \(L)",
                  iconData: Icons.live_tv_outlined,
                  selectedIconData: Icons.live_tv,
                  isSelected: sidebarState.sidebarOptions ==
                      SidebarOptions.tvGuideLegacy,
                  onlyIcon: shouldHide,
                  onTap: () {
                    // sidebarStateNotifier
                    //     .setSidebarOption(SidebarOptions.tvGuideLegacy);
                    AppRouter.navigateToPage(Routes.tvGuide);
                  },
                ),
                DrawerItem(
                  title: context.localisations.adult,
                  iconData: Icons.eighteen_up_rating_outlined,
                  selectedIconData: Icons.eighteen_up_rating,
                  isSelected:
                      sidebarState.sidebarOptions == SidebarOptions.adult,
                  onlyIcon: shouldHide,
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
                  title: context.localisations.search,
                  iconData: Icons.search_outlined,
                  selectedIconData: Icons.search,
                  isSelected:
                      sidebarState.sidebarOptions == SidebarOptions.search,
                  onlyIcon: shouldHide,
                  onTap: () {
                    sidebarStateNotifier
                        .setSidebarOption(SidebarOptions.search);
                  },
                ),
                DrawerItem(
                  title: context.localisations.liveChannelSearch,
                  iconData: Icons.search_outlined,
                  selectedIconData: Icons.search,
                  isSelected: sidebarState.sidebarOptions ==
                      SidebarOptions.liveChannelsSearch,
                  onlyIcon: shouldHide,
                  onTap: () {
                    sidebarStateNotifier
                        .setSidebarOption(SidebarOptions.liveChannelsSearch);
                  },
                ),
                DrawerItem(
                  title: context.localisations.sports,
                  iconData: Icons.sports_basketball_outlined,
                  selectedIconData: Icons.sports_basketball,
                  isSelected:
                      sidebarState.sidebarOptions == SidebarOptions.sports,
                  onlyIcon: shouldHide,
                  onTap: () {
                    sidebarStateNotifier
                        .setSidebarOption(SidebarOptions.sports);
                  },
                ),
                DrawerItem(
                  title: context.localisations.favorites,
                  iconData: Icons.favorite_border,
                  selectedIconData: Icons.favorite,
                  isSelected:
                      sidebarState.sidebarOptions == SidebarOptions.favorites,
                  onlyIcon: shouldHide,
                  onTap: () {},
                ),
                DrawerItem(
                  title: context.localisations.watchlist,
                  iconData: Icons.list_outlined,
                  selectedIconData: Icons.list,
                  isSelected:
                      sidebarState.sidebarOptions == SidebarOptions.watchlist,
                  onlyIcon: shouldHide,
                  onTap: () {},
                ),
                DrawerItem(
                  title: 'API V2 ${context.localisations.movies}',
                  iconData: Icons.movie_outlined,
                  selectedIconData: Icons.movie,
                  isSelected:
                      sidebarState.sidebarOptions == SidebarOptions.apiMovies,
                  onlyIcon: shouldHide,
                  onTap: () {
                    sidebarStateNotifier
                        .setSidebarOption(SidebarOptions.apiMovies);
                  },
                ),
                DrawerItem(
                  title: 'API V3 ${context.localisations.movies}',
                  iconData: Icons.movie_outlined,
                  selectedIconData: Icons.movie,
                  isSelected:
                      sidebarState.sidebarOptions == SidebarOptions.apiMoviesV3,
                  onlyIcon: shouldHide,
                  onTap: () {
                    sidebarStateNotifier
                        .setSidebarOption(SidebarOptions.apiMoviesV3);
                  },
                ),
                DrawerItem(
                  title: context.localisations.settings,
                  iconData: Icons.settings_outlined,
                  selectedIconData: Icons.settings,
                  isSelected:
                      sidebarState.sidebarOptions == SidebarOptions.settings,
                  onlyIcon: shouldHide,
                  onTap: () {
                    sidebarStateNotifier
                        .setSidebarOption(SidebarOptions.settings);
                  },
                ),
                DrawerItem(
                  title: context.localisations.reset,
                  iconData: Icons.refresh,
                  selectedIconData: Icons.refresh,
                  isSelected: false,
                  onlyIcon: shouldHide,
                  focusNode: bottomMostItemNode,
                  onTap: () async {
                    Future.wait([
                      ref
                          .read(sharedPreferencesServiceProvider)
                          .sharedPreferences
                          .remove(SharedPreferencesService.isPasscodeSet),
                      ref
                          .read(sharedPreferencesServiceProvider)
                          .sharedPreferences
                          .remove(
                              SharedPreferencesService.adultContentPasscode),
                    ]);
                  },
                ),
                verticalSpaceRegular,
                DrawerItem(
                  title: 'Build ID: ${ref.watch(androidDeviceInfoProvider).id}',
                  iconData: Icons.info,
                  selectedIconData: Icons.info,
                  isSelected: false,
                  onTap: null,
                  onlyIcon: shouldHide,
                ),
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
                        onlyIcon: shouldHide,
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
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key? key,
    required this.isSelected,
    required this.onTap,
    required this.title,
    required this.iconData,
    required this.selectedIconData,
    this.focusNode,
    this.onlyIcon = false,
  }) : super(key: key);

  final bool isSelected;
  final VoidCallback? onTap;
  final String title;
  final IconData iconData;
  final IconData selectedIconData;
  final bool onlyIcon;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      focusNode: focusNode,
      leading: Icon(isSelected ? selectedIconData : iconData, size: 20),
      title: onlyIcon ? null : Text(title),
      horizontalTitleGap: onlyIcon ? 0 : 5,
      style: ListTileStyle.drawer,
      selectedTileColor: kPrimaryColor.withOpacity(.6),
      focusColor: kPrimaryColor.withOpacity(.3),
      selected: isSelected,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      onTap: onTap,
      textColor: Colors.white,
    );
  }
}
