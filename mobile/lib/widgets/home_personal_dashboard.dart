import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' show FontFeature;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/archive_merge.dart';
import '../utils/eatery_display.dart';

/// Premium journal dashboard tiles on Home (P-DFD-1 / DFD-P1-02).
class HomePersonalDashboard extends StatelessWidget {
  const HomePersonalDashboard({
    super.key,
    required this.stats,
    required this.onJournalTap,
    this.onPassportTap,
    this.archiveEateryCount,
  });

  final PersonalStats stats;
  final VoidCallback onJournalTap;
  final VoidCallback? onPassportTap;
  final int? archiveEateryCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final countFmt = NumberFormat.decimalPattern();
    final archiveLine = archiveEateryCount != null
        ? l10n.homeArchiveCount(countFmt.format(archiveEateryCount))
        : '${stats.visitCount} visits · ${stats.uniqueEateries} places';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inkBrown.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.inkBrown.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // One Caveat decorative heading per screen (DFD-P1-01).
                    Text(
                      l10n.homeDashboardTitle,
                      style: GoogleFonts.caveat(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkBrown,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      archiveLine,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: onJournalTap,
                child: Text(l10n.homeSeeAll, style: Theme.of(context).textTheme.labelLarge),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 340;
              final tiles = [
                _DashTile(
                  icon: CupertinoIcons.location_solid,
                  value: countFmt.format(stats.uniqueEateries),
                  label: l10n.homeDashboardPlaces,
                  accent: AppColors.rust,
                ),
                _DashTile(
                  icon: CupertinoIcons.book_solid,
                  value: countFmt.format(stats.visitCount),
                  label: l10n.homeDashboardVisits,
                  accent: AppColors.coffeeBrown,
                ),
                _DashTile(
                  icon: CupertinoIcons.money_dollar_circle_fill,
                  value: stats.totalSpent > 0 ? formatRs(stats.totalSpent) : '—',
                  label: l10n.homeDashboardSpent,
                  accent: AppColors.darkGreen,
                ),
                _DashTile(
                  icon: CupertinoIcons.map_pin_ellipse,
                  value: countFmt.format(stats.areasVisited),
                  label: l10n.homeDashboardAreas,
                  accent: AppColors.coffeeBrown,
                  onTap: onPassportTap,
                ),
              ];

              if (narrow) {
                return Column(
                  children: [
                    for (var i = 0; i < tiles.length; i += 2) ...[
                      if (i > 0) const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(child: tiles[i]),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(child: tiles[i + 1]),
                        ],
                      ),
                    ],
                  ],
                );
              }
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: tiles[0]),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: tiles[1]),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(child: tiles[2]),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: tiles[3]),
                    ],
                  ),
                ],
              );
            },
          ),
          if (stats.visitCount > 0) ...[
            const SizedBox(height: AppSpacing.md),
            Divider(height: 1, color: AppColors.inkBrown.withValues(alpha: 0.08)),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.homeDashboardAvgBill(stats.avgPerVisit > 0 ? formatRs(stats.avgPerVisit) : '—'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.rust, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      stats.avgRating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                    ),
                    const SizedBox(width: 6),
                    Text(l10n.homeDashboardAvgRating, style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DashTile extends StatelessWidget {
  const _DashTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.accent,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $value',
      button: onTap != null,
      child: Material(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 72),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm + 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 20, color: accent, semanticLabel: label),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
