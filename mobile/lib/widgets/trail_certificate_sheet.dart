import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/karachi_trails.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class TrailCertificateSheet extends StatelessWidget {
  const TrailCertificateSheet({
    super.key,
    required this.trail,
    required this.userName,
    required this.completedAt,
  });

  final KarachiTrail trail;
  final String userName;
  final String completedAt;

  static Future<void> show(
    BuildContext context, {
    required KarachiTrail trail,
    required String userName,
    required String completedAt,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => TrailCertificateSheet(trail: trail, userName: userName, completedAt: completedAt),
    );
  }

  String _certificateText(AppLocalizations l10n) {
    return [
      l10n.trailCertificateTitle,
      '',
      trail.name,
      trail.description,
      '',
      l10n.trailCertificateAwarded(userName),
      completedAt,
      '',
      l10n.trailCertificateFooter,
    ].join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.coffeeBrown.withValues(alpha: 0.35), width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.workspace_premium_rounded, size: 48, color: AppColors.coffeeBrown),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.trailCertificateTitle, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.md),
              Text(trail.name, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(trail.description, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.trailCertificateAwarded(userName), style: Theme.of(context).textTheme.titleMedium),
              Text(completedAt, style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _certificateText(l10n)));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.trailCertificateCopied)));
                },
                icon: const Icon(Icons.ios_share_rounded),
                label: Text(l10n.trailCertificateShare),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
