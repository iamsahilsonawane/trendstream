import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/config/config.dart';
import '../../../../core/utilities/design_utility.dart';
import '../../models/movie/movie.dart';
import 'movie_details.dart';

class AllCastAndCrewView extends HookWidget {
  const AllCastAndCrewView({super.key});

  @override
  Widget build(BuildContext context) {
    final movie =
        useMemoized(() => ModalRoute.of(context)!.settings.arguments as Movie);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "${Configs.largeBaseImagePath}${movie.backdropPath}",
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
                    verticalSpaceMedium,
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
                      itemCount: movie.credits!.cast!.length,
                      itemBuilder: (context, index) {
                        final cast = movie.credits!.cast![index];
                        return CastTile(
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
                      itemCount: movie.credits!.crew!.length,
                      itemBuilder: (context, index) {
                        final crew = movie.credits!.crew![index];
                        return CastTile(
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
