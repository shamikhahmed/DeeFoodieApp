import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'food_photo_orb.dart';

class StickerEmptyState extends StatelessWidget {
  const StickerEmptyState({
    super.key,
    required this.message,
    required this.photoUrl,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String photoUrl;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FoodPhotoOrb(url: photoUrl, size: 120, borderWidth: 4),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5, color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.md),
              FilledButton.tonal(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onAction!();
                },
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
