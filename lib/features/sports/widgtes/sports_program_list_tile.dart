import "package:flutter/material.dart";

import "../../../core/constants/colors.dart";
import "../../../core/utilities/design_utility.dart";

class SportsProgramListTile extends StatelessWidget {
  const SportsProgramListTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
    this.autofocus = false,
    this.onFocused,
  });

  final String title;
  final VoidCallback onTap;
  final IconData icon;
  final bool autofocus;
  final VoidCallback? onFocused;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      focusColor: Colors.white,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      autofocus: autofocus,
      onFocusChange: (isFocused) {
        if (isFocused) {
          onFocused?.call();
        }
      },
      child: Builder(builder: (context) {
        final isFocused = Focus.of(context).hasPrimaryFocus;
        return Container(
          decoration: BoxDecoration(
            color: isFocused ? Colors.white : Colors.transparent,
            border: const Border(
              left: BorderSide(
                color: kBackgroundColor,
                width: 1.5,
              ),
              right: BorderSide(
                color: kBackgroundColor,
                width: 1.5,
              ),
            ),
          ),
          height: 40,
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(icon, color: isFocused ? kPrimaryAccentColor : null),
              horizontalSpaceRegular,
              Text(
                title,
                style: TextStyle(
                  color: isFocused ? Colors.black : null,
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
