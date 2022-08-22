import "package:flutter/material.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashboardSideBar extends StatelessWidget {
  const DashboardSideBar({super.key});

  @override
  Widget build(BuildContext context) {
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
                leading: const Icon(Icons.list),
                title: const Text(
                  'Home',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                selected: true,
                onTap: () {},
                selectedTileColor: Colors.grey[800],
                textColor: Colors.white,
                // selectedColor: Colors.white,
              ),
              ListTile(
                leading: const Icon(Icons.list),
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
