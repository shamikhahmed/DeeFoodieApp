import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../models/visit.dart';
import '../theme/app_theme.dart';
import '../utils/eatery_display.dart';
import 'share_visit_card.dart';

class ShareVisitSheet extends StatefulWidget {
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

  @override
  State<ShareVisitSheet> createState() => _ShareVisitSheetState();
}

class _ShareVisitSheetState extends State<ShareVisitSheet> {
  final _cardKey = GlobalKey();

  String _shareText() {
    final visit = widget.visit;
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

  Future<void> _shareImage() async {
    final boundary = _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return;
    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) return;
    await Share.shareXFiles(
      [XFile.fromData(bytes.buffer.asUint8List(), mimeType: 'image/png', name: 'visit.png')],
      text: widget.visit.eateryName,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final visit = widget.visit;

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
              RepaintBoundary(
                key: _cardKey,
                child: ShareVisitCard(visit: visit),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: _shareImage,
                icon: const Icon(Icons.image_outlined),
                label: Text(l10n.shareVisitImage),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.coffeeBrown,
                  foregroundColor: AppColors.paper,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _shareText()));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Visit copied — paste to WhatsApp or Instagram')),
                  );
                },
                icon: const Icon(Icons.ios_share_rounded),
                label: const Text('Copy text'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
