import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/router/router.dart';
import 'package:latest_movies/features/movies/controllers/current_popular_movies_provider.dart';

import '../../../../core/utilities/design_utility.dart';
import "package:flutter/material.dart";

import '../../../core/config/config.dart';
import '../../../core/shared_widgets/app_loader.dart';
import '../../../core/shared_widgets/error_view.dart';
import '../../../core/shared_widgets/image.dart';
import '../models/movie/movie.dart';

class MovieTile extends HookConsumerWidget {
  const MovieTile({
    this.autofocus = false,
    Key? key,
  }) : super(key: key);

  final bool autofocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Movie> movieAsync = ref.watch(currentPopularMovieProvider);

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
            AppRouter.navigateToPage(Routes.detailsView, arguments: movie.id);
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
                  Container(
                    height: 250,
                    width: double.infinity,
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
                    child: AppImage(
                      imageUrl: "${Configs.baseImagePath}${movie.posterPath}",
                    ),
                  ),
                  verticalSpaceRegular,
                  Text(
                    validString(movie.releaseDate != null &&
                            movie.releaseDate!.isNotEmpty
                        ? DateFormat("dd MMM yyyy").format(
                            DateFormat("yyyy-MM-dd").parse(movie.releaseDate!))
                        : null),
                    style: TextStyle(
                        fontSize: 14,
                        color: hasFocus ? Colors.white : Colors.grey[700],
                        fontWeight:
                            hasFocus ? FontWeight.w700 : FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "⭐️ ${validString(movie.voteAverage.toString())}",
                    style: TextStyle(
                        fontSize: 14,
                        color: hasFocus ? Colors.white : Colors.grey[700],
                        fontWeight:
                            hasFocus ? FontWeight.w700 : FontWeight.w600),
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
