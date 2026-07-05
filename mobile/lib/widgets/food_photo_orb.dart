import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Circular food photo — premium substitute for cartoon sticker SVGs.
class FoodPhotoOrb extends StatelessWidget {
  const FoodPhotoOrb({
    super.key,
    required this.url,
    this.size = 72,
    this.borderWidth = 3,
  });

  final String url;
  final double size;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.paper, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: AppColors.inkBrown.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (_, _) => ColoredBox(color: AppColors.coffeeBrown.withValues(alpha: 0.08)),
          errorWidget: (_, _, _) => ColoredBox(
            color: AppColors.coffeeBrown.withValues(alpha: 0.12),
            child: Icon(Icons.restaurant_rounded, color: AppColors.coffeeBrown.withValues(alpha: 0.5), size: size * 0.4),
          ),
        ),
      ),
    );
  }
}
