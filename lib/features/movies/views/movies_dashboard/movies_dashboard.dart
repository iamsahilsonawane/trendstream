import 'package:flutter/material.dart';
import 'package:latest_movies/features/movies/widgets/movies_grid.dart';

import '../../../../core/shared_widgets/text_field.dart';
import '../../../../core/utilities/design_utility.dart';
import '../../widgets/dashboard_sidebar.dart';

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
          const Expanded(
            flex: 8,
            child:
                Padding(padding: EdgeInsets.only(top: 10), child: MoviesGrid()),
          ),
        ],
      ),
    );
  }
}
