import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:latest_movies/features/sports/controllers/sports_categories_provider.dart';
import 'package:latest_movies/features/sports/widgtes/sports_program_channel_tile.dart';

class CategorySelector extends ConsumerWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(sportsCategoryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return categoriesAsync.when(
      data: (categories) {
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length + 1,
          separatorBuilder: (context, _) => horizontalSpaceSmall,
          itemBuilder: (context, index) {
            if (index == 0) {
              return SportsProgramChannelTile(
                title: "All",
                isSelected: selectedCategory == null,
                onTap: () {
                  ref
                      .read(selectedCategoryProvider.notifier)
                      .update((state) => null);
                },
              );
            }

            final c = categories[index - 1];
            return SportsProgramChannelTile(
              title: c.name ?? "N/A",
              isSelected: selectedCategory == c,
              onTap: () {
                ref
                    .read(selectedCategoryProvider.notifier)
                    .update((state) => c);
              },
            );
          },
        );
      },
      error: (err, st) => const SizedBox.shrink(),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
