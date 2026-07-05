import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../providers/trails_provider.dart';
import '../constants/karachi_trails.dart';
import '../l10n/app_localizations.dart';
import '../router/navigation.dart';
import '../theme/app_theme.dart';
import '../providers/profile_prefs_provider.dart';
import '../widgets/trail_certificate_sheet.dart';
import '../widgets/journal_screen_shell.dart';
import '../widgets/content_sheet.dart';

class TrailProgress {
  const TrailProgress({
    required this.trail,
    required this.visitedCount,
    required this.totalCount,
    required this.visitedNames,
    required this.eateryIdsByName,
  });

  final KarachiTrail trail;
  final int visitedCount;
  final int totalCount;
  final Set<String> visitedNames;
  final Map<String, String> eateryIdsByName;

  double get pct => totalCount == 0 ? 0 : visitedCount / totalCount;
  bool get complete => visitedCount >= totalCount && totalCount > 0;
}

final trailProgressProvider = Provider<AsyncValue<List<TrailProgress>>>((ref) {
  final visits = ref.watch(visitsProvider);
  final eateries = ref.watch(allEateriesProvider);
  final trails = ref.watch(archiveTrailsProvider);

  return trails.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (trailList) => visits.when(
      loading: () => const AsyncValue.loading(),
      error: (e, st) => AsyncValue.error(e, st),
      data: (visitList) => eateries.when(
        loading: () => const AsyncValue.loading(),
        error: (e, st) => AsyncValue.error(e, st),
        data: (eateryList) {
          final visitedIds = visitList.map((v) => v.eateryId).toSet();
          final byName = {for (final e in eateryList) e.name.toLowerCase(): e};

          final progress = trailList.map((trail) {
            final idsByName = <String, String>{};
            final visitedNames = <String>{};
            for (final name in trail.eateryNames) {
              final e = byName[name.toLowerCase()];
              if (e != null) {
                idsByName[name] = e.id;
                if (visitedIds.contains(e.id)) visitedNames.add(name);
              }
            }
            return TrailProgress(
              trail: trail,
              visitedCount: visitedNames.length,
              totalCount: idsByName.length,
              visitedNames: visitedNames,
              eateryIdsByName: idsByName,
            );
          }).toList();
          return AsyncValue.data(progress);
        },
      ),
    ),
  );
});

class TrailsScreen extends ConsumerWidget {
  const TrailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final trails = ref.watch(trailProgressProvider);

    return JournalScreenShell(
      title: l10n.trailsTitle,
      body: trails.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.coffeeBrown)),
        error: (_, _) => Center(child: Text(l10n.errorExplore)),
        data: (list) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.md, AppSpacing.screenPadding, 120),
          itemCount: list.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, i) => _TrailCard(progress: list[i], l10n: l10n),
        ),
      ),
    );
  }
}

class _TrailCard extends ConsumerWidget {
  const _TrailCard({required this.progress, required this.l10n});

  final TrailProgress progress;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ContentSheet(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(progress.trail.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(progress.trail.name, style: Theme.of(context).textTheme.titleMedium)),
              if (progress.complete)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.darkGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text(l10n.trailsComplete, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.darkGreen)),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(progress.trail.description, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.pct.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.coffeeBrown.withValues(alpha: 0.12),
              color: AppColors.darkGreen,
            ),
          ),
          const SizedBox(height: 6),
          Text(l10n.trailsProgress(progress.visitedCount, progress.totalCount), style: Theme.of(context).textTheme.labelMedium),
          if (progress.complete) ...[
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () {
                final name = ref.read(userProfileProvider).displayName;
                TrailCertificateSheet.show(
                  context,
                  trail: progress.trail,
                  userName: name,
                  completedAt: DateTime.now().toIso8601String().split('T').first,
                );
              },
              icon: const Icon(Icons.workspace_premium_outlined),
              label: Text(l10n.trailCertificateShare),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          ...progress.trail.eateryNames.map((name) {
            final done = progress.visitedNames.contains(name);
            final eateryId = progress.eateryIdsByName[name];
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: eateryId == null
                      ? null
                      : () {
                          HapticFeedback.selectionClick();
                          openEatery(context, eateryId);
                        },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          done ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.circle,
                          size: 16,
                          color: done ? AppColors.darkGreen : AppColors.textMuted,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            name,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  decoration: done ? null : null,
                                  color: done ? AppColors.inkBrown : AppColors.textMuted,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
