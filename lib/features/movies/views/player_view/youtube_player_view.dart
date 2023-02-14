import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerView extends StatefulWidget {
  const YoutubePlayerView({super.key});

  @override
  State<YoutubePlayerView> createState() => _YoutubePlayerViewState();
}

class _YoutubePlayerViewState extends State<YoutubePlayerView> {
  late final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: ModalRoute.of(context)!.settings.arguments as String,
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: true,
    ),
  );

  void listener() {}
  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(listener);
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      onReady: () {
        _controller.addListener(listener);
      },
    );
  }
}
