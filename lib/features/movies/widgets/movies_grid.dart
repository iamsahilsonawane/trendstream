import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/shared_widgets/error_view.dart';
import 'package:latest_movies/features/movies/controllers/popular_movies_count_provider.dart';

import '../../../core/shared_widgets/app_loader.dart';
import '../../../core/utilities/responsive.dart';
import '../controllers/current_popular_movies_provider.dart';
import '../controllers/popular_paginated_movies_provider.dart';
import '../models/movie/movie.dart';
import 'movie_item.dart';

class MoviesGrid extends HookConsumerWidget {
  const MoviesGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularMoviesCount = ref.watch(popularMoviesCountProvider);

    return popularMoviesCount.map(
      data: (asyncData) {
        return AlignedGridView.count(
          key: const PageStorageKey<String>(
              'preserve_movies_grid_scroll_and_focus'),
          itemCount: asyncData.value,
          crossAxisCount: ResponsiveWidget.isMediumScreen(context)
              ? 4
              : ResponsiveWidget.isSmallScreen(context)
                  ? 2
                  : 6,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          cacheExtent: 100,
          itemBuilder: (BuildContext context, int index) {
            final AsyncValue<Movie> currentPopularMovieFromIndex = ref
                .watch(paginatedPopularMoviesProvider(index ~/ 20))
                .whenData((pageData) => pageData.results[index % 20]);

            return ProviderScope(
              overrides: [
                currentPopularMovieProvider
                    .overrideWithValue(currentPopularMovieFromIndex)
              ],
              child: MovieTile(autofocus: index == 0),
            );
          },
        );
      },
      error: (e) => ErrorView(error: e.error.toString()),
      loading: (_) => const AppLoader(),
    );
  }
}
