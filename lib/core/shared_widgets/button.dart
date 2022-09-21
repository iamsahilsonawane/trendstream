import 'package:flutter/material.dart';
import 'package:latest_movies/core/constants/colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.prefix,
    this.isLoading = false,
    this.autofocus = false,
  }) : super(key: key);

  final bool isLoading;
  final String text;
  final Widget? prefix;
  final VoidCallback? onTap;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      autofocus: autofocus,
      onPressed: onTap,
      style: ElevatedButton.styleFrom(primary: kPrimaryColor).copyWith(
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.focused)) {
              return kPrimaryColor.withOpacity(.7);
            }
            return kPrimaryColor;
          },
        ),
        side: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.focused)) {
              return const BorderSide(
                color: Colors.white,
              );
            }
            return const BorderSide(color: kPrimaryColor);
          },
        ),
      ),
      child: isLoading
          ? const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white)),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (prefix != null) prefix!,
                const SizedBox(width: 10),
                Text(
                  text,
                ),
              ],
            ),
    );
  }
}
