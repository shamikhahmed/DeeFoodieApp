import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/journal_stickers.dart';
import '../theme/app_theme.dart';
import '../utils/haptics.dart';
import 'journal_paper.dart';

class BookMemoryPickerSheet extends StatelessWidget {
  const BookMemoryPickerSheet({
    super.key,
    required this.visitId,
    required this.onSticker,
    required this.onPhoto,
  });

  final String visitId;
  final void Function(String stickerId) onSticker;
  final void Function(String dataUrl) onPhoto;

  static Future<void> show(
    BuildContext context, {
    required String visitId,
    required void Function(String stickerId) onSticker,
    required void Function(String dataUrl) onPhoto,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookMemoryPickerSheet(visitId: visitId, onSticker: onSticker, onPhoto: onPhoto),
    );
  }

  Future<void> _pickPhoto(BuildContext context) async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1200, imageQuality: 80);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    final dataUrl = 'data:image/jpeg;base64,${base64Encode(bytes)}';
    AppHaptics.light();
    onPhoto(dataUrl);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: JournalPageCard(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Add to this page', style: GoogleFonts.fraunces(fontSize: 20, fontStyle: FontStyle.italic, color: AppColors.inkBrown)),
            const SizedBox(height: 6),
            Text('Stickers & memory photos stay on your book spread.', style: GoogleFonts.caveat(fontSize: 16, color: AppColors.textMuted)),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 8, crossAxisSpacing: 8),
                itemCount: journalStickerIds.length,
                itemBuilder: (context, i) {
                  final id = journalStickerIds[i];
                  final asset = journalStickerAssets[id]!;
                  return Material(
                    color: const Color(0xFFFFF9F0),
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () {
                        AppHaptics.selection();
                        onSticker(id);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: SvgPicture.asset(asset, fit: BoxFit.contain),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _pickPhoto(context),
              icon: const Icon(CupertinoIcons.photo_on_rectangle),
              label: Text('Add memory photo', style: GoogleFonts.caveat(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
