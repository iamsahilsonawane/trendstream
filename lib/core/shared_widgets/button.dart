import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.prefix,
    this.isLoading = false,
  }) : super(key: key);

  final bool isLoading;
  final String text;
  final Widget? prefix;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style:
          ElevatedButton.styleFrom(primary: const Color(0xFF1E365C)).copyWith(
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.focused)) {
              return const Color(0xFF1E365C).withOpacity(.7);
            }
            return const Color(0xFF1E365C);
          },
        ),
        side: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.focused)) {
              return const BorderSide(
                color: Colors.white,
              );
            }
            return const BorderSide(
              color: Color(0xFF1E365C),
            );
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
