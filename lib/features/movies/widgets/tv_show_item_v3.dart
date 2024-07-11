import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/extensions/context_extension.dart';
import 'package:latest_movies/features/movies/controllers/tv_shows_provider_v3.dart';
import 'package:latest_movies/features/movies/models/tv_show_v3/urls_image.dart';
import 'package:latest_movies/features/movies/models/tv_show_v3/tv_show_v3.dart';

import '../../../../core/utilities/design_utility.dart';
import "package:flutter/material.dart";

import 'package:latest_movies/core/router/router.dart';
import '../../../core/shared_widgets/image.dart';

class TvShowTileV3 extends HookConsumerWidget {
  const TvShowTileV3({
    this.autofocus = false,
    Key? key,
  }) : super(key: key);

  final bool autofocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RawAsyncTvShowTileV3(autofocus: autofocus);
  }
}

class RawAsyncTvShowTileV3 extends ConsumerWidget {
  const RawAsyncTvShowTileV3({
    super.key,
    required this.autofocus,
  });

  final bool autofocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<TvShowV3> tvShowAsync = ref.watch(currentTvShowProvider);

    return InkWell(
      autofocus: autofocus,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        if (tvShowAsync is! AsyncData) return;
        AppRouter.navigateToPage(Routes.tvShowDetailsV3View,
            arguments: tvShowAsync.asData!.value.id);
      },
      child: Builder(builder: (context) {
        final bool hasFocus = Focus.of(context).hasPrimaryFocus;
        return Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 2 / 3,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.4),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                    border: hasFocus
                        ? Border.all(
                            width: 4,
                            color: kPrimaryAccentColor,
                          )
                        : null,
                  ),
                  child: tvShowAsync.maybeWhen(
                    data: (show) {
                      return AppImage(
                        imageUrl: show.poster?.urlsImage
                                ?.firstWhere(
                                    (img) => img.size?.value == "original",
                                    orElse: () => const UrlsImage(url: ""))
                                .url ??
                            "",
                        blurHash: show.poster?.urlsImage
                            ?.firstWhere((img) => img.size?.value == "original",
                                orElse: () => const UrlsImage())
                            .blurHash,
                      );
                    },
                    orElse: () => null,
                  ),
                ),
              ),
              verticalSpaceRegular,
              Text(
                tvShowAsync.maybeWhen(
                    data: (show) => validString(show.firstAirDate != null &&
                            show.firstAirDate!.isNotEmpty
                        ? DateFormat("dd MMM yyyy").format(
                            DateFormat("yyyy-MM-dd").parse(show.firstAirDate!))
                        : null),
                    orElse: () => context.localisations.loading),
                style: TextStyle(
                    fontSize: 14,
                    color: hasFocus ? Colors.white : Colors.grey[700],
                    fontWeight: hasFocus ? FontWeight.w700 : FontWeight.w600),
              ),
              const SizedBox(height: 5),
              Text(
                "⭐️ ${tvShowAsync.maybeWhen(data: (show) => validString(show.voteAverage.toString()), orElse: () => context.localisations.loading)}",
                style: TextStyle(
                    fontSize: 14,
                    color: hasFocus ? Colors.white : Colors.grey[700],
                    fontWeight: hasFocus ? FontWeight.w700 : FontWeight.w600),
              ),
            ],
          ),
        );
      }),
    );
  }
}
