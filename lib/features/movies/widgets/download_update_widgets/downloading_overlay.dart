import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/extensions/context_extension.dart';

import '../../../../core/utilities/design_utility.dart';
import '../../controllers/update_dowload_providers/update_download_info_provider.dart';

class DownloadingOverlay extends StatelessWidget {
  const DownloadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer(builder: (context, ref, child) {
          return CircularProgressIndicator(
              value: ref.watch(updateDownloadPercentageProvider));
        }),
        horizontalSpaceRegular,
        Text(context.localisations.downloadingApplication),
      ],
    );
  }
}
