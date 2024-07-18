import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/shared_widgets/error_view.dart';
import 'package:latest_movies/features/movies/controllers/current_movie_v2_provider.dart';

import '../../../core/shared_widgets/app_loader.dart';
import '../../../core/utilities/responsive.dart';
import '../controllers/movies_v2_provider.dart';
import 'movie_item_v2.dart';

class MoviesV2Grid extends HookConsumerWidget {
  const MoviesV2Grid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularMoviesCount = ref.watch(moviesV2Provider);

    return popularMoviesCount.when(
      data: (movies) {
        return AlignedGridView.count(
          key: const PageStorageKey<String>(
              'preserve_movies_v2_grid_scroll_and_focus'),
          itemCount: movies.length,
          crossAxisCount: ResponsiveWidget.isMediumScreen(context)
              ? 4
              : ResponsiveWidget.isSmallScreen(context)
                  ? 2
                  : 6,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          cacheExtent: 100,
          itemBuilder: (BuildContext context, int index) {
            return ProviderScope(
              overrides: [
                currentMovieV2Provider
                    .overrideWithValue(AsyncValue.data(movies[index]))
              ],
              child: MovieTileV2(autofocus: index == 0),
            );
          },
        );
      },
      error: (e, st) => ErrorView(error: e.toString()),
      loading: () => const AppLoader(),
    );
  }
}
