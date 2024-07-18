import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/features/sports/controllers/current_focused_program_controller.dart';
import 'package:latest_movies/features/sports/views/sports_view.dart';

class CurrentSportsDetails extends ConsumerWidget {
  const CurrentSportsDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusedEvent = ref.watch(currentFocusedEventController);

    if (focusedEvent == null) {
      return const Center(
        child: Text("Focus on an event to see details"),
      );
    }

    return Row(
      children: [
        Image.network(
          focusedEvent.poster!,
          height: 100,
        ),
        horizontalSpaceRegular,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                focusedEvent.name ?? "N/A",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, color: kPrimaryAccentColor),
              ),
              verticalSpaceSmall,
              Text(
                focusedEvent.category?.name ?? "N/A",
                style: textTheme(context)
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              verticalSpaceTiny,
              Text(
                  "${DateFormat("dd MMM, yyyy").format(focusedEvent.eventDate!)} at ${DateFormat("HH:mm a").format(focusedEvent.eventDate!)}"),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          height: 100,
          // child: AspectRatio(
          //   aspectRatio: 16 / 9,
          //   child: SizedBox.expand(
          //     child: ColoredBox(color: Colors.black),
          //   ),
          // ),
          child: LivePreviewPlayer(
            onControllerInitialized: (controller) {
              // previewController = controller;
            },
          ),
        ),
      ],
    );
  }
}
