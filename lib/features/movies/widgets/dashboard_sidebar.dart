import "package:flutter/material.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
        decoration: BoxDecoration(color: Colors.grey[900]),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView(
            key: GlobalKey(debugLabel: "dashboardSideBar"),
            shrinkWrap: true,
            controller: ScrollController(),
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text(
                  'Home',
                ),
                selected: sidebarState.sidebarOptions == SidebarOptions.home,
                onTap: () {
                  sidebarStateNotifier.setSidebarOption(SidebarOptions.home);
                },
                selectedTileColor: Colors.grey[800],
                textColor: Colors.white,
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text(
                  'Search',
                ),
                selected: sidebarState.sidebarOptions == SidebarOptions.search,
                onTap: () {
                  sidebarStateNotifier.setSidebarOption(SidebarOptions.search);
                },
                selectedTileColor: Colors.grey[800],
                textColor: Colors.white,
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Favorites'),
                selected: false,
                onTap: () {},
                selectedTileColor: Colors.grey[800],
                textColor: Colors.white,
                selectedColor: Colors.white,
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Watchlist'),
                selected: false,
                onTap: () {},
                selectedTileColor: Colors.grey[800],
                textColor: Colors.white,
                selectedColor: Colors.white,
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Series'),
                selected: false,
                onTap: () {},
                selectedTileColor: Colors.grey[800],
                textColor: Colors.white,
                selectedColor: Colors.white,
              ),
              Consumer(
                builder: (context, ref, child) => ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Logout'),
                  selected: false,
                  onTap: () {
                    // ref.read(authVMProvider).logout();
                  },
                  selectedTileColor: Colors.grey[800],
                  textColor: Colors.white,
                  selectedColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
