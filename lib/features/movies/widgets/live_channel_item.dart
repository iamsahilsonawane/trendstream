import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/features/movies/controllers/live_channels_provider.dart';
import 'package:latest_movies/features/movies/models/live_channel/live_channel.dart';

import '../../../../core/utilities/design_utility.dart';
import "package:flutter/material.dart";

import '../../../core/shared_widgets/app_loader.dart';
import '../../../core/shared_widgets/error_view.dart';
import '../../../core/shared_widgets/image.dart';

class LiveChannelTile extends HookConsumerWidget {
  const LiveChannelTile({
    this.autofocus = false,
    Key? key,
  }) : super(key: key);

  final bool autofocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<LiveChannel> liveChannelAsync =
        ref.watch(currentLiveChannelProvider);

    return liveChannelAsync.map(
      data: (asyncData) {
        final channel = asyncData.value;
        return RawLiveChannelItem(autofocus: autofocus, channel: channel);
      },
      error: (e) => const ErrorView(),
      loading: (_) => const AppLoader(),
    );
  }
}

class RawLiveChannelItem extends StatelessWidget {
  const RawLiveChannelItem({
    super.key,
    required this.autofocus,
    required this.channel,
  });

  final bool autofocus;
  final LiveChannel channel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      autofocus: autofocus,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {},
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
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.4),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: const Offset(0, 1)),
                  ],
                  border: hasFocus
                      ? Border.all(
                          width: 4,
                          color: kPrimaryAccentColor,
                        )
                      : null,
                ),
                child: AppImage(
                  imageUrl: channel.channelBanner!,
                ),
              ),
              verticalSpaceRegular,
              Text(
                channel.channelName!,
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
