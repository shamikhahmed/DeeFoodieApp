import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/providers.dart';
import '../theme/app_theme.dart';

/// Subtle offline indicator — not a full-width banner.
class DemoModeBanner extends ConsumerWidget {
  const DemoModeBanner({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDemo = ref.watch(demoModeActiveProvider);
    if (!isDemo) return const SizedBox.shrink();

    if (compact) {
      return Semantics(
        label: 'Offline demo mode',
        child: Tooltip(
          message: 'Using bundled Karachi archive',
          child: Icon(Icons.cloud_off_rounded, size: 16, color: AppColors.coffeeBrown.withValues(alpha: 0.7)),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.coffeeBrown.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.coffeeBrown.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off_rounded, size: 14, color: AppColors.coffeeBrown.withValues(alpha: 0.85)),
              const SizedBox(width: 6),
              Text('Offline archive', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.coffeeBrown, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
