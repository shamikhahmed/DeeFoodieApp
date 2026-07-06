import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../models/eatery.dart';
import '../providers/plan_tonight_provider.dart';
import '../theme/app_theme.dart';

class PlanTonightSheet extends ConsumerWidget {
  const PlanTonightSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => const PlanTonightSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final picks = ref.watch(planTonightProvider);
    final eateries = ref.watch(allEateriesProvider).asData?.value ?? [];
    final byId = {for (final e in eateries) e.id: e};

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.planTonightTitle, style: Theme.of(context).textTheme.titleLarge),
            Text(l10n.planTonightHint, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: AppSpacing.md),
            if (picks.isEmpty)
              Text(l10n.planTonightEmpty, style: Theme.of(context).textTheme.bodyMedium)
            else
              ...picks.map((id) {
                final e = byId[id];
                if (e == null) return const SizedBox.shrink();
                return ListTile(
                  title: Text(e.name),
                  subtitle: Text(e.areaName ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => ref.read(planTonightProvider.notifier).toggle(id),
                  ),
                );
              }),
            const SizedBox(height: AppSpacing.sm),
            FilledButton.icon(
              onPressed: picks.isEmpty ? null : () => _openMaps(picks.map((id) => byId[id]).whereType<Eatery>().toList()),
              icon: const Icon(Icons.map_outlined),
              label: Text(l10n.planTonightOpenMaps),
              style: FilledButton.styleFrom(backgroundColor: AppColors.coffeeBrown, foregroundColor: AppColors.paper),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMaps(List<Eatery> stops) async {
    if (stops.isEmpty) return;
    final first = stops.first;
    if (first.lat == null || first.lng == null) return;
    var url = 'https://maps.apple.com/?daddr=${first.lat},${first.lng}';
    if (stops.length > 1) {
      final last = stops.last;
      if (last.lat != null && last.lng != null) {
        url = 'https://maps.apple.com/?saddr=${first.lat},${first.lng}&daddr=${last.lat},${last.lng}';
      }
    }
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
