import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/features/movies/widgets/search_grid.dart';

import '../../../../../core/shared_widgets/app_keyboard/app_keyboard.dart';
import '../../../controllers/movie_search_controller.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyword = ref.watch(searchKeywordProvider);

    return FocusTraversalGroup(
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: AppOnScreenKeyboard(
                onValueChanged: (value) {
                  ref.read(searchKeywordProvider.notifier).setKeyword(value);
                },
                focusColor: Colors.lightBlue),
          ),
          horizontalSpaceRegular,
          Expanded(
            flex: 6,
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.search),
                    horizontalSpaceSmall,
                    Text(
                      keyword.isEmpty ? "Search for movies..." : keyword,
                      style: TextStyle(
                          fontSize: 18,
                          color: keyword.isEmpty
                              ? Colors.grey[600]
                              : Colors.white),
                    )
                  ],
                ),
                verticalSpaceRegular,
                Expanded(
                  child: FocusTraversalGroup(child: const SearchGrid()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
