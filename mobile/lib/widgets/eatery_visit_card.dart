import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/visit.dart';
import '../theme/app_theme.dart';
import '../utils/eatery_display.dart';
import 'glass_surface.dart';

class EateryVisitCard extends StatelessWidget {
  const EateryVisitCard({super.key, required this.visit, required this.onTap});

  final Visit visit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final snippet = reviewSnippet(visit.reviewText, maxLen: 120);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: GlassSurface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.rust, size: 18),
                    const SizedBox(width: 4),
                    Text(visit.rating.toStringAsFixed(1), style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(width: AppSpacing.sm),
                    Text(_formatDate(visit.date), style: Theme.of(context).textTheme.labelSmall),
                    const Spacer(),
                    if (visit.userName != null)
                      Text(visit.userName!, style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
                if (visit.favoriteItem != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${l10n.eateryMustTry}: ${visit.favoriteItem}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.coffeeBrown),
                  ),
                ],
                if (snippet != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    snippet,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
                  ),
                ],
                if (visit.moodTags.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: visit.moodTags
                        .take(3)
                        .map(
                          (t) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.darkGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(t, style: Theme.of(context).textTheme.labelSmall),
                          ),
                        )
                        .toList(),
                  ),
                ],
                if (visit.totalBill != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${l10n.visitBill}: ${formatRs(visit.totalBill!)}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final d = DateTime.parse(iso);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${d.day} ${months[d.month - 1]} ${d.year}';
    } catch (_) {
      return iso;
    }
  }
}
