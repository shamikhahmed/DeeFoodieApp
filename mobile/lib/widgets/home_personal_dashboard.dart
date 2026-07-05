import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/archive_merge.dart';
import '../utils/eatery_display.dart';

/// Premium journal dashboard tiles on Home.
class HomePersonalDashboard extends StatelessWidget {
  const HomePersonalDashboard({
    super.key,
    required this.stats,
    required this.onJournalTap,
    this.onPassportTap,
  });

  final PersonalStats stats;
  final VoidCallback onJournalTap;
  final VoidCallback? onPassportTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                    Text(
                      l10n.homeDashboardTitle,
                      style: GoogleFonts.fraunces(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: AppColors.inkBrown,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${stats.visitCount} visits · ${stats.uniqueEateries} places',
                      style: GoogleFonts.caveat(fontSize: 16, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              TextButton(onPressed: onJournalTap, child: Text(l10n.homeSeeAll, style: GoogleFonts.caveat(fontSize: 16))),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: _DashTile(icon: CupertinoIcons.location_solid, value: '${stats.uniqueEateries}', label: l10n.homeDashboardPlaces, accent: AppColors.rust)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _DashTile(icon: CupertinoIcons.book_solid, value: '${stats.visitCount}', label: l10n.homeDashboardVisits, accent: AppColors.coffeeBrown)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _DashTile(
                  icon: CupertinoIcons.money_dollar_circle,
                  value: stats.totalSpent > 0 ? formatRs(stats.totalSpent) : '—',
                  label: l10n.homeDashboardSpent,
                  accent: AppColors.darkGreen,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _DashTile(
                  icon: CupertinoIcons.map_pin_ellipse,
                  value: '${stats.areasVisited}',
                  label: l10n.homeDashboardAreas,
                  accent: AppColors.coffeeBrown,
                  onTap: onPassportTap,
                ),
              ),
            ],
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
                    style: GoogleFonts.caveat(fontSize: 15, color: AppColors.textSecondary),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.rust, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      stats.avgRating.toStringAsFixed(1),
                      style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.inkBrown),
                    ),
                    const SizedBox(width: 6),
                    Text(l10n.homeDashboardAvgRating, style: GoogleFonts.caveat(fontSize: 14, color: AppColors.textMuted)),
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
    return Material(
      color: accent.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm + 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: accent),
              const SizedBox(height: 8),
              Text(
                value,
                style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.inkBrown),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(label, style: GoogleFonts.caveat(fontSize: 14, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
