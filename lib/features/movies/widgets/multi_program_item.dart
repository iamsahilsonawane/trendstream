import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/controllers/current_multi_program_provider.dart';
import 'package:latest_movies/features/movies/models/movie/movie.dart';
import 'package:latest_movies/features/movies/models/tv_show/tv_show.dart';
import 'package:latest_movies/features/movies/widgets/movie_item.dart';
import 'package:latest_movies/features/movies/widgets/tv_show_item.dart';

import "package:flutter/material.dart";
import '../../../core/shared_widgets/app_loader.dart';
import '../../../core/shared_widgets/error_view.dart';

class MultiProgramTile extends HookConsumerWidget {
  const MultiProgramTile({
    this.autofocus = false,
    Key? key,
  }) : super(key: key);

  final bool autofocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<dynamic> programAsync =
        ref.watch(currentMultiProgramProvider);

    return programAsync.map(
      data: (asyncData) {
        var show = asyncData.value;
        if (show is Movie) {
          return RawMovieTile(autofocus: autofocus, movie: show);
        } else {
          return RawTvShowItem(autofocus: autofocus, show: show as TvShow);
        }
      },
      error: (e) => const ErrorView(),
      loading: (_) => const AppLoader(),
    );
  }
}
