import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:latest_movies/features/movies/models/movie/credits/credits.dart';

import '../../../../core/config/config.dart';
import '../../../../core/router/router.dart';
import '../../../../core/utilities/debouncer.dart';
import '../../../../core/utilities/design_utility.dart';
import 'movie_details.dart';

class AllClassAndCrewArgs {
  final Credits credits;
  final String backdropPath;

  const AllClassAndCrewArgs(
      {required this.credits, required this.backdropPath});
}

class AllCastAndCrewView extends HookWidget {
  const AllCastAndCrewView({super.key});

  Widget _buildBackButton() {
    return TextButton.icon(
        onPressed: () {
          Debouncer(delay: const Duration(milliseconds: 500)).call(() {
            AppRouter.pop();
          });
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
        ),
        icon: const Icon(Icons.arrow_back),
        label: const Text("Back"));
  }

  @override
  Widget build(BuildContext context) {
    final args = useMemoized(() =>
        ModalRoute.of(context)!.settings.arguments as AllClassAndCrewArgs);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "${Configs.largeBaseImagePath}${args.backdropPath}",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: ColoredBox(
            color: const Color.fromRGBO(0, 0, 0, 1).withOpacity(.8),
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBackButton(),
                    verticalSpaceRegular,
                    const Text(
                      "Cast",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    verticalSpaceMedium,
                    AlignedGridView.count(
                      crossAxisCount: 6,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: args.credits.cast!.length,
                      itemBuilder: (context, index) {
                        final cast = args.credits.cast![index];
                        return CastTileV1(
                            name: cast.name,
                            character: cast.character,
                            profilePath: cast.profilePath);
                      },
                    ),
                    verticalSpaceMedium,
                    const Text(
                      "Crew",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    verticalSpaceMedium,
                    AlignedGridView.count(
                      crossAxisCount: 6,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: args.credits.crew!.length,
                      itemBuilder: (context, index) {
                        final crew = args.credits.crew![index];
                        return CastTileV1(
                          name: crew.name,
                          character: crew.job,
                          profilePath: crew.profilePath,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
