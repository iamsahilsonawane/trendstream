// import 'dart:async';

// import 'package:chewie/chewie.dart';
// import 'package:chewie/src/chewie_player.dart';
// import 'package:chewie/src/helpers/adaptive_controls.dart';
// import 'package:chewie/src/notifiers/index.dart';

// import 'package:chewie/src/models/option_item.dart';
// import 'package:chewie/src/models/options_translation.dart';
// import 'package:chewie/src/models/subtitle_model.dart';
// import 'package:chewie/src/notifiers/player_notifier.dart';
// import 'package:chewie/src/player_with_controls.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:wakelock/wakelock.dart';

// import 'package:chewie/src/animated_play_pause.dart';
// import 'package:chewie/src/center_play_button.dart';
// import 'package:chewie/src/chewie_progress_colors.dart';
// import 'package:chewie/src/helpers/utils.dart';
// import 'package:chewie/src/material/material_progress_bar.dart';
// import 'package:chewie/src/material/widgets/options_dialog.dart';
// import 'package:chewie/src/material/widgets/playback_speed_dialog.dart';

// typedef ChewieRoutePageBuilder = Widget Function(
//   BuildContext context,
//   Animation<double> animation,
//   Animation<double> secondaryAnimation,
//   ChewieControllerProvider controllerProvider,
// );

// /// A Video Player with Material and Cupertino skins.
// ///
// /// `video_player` is pretty low level. Chewie wraps it in a friendly skin to
// /// make it easy to use!
// class Chewie1 extends StatefulWidget {
//   const Chewie1({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   /// The [ChewieController]
//   final ChewieController controller;

//   @override
//   ChewieState1 createState() {
//     return ChewieState1();
//   }
// }

// class ChewieState1 extends State<Chewie1> {
//   bool _isFullScreen = false;

//   bool get isControllerFullScreen => widget.controller.isFullScreen;
//   late PlayerNotifier notifier;

//   @override
//   void initState() {
//     super.initState();
//     widget.controller.addListener(listener);
//     notifier = PlayerNotifier.init();
//   }

//   @override
//   void dispose() {
//     widget.controller.removeListener(listener);
//     super.dispose();
//   }

//   @override
//   void didUpdateWidget(Chewie1 oldWidget) {
//     if (oldWidget.controller != widget.controller) {
//       widget.controller.addListener(listener);
//     }
//     super.didUpdateWidget(oldWidget);
//     if (_isFullScreen != isControllerFullScreen) {
//       // widget.controller._isFullScreen = _isFullScreen;
//     }
//   }

//   Future<void> listener() async {
//     if (isControllerFullScreen && !_isFullScreen) {
//       _isFullScreen = isControllerFullScreen;
//       await _pushFullScreenWidget(context);
//     } else if (_isFullScreen) {
//       Navigator.of(
//         context,
//         rootNavigator: widget.controller.useRootNavigator,
//       ).pop();
//       _isFullScreen = false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChewieControllerProvider(
//       controller: widget.controller,
//       child: ChangeNotifierProvider<PlayerNotifier>.value(
//         value: notifier,
//         builder: (context, w) => const PlayerWithControls1(),
//       ),
//     );
//   }

//   Widget _buildFullScreenVideo(
//     BuildContext context,
//     Animation<double> animation,
//     ChewieControllerProvider controllerProvider,
//   ) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         alignment: Alignment.center,
//         color: Colors.black,
//         child: controllerProvider,
//       ),
//     );
//   }

//   AnimatedWidget _defaultRoutePageBuilder(
//     BuildContext context,
//     Animation<double> animation,
//     Animation<double> secondaryAnimation,
//     ChewieControllerProvider controllerProvider,
//   ) {
//     return AnimatedBuilder(
//       animation: animation,
//       builder: (BuildContext context, Widget? child) {
//         return _buildFullScreenVideo(context, animation, controllerProvider);
//       },
//     );
//   }

//   Widget _fullScreenRoutePageBuilder(
//     BuildContext context,
//     Animation<double> animation,
//     Animation<double> secondaryAnimation,
//   ) {
//     final controllerProvider = ChewieControllerProvider(
//       controller: widget.controller,
//       child: ChangeNotifierProvider<PlayerNotifier>.value(
//         value: notifier,
//         builder: (context, w) => const PlayerWithControls1(),
//       ),
//     );

