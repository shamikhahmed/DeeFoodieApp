import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_archive_prefs_provider.dart';
import '../theme/app_theme.dart';
import 'glass_surface.dart';

class HomeMoodStrip extends ConsumerWidget {
  const HomeMoodStrip({super.key, required this.title});

  final String title;

  static const _moods = ['Friends', 'Family', 'Late Night', 'Celebration', 'Alone'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _moods.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final mood = _moods[i];
              return ActionChip(
                label: Text(mood),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  ref.read(journalMoodFilterProvider.notifier).setFilter(mood);
                  context.go('/journal');
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
