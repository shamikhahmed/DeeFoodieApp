import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.photoUrl,
    this.radius = 32,
    this.onTap,
    this.showEditBadge = false,
  });

  final String? photoUrl;
  final double radius;
  final VoidCallback? onTap;
  final bool showEditBadge;

  @override
  Widget build(BuildContext context) {
    final child = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.coffeeBrown.withValues(alpha: 0.15),
      backgroundImage: _imageProvider(photoUrl),
      child: photoUrl == null
          ? Icon(CupertinoIcons.person_fill, color: AppColors.coffeeBrown, size: radius * 0.85)
          : null,
    );

    if (!showEditBadge && onTap == null) return child;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          if (showEditBadge)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.coffeeBrown,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.paper, width: 2),
                ),
                child: Icon(
                  photoUrl == null ? CupertinoIcons.camera_fill : CupertinoIcons.pencil,
                  size: radius * 0.28,
                  color: AppColors.paper,
                ),
              ),
            ),
        ],
      ),
    );
  }

  ImageProvider? _imageProvider(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('data:')) {
      try {
        return MemoryImage(base64Decode(url.split(',').last));
      } catch (_) {
        return null;
      }
    }
    return NetworkImage(url);
  }
}
