import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../router/_app_router.dart';
import '../../../../../router/_routes.dart';
import '../../../../ui/shared/focus_widget.dart';
import '../../../../ui/shared/image.dart';
import '../../../../ui/shared/text_field.dart';
import '../../../../utilities/design_utility.dart';
import '../../../../utilities/responsive.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width / 10;
    double cardHeight = MediaQuery.of(context).size.width / 5;

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
          children: [
            const FlutterLogo(),
            horizontalSpaceMedium,
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: const AppTextField(
                prefixIcon: Icon(Icons.search),
              ),
            )
          ],
        ),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: FocusTraversalGroup(child: const DashboardSideBar())),
          horizontalSpaceMedium,
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GridView.builder(
                key: GlobalKey(debugLabel: "dashboardGrid"),
                controller: ScrollController(),
                itemCount: 30,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveWidget.isMediumScreen(context)
                      ? 4
                      : ResponsiveWidget.isSmallScreen(context)
                          ? 2
                          : 6,
                  childAspectRatio: cardWidth / cardHeight,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return MovieTile(index, autofocus: index == 0);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MovieTile extends StatelessWidget {
  const MovieTile(
    this.index, {
    this.autofocus = false,
    Key? key,
  }) : super(key: key);

  final int index;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      autofocus: autofocus,
      event: (event) {
        if (event.logicalKey == LogicalKeyboardKey.select) {
          AppRouter.navigateToPage(Routes.detailsView);
        }
        // if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        //   Scrollable.ensureVisible(
        //     context,
        //     duration: const Duration(milliseconds: 250),
        //     curve: Curves.easeIn,
        //   );
        // }
      },
      child: Builder(builder: (context) {
        return GestureDetector(
          onTap: () {
            Focus.of(context).requestFocus();
            AppRouter.navigateToPage(Routes.detailsView);
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Focus.of(context).hasPrimaryFocus
                  ? Colors.white
                  : Colors.transparent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.4),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: const Offset(0, 1)),
                  ]),
                  child: AppImage(
                    imageUrl: "https://picsum.photos/id/${index + 20}/200/300",
                  ),
                ),
                verticalSpaceMedium,
                Text(
                  "Peaky Blinders",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Focus.of(context).hasPrimaryFocus
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "2022",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 5),
                Text(
                  "Lorem ipsum",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

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
