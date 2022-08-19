import 'package:flutter/material.dart';

class DefaultAppPadding extends StatelessWidget {
  const DefaultAppPadding({
    Key? key,
    this.child,
    this.padding,
  })  : onlyVertical = false,
        onlyHorizontal = false,
        super(key: key);

  const DefaultAppPadding.vertical({
    Key? key,
    this.child,
  })  : onlyVertical = true,
        onlyHorizontal = false,
        padding = null,
        super(key: key);

  const DefaultAppPadding.horizontal({
    Key? key,
    this.child,
  })  : onlyVertical = false,
        onlyHorizontal = true,
        padding = null,
        super(key: key);

  final Widget? child;
  final bool onlyVertical;
  final bool onlyHorizontal;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    EdgeInsets cusPadding = padding ?? EdgeInsets.zero;
    if (padding == null) {
      if (onlyHorizontal) {
        cusPadding = const EdgeInsets.symmetric(horizontal: 24);
      } else if (onlyVertical) {
        cusPadding = const EdgeInsets.symmetric(vertical: 24);
      } else {
        cusPadding = const EdgeInsets.all(24);
      }
    }
    return Padding(
      padding: cusPadding,
      child: child,
    );
  }
}
