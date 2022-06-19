import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:latest_movies/app/ui/movies/movie_details/package_override.dart';
import 'package:video_player/video_player.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({super.key});

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  // final videoPlayerController = VideoPlayerController.network(
  //     'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
  final videoPlayerController = VideoPlayerController.network(
      'https://rr1---sn-cvh7knzz.googlevideo.com/videoplayback?expire=1655478197&ei=VUOsYuK1D6-U2_gP3fmV6Ac&ip=198.181.163.31&id=o-AKgfzt4cLZ3qSUrwBAHTeKlKrgw7klby9qQJug0F4ip0&itag=18&source=youtube&requiressl=yes&spc=4ocVC1iazSXNchkTX6gc5d7m5LFZbPg&vprv=1&mime=video%2Fmp4&ns=OIXLCojXKQZOn-p1NgljAw8G&gir=yes&clen=661796330&ratebypass=yes&dur=7565.966&lmt=1647236050519773&fexp=24001373,24007246&c=WEB&txp=5518222&n=Hao8nmV09Nkvpg&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cspc%2Cvprv%2Cmime%2Cns%2Cgir%2Cclen%2Cratebypass%2Cdur%2Clmt&sig=AOq0QJ8wRQIgTVug272qNLOlzbJT3mEG-B4a0J-XIKsVn_I_3Ie5qrICIQCKawVlKpSZjjyQMGJSGQ0L2z4vNmv67rDI9YiNROdrVg%3D%3D&rm=sn-vgqeel7e&req_id=6d45b6a51af7a3ee&redirect_counter=2&cm2rm=sn-q8vpn-cvh67l&cms_redirect=yes&cmsv=e&ipbypass=yes&mh=Jp&mip=1.186.196.124&mm=29&mn=sn-cvh7knzz&ms=rdu&mt=1655463925&mv=m&mvi=1&pl=24&lsparams=ipbypass,mh,mip,mm,mn,ms,mv,mvi,pl&lsig=AG3C_xAwRAIgVTPqvefw4nvuDLqyhjF0R0qCrgbJkp0QIGNaAhHZW-cCIALKy-Zhf4HxdWJn_r3TPbKS0vZ4WLYzzcCX9ftfSLsI');

  ChewieController? chewieController;

  Future<void> initializePlayer() async {
    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void didChangeDependencies() {
    log("target platform: ${Theme.of(context).platform}");
    super.didChangeDependencies();
  }

  @override
  void dispose() async {
    videoPlayerController.dispose();
    chewieController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: chewieController != null &&
                      chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie1(
                      controller: chewieController!,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Loading'),
                      ],
                    ),
            ),
          ),
          // Expanded(
          //   child: Stack(
          //     children: [
          //       Container(
          //         width: double.infinity,
          //         height: double.infinity,
          //         color: Colors.blue[900],
          //       ),
          //       Positioned(
          //         top: 200,
          //         left: 200,
          //         child: IconButton(
          //             icon: const Icon(Icons.play_arrow), onPressed: () {}),
          //       ),
          //     ],
          //   ),
          // )
          // TextButton(
          //   onPressed: () {
          //     chewieController?.enterFullScreen();
          //   },
          //   child: const Text('Fullscreen'),
          // ),
          // Row(
          //   children: <Widget>[
          //     Expanded(
          //       child: TextButton(
          //         onPressed: () {
          //           setState(() {
          //             // _videoPlayerController1.pause();
          //             // _videoPlayerController1.seekTo(Duration.zero);
          //             // _createChewieController();
          //           });
          //         },
          //         child: const Padding(
          //           padding: EdgeInsets.symmetric(vertical: 16.0),
          //           child: Text("Landscape Video"),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: TextButton(
          //         onPressed: () {
          //           setState(() {
          //             // _videoPlayerController2.pause();
          //             // _videoPlayerController2.seekTo(Duration.zero);
          //             // chewieController = chewieController!.copyWith(
          //             //   videoPlayerController: _videoPlayerController2,
          //             //   autoPlay: true,
          //             //   looping: true,
          //             //   /* subtitle: Subtitles([
          //             //     Subtitle(
          //             //       index: 0,
          //             //       start: Duration.zero,
          //             //       end: const Duration(seconds: 10),
          //             //       text: 'Hello from subtitles',
          //             //     ),
          //             //     Subtitle(
          //             //       index: 0,
          //             //       start: const Duration(seconds: 10),
          //             //       end: const Duration(seconds: 20),
          //             //       text: 'Whats up? :)',
          //             //     ),
          //             //   ]),
          //             //   subtitleBuilder: (context, subtitle) => Container(
          //             //     padding: const EdgeInsets.all(10.0),
          //             //     child: Text(
          //             //       subtitle,
          //             //       style: const TextStyle(color: Colors.white),
          //             //     ),
          //             //   ), */
          //             // );
          //           });
          //         },
          //         child: const Padding(
          //           padding: EdgeInsets.symmetric(vertical: 16.0),
          //           child: Text("Portrait Video"),
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          // Row(
          //   children: <Widget>[
          //     Expanded(
          //       child: TextButton(
          //         onPressed: () {
          //           // setState(() {
          //           //   _platform = TargetPlatform.android;
          //           // });
          //         },
          //         child: const Padding(
          //           padding: EdgeInsets.symmetric(vertical: 16.0),
          //           child: Text("Android controls"),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: TextButton(
          //         onPressed: () {
          //           // setState(() {
          //           //   _platform = TargetPlatform.iOS;
          //           // });
          //         },
          //         child: const Padding(
          //           padding: EdgeInsets.symmetric(vertical: 16.0),
          //           child: Text("iOS controls"),
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          // Row(
          // children: <Widget>[
          //   Expanded(
          //     child: TextButton(
          //       onPressed: () {
          //         // setState(() {
          //         //   _platform = TargetPlatform.windows;
          //         // });
          //       },
          //       child: const Padding(
          //         padding: EdgeInsets.symmetric(vertical: 16.0),
          //         child: Text("Desktop controls"),
          //       ),
          //     ),
          //   ),
          // ],
          // ),
        ],
      ),
    );
  }
}
