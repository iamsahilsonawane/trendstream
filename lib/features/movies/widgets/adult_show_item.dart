import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/features/movies/controllers/current_adult_show_controller.dart';

import '../../../../core/utilities/design_utility.dart';
import "package:flutter/material.dart";

import '../../../core/router/router.dart';
import '../../../core/shared_widgets/app_loader.dart';
import '../../../core/shared_widgets/error_view.dart';
import '../../../core/shared_widgets/image.dart';

class AdultShowItem extends HookConsumerWidget {
  const AdultShowItem({
    this.autofocus = false,
    Key? key,
  }) : super(key: key);

  final bool autofocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<int> movieAsync = ref.watch(currentAdultShowProvider);

    return movieAsync.map(
      data: (asyncData) {
        final movie = asyncData.value;
        return InkWell(
          autofocus: autofocus,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            AppRouter.navigateToPage(Routes.playerView);
          },
          child: Builder(builder: (context) {
            final bool hasFocus = Focus.of(context).hasPrimaryFocus;
            return Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.4),
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: const Offset(0, 1)),
                        ],
                        border: hasFocus
                            ? Border.all(
                                width: 4,
                                color: kPrimaryAccentColor,
                              )
                            : null,
                      ),
                      child: const AppImage(
                        imageUrl:
                            "https://www.themoviedb.org/t/p/w710_and_h400_multi_faces/oo4Qn2q2MRpWVXeZnlIGYk38HPh.jpg",
                      ),
                    ),
                  ),
                  verticalSpaceRegular,
                  Text(
                    "The Falcon and the Winter Soldier",
                    style: TextStyle(
                        fontSize: 14,
                        color: hasFocus ? Colors.white : Colors.grey[700],
                        fontWeight:
                            hasFocus ? FontWeight.w700 : FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.visibility,
                          size: 18, color: Colors.grey),
                      horizontalSpaceSmall,
                      Text(
                        "22k views",
                        style: TextStyle(
                            fontSize: 14,
                            color: hasFocus ? Colors.white : Colors.grey[700],
                            fontWeight:
                                hasFocus ? FontWeight.w700 : FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        );
      },
      error: (e) => const ErrorView(),
      loading: (_) => const AppLoader(),
    );
  }
}
