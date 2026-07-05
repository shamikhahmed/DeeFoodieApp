import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../providers/food_passport_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/journal_screen_shell.dart';
import '../widgets/content_sheet.dart';
import '../widgets/glass_surface.dart';

class FoodPassportScreen extends ConsumerWidget {
  const FoodPassportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final passport = ref.watch(foodPassportProvider);

    return JournalScreenShell(
      title: l10n.passportTitle,
      subtitle: l10n.passportSubtitle,
      body: passport.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.coffeeBrown)),
        error: (_, _) => Center(child: Text(l10n.errorExplore)),
        data: (data) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, 0, AppSpacing.screenPadding, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ContentSheet(
                child: Column(
                  children: [
                    Text(l10n.passportSubtitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: (data.karachiScorePct / 100).clamp(0.0, 1.0),
                            strokeWidth: 8,
                            backgroundColor: AppColors.coffeeBrown.withValues(alpha: 0.12),
                            color: AppColors.darkGreen,
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${data.karachiScorePct}%', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.darkGreen)),
                                Text(l10n.homeKarachiScore, style: Theme.of(context).textTheme.labelSmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.passportProgress(data.areasVisited, data.totalAreas),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(l10n.passportVisitCount(data.totalVisits), style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.passportStamps, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 1.05,
                ),
                itemCount: data.stamps.length,
                itemBuilder: (context, i) {
                  final stamp = data.stamps[i];
                  return _StampCard(
                    stamp: stamp,
                    onTap: stamp.visited
                        ? () {
                            ref.read(eateryFilterProvider.notifier).toggleArea(stamp.areaName);
                            context.push('/area/${Uri.encodeComponent(stamp.areaName)}');
                          }
                        : () {
                            ref.read(eateryFilterProvider.notifier).toggleArea(stamp.areaName);
                            context.go('/explore');
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StampCard extends StatelessWidget {
  const _StampCard({required this.stamp, required this.onTap});

  final AreaStamp stamp;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(18),
        child: GlassSurface(
          borderRadius: 18,
          tintOpacity: stamp.visited ? 0.88 : 0.82,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: stamp.visited ? AppColors.darkGreen.withValues(alpha: 0.15) : AppColors.coffeeBrown.withValues(alpha: 0.08),
                      border: Border.all(
                        color: stamp.visited ? AppColors.darkGreen : AppColors.coffeeBrown.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      stamp.visited ? CupertinoIcons.checkmark_seal_fill : CupertinoIcons.map_pin,
                      size: 18,
                      color: stamp.visited ? AppColors.darkGreen : AppColors.coffeeBrown,
                    ),
                  ),
                  const Spacer(),
                  if (stamp.visited)
                    Text('${stamp.visitCount}', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.rust)),
                ],
              ),
              const Spacer(),
              Text(stamp.areaName, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleSmall),
              Text(
                stamp.visited ? l10n.passportStampVisited(stamp.eateryCount) : l10n.passportStampLocked(stamp.eateryCount),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: stamp.visited ? AppColors.textSecondary : AppColors.textMuted,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
