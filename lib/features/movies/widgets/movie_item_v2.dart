import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/router/router.dart';
import 'package:latest_movies/features/movies/controllers/current_movie_v2_provider.dart';
import 'package:latest_movies/features/movies/models/movie_v2/urls_image.dart';

import '../../../../core/utilities/design_utility.dart';
import "package:flutter/material.dart";

import '../../../core/shared_widgets/app_loader.dart';
import '../../../core/shared_widgets/error_view.dart';
import '../../../core/shared_widgets/image.dart';
import '../models/movie_v2/movie_v2.dart';

class MovieTileV2 extends HookConsumerWidget {
  const MovieTileV2({
    this.autofocus = false,
    Key? key,
  }) : super(key: key);

  final bool autofocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<MovieV2> movieAsync = ref.watch(currentMovieV2Provider);

    return movieAsync.map(
      data: (asyncData) {
        final movie = asyncData.value;
        return RawMovieTileV2(
          autofocus: autofocus,
          movie: movie,
        );
      },
      error: (e) => const ErrorView(),
      loading: (_) => const AppLoader(),
    );
  }
}

class RawMovieTileV2 extends StatelessWidget {
  const RawMovieTileV2({
    super.key,
    required this.autofocus,
    required this.movie,
  });

  final bool autofocus;
  final MovieV2 movie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      autofocus: autofocus,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        AppRouter.navigateToPage(Routes.detailsViewV2, arguments: movie.id);
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
                aspectRatio: 2 / 3,
                child: Container(
                  // height: 250,
                  // width: double.infinity,
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
                    imageUrl: movie.poster?.urlsImage
                            ?.firstWhere((img) => img.size?.value == "original",
                                orElse: () => const UrlsImage(url: ""))
                            .url ??
                        "",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              verticalSpaceRegular,
              Text(
                validString(movie.originalTitle?.toString()),
                style: TextStyle(
                    fontSize: 14,
                    color: hasFocus ? Colors.white : Colors.grey[700],
                    fontWeight: hasFocus ? FontWeight.w700 : FontWeight.w600),
              ),
              const SizedBox(height: 5),
              Text(
                validString(
                    movie.releaseDate != null && movie.releaseDate!.isNotEmpty
                        ? DateFormat("dd MMM yyyy").format(
                            DateFormat("yyyy-MM-dd").parse(movie.releaseDate!))
                        : null),
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: hasFocus ? FontWeight.w700 : FontWeight.w600),
              ),
              const SizedBox(height: 5),
              Text(
                "⭐️ ${validString(movie.voteAverage.toString())}",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: hasFocus ? FontWeight.w700 : FontWeight.w600),
              ),
            ],
          ),
        );
      }),
    );
  }
}
