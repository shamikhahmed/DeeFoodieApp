import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/eatery.dart';
import '../theme/app_theme.dart';
import '../utils/eatery_display.dart';
import 'glass_surface.dart';

class HomeSpotlightCard extends StatelessWidget {
  const HomeSpotlightCard({
    super.key,
    required this.eatery,
    required this.subtitle,
    required this.onTap,
  });

  final Eatery eatery;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(22),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (eatery.coverPhotoUrl != null)
                  CachedNetworkImage(imageUrl: eatery.coverPhotoUrl!, fit: BoxFit.cover)
                else
                  Image.asset('assets/backgrounds/karachi_food_street.jpg', fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.inkBrown.withValues(alpha: 0.85),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlassSurface(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        borderRadius: 10,
                        tintOpacity: 0.5,
                        child: Text(subtitle, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.paper)),
                      ),
                      const Spacer(),
                      Text(
                        eatery.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.paper),
                      ),
                      if (eatery.areaName != null)
                        Text(
                          eatery.areaName!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.paper.withValues(alpha: 0.85)),
                        ),
                      if (hasDisplayRating(eatery)) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.rust, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              displayRating(eatery).toStringAsFixed(1),
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.paper),
                            ),
                            if (eatery.visitCount > 0) ...[
                              const SizedBox(width: 6),
                              Text(
                                '· ${eatery.visitCount} visits',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.paper.withValues(alpha: 0.8)),
                              ),
                            ],
                          ],
                        ),
                      ],
                      if (mustTryItem(eatery) case final mt?) ...[
                        const SizedBox(height: 4),
                        Text(
                          mt.price > 0 ? 'Must try ${mt.name} · ${formatRs(mt.price)}' : 'Must try ${mt.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.paper.withValues(alpha: 0.9)),
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
