import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    this.controller,
    this.prefixIcon,
    this.hintText,
    this.isPassword = false,
    this.validator,
    this.focusNode,
    this.onFieldSubmitted,
    this.onSaved,
    this.onEditingComplete,
  }) : super(key: key);

  final TextEditingController? controller;
  final Widget? prefixIcon;
  final String? hintText;
  final bool isPassword;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final Function(String?)? onSaved;
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[800],
        prefixIcon: prefixIcon,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      ),
    );
  }
}
