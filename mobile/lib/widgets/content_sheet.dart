import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Solid paper surface for readable content over photos/gradients.
class ContentSheet extends StatelessWidget {
  const ContentSheet({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2218) : AppColors.paper,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColors.inkBrown.withValues(alpha: isDark ? 0.15 : 0.06)),
        boxShadow: [
          BoxShadow(
            color: AppColors.inkBrown.withValues(alpha: isDark ? 0.4 : 0.12),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: padding,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: isDark ? AppColors.paper : AppColors.textPrimary,
            ),
        child: child,
      ),
    );
  }
}