//     if (widget.controller.routePageBuilder == null) {
//       return _defaultRoutePageBuilder(
//         context,
//         animation,
//         secondaryAnimation,
//         controllerProvider,
//       );
//     }
//     return widget.controller.routePageBuilder!(
//       context,
//       animation,
//       secondaryAnimation,
//       controllerProvider,
//     );
//   }

//   Future<dynamic> _pushFullScreenWidget(BuildContext context) async {
//     final TransitionRoute<void> route = PageRouteBuilder<void>(
//       pageBuilder: _fullScreenRoutePageBuilder,
//     );

//     // onEnterFullScreen();

//     // if (!widget.controller.allowedScreenSleep) {
//     //   Wakelock.enable();
//     // }

//     // await Navigator.of(
//     //   context,
//     //   rootNavigator: widget.controller.useRootNavigator,
//     // ).push(route);

//     await Navigator.of(
//       context,
//       // rootNavigator: widget.controller.useRootNavigator,
//     ).push(MaterialPageRoute(
//         builder: (context) => Scaffold(
//             resizeToAvoidBottomInset: false,
//             body: ChewieControllerProvider(
//               controller: widget.controller,
//               child: ChangeNotifierProvider<PlayerNotifier>.value(
//                 value: notifier,
//                 builder: (context, w) => const PlayerWithControls1(),
//               ),
//             ))));

//     _isFullScreen = false;
//     widget.controller.exitFullScreen();

//     // The wakelock plugins checks whether it needs to perform an action internally,
//     // so we do not need to check Wakelock.isEnabled.
//     Wakelock.disable();

//     SystemChrome.setEnabledSystemUIMode(
//       SystemUiMode.manual,
//       overlays: widget.controller.systemOverlaysAfterFullScreen,
//     );
//     SystemChrome.setPreferredOrientations(
//       widget.controller.deviceOrientationsAfterFullScreen,
//     );
//   }

//   void onEnterFullScreen() {
//     final videoWidth = widget.controller.videoPlayerController.value.size.width;
//     final videoHeight =
//         widget.controller.videoPlayerController.value.size.height;

//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

//     // if (widget.controller.systemOverlaysOnEnterFullScreen != null) {
//     //   /// Optional user preferred settings
//     //   SystemChrome.setEnabledSystemUIMode(
//     //     SystemUiMode.manual,
//     //     overlays: widget.controller.systemOverlaysOnEnterFullScreen,
//     //   );
//     // } else {
//     //   /// Default behavior
//     //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
//     // }

//     if (widget.controller.deviceOrientationsOnEnterFullScreen != null) {
//       /// Optional user preferred settings
//       SystemChrome.setPreferredOrientations(
//         widget.controller.deviceOrientationsOnEnterFullScreen!,
//       );
//     } else {
//       final isLandscapeVideo = videoWidth > videoHeight;
//       final isPortraitVideo = videoWidth < videoHeight;

//       /// Default behavior
//       /// Video w > h means we force landscape
//       if (isLandscapeVideo) {
//         SystemChrome.setPreferredOrientations([
//           DeviceOrientation.landscapeLeft,
//           DeviceOrientation.landscapeRight,
//         ]);
//       }

//       /// Video h > w means we force portrait
//       else if (isPortraitVideo) {
//         SystemChrome.setPreferredOrientations([
//           DeviceOrientation.portraitUp,
//           DeviceOrientation.portraitDown,
//         ]);
//       }

//       /// Otherwise if h == w (square video)
//       else {
//         SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//       }
//     }
//   }
// }

// class PlayerWithControls1 extends StatelessWidget {
//   const PlayerWithControls1({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final ChewieController chewieController = ChewieController.of(context);

//     double _calculateAspectRatio(BuildContext context) {
//       final size = MediaQuery.of(context).size;
//       final width = size.width;
//       final height = size.height;

//       return width > height ? width / height : height / width;
//     }

//     Widget _buildControls(
//       BuildContext context,
//       ChewieController chewieController,
//     ) {
//       return chewieController.showControls
//           ? chewieController.customControls ?? const AdaptiveControls1()
//           : Container();
//     }

