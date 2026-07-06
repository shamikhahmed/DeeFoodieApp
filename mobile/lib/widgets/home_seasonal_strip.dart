import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../constants/seasonal_collections.dart';
import '../theme/app_theme.dart';
import 'glass_surface.dart';

SeasonalCollection activeSeasonalCollection() {
  final month = DateTime.now().month;
  if (month == 3 || month == 4) {
    return seasonalCollections.firstWhere((c) => c.id == 'mango-season');
  }
  if (month >= 3 && month <= 4) {
    return seasonalCollections.firstWhere((c) => c.id == 'ramadan-iftar');
  }
  // Ramadan-ish window Mar–Apr; default iftar in spring months
  if (month >= 2 && month <= 4) {
    return seasonalCollections.firstWhere((c) => c.id == 'ramadan-iftar');
  }
  return seasonalCollections.firstWhere((c) => c.id == 'mango-season');
}

class HomeSeasonalStrip extends StatelessWidget {
  const HomeSeasonalStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final season = activeSeasonalCollection();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          context.push('/seasonal/${season.id}');
        },
        borderRadius: BorderRadius.circular(18),
        child: GlassSurface(
          borderRadius: 18,
          tintOpacity: 0.86,
          child: Row(
            children: [
              Text(season.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(season.title, style: Theme.of(context).textTheme.titleSmall),
                    Text(season.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.coffeeBrown),
            ],
          ),
        ),
      ),
    );
  }
}
