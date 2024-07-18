import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/extensions/context_extension.dart';
import 'package:latest_movies/core/shared_widgets/error_view.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/features/movies/controllers/movie_search_controller.dart';
import 'package:latest_movies/features/movies/controllers/search_movie_count_provider.dart';
import 'package:latest_movies/features/movies/controllers/search_paginated_movies_provider.dart';

import '../../../core/shared_widgets/app_loader.dart';
import '../../../core/utilities/responsive.dart';
import '../controllers/current_popular_movies_provider.dart';
import '../models/movie/movie.dart';
import 'movie_item.dart';

class MovieSearchGrid extends HookConsumerWidget {
  const MovieSearchGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchedMoviesCount = ref.watch(searchMovieCountProvider);
    final pageBucket = useMemoized(() => PageStorageBucket());

    return PageStorage(
      bucket: pageBucket,
      child: searchedMoviesCount.map(
        data: (asyncData) {
          return AlignedGridView.count(
            key: const PageStorageKey<String>(
                'preserve_search_grid_scroll_and_focus'),
            controller: ScrollController(),
            itemCount: asyncData.value,
            crossAxisCount: ResponsiveWidget.isMediumScreen(context)
                ? 3
                : ResponsiveWidget.isSmallScreen(context)
                    ? 2
                    : 6,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            itemBuilder: (BuildContext context, int index) {
              final AsyncValue<Movie> currentPopularPersonFromIndex = ref
                  .watch(paginatedSearchMoviesProvider(
                      PaginatedSearchProviderArgs(
                          page: index ~/ 20,
                          query: ref.watch(searchKeywordProvider))))
                  .whenData((pageData) => pageData.results[index % 20]);

              return ProviderScope(
                overrides: [
                  currentPopularMovieProvider
                      .overrideWithValue(currentPopularPersonFromIndex)
                ],
                child: const MovieTile(),
              );
            },
          );
        },
        error: (e) {
          if (e.error is DioError) {
            try {
              if ((e.error as DioError)
                  .response
                  ?.data['errors']
                  .contains('query must be provided')) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.search,
                      size: 100,
                      color: kPrimaryColor,
                    ),
                    verticalSpaceRegular,
                    Text(
                        "${context.localisations.trySearchingFor}\"Top Gun Maverick...\""),
                  ],
                );
              }
            } catch (e) {}
          }
          return const ErrorView();
        },
        loading: (_) => const AppLoader(),
      ),
    );
  }
}
