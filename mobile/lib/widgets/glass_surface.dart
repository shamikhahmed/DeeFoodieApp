import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Paper journal card — app-wide replacement for glass blur cards.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.borderRadius = 12,
    this.blurSigma = 0,
    this.tintOpacity = 1,
    this.padding,
  });

  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final double tintOpacity;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF6).withValues(alpha: tintOpacity.clamp(0.85, 1.0)),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.inkBrown.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.inkBrown.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      child: DefaultTextStyle.merge(
        style: Theme.of(context).textTheme.bodyMedium,
        child: child,
      ),
    );
  }
}
