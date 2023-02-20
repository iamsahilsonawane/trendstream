import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/shared_widgets/clock.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/features/sports/widgtes/sports_program_channel_tile.dart';
import 'package:latest_movies/features/sports/widgtes/sports_program_list_tile.dart';

import '../../../core/router/router.dart';

class SportsPage extends StatelessWidget {
  const SportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildHeader(context),
        verticalSpaceMedium,
        SizedBox(
          height: 30,
          child: Row(
            children: [
              const Clock(),
              horizontalSpaceMedium,
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return SportsProgramChannelTile(
                      title: "NBA Regular Season",
                      onTap: () {},
                    );
                  },
                  separatorBuilder: (context, _) => horizontalSpaceSmall,
                  itemCount: 20,
                ),
              ),
            ],
          ),
        ),
        verticalSpaceRegular,
        Expanded(
          child: ListView.separated(
            itemCount: 15,
            itemBuilder: (context, index) {
              return SportsProgramListTile(
                title:
                    "07:00 p.m. - lunes ${index + 1} - NBA Regular Season - Orlando Magic vs Chicago Bulls",
                icon: Icons.sports_football,
                onTap: () {
                  AppRouter.navigateToPage(Routes.playerView);
                },
              );
            },
            separatorBuilder: (contetxt, _) => const Divider(height: 0),
          ),
        ),
      ],
    );
  }

  Row buildHeader(BuildContext context) {
    return Row(
      children: [
        Image.network(
          "https://static.vecteezy.com/system/resources/previews/010/994/361/original/nba-logo-symbol-red-and-blue-design-america-basketball-american-countries-basketball-teams-illustration-with-black-background-free-vector.jpg",
          height: 100,
        ),
        horizontalSpaceRegular,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Orlando Regular Season",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold, color: kPrimaryAccentColor),
            ),
            verticalSpaceSmall,
            Text(
              "Orlando Magic vs Chicago Bulls",
              style: textTheme(context)
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            verticalSpaceTiny,
            const Text("13 May, 2022 at 8:00 PM"),
          ],
        ),
        const Spacer(),
        const SizedBox(
          height: 100,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: SizedBox.expand(
              child: ColoredBox(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
