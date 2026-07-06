import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/karachi_backgrounds.dart';
import '../theme/app_theme.dart';

class KarachiBackgroundImage extends StatelessWidget {
  const KarachiBackgroundImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String assetPath;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, _, _) => CachedNetworkImage(
        imageUrl: karachiBackgroundUrl(assetPath),
        fit: fit,
        width: width,
        height: height,
        placeholder: (_, _) => ColoredBox(
          color: AppColors.cream,
          child: Center(child: Icon(Icons.restaurant, color: AppColors.coffeeBrown.withValues(alpha: 0.4))),
        ),
        errorWidget: (_, _, _) => ColoredBox(
          color: AppColors.cream,
          child: Center(child: Icon(Icons.landscape, color: AppColors.coffeeBrown.withValues(alpha: 0.35))),
        ),
      ),
    );
  }
}
