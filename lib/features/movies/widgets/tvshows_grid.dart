import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/shared_widgets/error_view.dart';
import 'package:latest_movies/features/movies/widgets/tv_show_item.dart';

import '../../../core/shared_widgets/app_loader.dart';
import '../../../core/utilities/responsive.dart';
import '../controllers/tv_shows_provider.dart';
import '../models/tv_show/tv_show.dart';

class TvShowsGrid extends HookConsumerWidget {
  const TvShowsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularTvShowsCountAsync = ref.watch(popularTvShowsCountProvider);

    return popularTvShowsCountAsync.map(
      data: (asyncData) {
        return AlignedGridView.count(
          key: const PageStorageKey<String>(
              'preserve_tv_shows_grid_scroll_and_focus'),
          controller: ScrollController(),
          itemCount: 30,
          crossAxisCount: ResponsiveWidget.isMediumScreen(context)
              ? 4
              : ResponsiveWidget.isSmallScreen(context)
                  ? 2
                  : 6,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          itemBuilder: (BuildContext context, int index) {
            final AsyncValue<TvShow> currentPopularTvShowFromIndex = ref
                .watch(paginatedPopularTvShowsProvider(index ~/ 20))
                .whenData((pageData) => pageData.results[index % 20]);

            return ProviderScope(
              overrides: [
                currentPopularTvShowProvider
                    .overrideWithValue(currentPopularTvShowFromIndex)
              ],
              child: TvShowTile(autofocus: index == 0),
            );
          },
        );
      },
      error: (e) => ErrorView(error: e.error.toString()),
      loading: (_) => const AppLoader(),
    );
  }
}
