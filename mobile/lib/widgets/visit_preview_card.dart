import 'package:flutter/material.dart';
import '../models/visit.dart';
import '../theme/app_theme.dart';
import '../utils/eatery_display.dart';
import 'glass_surface.dart';

class VisitPreviewCard extends StatelessWidget {
  const VisitPreviewCard({
    super.key,
    required this.visit,
    this.onTap,
  });

  final Visit visit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final snippet = reviewSnippet(visit.reviewText, maxLen: 56);

    return SizedBox(
      width: 220,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: GlassSurface(
            padding: const EdgeInsets.all(AppSpacing.md),
            borderRadius: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.rust, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      visit.rating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(visit.date),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                if (visit.userName != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    visit.userName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: Text(
                    visit.eateryName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (visit.favoriteItem != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    visit.favoriteItem!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.coffeeBrown),
                  ),
                ],
                if (snippet != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    snippet,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.35),
                  ),
                ] else if (visit.moodTags.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.darkGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      visit.moodTags.first,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.darkGreen,
                          ),
                    ),
                  ),
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
      return '${months[d.month - 1]} ${d.day}';
    } catch (_) {
      return iso;
    }
  }
}
