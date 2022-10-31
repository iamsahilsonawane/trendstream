import "package:flutter/material.dart";
import 'package:latest_movies/core/utilities/design_utility.dart';

class TvGuide extends StatefulWidget {
  const TvGuide({Key? key}) : super(key: key);

  @override
  State<TvGuide> createState() => _TvGuideState();
}

class _TvGuideState extends State<TvGuide> {
  final ScrollController _scrollController = ScrollController();

  int lastIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FocusTraversalGroup(
        child: FocusScope(
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    20,
                    (index) => Container(
                      width: 200,
                      height: 30,
                      color: Colors.grey[800],
                      child: Center(
                          child: Text(
                        "${index.toString().padLeft(2, '0')}:00",
                        style: const TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                ),
                verticalSpaceSmall,
                Row(
                  children: List.generate(
                    20,
                    (index) => Builder(builder: (context) {
                      return _Channel(
                        index: index,
                        onTap: () {},
                        onFocusChanged: () {
                          Scrollable.ensureVisible(context,
                              alignment: 0.5,
                              duration: const Duration(milliseconds: 400));
                        },
                      );
                    }),
                  ),
                ),
                verticalSpaceSmall,
                Row(
                  children: List.generate(
                    20,
                    (index) => Builder(builder: (context) {
                      return _Channel(
                        index: index,
                        onTap: () {},
                        onFocusChanged: () {
                          Scrollable.ensureVisible(context,
                              alignment: 0.5,
                              duration: const Duration(milliseconds: 400));
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Channel extends StatefulWidget {
  const _Channel({
    Key? key,
    required this.index,
    required this.onTap,
    required this.onFocusChanged,
  }) : super(key: key);

  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onFocusChanged;

  @override
  State<_Channel> createState() => _ChannelState();
}

class _ChannelState extends State<_Channel> {
  bool isFocused = false;

  void setIsFocused(bool value) {
    if (isFocused == value) return;
    setState(() => isFocused = value);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      focusColor: Colors.white,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      autofocus: widget.index == 0,
      onFocusChange: (value) {
        setIsFocused(value);
        widget.onFocusChanged?.call();
      },
      child: Builder(builder: (context) {
        // final isFocused = _focusNode.hasPrimaryFocus;
        return Container(
          width: 250,
          height: 70,
          color: isFocused ? Colors.white : Colors.grey[800],
          child: Center(
            child: Text(
              "${widget.index.toString().padLeft(2, '0')}:00",
              style: TextStyle(
                color: isFocused ? Colors.grey[800] : Colors.white,
              ),
            ),
          ),
        );
      }),
    );
  }
}
