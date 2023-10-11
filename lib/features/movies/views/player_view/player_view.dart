import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'controls/controls.dart';

class PlayerView extends ConsumerStatefulWidget {
  const PlayerView({Key? key}) : super(key: key);

  @override
  ConsumerState<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends ConsumerState<PlayerView> {
  late VlcPlayerController _videoPlayerController;
  final uuid = const Uuid();

  String? key;

  @override
  void initState() {
    super.initState();

    key = uuid.v4();
  }

  dynamic argUrl;

  bool isLiveStream(url) {
    if (url is! String) return false;
    if (url.contains('m3u8') || url.contains('mpd')) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void didChangeDependencies() {
    argUrl = ModalRoute.of(context)?.settings.arguments;

    _videoPlayerController = VlcPlayerController.network(
      // 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
      argUrl is String
          ? argUrl
          : 'https://media.w3.org/2010/05/sintel/trailer.mp4',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        subtitle: VlcSubtitleOptions([
          VlcSubtitleOptions.boldStyle(false),
          VlcSubtitleOptions.fontSize(48),
          VlcSubtitleOptions.color(VlcSubtitleColor.white),
          VlcSubtitleOptions.backgroundColor(VlcSubtitleColor.black),
          VlcSubtitleOptions.backgroundOpacity(255),
          VlcSubtitleOptions.shadowOpacity(0),
        ]),
        http: VlcHttpOptions([
          VlcHttpOptions.httpReconnect(true),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() async {
    super.dispose();
    if (_videoPlayerController.value.isInitialized) {
      await _videoPlayerController.stopRendererScanning();
      await _videoPlayerController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: VlcPlayer(
                key: ValueKey(key),
                controller: _videoPlayerController,
                aspectRatio: 16 / 9,
                placeholder: const Center(child: CircularProgressIndicator()),
              ),
              // child: Center()
            ),
          ),
          Positioned.fill(
            child: PlayerControls(
              key: ValueKey(key),
              isLiveView: isLiveStream(argUrl),
              vlcPlayerController: _videoPlayerController,
              onControllerChanged: (VlcPlayerController currentCtrl) async {
                final playbackSpeed = await currentCtrl.getPlaybackSpeed();

                await _videoPlayerController.dispose();
                final ct = currentCtrl.value.position;

                _videoPlayerController = VlcPlayerController.network(
                  argUrl is String
                      ? argUrl
                      : 'https://media.w3.org/2010/05/sintel/trailer.mp4',
                  hwAcc: HwAcc.full,
                  autoPlay: true,
                  autoInitialize: true,
                  options: VlcPlayerOptions(
                    advanced: currentCtrl.options?.advanced,
                    subtitle: currentCtrl.options?.subtitle,
                    http: currentCtrl.options?.http,
                    rtp: currentCtrl.options?.rtp,
                    video: currentCtrl.options?.video,
                  ),
                );

                _videoPlayerController.addOnInitListener(() {
                  Future.delayed(const Duration(seconds: 1), () async {
                    await _videoPlayerController
                        .setPlaybackSpeed(playbackSpeed ?? 1.0);
                    _videoPlayerController.seekTo(ct);
                  });
                });

                setState(() {
                  key = uuid.v4();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
