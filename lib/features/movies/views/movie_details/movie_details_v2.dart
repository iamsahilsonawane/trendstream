import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/router/router.dart';
import 'package:latest_movies/core/shared_widgets/app_loader.dart';
import 'package:latest_movies/core/shared_widgets/error_view.dart';
import 'package:latest_movies/core/shared_widgets/image.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import '../../../../core/config/config.dart';
import '../../../../core/shared_widgets/button.dart';
import '../../../../core/utilities/debouncer.dart';
import '../../controllers/movie_details_provider.dart';
import '../../models/movie_v2/urls_image.dart';

class MovieDetailsViewV2 extends HookConsumerWidget {
  const MovieDetailsViewV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieId =
        useMemoized(() => ModalRoute.of(context)!.settings.arguments as int);
    final movieDetailsAsync = ref.watch(movieDetailsV2Provider(movieId));

    // final movieVideosAsync = ref.watch(movieVideosProvider(movieId));
    final posterContainerHeight = MediaQuery.of(context).size.height * 0.85;

    return Scaffold(
      body: movieDetailsAsync.when(
        data: (movie) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  movie.poster?.urlsImage
                          ?.firstWhere((img) => img.size?.value == "original",
                              orElse: () => const UrlsImage(url: ""))
                          .url ??
                      "",
                ),
                fit: BoxFit.cover,
              ),
            ),
            height: double.infinity,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: ColoredBox(
                color: Colors.black.withOpacity(.8),
                child: SingleChildScrollView(
                  child: FocusTraversalGroup(
                    policy: WidgetOrderTraversalPolicy(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBackButton(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          height: posterContainerHeight,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: posterContainerHeight,
                                // width: 250,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(.7),
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: AppImage(
                                      imageUrl: movie.poster?.urlsImage
                                              ?.firstWhere(
                                                  (img) =>
                                                      img.size?.value ==
                                                      "original",
                                                  orElse: () =>
                                                      const UrlsImage(url: ""))
                                              .url ??
                                          "",
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        validString(movie.originalTitle),
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    if (movie.tagline?.isNotEmpty ?? false)
                                      Text(
                                        validString(movie.tagline),
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    const SizedBox(height: 20),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              (movie.voteAverage ?? 0.0)
                                                  .toStringAsFixed(2),
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "(${movie.voteCount})",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "${(movie.adult ?? false) ? "18+ | " : ""}${movie.genres?.map((e) => e.name).join(" / ")} | ${movie.year}",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Row(
                                      children: [
                                        Icon(Icons.info_outline,
                                            color: Colors.grey, size: 14),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            "Click on the overview text to read more",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    verticalSpaceTiny,
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    kBackgroundColor,
                                                title: const Text(
                                                  "Overview",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                content: SingleChildScrollView(
                                                  child: Text(
                                                    validString(movie.overview),
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  AppButton(
                                                    text: "Close",
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Builder(
                                          builder: (context) {
                                            final hasPrimaryFocus =
                                                Focus.of(context)
                                                    .hasPrimaryFocus;
                                            return Container(
                                              decoration: hasPrimaryFocus
                                                  ? BoxDecoration(
                                                      color: kPrimaryAccentColor
                                                          .withOpacity(.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    )
                                                  : null,
                                              child: Text(
                                                validString(movie.overview),
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                  overflow: TextOverflow.fade,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        AppButton(
                                          autofocus: true,
                                          text: "Watch Now",
                                          onTap: () {
                                            AppRouter.navigateToPage(
                                                Routes.playerView,
                                                arguments:
                                                    "https://mazwai.com/videvo_files/video/free/2016-01/small_watermarked/rio_from_above_preview.webm");
                                          },
                                          prefix: const Icon(
                                            Icons.play_circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                        // horizontalSpaceRegular,
                                        // movieVideosAsync.when(
                                        //   data: (videos) {
                                        //     final hasTrailer = videos.any(
                                        //         (element) =>
                                        //             element.type == "Trailer" &&
                                        //             (element.official ??
                                        //                 false) &&
                                        //             element.site == "YouTube");

                                        //     return AppButton(
                                        //       text: "Watch Trailer",
                                        //       onTap: !hasTrailer
                                        //           ? null
                                        //           : () async {
                                        //               final firstTrailer =
                                        //                   videos.firstWhere(
                                        //                 (element) =>
                                        //                     element.type ==
                                        //                         "Trailer" &&
                                        //                     (element.official ??
                                        //                         false) &&
                                        //                     element.site ==
                                        //                         "YouTube",
                                        //               );

                                        //               // if (!await launchUrl(Uri.parse(
                                        //               //     "https://youtube.com/watch?v=${firstTrailer.key}"))) {
                                        //               //   AppUtils.showSnackBar(context,
                                        //               //       message:
                                        //               //           "This TV does not support opening URLs");
                                        //               // }

                                        //               AppRouter.navigateToPage(
                                        //                   Routes
                                        //                       .youtubePlayerView,
                                        //                   arguments:
                                        //                       firstTrailer.key);
                                        //             },
                                        //     );
                                        //   },
                                        //   loading: () => const AppButton(
                                        //       text: "Watch Trailer",
                                        //       isLoading: true,
                                        //       onTap: null),
                                        //   error: (e, s) =>
                                        //       const SizedBox.shrink(),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const AppLoader(),
        error: (error, stack) => const ErrorView(),
      ),
    );
  }

  Padding _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton.icon(
          onPressed: () {
            Debouncer(delay: const Duration(milliseconds: 500)).call(() {
              AppRouter.pop();
            });
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.arrow_back),
          label: const Text("Back")),
    );
  }
}

class StatsItem extends StatelessWidget {
  const StatsItem({
    super.key,
    required this.stat,
    required this.value,
  });

  final String stat;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          stat,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        verticalSpaceSmall,
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}

class CreatorItem extends StatelessWidget {
  const CreatorItem({
    super.key,
    required this.name,
    required this.job,
  });

  final String name;
  final String job;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          job,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class CastTile extends StatelessWidget {
  const CastTile({
    super.key,
    required this.name,
    required this.character,
    required this.profilePath,
  });

  final String? name;
  final String? character;
  final String? profilePath;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Builder(builder: (context) {
        final hasFocus = Focus.of(context).hasPrimaryFocus;

        return Container(
          width: 120,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            // boxShadow: hasFocus
            //     ? [
            //         BoxShadow(
            //           color: Colors.white.withOpacity(.5),
            //           blurRadius: 10,
            //           spreadRadius: 5,
            //           offset: const Offset(0, 0),
            //         ),
            //       ]
            //     : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: profilePath == null ? Colors.grey[300] : null,
                  boxShadow: hasFocus
                      ? [
                          BoxShadow(
                            color: kPrimaryAccentColor.withOpacity(.5),
                            blurRadius: 10,
                            spreadRadius: 5,
                            offset: const Offset(0, 0),
                          ),
                        ]
                      : null,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.antiAlias,
                child: AppImage(
                  imageUrl: "${Configs.mediumBaseImagePath}$profilePath",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      name ?? "N/A",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: hasFocus ? Colors.white : Colors.grey[800],
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      character ?? "N/A",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: hasFocus ? Colors.white : Colors.grey[800],
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
