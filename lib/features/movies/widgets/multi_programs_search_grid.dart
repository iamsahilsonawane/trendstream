import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/exceptions/app_error_codes.dart';
import 'package:latest_movies/core/exceptions/general_exception.dart';
import 'package:latest_movies/core/extensions/context_extension.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/core/utilities/responsive.dart';
import 'package:latest_movies/features/movies/controllers/current_multi_program_provider.dart';
import 'package:latest_movies/features/movies/controllers/search_multi_programs_count_provider.dart';
import 'package:latest_movies/features/movies/controllers/search_paginated_multi_programs.dart';
import 'package:latest_movies/features/movies/widgets/multi_program_item.dart';
import '../../../core/shared_widgets/app_loader.dart';
import '../../../core/shared_widgets/error_view.dart';
import '../controllers/movie_search_controller.dart';
import '../controllers/search_paginated_movies_provider.dart';

class MultiProgramsSearchGrid extends HookConsumerWidget {
  const MultiProgramsSearchGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchedMultiProgramsCount =
        ref.watch(searchMultiProgramsCountProvider);
    final pageBucket = useMemoized(() => PageStorageBucket());

    return PageStorage(
      bucket: pageBucket,
      child: searchedMultiProgramsCount.map(
        data: (asyncData) {
          return AlignedGridView.count(
              key: const PageStorageKey<String>(
                  'preserve_search_grid_scroll_and_focus_multi'),
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
                final AsyncValue<dynamic> currentShow = ref
                    .watch(paginatedMultiProgramsProvider(
                        PaginatedSearchProviderArgs(
                            page: index ~/ 20,
                            query: ref.watch(searchKeywordProvider))))
                    .whenData((pageData) => pageData.results[index % 20]);

                return ProviderScope(
                  overrides: [
                    currentMultiProgramProvider.overrideWithValue(currentShow)
                  ],
                  child: const MultiProgramTile(),
                );
              });
        },
        error: (e) {
          if (e.error is DioError) {
            final DioError dioError = e.error as DioError;

            if (dioError.response?.data['errors']
                .contains('query must be provided')) {
              return SearchErrorWidget(
                  message: context.localisations.trySearchingForMovieOrTvShow);
            }
          } else if (e.error is GeneralException) {
            final GeneralException generalException =
                e.error as GeneralException;

            if (generalException.code == AppErrorCodes.noItems) {
              return SearchErrorWidget(message: generalException.message!);
            }
          }
          return const ErrorView();
        },
        loading: (_) => const AppLoader(),
      ),
    );
  }
}

class SearchErrorWidget extends StatelessWidget {
  const SearchErrorWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          CupertinoIcons.search,
          size: 100,
          color: kPrimaryColor,
        ),
        verticalSpaceRegular,
        Text(message),
      ],
    );
  }
}
