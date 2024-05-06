import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/config/config.dart';
import '../../../../core/router/router.dart';
import '../../../../core/utilities/debouncer.dart';
import '../../../../core/utilities/design_utility.dart';
import '../../models/tv_show_v3/cast.dart';
import 'movie_details.dart';

class AllClassAndCrewV3Args {
  final List<Cast> casts;
  final String backdropPath;
  final bool includeProfilePathPrefix;

  const AllClassAndCrewV3Args(
      {required this.casts, required this.backdropPath, required this.includeProfilePathPrefix});
}

class AllCastAndCrewV3View extends HookWidget {
  const AllCastAndCrewV3View({super.key});

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
        ModalRoute.of(context)!.settings.arguments as AllClassAndCrewV3Args);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              args.backdropPath,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: ColoredBox(
              color: const Color.fromRGBO(0, 0, 0, 1).withOpacity(.8),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 40),
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
                        itemCount: args.casts.length,
                        itemBuilder: (context, index) {
                          final cast = args.casts[index];

                          final profileImage = cast.urlsImage?.firstWhere(
                              (element) => element.size?.value == "original",
                              orElse: () => cast.urlsImage!.first);

                          return CastTileV3(
                            name: cast.name,
                            character: cast.characterName,
                            profilePath: profileImage?.url,
                            blurHash: profileImage?.blurHash,
                            includeProfilePathPrefix: args.includeProfilePathPrefix,
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
      ),
    );
  }
}