//     Widget _buildPlayerWithControls(
//       ChewieController chewieController,
//       BuildContext context,
//     ) {
//       return Stack(
//         children: <Widget>[
//           if (chewieController.placeholder != null)
//             chewieController.placeholder!,
//           InteractiveViewer(
//             maxScale: chewieController.maxScale,
//             panEnabled: chewieController.zoomAndPan,
//             scaleEnabled: chewieController.zoomAndPan,
//             child: Center(
//               child: AspectRatio(
//                 aspectRatio: chewieController.aspectRatio ??
//                     chewieController.videoPlayerController.value.aspectRatio,
//                 child: VideoPlayer(chewieController.videoPlayerController),
//               ),
//             ),
//           ),
//           if (chewieController.overlay != null) chewieController.overlay!,
//           if (Theme.of(context).platform != TargetPlatform.iOS)
//             Consumer<PlayerNotifier>(
//               builder: (
//                 BuildContext context,
//                 PlayerNotifier notifier,
//                 Widget? widget,
//               ) =>
//                   Visibility(
//                 visible: !notifier.hideStuff,
//                 child: AnimatedOpacity(
//                   opacity: notifier.hideStuff ? 0.0 : 0.8,
//                   duration: const Duration(
//                     milliseconds: 250,
//                   ),
//                   child: Container(
//                     decoration: const BoxDecoration(color: Colors.black54),
//                     child: Container(),
//                   ),
//                 ),
//               ),
//             ),
//           if (!chewieController.isFullScreen)
//             _buildControls(context, chewieController)
//           else
//             SafeArea(
//               bottom: false,
//               child: _buildControls(context, chewieController),
//             ),
//         ],
//       );
//     }

//     return Center(
//       child: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: AspectRatio(
//           aspectRatio: _calculateAspectRatio(context),
//           child: _buildPlayerWithControls(chewieController, context),
//         ),
//       ),
//     );
//   }
// }

// class AdaptiveControls1 extends StatelessWidget {
//   const AdaptiveControls1({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialDesktopControls1();
//   }
// }

// class MaterialDesktopControls1 extends StatefulWidget {
//   const MaterialDesktopControls1({
//     this.showPlayButton = true,
//     Key? key,
//   }) : super(key: key);

//   final bool showPlayButton;

//   @override
//   State<StatefulWidget> createState() {
//     return _MaterialDesktopControlsState1();
//   }
// }

// class _MaterialDesktopControlsState1 extends State<MaterialDesktopControls1>
//     with SingleTickerProviderStateMixin {
//   late PlayerNotifier notifier;
//   late VideoPlayerValue _latestValue;
//   double? _latestVolume;
//   Timer? _hideTimer;
//   Timer? _initTimer;
//   late var _subtitlesPosition = Duration.zero;
//   bool _subtitleOn = false;
//   Timer? _showAfterExpandCollapseTimer;
//   bool _dragging = false;
//   bool _displayTapped = false;

//   final barHeight = 48.0 * 1.5;
//   final marginSize = 5.0;

//   late VideoPlayerController controller;
//   ChewieController? _chewieController;

//   // We know that _chewieController is set in didChangeDependencies
//   ChewieController get chewieController => _chewieController!;

//   final _rewindFocusNode = FocusNode();
//   final _forwardFocusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     notifier = Provider.of<PlayerNotifier>(context, listen: false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_latestValue.hasError) {
//       return chewieController.errorBuilder?.call(
//             context,
//             chewieController.videoPlayerController.value.errorDescription!,
//           ) ??
//           const Center(
//             child: Icon(
//               Icons.error,
//               color: Colors.white,
//               size: 42,
//             ),
//           );
//     }

//     return FocusScope(
//       // onKey: (node, event) {
//       //   print(event.toString());
//       //   node.nextFocus();
//       //   return KeyEventResult.handled;
//       // },
//       node: FocusScopeNode(),

//       onFocusChange: (bool isChildrenFocussed) {
//         if (isChildrenFocussed) {
//           _cancelTimer();
//         } else {
//           print('isChildrenFocussed: $isChildrenFocussed');
//           _cancelAndRestartTimer();
//           FocusScope.of(context).unfocus();
//         }
//       },
//       child: MouseRegion(
//         onHover: (_) {
//           _cancelAndRestartTimer();
//         },
//         child: GestureDetector(
//           onTap: () => _cancelAndRestartTimer(),
//           child: AbsorbPointer(
//             absorbing: notifier.hideStuff,
//             child: Stack(
//               children: [
//                 Positioned(
//                   left: 20,
//                   top: 20,
//                   child: AnimatedOpacity(
//                     opacity: widget.showPlayButton &&
//                             !_dragging &&
//                             !notifier.hideStuff
//                         ? 1.0
//                         : 0.0,
//                     duration: const Duration(milliseconds: 300),
//                     child: Material(
//                       color: Colors.transparent,
//                       child: Container(
//                         decoration: const BoxDecoration(
//                           color: Colors.black54,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),

