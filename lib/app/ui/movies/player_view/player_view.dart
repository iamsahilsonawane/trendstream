import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:latest_movies/app/ui/movies/player_view/controls/controls.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({Key? key}) : super(key: key);

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  late VlcPlayerController _videoPlayerController;
  @override
  void initState() {
    super.initState();
    _videoPlayerController = VlcPlayerController.network(
      'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
      hwAcc: HwAcc.full,
      autoPlay: false,
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: VlcPlayer(
                controller: _videoPlayerController,
                aspectRatio: 16 / 9,
                placeholder: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          Positioned.fill(
            child: PlayerControls(vlcPlayerController: _videoPlayerController),
          ),
        ],
      ),
    );
  }
}
