import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/router/router.dart';
import 'package:latest_movies/core/shared_widgets/app_loader.dart';
import 'package:latest_movies/core/shared_widgets/error_view.dart';
import 'package:latest_movies/core/shared_widgets/image.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/features/movies/controllers/movie_videos_provider.dart';
import '../../../../core/config/config.dart';
import '../../../../core/shared_widgets/button.dart';
import '../../../../core/utilities/debouncer.dart';
import '../../controllers/movie_details_provider.dart';

class MovieDetailsView extends HookConsumerWidget {
  const MovieDetailsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieId =
        useMemoized(() => ModalRoute.of(context)!.settings.arguments as int);
    final movieDetailsAsync = ref.watch(movieDetailsProvider(movieId));
    final movieVideosAsync = ref.watch(movieVideosProvider(movieId));
    final posterContainerHeight = MediaQuery.of(context).size.height * 0.7;

    // States
    final uniqueMainCrew = useState(<String, String>{});

    // Function to run some code after movie is fetched. This will only be called once the movie is changed and not on every build method
    useEffect(() {
      movieDetailsAsync.whenData((movie) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final mainCrew = movie.credits?.crew
                  ?.where((c) =>
                      c.job == "Director" ||
                      c.job == "Producer" ||
                      c.job == "Creator" ||
                      c.job == "Writer")
                  .toList() ??
              [];

          // Create a map to store unique names and their corresponding jobs
          final uniqueNames = <String, String>{};

          // Iterate over the crew members and merge their jobs for duplicate names
          for (final crewMember in mainCrew) {
            final name = crewMember.name!;
            final job = crewMember.job ?? "N/A";

            if (uniqueNames.containsKey(name)) {
              // Merge the job with the existing entry
              uniqueNames[name] = '${uniqueNames[name]}, $job';
            } else {
              // Add the new entry
              uniqueNames[name] = job;
            }
          }

          uniqueMainCrew.value = uniqueNames;
        });
      });
      return null;
    }, [movieDetailsAsync]);

    return Scaffold(
      body: movieDetailsAsync.when(
        data: (movie) => Container(
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
              color: Colors.black.withOpacity(.8),
              child: SingleChildScrollView(
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
                            width: 250,
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
                                  imageUrl:
                                      "${Configs.largeBaseImagePath}${movie.posterPath}",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  validString(movie.originalTitle),
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  "${(movie.adult ?? false) ? "18+ | " : ""}${movie.genres?.map((e) => e.name).join(" / ")} | ${movie.spokenLanguages?.map((e) => e.name).join(", ")} | ${movie.releaseDate?.split("-").first}",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  validString(movie.overview),
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Wrap(
                                  spacing: 20,
                                  runSpacing: 10,
                                  children: [
                                    ...uniqueMainCrew.value.entries.map(
                                        (entry) => CreatorItem(
                                            name: entry.key, job: entry.value)),
                                  ],
                                ),
                                const Expanded(child: SizedBox()),
                                Row(
                                  children: [
                                    AppButton(
                                      autofocus: true,
                                      text: "Watch Now",
                                      onTap: () {
                                        AppRouter.navigateToPage(
                                            Routes.playerView);
                                      },
                                      prefix: const Icon(
                                        Icons.play_circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                    horizontalSpaceRegular,
                                    movieVideosAsync.when(
                                      data: (videos) {
                                        final hasTrailer = videos.any(
                                            (element) =>
                                                element.type == "Trailer" &&
                                                (element.official ?? false) &&
                                                element.site == "YouTube");

                                        return AppButton(
                                          text: "Watch Trailer",
                                          onTap: !hasTrailer
                                              ? null
                                              : () async {
                                                  final firstTrailer =
                                                      videos.firstWhere(
                                                    (element) =>
                                                        element.type ==
                                                            "Trailer" &&
                                                        (element.official ??
                                                            false) &&
                                                        element.site ==
                                                            "YouTube",
                                                  );

                                                  // if (!await launchUrl(Uri.parse(
                                                  //     "https://youtube.com/watch?v=${firstTrailer.key}"))) {
                                                  //   AppUtils.showSnackBar(context,
                                                  //       message:
                                                  //           "This TV does not support opening URLs");
                                                  // }

                                                  AppRouter.navigateToPage(
                                                      Routes.youtubePlayerView,
                                                      arguments:
                                                          firstTrailer.key);
                                                },
                                        );
                                      },
                                      loading: () => const AppButton(
                                          text: "Watch Trailer",
                                          isLoading: true,
                                          onTap: null),
                                      error: (e, s) => const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
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
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 230,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: min(
                                            movie.credits?.cast?.length ?? 10,
                                            10) +
                                        1,
                                    clipBehavior: Clip.none,
                                    itemBuilder: (context, index) {
                                      //if item is last
                                      if (index ==
                                          min(movie.credits?.cast?.length ?? 10,
                                              10)) {
                                        return Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: TextButton.icon(
                                              onPressed: () {
                                                AppRouter.navigateToPage(
                                                    Routes.allMovieCastAndCrew,
                                                    arguments: movie);
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                              ),
                                              icon: const Icon(
                                                  Icons.arrow_forward),
                                              label: const Text("View all")),
                                        );
                                      }
                                      final cast = movie.credits?.cast?[index];
                                      return CastTile(
                                          name: cast?.name,
                                          character: cast?.character,
                                          profilePath: cast?.profilePath);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          verticalSpaceMedium,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        loading: () => const AppLoader(),
        error: (error, stack) => const ErrorView(),
      ),
    );
  }

  Padding _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: hasFocus
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(.5),
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: const Offset(0, 0),
                    ),
                  ]
                : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 150,
                color: profilePath == null ? Colors.grey[300] : null,
                child: AppImage(
                  imageUrl: "${Configs.mediumBaseImagePath}$profilePath",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      name ?? "N/A",
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      character ?? "N/A",
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
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
