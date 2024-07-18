import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/shared_widgets/error_view.dart';
import 'package:latest_movies/features/movies/widgets/tv_show_item.dart';
import 'package:latest_movies/features/movies/widgets/tv_show_item_v3.dart';

import '../../../core/shared_widgets/app_loader.dart';
import '../../../core/utilities/responsive.dart';
import '../controllers/tv_shows_provider_v3.dart';

class TvShowsGridV3 extends HookConsumerWidget {
  const TvShowsGridV3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tvShowsAsync = ref.watch(showsV3Provider);

    return tvShowsAsync.when(
      data: (shows) {
        return AlignedGridView.count(
          key: const PageStorageKey<String>(
              'preserve_tv_shows_v3_grid_scroll_and_focus'),
          itemCount: shows.length,
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
                currentTvShowProvider.overrideWithValue(AsyncData(shows[index]))
              ],
              child: TvShowTileV3(autofocus: index == 0),
            );
          },
        );
      },
      error: (e, st) => ErrorView(error: e.toString()),
      loading: () => const AppLoader(),
    );
  }
}