//                           // Always set the iconSize on the IconButton, not on the Icon itself:
//                           // https://github.com/flutter/flutter/issues/52980
//                           child: IconButton(
//                             focusColor: Colors.blue,
//                             iconSize: 32,
//                             icon: const Icon(Icons.arrow_back,
//                                 color: Colors.white),
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (_latestValue.isBuffering)
//                   const Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 else ...[
//                   _buildHitArea(),
//                   _buildRewindControl(),
//                   _buildForwardControl(),
//                 ],
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     if (_subtitleOn)
//                       Transform.translate(
//                         offset: Offset(
//                           0.0,
//                           notifier.hideStuff ? barHeight * 0.8 : 0.0,
//                         ),
//                         child: _buildSubtitles(
//                             context, chewieController.subtitle!),
//                       ),
//                     _buildBottomBar(context),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _dispose();
//     super.dispose();
//   }

//   void _dispose() {
//     controller.removeListener(_updateState);
//     _hideTimer?.cancel();
//     _initTimer?.cancel();
//     _showAfterExpandCollapseTimer?.cancel();
//   }

//   @override
//   void didChangeDependencies() {
//     final _oldController = _chewieController;
//     _chewieController = ChewieController.of(context);
//     controller = chewieController.videoPlayerController;

//     if (_oldController != chewieController) {
//       _dispose();
//       _initialize();
//     }

//     super.didChangeDependencies();
//   }

//   Widget _buildSubtitleToggle({IconData? icon, bool isPadded = false}) {
//     return IconButton(
//       padding: isPadded ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
//       icon: Icon(icon, color: _subtitleOn ? Colors.white : Colors.grey[700]),
//       onPressed: _onSubtitleTap,
//     );
//   }

//   Widget _buildOptionsButton({
//     IconData? icon,
//     bool isPadded = false,
//   }) {
//     final options = <OptionItem>[
//       OptionItem(
//         onTap: () async {
//           Navigator.pop(context);
//           _onSpeedButtonTap();
//         },
//         iconData: Icons.speed,
//         title: chewieController.optionsTranslation?.playbackSpeedButtonText ??
//             'Playback speed',
//       )
//     ];

//     if (chewieController.additionalOptions != null &&
//         chewieController.additionalOptions!(context).isNotEmpty) {
//       options.addAll(chewieController.additionalOptions!(context));
//     }

//     return AnimatedOpacity(
//       opacity: notifier.hideStuff ? 0.0 : 1.0,
//       duration: const Duration(milliseconds: 250),
//       child: Container(
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         decoration: const BoxDecoration(shape: BoxShape.circle),
//         child: Material(
//           child: IconButton(
//             focusColor: Colors.blue,
//             padding: isPadded ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
//             onPressed: () async {
//               _hideTimer?.cancel();

//               if (chewieController.optionsBuilder != null) {
//                 await chewieController.optionsBuilder!(context, options);
//               } else {
//                 await showModalBottomSheet<OptionItem>(
//                   context: context,
//                   isScrollControlled: true,
//                   useRootNavigator: chewieController.useRootNavigator,
//                   builder: (context) => OptionsDialog(
//                     options: options,
//                     cancelButtonText:
//                         chewieController.optionsTranslation?.cancelButtonText,
//                   ),
//                 );
//               }

//               if (_latestValue.isPlaying) {
//                 _startHideTimer();
//               }
//             },
//             icon: Icon(
//               icon ?? Icons.more_vert,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSubtitles(BuildContext context, Subtitles subtitles) {
//     if (!_subtitleOn) {
//       return Container();
//     }
//     final currentSubtitle = subtitles.getByPosition(_subtitlesPosition);
//     if (currentSubtitle.isEmpty) {
//       return Container();
//     }

//     if (chewieController.subtitleBuilder != null) {
//       return chewieController.subtitleBuilder!(
//         context,
//         currentSubtitle.first!.text,
//       );
//     }

