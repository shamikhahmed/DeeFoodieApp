import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/journal_stickers.dart';
import '../constants/onboarding_options.dart';
import '../theme/app_theme.dart';

List<String> get allJournalStickerIds => [
      ...journalStickerIds,
      ...journalIconStickers.keys,
    ];

class JournalStickerTile extends StatelessWidget {
  const JournalStickerTile({super.key, required this.id, this.size = 32});

  final String id;
  final double size;

  @override
  Widget build(BuildContext context) {
    final asset = journalStickerAssets[id];
    if (asset != null) {
      return SizedBox(width: size, height: size, child: SvgPicture.asset(asset, fit: BoxFit.contain));
    }
    final icon = journalIconStickers[id];
    if (icon != null) {
      return Icon(icon, size: size * 0.85, color: AppColors.coffeeBrown);
    }
    return const SizedBox.shrink();
  }
}
