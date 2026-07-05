import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class VisitPhotoImage extends StatelessWidget {
  const VisitPhotoImage({
    super.key,
    required this.url,
    this.height = 200,
    this.borderRadius = 12,
  });

  final String url;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: url.startsWith('data:')
            ? Image.memory(
                base64Decode(url.split(',').last),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(),
              )
            : CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, _) => _placeholder(),
                errorWidget: (_, __, ___) => _placeholder(),
              ),
      ),
    );
  }

  Widget _placeholder() => ColoredBox(
        color: AppColors.coffeeBrown.withValues(alpha: 0.1),
        child: const Center(child: Icon(Icons.photo_outlined, color: AppColors.coffeeBrown)),
      );
}
