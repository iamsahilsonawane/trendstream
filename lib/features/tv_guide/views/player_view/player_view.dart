import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class LivePlayerView extends StatefulWidget {
  const LivePlayerView({Key? key}) : super(key: key);

  @override
  State<LivePlayerView> createState() => _LivePlayerViewState();
}

class _LivePlayerViewState extends State<LivePlayerView> {
  late VlcPlayerController _videoPlayerController;
  @override
  void initState() {
    super.initState();
    _videoPlayerController = VlcPlayerController.network(
      'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
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
          // VlcSubtitleOptions.outlineColor(VlcSubtitleColor.white),
          // VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
          // works only on externally added subtitles
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
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
    await _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VlcPlayer(
        controller: _videoPlayerController,
        aspectRatio: 16 / 9,
        placeholder: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
