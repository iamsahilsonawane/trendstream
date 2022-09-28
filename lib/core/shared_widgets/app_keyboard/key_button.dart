import 'package:flutter/material.dart';

class KeyboardKeyButton extends StatefulWidget {
  final Function? onPressed;
  final Widget label;
  final Color? borderColor;
  final Color? buttonColor;
  final Color? focusColor;
  final bool? autofocus;

  const KeyboardKeyButton({
    super.key,
    required this.label,
    this.onPressed,
    this.autofocus,
    this.borderColor,
    this.focusColor,
    this.buttonColor,
  });

  @override
  KeyboardKeyButtonState createState() => KeyboardKeyButtonState();
}

class KeyboardKeyButtonState extends State<KeyboardKeyButton> {
  FocusNode? _node;

  @override
  void initState() {
    _node = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      highlightElevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      autofocus: widget.autofocus ?? false,
      fillColor: widget.buttonColor,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: widget.borderColor != null
              ? BorderSide(color: widget.borderColor!)
              : BorderSide.none),
      elevation: 0,
      focusColor: widget.focusColor ?? widget.focusColor,
      focusNode: _node,
      padding: EdgeInsets.zero,
      onPressed: () {
        widget.onPressed!();
      },
      child: Align(
        alignment: Alignment.center,
        child: FittedBox(child: widget.label),
      ),
    );
  }
}
