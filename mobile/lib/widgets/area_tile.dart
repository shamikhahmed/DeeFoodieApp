import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/food_visuals.dart';
import '../theme/app_theme.dart';
import 'glass_surface.dart';

class AreaTile extends StatelessWidget {
  const AreaTile({
    super.key,
    required this.name,
    required this.eateryCount,
    required this.countLabel,
    required this.onTap,
  });

  final String name;
  final int eateryCount;
  final String countLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final photo = areaPhoto(name);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: GlassSurface(
          padding: EdgeInsets.zero,
          borderRadius: 16,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
                child: CachedNetworkImage(
                  imageUrl: photo,
                  width: 88,
                  height: 72,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => ColoredBox(
                    color: AppColors.coffeeBrown.withValues(alpha: 0.12),
                    child: const Center(child: Icon(CupertinoIcons.map_pin_ellipse, color: AppColors.coffeeBrown)),
                  ),
                  errorWidget: (_, __, ___) => ColoredBox(
                    color: AppColors.coffeeBrown.withValues(alpha: 0.12),
                    child: const Center(child: Icon(CupertinoIcons.map_pin_ellipse, color: AppColors.coffeeBrown)),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(countLabel, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: Icon(CupertinoIcons.chevron_right, size: 18, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
