import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:uuid/uuid.dart';

import 'controls/controls.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({Key? key}) : super(key: key);

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  late VlcPlayerController _videoPlayerController;
  final uuid = const Uuid();

  String? key;

  @override
  void initState() {
    super.initState();

    key = uuid.v4();

    _videoPlayerController = VlcPlayerController.network(
      // 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
      'https://media.w3.org/2010/05/sintel/trailer.mp4',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        subtitle: VlcSubtitleOptions([
          VlcSubtitleOptions.boldStyle(false),
          VlcSubtitleOptions.fontSize(24),
          VlcSubtitleOptions.color(VlcSubtitleColor.white),
          VlcSubtitleOptions.backgroundColor(VlcSubtitleColor.black),
          VlcSubtitleOptions.backgroundOpacity(1),
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
              vlcPlayerController: _videoPlayerController,
              onControllerChanged: (VlcPlayerController currentCtrl) async {
                await _videoPlayerController.dispose();
                final ct = currentCtrl.value.position;

                _videoPlayerController = VlcPlayerController.network(
                  'https://media.w3.org/2010/05/sintel/trailer.mp4',
                  hwAcc: HwAcc.full,
                  autoPlay: true,
                  autoInitialize: true,
                  options: VlcPlayerOptions(
                    advanced: VlcAdvancedOptions([
                      VlcAdvancedOptions.networkCaching(2000),
                    ]),
                    subtitle: currentCtrl.options?.subtitle,
                    http: VlcHttpOptions([
                      VlcHttpOptions.httpReconnect(true),
                    ]),
                    rtp: VlcRtpOptions([
                      VlcRtpOptions.rtpOverRtsp(true),
                    ]),
                  ),
                );

                _videoPlayerController.addOnInitListener(() {
                  Future.delayed(const Duration(seconds: 1), () {
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
