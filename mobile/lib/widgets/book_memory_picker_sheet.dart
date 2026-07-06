import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../utils/haptics.dart';
import '../widgets/journal_sticker_tile.dart';
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
  final void Function(String dataUrl, String label) onPhoto;

  static Future<void> show(
    BuildContext context, {
    required String visitId,
    required void Function(String stickerId) onSticker,
    required void Function(String dataUrl, String label) onPhoto,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookMemoryPickerSheet(visitId: visitId, onSticker: onSticker, onPhoto: onPhoto),
    );
  }

  Future<void> _pickPhoto(BuildContext context, String label) async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1200, imageQuality: 80);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    final dataUrl = 'data:image/jpeg;base64,${base64Encode(bytes)}';
    AppHaptics.light();
    onPhoto(dataUrl, label);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final stickers = allJournalStickerIds;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: JournalPageCard(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add to this page', style: GoogleFonts.fraunces(fontSize: 20, fontStyle: FontStyle.italic, color: AppColors.inkBrown)),
              const SizedBox(height: 6),
              Text('Stickers, friends & family photos stay on your spread.', style: GoogleFonts.caveat(fontSize: 16, color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              Text('Stickers', style: GoogleFonts.fraunces(fontSize: 15, color: AppColors.coffeeBrown)),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, mainAxisSpacing: 8, crossAxisSpacing: 8),
                itemCount: stickers.length,
                itemBuilder: (context, i) {
                  final id = stickers[i];
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
                        child: JournalStickerTile(id: id, size: 28),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text('People photos', style: GoogleFonts.fraunces(fontSize: 15, color: AppColors.coffeeBrown)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickPhoto(context, 'friends'),
                      icon: const Icon(CupertinoIcons.person_2, size: 18),
                      label: Text('Friends', style: GoogleFonts.caveat(fontSize: 17, color: AppColors.inkBrown)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickPhoto(context, 'family'),
                      icon: const Icon(CupertinoIcons.house, size: 18),
                      label: Text('Family', style: GoogleFonts.caveat(fontSize: 17, color: AppColors.inkBrown)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _pickPhoto(context, 'group'),
                icon: const Icon(CupertinoIcons.photo_on_rectangle),
                label: Text('Group / other photo', style: GoogleFonts.caveat(fontSize: 17, color: AppColors.inkBrown)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
