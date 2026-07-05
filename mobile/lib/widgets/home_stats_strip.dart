import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'glass_surface.dart';

class HomeStatsStrip extends StatelessWidget {
  const HomeStatsStrip({
    super.key,
    required this.eateryCount,
    required this.visitCount,
    required this.areaCount,
    required this.eateriesLabel,
    required this.visitsLabel,
    required this.areasLabel,
  });

  final int eateryCount;
  final int visitCount;
  final int areaCount;
  final String eateriesLabel;
  final String visitsLabel;
  final String areasLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatPill(value: '$eateryCount', label: eateriesLabel)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: _StatPill(value: '$visitCount', label: visitsLabel)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: _StatPill(value: '$areaCount', label: areasLabel)),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2, horizontal: AppSpacing.sm),
      borderRadius: 14,
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.coffeeBrown)),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
