import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../providers/profile_prefs_provider.dart';
import '../theme/app_theme.dart';

class PioneerBadge extends ConsumerWidget {
  const PioneerBadge({super.key, required this.eateryId});

  final String eateryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(userProfileProvider);
    final visits = ref.watch(visitsProvider).asData?.value ?? [];
    final mine = visits.where((v) => v.eateryId == eateryId).toList();
    if (mine.isEmpty) return const SizedBox.shrink();

    mine.sort((a, b) => a.date.compareTo(b.date));
    final allForEatery = visits.where((v) => v.eateryId == eateryId).toList()..sort((a, b) => a.date.compareTo(b.date));
    final first = allForEatery.first;
    final isPioneer = first.userName == profile.displayName || first.userName == 'You';
    if (!isPioneer) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Chip(
        avatar: const Icon(Icons.flag_outlined, size: 16, color: AppColors.rust),
        label: Text(l10n.pioneerBadge),
        backgroundColor: AppColors.rust.withValues(alpha: 0.12),
        labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.rust, fontWeight: FontWeight.w700),
      ),
    );
  }
}
