import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required this.text,
    required this.onTap,
  })  : isPrimary = true,
        super(key: key);

  const AppButton.secondary({
    Key? key,
    required this.text,
    required this.onTap,
  })  : isPrimary = false,
        super(key: key);

  final bool isPrimary;
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
      child: Text(
        text,
        style: TextStyle(color: isPrimary ? Colors.white : Colors.black),
      ),
    );
  }
}
