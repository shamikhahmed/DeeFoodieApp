import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OnboardingPhoto extends StatelessWidget {
  const OnboardingPhoto({
    super.key,
    required this.url,
    this.height,
    this.borderRadius = 16,
    this.fit = BoxFit.cover,
  });

  final String url;
  final double? height;
  final double borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: fit,
          placeholder: (_, _) => ColoredBox(color: AppColors.coffeeBrown.withValues(alpha: 0.08)),
          errorWidget: (_, _, _) => ColoredBox(
            color: AppColors.coffeeBrown.withValues(alpha: 0.12),
            child: const Center(child: Icon(Icons.restaurant, color: AppColors.coffeeBrown)),
          ),
        ),
      ),
    );
  }
}
