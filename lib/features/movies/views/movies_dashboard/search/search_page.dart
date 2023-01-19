import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/features/movies/constants.dart';
import 'package:latest_movies/features/movies/views/movies_dashboard/search/tv_show_search_grid.dart';
import 'package:latest_movies/features/movies/widgets/search_grid.dart';

import '../../../../../core/shared_widgets/app_keyboard/app_keyboard.dart';
import '../../../controllers/movie_search_controller.dart';
import '../../../controllers/search_type_provider.dart';
import '../../../enums/search_type.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyword = ref.watch(searchKeywordProvider);
    final searchType = ref.watch(searchTypeProvider);

    return FocusTraversalGroup(
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Switch(value: false, onChanged: (newValue) {}),
                // CupertinoSwitch(value: false, onChanged: (newValue) {}),
                Expanded(
                  child: AppOnScreenKeyboard(
                      onValueChanged: (value) {
                        ref
                            .read(searchKeywordProvider.notifier)
                            .setKeyword(value);
                      },
                      focusColor: kPrimaryColor),
                ),
              ],
            ),
          ),
          horizontalSpaceRegular,
          Expanded(
            flex: 6,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: kPrimaryColor.withOpacity(.2),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search),
                            horizontalSpaceSmall,
                            Text(
                              keyword.isEmpty
                                  ? "Search for movies..."
                                  : keyword,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: keyword.isEmpty
                                      ? Colors.grey[600]
                                      : Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    horizontalSpaceSmall,
                    // AppButton(
                    //     text: "Movies",
                    //     prefix: const Icon(Icons.filter_list),
                    //     onTap: () {}),
                    Flexible(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: kPrimaryColor.withOpacity(.2),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              dropdownColor: kBackgroundColor,
                              icon: const Icon(Icons.filter_list),
                              style: const TextStyle(color: Colors.white),
                              value: getSearchTypeString(searchType),
                              items: const [
                                DropdownMenuItem(
                                  value: SearchTypeConstants.movie,
                                  child: Text("Movies"),
                                ),
                                DropdownMenuItem(
                                  value: SearchTypeConstants.tvShows,
                                  child: Text("TV Shows"),
                                ),
                              ],
                              onChanged: (String? newValue) {
                                if (newValue == null) return;

                                ref.watch(searchTypeProvider.state).state =
                                    getSearchTypeFromString(newValue);
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                verticalSpaceRegular,
                Expanded(
                  child: FocusTraversalGroup(
                    child: searchType == SearchType.movies
                        ? const MovieSearchGrid()
                        : const TvShowSearchGrid(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
