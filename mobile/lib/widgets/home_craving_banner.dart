import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../constants/food_visuals.dart';
import 'food_photo_orb.dart';
import 'glass_surface.dart';

class HomeCravingBanner extends StatelessWidget {
  const HomeCravingBanner({
    super.key,
    required this.craving,
    required this.matchCount,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
  });

  final String craving;
  final int matchCount;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final photo = cravingPhoto(craving);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: [
                AppColors.rust.withValues(alpha: 0.35),
                AppColors.coffeeBrown.withValues(alpha: 0.2),
                AppColors.darkGreen.withValues(alpha: 0.25),
              ],
            ),
          ),
          padding: const EdgeInsets.all(2),
          child: GlassSurface(
            borderRadius: 20,
            tintOpacity: 0.82,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.inkBrown.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: FoodPhotoOrb(url: photo, size: 56, borderWidth: 2),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$matchCount',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.darkGreen),
                    ),
                    Text(actionLabel, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.coffeeBrown)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
