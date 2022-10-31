import "package:flutter/material.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/features/movies/controllers/side_bar_controller.dart';

import '../enums/sidebar_options.dart';

class DashboardSideBar extends HookConsumerWidget {
  const DashboardSideBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sidebarState = ref.watch(sidebarStateProvider);
    final sidebarStateNotifier = ref.watch(sidebarStateProvider.notifier);

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
                onTap: () {
                  sidebarStateNotifier.setSidebarOption(SidebarOptions.tvGuide);
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
