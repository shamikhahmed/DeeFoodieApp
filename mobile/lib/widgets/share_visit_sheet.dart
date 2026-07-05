import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/visit.dart';
import '../theme/app_theme.dart';
import '../utils/eatery_display.dart';

class ShareVisitSheet extends StatelessWidget {
  const ShareVisitSheet({super.key, required this.visit});

  final Visit visit;

  static Future<void> show(BuildContext context, Visit visit) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ShareVisitSheet(visit: visit),
    );
  }

  String _shareText() {
    final lines = <String>[
      '${visit.eateryName} · ${visit.rating.toStringAsFixed(1)}★',
      if (visit.reviewText != null && visit.reviewText!.trim().isNotEmpty) visit.reviewText!.trim(),
      if (visit.items.isNotEmpty) 'Ordered: ${visit.items.map((i) => i.name).join(', ')}',
      if (visit.totalBill != null) 'Bill: ${formatRs(visit.totalBill!)}',
      '',
      'Logged on DeeFoodieApp — Karachi food archive',
    ];
    return lines.where((l) => l.isNotEmpty).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: AppColors.inkBrown.withValues(alpha: 0.15), blurRadius: 24, offset: const Offset(0, 8)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.rust, size: 28),
                  const SizedBox(width: 8),
                  Text(visit.rating.toStringAsFixed(1), style: Theme.of(context).textTheme.headlineMedium),
                  const Spacer(),
                  Text(visit.date, style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(visit.eateryName, style: Theme.of(context).textTheme.titleLarge),
              if (visit.reviewText != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(visit.reviewText!, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45)),
              ],
              if (visit.items.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text('Ordered', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(visit.items.map((i) => i.name).join(' · '), style: Theme.of(context).textTheme.bodyMedium),
              ],
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _shareText()));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Visit copied — paste to WhatsApp or Instagram')),
                  );
                },
                icon: const Icon(Icons.ios_share_rounded),
                label: const Text('Copy to share'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.coffeeBrown,
                  foregroundColor: AppColors.paper,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
