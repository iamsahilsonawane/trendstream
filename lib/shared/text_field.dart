import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    this.controller,
    this.prefixIcon,
    this.hintText,
    this.isPassword = true,
  }) : super(key: key);

  final TextEditingController? controller;
  final Widget? prefixIcon;
  final String? hintText;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[800],
          prefixIcon: const Icon(Icons.email),
          contentPadding: const EdgeInsets.all(14)),
    );
  }
}
