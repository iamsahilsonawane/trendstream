import 'package:flutter/material.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';

class LoadingOverlay {
  BuildContext _context;

  Future<void> hide() async {
    Navigator.of(_context).pop();
  }

  bool get isOpen {
    return ModalRoute.of(_context)?.isCurrent != true;
  }

  void show({required String text}) {
    showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            _FullScreenLoaderWithText(text: text));
  }

  void showWithCustomChild({required Widget child}) {
    showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            _FullScreenLoaderWithText.customChild(child: child));
  }

  Future<T> during<T>(Future<T> future, {required String text}) {
    show(text: text);
    return future.whenComplete(() => hide());
  }

  LoadingOverlay._create(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._create(context);
  }
}

class _FullScreenLoaderWithText extends StatelessWidget {
  const _FullScreenLoaderWithText({Key? key, required this.text})
      : child = null,
        super(key: key);
  const _FullScreenLoaderWithText.customChild({Key? key, required this.child})
      : text = "",
        super(key: key);

  final String text;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: kBackgroundColor,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          constraints: const BoxConstraints(maxWidth: 400),
          child: child ??
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  horizontalSpaceMedium,
                  Text(text,
                      style: const TextStyle(fontSize: 18, color: Colors.black))
                ],
              ),
        ),
      ),
    );
  }
}
