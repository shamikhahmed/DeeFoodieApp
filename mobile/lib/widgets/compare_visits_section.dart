import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../models/visit.dart';
import '../theme/app_theme.dart';
import '../utils/eatery_display.dart';
import '../widgets/glass_surface.dart';

class CompareVisitsSection extends StatelessWidget {
  const CompareVisitsSection({super.key, required this.visits});

  final List<Visit> visits;

  @override
  Widget build(BuildContext context) {
    if (visits.length < 2) return const SizedBox.shrink();
    final sorted = sortVisitsByDate(visits);
    final latest = sorted.first;
    final earliest = sorted.last;
    final ratingDelta = latest.rating - earliest.rating;
    final billDelta = (latest.totalBill ?? 0) - (earliest.totalBill ?? 0);

    return GlassSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Compare visits', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(child: _VisitColumn(label: earliest.date, visit: earliest)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward, size: 18, color: AppColors.coffeeBrown),
              ),
              Expanded(child: _VisitColumn(label: latest.date, visit: latest)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _summary(ratingDelta, billDelta),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  String _summary(double ratingDelta, double billDelta) {
    final parts = <String>[];
    if (ratingDelta.abs() >= 0.1) {
      parts.add(ratingDelta > 0 ? 'Rating up ${ratingDelta.toStringAsFixed(1)}' : 'Rating down ${ratingDelta.abs().toStringAsFixed(1)}');
    }
    if (billDelta.abs() >= 50) {
      parts.add(billDelta > 0 ? 'Bill up ${formatRs(billDelta)}' : 'Bill down ${formatRs(billDelta.abs())}');
    }
    return parts.isEmpty ? 'Same mood across visits — consistency counts.' : parts.join(' · ');
  }
}

class _VisitColumn extends StatelessWidget {
  const _VisitColumn({required this.label, required this.visit});

  final String label;
  final Visit visit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        Text('${visit.rating.toStringAsFixed(1)}★', style: Theme.of(context).textTheme.titleMedium),
        if (visit.favoriteItem != null)
          Text(visit.favoriteItem!, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
        if (visit.totalBill != null) Text(formatRs(visit.totalBill!), style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
