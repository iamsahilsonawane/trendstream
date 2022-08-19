import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  })  : isPrimary = true,
        super(key: key);

  const AppButton.secondary({
    Key? key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  })  : isPrimary = false,
        super(key: key);

  final bool isPrimary;
  final bool isLoading;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: isPrimary ? Colors.grey[900] : Colors.white,
        padding: const EdgeInsets.all(24),
        onPrimary: !isPrimary ? Colors.black : null,
      ),
      child: isLoading
          ? Center(
              child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                valueColor: isPrimary
                    ? const AlwaysStoppedAnimation(Colors.white)
                    : AlwaysStoppedAnimation(Colors.grey[900]),
              ),
            ))
          : Text(
              text,
              style: TextStyle(color: isPrimary ? Colors.white : Colors.black),
            ),
    );
  }
}
