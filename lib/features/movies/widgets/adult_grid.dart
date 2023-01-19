import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/controllers/current_adult_show_controller.dart';
import 'package:latest_movies/features/movies/widgets/adult_show_item.dart';

import '../../../core/utilities/responsive.dart';

class AdultGrid extends StatelessWidget {
  const AdultGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return AlignedGridView.count(
      key: const PageStorageKey<String>(
          'preserve_adultcontent_grid_scroll_and_focus'),
      itemCount: 40,
      crossAxisCount: ResponsiveWidget.isMediumScreen(context)
          ? 3
          : ResponsiveWidget.isSmallScreen(context)
              ? 2
              : 4,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      itemBuilder: (BuildContext context, int index) {
        return ProviderScope(
          overrides: [
            currentAdultShowProvider.overrideWithValue(AsyncValue.data(index))
          ],
          child: AdultShowItem(autofocus: index == 0),
        );
      },
    );
  }
}
