import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/eatery.dart';
import '../theme/app_theme.dart';
import '../utils/eatery_display.dart';
import 'glass_surface.dart';

class HomeReviewCard extends StatelessWidget {
  const HomeReviewCard({
    super.key,
    required this.eateryName,
    required this.rating,
    required this.reviewText,
    required this.userName,
    required this.onTap,
  });

  final String eateryName;
  final double rating;
  final String reviewText;
  final String? userName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final snippet = reviewSnippet(reviewText, maxLen: 140) ?? reviewText;

    return SizedBox(
      width: 280,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: GlassSurface(
            borderRadius: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.rust, size: 16),
                    const SizedBox(width: 4),
                    Text(rating.toStringAsFixed(1), style: Theme.of(context).textTheme.labelLarge),
                    const Spacer(),
                    if (userName != null)
                      Text(userName!, style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(eateryName, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(
                    snippet,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeMustTryCard extends StatelessWidget {
  const HomeMustTryCard({super.key, required this.eatery, required this.onTap, this.highlight = false});

  final Eatery eatery;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final mt = mustTryItem(eatery);
    if (mt == null) return const SizedBox.shrink();

    return SizedBox(
      width: 200,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(18),
          child: GlassSurface(
            borderRadius: 18,
            tintOpacity: highlight ? 0.88 : AppColors.glassTintOpacity,
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: SizedBox(
                    height: 88,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (eatery.coverPhotoUrl != null)
                          CachedNetworkImage(
                            imageUrl: eatery.coverPhotoUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_, _) => ColoredBox(color: AppColors.coffeeBrown.withValues(alpha: 0.08)),
                            errorWidget: (_, _, _) => Image.asset(
                              'assets/backgrounds/karachi_food_street.jpg',
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Image.asset('assets/backgrounds/karachi_food_street.jpg', fit: BoxFit.cover),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.inkBrown.withValues(alpha: 0.55),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        if (highlight)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.rust.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'For you',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.paper),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm + 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eatery.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mt.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.darkGreen),
                      ),
                      if (mt.price > 0) ...[
                        const SizedBox(height: 2),
                        Text(
                          formatRs(mt.price),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.coffeeBrown),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
