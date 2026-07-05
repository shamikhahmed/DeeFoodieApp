import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/food_visuals.dart';
import '../theme/app_theme.dart';

class HomeAreaChips extends StatelessWidget {
  const HomeAreaChips({
    super.key,
    required this.areas,
    required this.onAreaTap,
    required this.title,
  });

  final List<String> areas;
  final ValueChanged<String> onAreaTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (areas.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        SizedBox(
          height: 52,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: areas.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, i) {
              final area = areas[i];
              final photo = areaPhoto(area);
              return Material(
                color: const Color(0xFFFFFDF8),
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onAreaTap(area);
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(6, 6, 14, 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.inkBrown.withValues(alpha: 0.16)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: CachedNetworkImage(
                            imageUrl: photo,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => ColoredBox(
                              color: AppColors.coffeeBrown.withValues(alpha: 0.12),
                              child: const Icon(Icons.location_on, size: 18, color: AppColors.coffeeBrown),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(area, style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