//     return Padding(
//       padding: EdgeInsets.all(marginSize),
//       child: Container(
//         padding: const EdgeInsets.all(5),
//         decoration: BoxDecoration(
//           color: const Color(0x96000000),
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Text(
//           currentSubtitle.first!.text.toString(),
//           style: const TextStyle(
//             fontSize: 18,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }

//   AnimatedOpacity _buildBottomBar(
//     BuildContext context,
//   ) {
//     final iconColor = Theme.of(context).textTheme.button!.color;

//     return AnimatedOpacity(
//       opacity: notifier.hideStuff ? 0.0 : 1.0,
//       duration: const Duration(milliseconds: 300),
//       child: Container(
//         height: barHeight + (chewieController.isFullScreen ? 20.0 : 0),
//         padding:
//             EdgeInsets.only(bottom: chewieController.isFullScreen ? 10.0 : 15),
//         child: SafeArea(
//           bottom: chewieController.isFullScreen,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             verticalDirection: VerticalDirection.up,
//             children: [
//               Flexible(
//                 child: Row(
//                   children: <Widget>[
//                     _buildPlayPause(controller),
//                     _buildMuteButton(controller),
//                     if (chewieController.isLive)
//                       const Expanded(child: Text('LIVE'))
//                     else
//                       _buildPosition(iconColor),
//                     const Spacer(),
//                     if (chewieController.showControls &&
//                         chewieController.subtitle != null &&
//                         chewieController.subtitle!.isNotEmpty)
//                       _buildSubtitleToggle(icon: Icons.subtitles),
//                     if (chewieController.showOptions)
//                       _buildOptionsButton(icon: Icons.settings),
//                     if (chewieController.allowFullScreen) _buildExpandButton(),
//                   ],
//                 ),
//               ),
//               if (!chewieController.isLive)
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.only(
//                       right: 20,
//                       left: 20,
//                       bottom: chewieController.isFullScreen ? 5.0 : 0,
//                     ),
//                     child: Row(
//                       children: [
//                         _buildProgressBar(),
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildExpandButton() {
//     return Padding(
//       padding: const EdgeInsets.only(right: 12),
//       child: Container(
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         decoration: const BoxDecoration(shape: BoxShape.circle),
//         child: Material(
//           child: IconButton(
//             focusColor: Colors.blue,
//             onPressed: _onExpandCollapse,
//             padding: EdgeInsets.zero,
//             icon: AnimatedOpacity(
//               opacity: notifier.hideStuff ? 0.0 : 1.0,
//               duration: const Duration(milliseconds: 300),
//               child: Center(
//                 child: Icon(
//                   chewieController.isFullScreen
//                       ? Icons.fullscreen_exit
//                       : Icons.fullscreen,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRewindControl() {
//     return _buildSeekControls(
//       icon: Icons.fast_rewind,
//       pageAlignment: Alignment.centerLeft,
//       focusNode: _rewindFocusNode,
//       onPressed: () async {
//         await controller
//             .seekTo((await controller.position)! - const Duration(seconds: 10));
//         if (_rewindFocusNode.canRequestFocus) {
//           Future.delayed(const Duration(milliseconds: 200), () {
//             _rewindFocusNode.requestFocus();
//           });
//         }
//       },
//     );
//   }

//   Widget _buildForwardControl() {
//     return _buildSeekControls(
//       icon: Icons.fast_forward,
//       pageAlignment: Alignment.centerRight,
//       focusNode: _forwardFocusNode,
//       onPressed: () async {
//         await controller
//             .seekTo((await controller.position)! + const Duration(seconds: 10));
//         if (_forwardFocusNode.canRequestFocus) {
//           Future.delayed(const Duration(milliseconds: 200), () {
//             _forwardFocusNode.requestFocus();
//           });
//         }
//       },
//     );
//   }

//   Widget _buildSeekControls({
//     required Alignment pageAlignment,
//     required IconData icon,
//     VoidCallback? onPressed,
//     FocusNode? focusNode,
//   }) {
//     final bool showRewind = !_dragging && !notifier.hideStuff;
//     return Align(
//       alignment: pageAlignment,
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width / 2,
//         child: Center(
//           child: AnimatedOpacity(
//             opacity: showRewind ? 1.0 : 0.0,
//             duration: const Duration(milliseconds: 300),
//             child: Material(
//               color: Colors.transparent,
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: Colors.black54,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   // Always set the iconSize on the IconButton, not on the Icon itself:
//                   // https://github.com/flutter/flutter/issues/52980
//                   child: IconButton(
//                     iconSize: 32,
//                     focusColor: Colors.blue,
//                     focusNode: focusNode,
//                     icon: Icon(icon, color: Colors.white),
//                     onPressed: onPressed,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHitArea() {
//     final bool isFinished = _latestValue.position >= _latestValue.duration;
//     final bool showPlayButton =
//         widget.showPlayButton && !_dragging && !notifier.hideStuff;

//     return GestureDetector(
//       onTap: () {
//         if (_latestValue.isPlaying) {
//           if (_displayTapped) {
//             setState(() {
//               notifier.hideStuff = true;
//             });
//           } else {
//             _cancelAndRestartTimer();
//           }
//         } else {
//           _playPause();

//           setState(() {
//             notifier.hideStuff = true;
//           });
//         }
//       },
//       child: CenterPlayButton1(
//         backgroundColor: Colors.black54,
//         iconColor: Colors.white,
//         isFinished: isFinished,
//         isPlaying: controller.value.isPlaying,
//         show: showPlayButton,
//         onPressed: _playPause,
//       ),
//     );
//   }

//   Future<void> _onSpeedButtonTap() async {
//     _hideTimer?.cancel();

//     final chosenSpeed = await showModalBottomSheet<double>(
//       context: context,
//       isScrollControlled: true,
//       useRootNavigator: chewieController.useRootNavigator,
//       builder: (context) => PlaybackSpeedDialog(
//         speeds: chewieController.playbackSpeeds,
//         selected: _latestValue.playbackSpeed,
//       ),
//     );

//     if (chosenSpeed != null) {
//       controller.setPlaybackSpeed(chosenSpeed);
//     }

//     if (_latestValue.isPlaying) {
//       _startHideTimer();
//     }
//   }

//   Widget _buildMuteButton(
//     VideoPlayerController controller,
//   ) {
//     return Container(
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       decoration: const BoxDecoration(shape: BoxShape.circle),
//       child: Material(
//         child: IconButton(
//           onPressed: () {
//             _cancelAndRestartTimer();

//             if (_latestValue.volume == 0) {
//               controller.setVolume(_latestVolume ?? 0.5);
//             } else {
//               _latestVolume = controller.value.volume;
//               controller.setVolume(0.0);
//             }
//           },
//           focusColor: Colors.blue,
//           padding: EdgeInsets.zero,
//           icon: AnimatedOpacity(
//             opacity: notifier.hideStuff ? 0.0 : 1.0,
//             duration: const Duration(milliseconds: 300),
//             child: Icon(
//               _latestValue.volume > 0 ? Icons.volume_up : Icons.volume_off,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPlayPause(VideoPlayerController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12),
//       child: Container(
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         decoration: const BoxDecoration(shape: BoxShape.circle),
//         child: Material(
//           child: IconButton(
//             focusColor: Colors.blue,
//             onPressed: _playPause,
//             padding: EdgeInsets.zero,
//             icon: AnimatedPlayPause(
//               playing: controller.value.isPlaying,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPosition(Color? iconColor) {
//     final position = _latestValue.position;
//     final duration = _latestValue.duration;

//     return Text(
//       '${formatDuration(position)} / ${formatDuration(duration)}',
//       style: const TextStyle(
//         fontSize: 14.0,
//         color: Colors.white,
//       ),
//     );
//   }

//   void _onSubtitleTap() {
//     setState(() {
//       _subtitleOn = !_subtitleOn;
//     });
//   }

//   void _cancelAndRestartTimer() {
//     _hideTimer?.cancel();
//     _startHideTimer();

//     setState(() {
//       notifier.hideStuff = false;
//       _displayTapped = true;
//     });
//   }

//   void _cancelTimer() {
//     _hideTimer?.cancel();

//     setState(() {
//       notifier.hideStuff = false;
//       _displayTapped = true;
//     });
//   }

//   Future<void> _initialize() async {
//     _subtitleOn = chewieController.subtitle?.isNotEmpty ?? false;
//     controller.addListener(_updateState);

//     _updateState();

//     if (controller.value.isPlaying || chewieController.autoPlay) {
//       _startHideTimer();
//     }

//     if (chewieController.showControlsOnInitialize) {
//       _initTimer = Timer(const Duration(milliseconds: 200), () {
//         setState(() {
//           notifier.hideStuff = false;
//         });
//       });
//     }
//   }

//   void _onExpandCollapse() {
//     setState(() {
//       notifier.hideStuff = true;

//       chewieController.toggleFullScreen();
//       _showAfterExpandCollapseTimer =
//           Timer(const Duration(milliseconds: 300), () {
//         setState(() {
//           _cancelAndRestartTimer();
//         });
//       });
//     });
//   }

//   void _playPause() {
//     final isFinished = _latestValue.position >= _latestValue.duration;

//     setState(() {
//       if (controller.value.isPlaying) {
//         notifier.hideStuff = false;
//         _hideTimer?.cancel();
//         controller.pause();
//       } else {
//         _cancelAndRestartTimer();

//         if (!controller.value.isInitialized) {
//           controller.initialize().then((_) {
//             controller.play();
//           });
//         } else {
//           if (isFinished) {
//             controller.seekTo(Duration.zero);
//           }
//           controller.play();
//         }
//       }
//     });
//   }

//   void _startHideTimer() {
//     final hideControlsTimer = chewieController.hideControlsTimer.isNegative
//         ? ChewieController.defaultHideControlsTimer
//         : chewieController.hideControlsTimer;
//     _hideTimer = Timer(hideControlsTimer, () {
//       setState(() {
//         notifier.hideStuff = true;
//       });
//     });
//   }

//   void _updateState() {
//     if (!mounted) return;
//     setState(() {
//       _latestValue = controller.value;
//       _subtitlesPosition = controller.value.position;
//     });
//   }

//   Widget _buildProgressBar() {
//     return Expanded(
//       child: MaterialVideoProgressBar1(
//         controller,
//         onDragStart: () {
//           setState(() {
//             _dragging = true;
//           });

//           _hideTimer?.cancel();
//         },
//         onDragEnd: () {
//           setState(() {
//             _dragging = false;
//           });

//           _startHideTimer();
//         },
//         colors: chewieController.materialProgressColors ??
//             ChewieProgressColors(
//               playedColor: Colors.blue,
//               handleColor: Colors.blue,
//               bufferedColor: Theme.of(context).backgroundColor.withOpacity(0.5),
//               backgroundColor: Theme.of(context).disabledColor.withOpacity(.5),
//             ),
//       ),
//     );
//   }
// }

// class CenterPlayButton1 extends StatelessWidget {
//   const CenterPlayButton1({
//     Key? key,
//     required this.backgroundColor,
//     this.iconColor,
//     required this.show,
//     required this.isPlaying,
//     required this.isFinished,
//     this.onPressed,
//   }) : super(key: key);

//   final Color backgroundColor;
//   final Color? iconColor;
//   final bool show;
//   final bool isPlaying;
//   final bool isFinished;
//   final VoidCallback? onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: AnimatedOpacity(
//         opacity: show ? 1.0 : 0.0,
//         duration: const Duration(milliseconds: 300),
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             decoration: const BoxDecoration(
//               color: Colors.black54,
//               shape: BoxShape.circle,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),

//               // Always set the iconSize on the IconButton, not on the Icon itself:
//               // https://github.com/flutter/flutter/issues/52980
//               child: IconButton(
//                 focusColor: Colors.blue,
//                 iconSize: 32,
//                 icon: isFinished
//                     ? Icon(Icons.replay, color: iconColor)
//                     : AnimatedPlayPause(
//                         color: iconColor,
//                         playing: isPlaying,
//                       ),
//                 onPressed: onPressed,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MaterialVideoProgressBar1 extends StatelessWidget {
//   MaterialVideoProgressBar1(
//     this.controller, {
//     this.height = kToolbarHeight,
//     ChewieProgressColors? colors,
//     this.onDragEnd,
//     this.onDragStart,
//     this.onDragUpdate,
//     Key? key,
//   })  : colors = colors ?? ChewieProgressColors(),
//         super(key: key);

//   final double height;
//   final VideoPlayerController controller;
//   final ChewieProgressColors colors;
//   final Function()? onDragStart;
//   final Function()? onDragEnd;
//   final Function()? onDragUpdate;

//   @override
//   Widget build(BuildContext context) {
//     return VideoProgressBar1(
//       controller,
//       barHeight: 10,
//       handleHeight: 6,
//       drawShadow: true,
//       colors: colors,
//       onDragEnd: onDragEnd,
//       onDragStart: onDragStart,
//       onDragUpdate: onDragUpdate,
//     );
//   }
// }

// class VideoProgressBar1 extends StatefulWidget {
//   VideoProgressBar1(
//     this.controller, {
//     ChewieProgressColors? colors,
//     this.onDragEnd,
//     this.onDragStart,
//     this.onDragUpdate,
//     Key? key,
//     required this.barHeight,
//     required this.handleHeight,
//     required this.drawShadow,
//   })  : colors = colors ?? ChewieProgressColors(),
//         super(key: key);

//   final VideoPlayerController controller;
//   final ChewieProgressColors colors;
//   final Function()? onDragStart;
//   final Function()? onDragEnd;
//   final Function()? onDragUpdate;

//   final double barHeight;
//   final double handleHeight;
//   final bool drawShadow;

//   @override
//   // ignore: library_private_types_in_public_api
//   _VideoProgressBarState1 createState() {
//     return _VideoProgressBarState1();
//   }
// }

// class _VideoProgressBarState1 extends State<VideoProgressBar1> {
//   void listener() {
//     if (!mounted) return;
//     setState(() {});
//   }

//   bool _controllerWasPlaying = false;

//   VideoPlayerController get controller => widget.controller;

//   @override
//   void initState() {
//     super.initState();
//     controller.addListener(listener);
//   }

//   @override
//   void deactivate() {
//     controller.removeListener(listener);
//     super.deactivate();
//   }

//   void _seekToRelativePosition(Offset globalPosition) {
//     final box = context.findRenderObject()! as RenderBox;
//     final Offset tapPos = box.globalToLocal(globalPosition);
//     final double relative = tapPos.dx / box.size.width;
//     final Duration position = controller.value.duration * relative;
//     controller.seekTo(position);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onHorizontalDragStart: (DragStartDetails details) {
//         if (!controller.value.isInitialized) {
//           return;
//         }
//         _controllerWasPlaying = controller.value.isPlaying;
//         if (_controllerWasPlaying) {
//           controller.pause();
//         }

//         widget.onDragStart?.call();
//       },
//       onHorizontalDragUpdate: (DragUpdateDetails details) {
//         if (!controller.value.isInitialized) {
//           return;
//         }
//         _seekToRelativePosition(details.globalPosition);

//         widget.onDragUpdate?.call();
//       },
//       onHorizontalDragEnd: (DragEndDetails details) {
//         if (_controllerWasPlaying) {
//           controller.play();
//         }

//         widget.onDragEnd?.call();
//       },
//       onTapDown: (TapDownDetails details) {
//         if (!controller.value.isInitialized) {
//           return;
//         }
//         _seekToRelativePosition(details.globalPosition);
//       },
//       child: Center(
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           color: Colors.transparent,
//           child: CustomPaint(
//             painter: _ProgressBarPainter(
//               value: controller.value,
//               colors: widget.colors,
//               barHeight: widget.barHeight,
//               handleHeight: widget.handleHeight,
//               drawShadow: widget.drawShadow,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ProgressBarPainter extends CustomPainter {
//   _ProgressBarPainter({
//     required this.value,
//     required this.colors,
//     required this.barHeight,
//     required this.handleHeight,
//     required this.drawShadow,
//   });

//   VideoPlayerValue value;
//   ChewieProgressColors colors;

//   final double barHeight;
//   final double handleHeight;
//   final bool drawShadow;

//   @override
//   bool shouldRepaint(CustomPainter painter) {
//     return true;
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     final baseOffset = size.height / 2 - barHeight / 2;

//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromPoints(
//           Offset(0.0, baseOffset),
//           Offset(size.width, baseOffset + barHeight),
//         ),
//         const Radius.circular(4.0),
//       ),
//       colors.backgroundPaint,
//     );
//     if (!value.isInitialized) {
//       return;
//     }
//     final double playedPartPercent =
//         value.position.inMilliseconds / value.duration.inMilliseconds;
//     final double playedPart =
//         playedPartPercent > 1 ? size.width : playedPartPercent * size.width;
//     for (final DurationRange range in value.buffered) {
//       final double start = range.startFraction(value.duration) * size.width;
//       final double end = range.endFraction(value.duration) * size.width;
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromPoints(
//             Offset(start, baseOffset),
//             Offset(end, baseOffset + barHeight),
//           ),
//           const Radius.circular(4.0),
//         ),
//         colors.bufferedPaint,
//       );
//     }
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromPoints(
//           Offset(0.0, baseOffset),
//           Offset(playedPart, baseOffset + barHeight),
//         ),
//         const Radius.circular(4.0),
//       ),
//       colors.playedPaint,
//     );

//     if (drawShadow) {
//       final Path shadowPath = Path()
//         ..addOval(
//           Rect.fromCircle(
//             center: Offset(playedPart, baseOffset + barHeight / 2),
//             radius: handleHeight,
//           ),
//         );

//       canvas.drawShadow(shadowPath, Colors.black, 0.2, false);
//     }

//     canvas.drawCircle(
//       Offset(playedPart, baseOffset + barHeight / 2),
//       handleHeight,
//       colors.handlePaint,
//     );
//   }
// }
