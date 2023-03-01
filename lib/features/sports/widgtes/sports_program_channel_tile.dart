import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';

class SportsProgramChannelTile extends StatelessWidget {
  const SportsProgramChannelTile({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        border: Border(
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
      padding: const EdgeInsets.all(5),
      child: Center(
        child: Text(title),
      ),
    );
  }
}
