import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/controllers/live_channels_provider.dart';
import 'package:latest_movies/features/movies/models/live_channel/live_channel.dart';

import "package:flutter/material.dart";

import '../../../core/shared_widgets/app_loader.dart';
import '../../../core/shared_widgets/error_view.dart';
import '../controllers/live_channel_controller.dart';

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

class RawLiveChannelItem extends HookConsumerWidget {
  const RawLiveChannelItem({
    super.key,
    required this.autofocus,
    required this.channel,
  });

  final bool autofocus;
  final LiveChannel channel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      autofocus: autofocus,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {},
      onFocusChange: (isFocused) {
        if (isFocused ) {
          ref.read(currentSelectedLiveChannelProvider.notifier).state = channel;
        }
      },
      child: Builder(builder: (context) {
        final bool hasFocus = Focus.of(context).hasPrimaryFocus;
        return Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: !hasFocus ? Colors.grey[900] : Colors.grey[200],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                channel.channelName!,
                style: TextStyle(
                    fontSize: 14,
                    color: !hasFocus ? Colors.white : Colors.grey[700],
                    fontWeight: !hasFocus ? FontWeight.w700 : FontWeight.w600),
              ),
              Icon(
                Icons.play_arrow_rounded,
                size: 24,
                color: !hasFocus ? Colors.white : Colors.grey[700],
              ),
            ],
          ),
        );
      }),
    );
  }
}
