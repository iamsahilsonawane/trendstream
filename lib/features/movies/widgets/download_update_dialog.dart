import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/shared_widgets/button.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';

class DownloadUpdateDialog extends HookWidget {
  const DownloadUpdateDialog({super.key, required this.newUpdateVersion});

  final String newUpdateVersion;

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          focusNode.requestFocus();
        });
      });
      return null;
    }, []);
    return Dialog(
      backgroundColor: kBackgroundColor,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
                "There's an update available ($newUpdateVersion), do you want to update to latest version?"),
            verticalSpaceRegular,
            AppButton(
              text: "Yes, update",
              onTap: () {
                Navigator.pop(context, true);
              },
              prefix: const Icon(Icons.download_rounded),
              focusNode: focusNode,
            ),
            AppButton(
              text: "Not now",
              onTap: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
