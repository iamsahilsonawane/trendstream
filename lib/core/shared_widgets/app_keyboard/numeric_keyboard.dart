library numeric_keyboard;

import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import 'key_button.dart';

typedef KeyboardTapCallback = void Function(String text);

class NumericKeyboard extends StatefulWidget {
  /// Color of the text [default = Colors.black]
  final Color textColor;

  /// Action to trigger when Done (check icon) button is pressed
  final Function()? onDoneTap;

  /// Whether to include the backspace button [default = true]
  final bool includeBackButton;

  /// Main axis alignment [default = MainAxisAlignment.spaceEvenly]
  final MainAxisAlignment mainAxisAlignment;

  /// Whether to autofocus the the first button [default = false]
  final bool autofocus;

  /// Callback to trigger when a key is pressed and returns the new value
  final Function(String value) onValueChanged;

  /// Max length of the characeters to be entered
  final int? maxLength;

  const NumericKeyboard(
      {Key? key,
      required this.onValueChanged,
      this.autofocus = false,
      this.textColor = Colors.black,
      this.onDoneTap,
      this.includeBackButton = true,
      this.maxLength,
      this.mainAxisAlignment = MainAxisAlignment.spaceEvenly})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NumericKeyboardState();
  }
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  late final controller = TextEditingController()..addListener(textListener);

  void textListener() {
    widget.onValueChanged(controller.text);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          ButtonBar(
            alignment: widget.mainAxisAlignment,
            children: <Widget>[
              _calcButton('1', widget.autofocus),
              _calcButton('2'),
              _calcButton('3'),
            ],
          ),
          ButtonBar(
            alignment: widget.mainAxisAlignment,
            children: <Widget>[
              _calcButton('4'),
              _calcButton('5'),
              _calcButton('6'),
            ],
          ),
          ButtonBar(
            alignment: widget.mainAxisAlignment,
            children: <Widget>[
              _calcButton('7'),
              _calcButton('8'),
              _calcButton('9'),
            ],
          ),
          ButtonBar(
            alignment: widget.mainAxisAlignment,
            children: <Widget>[
              if (widget.includeBackButton)
                InkWell(
                  borderRadius: BorderRadius.circular(45),
                  onTap: () {
                    if (controller.text.isNotEmpty) {
                      controller.text = controller.text
                          .substring(0, controller.text.length - 1);
                    }
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 40,
                      child: widget.includeBackButton
                          ? const Icon(Icons.backspace)
                          : null),
                )
              else
                const SizedBox(width: 50, height: 50),
              _calcButton('0'),
              if (widget.onDoneTap != null)
                InkWell(
                  borderRadius: BorderRadius.circular(45),
                  onTap: () {
                    widget.onDoneTap!.call();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 50,
                    height: 40,
                    child: const Icon(Icons.check),
                  ),
                )
              else
                const SizedBox(width: 50, height: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _calcButton(String value, [bool autofocus = false]) {
    return SizedBox(
      width: 50,
      height: 40,
      child: KeyboardKeyButton(
        autofocus: autofocus,
        buttonColor: kPrimaryColor.withOpacity(.2),
        label: Text(
          value,
          style: const TextStyle(fontSize: 25),
        ),
        onPressed: () {
          if (widget.maxLength != null
              ? controller.text.length < widget.maxLength!
              : true) {
            controller.text += value;
          }
        },
      ),
    );
  }
}
