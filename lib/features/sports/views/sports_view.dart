import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/shared_widgets/clock.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/features/sports/widgtes/sports_program_channel_tile.dart';
import 'package:latest_movies/features/sports/widgtes/sports_program_list_tile.dart';

import '../../../core/router/router.dart';

class SportsPage extends StatefulWidget {
  const SportsPage({super.key});

  @override
  State<SportsPage> createState() => _SportsPageState();
}

class _SportsPageState extends State<SportsPage> {
  late VlcPlayerController previewController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildHeader(context),
        verticalSpaceMedium,
        SizedBox(
          height: 30,
          child: Row(
            children: [
              const Clock(),
              horizontalSpaceMedium,
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return SportsProgramChannelTile(
                      title: "NBA Regular Season",
                      onTap: () {},
                    );
                  },
                  separatorBuilder: (context, _) => horizontalSpaceSmall,
                  itemCount: 20,
                ),
              ),
            ],
          ),
        ),
        verticalSpaceRegular,
        Expanded(
          child: ListView.separated(
            itemCount: 15,
            itemBuilder: (context, index) {
              return SportsProgramListTile(
                title:
                    "07:00 p.m. - lunes ${index + 1} - NBA Regular Season - Orlando Magic vs Chicago Bulls",
                icon: Icons.sports_football,
                autofocus: index == 0,
                onTap: () async {
                  if (previewController.value.isPlaying) {
                    previewController.pause();
                  }
                  await AppRouter.navigateToPage(Routes.playerView, arguments: "http://x.lamtv.tv:8080/live/test/test/130.m3u8");
                  // previewController.play();
                },
              );
            },
            separatorBuilder: (contetxt, _) => const Divider(height: 0),
          ),
        ),
      ],
    );
  }

  Row buildHeader(BuildContext context) {
    return Row(
      children: [
        Image.network(
          "https://static.vecteezy.com/system/resources/previews/010/994/361/original/nba-logo-symbol-red-and-blue-design-america-basketball-american-countries-basketball-teams-illustration-with-black-background-free-vector.jpg",
          height: 100,
        ),
        horizontalSpaceRegular,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Orlando Regular Season",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold, color: kPrimaryAccentColor),
            ),
            verticalSpaceSmall,
            Text(
              "Orlando Magic vs Chicago Bulls",
              style: textTheme(context)
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            verticalSpaceTiny,
            const Text("13 May, 2022 at 8:00 PM"),
          ],
        ),
        const Spacer(),
        SizedBox(
          height: 100,
          // child: AspectRatio(
          //   aspectRatio: 16 / 9,
          //   child: SizedBox.expand(
          //     child: ColoredBox(color: Colors.black),
          //   ),
          // ),
          child: LivePreviewPlayer(
            onControllerInitialized: (controller) {
              previewController = controller;
            },
          ),
        ),
      ],
    );
  }
}


class LivePreviewPlayer extends StatefulWidget {
  const LivePreviewPlayer({super.key, this.onControllerInitialized});

  final Function(VlcPlayerController controller)? onControllerInitialized;

  @override
  State<LivePreviewPlayer> createState() => _LivePreviewPlayerState();
}

class _LivePreviewPlayerState extends State<LivePreviewPlayer> {
  late VlcPlayerController _videoPlayerController;

  void initListener() {
    if (_videoPlayerController.value.isInitialized) {
      _videoPlayerController.setVolume(0);
    }
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VlcPlayerController.network(
      'http://x.lamtv.tv:8080/live/test/test/130.m3u8',
      // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        subtitle: VlcSubtitleOptions([
          VlcSubtitleOptions.boldStyle(true),
          VlcSubtitleOptions.fontSize(30),
          VlcSubtitleOptions.color(VlcSubtitleColor.white),
        ]),
        http: VlcHttpOptions([
          VlcHttpOptions.httpReconnect(true),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    );
    widget.onControllerInitialized?.call(_videoPlayerController);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _videoPlayerController.addOnInitListener(initListener);
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: kPrimaryColor, width: 3),
      ),
      child: VlcPlayer(
        controller: _videoPlayerController,
        aspectRatio: 16 / 9,
        placeholder: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}