import 'package:flutter/material.dart';

class FocusWidget extends StatefulWidget {
  final Widget child;
  final bool? autofocus;
  final Function(bool hasFocus)? hasFocus;
  final Function(RawKeyEvent event) event;

  const FocusWidget({Key? key, 
    required this.child,
    required this.event,
    this.autofocus,
    this.hasFocus,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FocusWidgetState createState() => _FocusWidgetState();
}

class _FocusWidgetState extends State<FocusWidget> {
  final FocusNode fn = FocusNode();

  @override
  void initState() {
    super.initState();
    fn.addListener(() {
      widget.hasFocus?.call(fn.hasFocus);
    });
  }

  @override
  void dispose() {
    fn.removeListener(() {});
    fn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: widget.autofocus ?? false,
      focusNode: fn,
      onKey: (event) {
        widget.event.call(event);
      },
      child: widget.child,
    );
  }
}