import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/extensions/context_extension.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/features/movies/constants.dart';
import 'package:latest_movies/features/movies/views/movies_dashboard/search/tv_show_search_grid.dart';
import 'package:latest_movies/features/movies/widgets/multi_programs_search_grid.dart';
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
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: AppOnScreenKeyboard(
                    onValueChanged: (value) {
                      ref
                          .read(searchKeywordProvider.notifier)
                          .setKeyword(value);
                    },
                    focusColor: kPrimaryColor,
                  ),
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
                            FittedBox(
                              child: Text(
                                keyword.isEmpty
                                    ? context
                                        .localisations.searchForMoviesOrTvShows
                                    : keyword,
                                style: TextStyle(
                                    color: keyword.isEmpty
                                        ? Colors.grey[600]
                                        : Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    horizontalSpaceSmall,
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
                              iconEnabledColor: kPrimaryAccentColor,
                              style: const TextStyle(color: Colors.white),
                              value: getSearchTypeString(searchType),
                              items: [
                                DropdownMenuItem(
                                  value: SearchTypeConstants.all,
                                  child: Text(
                                    context.localisations.all,
                                    style: TextStyle(
                                      color: searchType == SearchType.all
                                          ? kPrimaryAccentColor
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: SearchTypeConstants.movie,
                                  child: Text(
                                    context.localisations.movies,
                                    style: TextStyle(
                                      color: searchType == SearchType.movies
                                          ? kPrimaryAccentColor
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: SearchTypeConstants.tvShows,
                                  child: Text(
                                    context.localisations.tvShows,
                                    style: TextStyle(
                                        color: searchType == SearchType.tvShows
                                            ? kPrimaryAccentColor
                                            : Colors.white),
                                  ),
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
                    child: Builder(builder: (context) {
                      Widget child;
                      switch (searchType) {
                        case SearchType.all:
                          child = const MultiProgramsSearchGrid();
                          break;
                        case SearchType.movies:
                          child = const MovieSearchGrid();
                          break;
                        case SearchType.tvShows:
                          child = const TvShowSearchGrid();
                          break;
                      }
                      return child;
                    }),
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
