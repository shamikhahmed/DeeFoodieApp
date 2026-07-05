import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'food_photo_orb.dart';
import 'glass_surface.dart';

class HomeHero extends StatelessWidget {
  const HomeHero({
    super.key,
    required this.greeting,
    required this.appName,
    this.scoreLabel,
    this.karachiScorePct,
    this.subtitle,
    this.onScoreTap,
    this.accentPhotoUrl,
  });

  final String greeting;
  final String appName;
  final String? scoreLabel;
  final int? karachiScorePct;
  final String? subtitle;
  final VoidCallback? onScoreTap;
  final String? accentPhotoUrl;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      padding: const EdgeInsets.all(AppSpacing.md + 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(greeting, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 6),
                    Text(appName, style: Theme.of(context).textTheme.displayMedium),
                    if (subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
              if (accentPhotoUrl != null)
                FoodPhotoOrb(url: accentPhotoUrl!, size: 64),
            ],
          ),
          if (karachiScorePct != null) ...[
            const SizedBox(height: AppSpacing.md),
            if (scoreLabel != null)
              Text(scoreLabel!, style: Theme.of(context).textTheme.labelMedium),
            if (scoreLabel != null) const SizedBox(height: 8),
            GestureDetector(
              onTap: onScoreTap,
              child: _ScoreRing(pct: karachiScorePct!),
            ),
          ],
        ],
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.pct});

  final int pct;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 52,
          height: 52,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: (pct / 100).clamp(0.0, 1.0),
                strokeWidth: 5,
                backgroundColor: AppColors.coffeeBrown.withValues(alpha: 0.12),
                color: AppColors.darkGreen,
              ),
              Center(
                child: Text(
                  '$pct%',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            pct < 15
                ? 'Karachi is waiting — log a visit in a new area.'
                : pct < 40
                    ? 'Good start. More neighbourhoods to taste.'
                    : 'You\'re building a real city archive.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
