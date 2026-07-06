import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/visit_book_memory_provider.dart';
import '../widgets/voice_note_player.dart';
import '../utils/journal_spread_theme.dart';
import '../utils/visit_date_format.dart';
import '../widgets/journal_sticker_tile.dart';
import '../widgets/book_memory_picker_sheet.dart';
import '../widgets/journal_view_toggle.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_page_flip/real_page_flip.dart';
import '../constants/food_visuals.dart';
import '../models/visit.dart';
import '../theme/app_theme.dart';
import '../utils/eatery_display.dart';
import '../widgets/food_photo_orb.dart';
import '../widgets/journal_paper.dart';
import '../widgets/rating_stars.dart';
import '../widgets/visit_photo_image.dart';

class JournalBookView extends ConsumerStatefulWidget {
  const JournalBookView({
    super.key,
    required this.visits,
    required this.onShare,
  });

  final List<Visit> visits;
  final void Function(Visit) onShare;

  @override
  ConsumerState<JournalBookView> createState() => _JournalBookViewState();
}

class _JournalBookViewState extends ConsumerState<JournalBookView> {
  final PageFlipController _controller = PageFlipController();
  int _pageIndex = 0;
  final _hintNotifier = ValueNotifier<int>(0);

  int get _itemCount => widget.visits.length + 1;

  @override
  void dispose() {
    _hintNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.visits.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: _BookTheatre(
              child: PageFlipWidget(
                key: const PageStorageKey<String>('journal-food-book'),
                controller: _controller,
                itemCount: _itemCount,
                initialIndex: _pageIndex,
                spreadMode: PageFlipSpreadMode.doubleSpread,
                config: PageFlipConfig(
                  skipTapAnimation: false,
                  enableHaptics: !kIsWeb,
                  enableSound: !kIsWeb,
                  backgroundColor: const Color(0xFFFFF9F0),
                  sensitivity: 0.48,
                  cutoffForward: 0.34,
                  cutoffPrevious: 0.38,
                  edgeTapWidthRatio: 0.12,
                  thinPaperStrength: 0.14,
                  duration: const Duration(milliseconds: 440),
                  hapticTexturePreset: PaperTexturePreset.standard,
                ),
                onPageChanged: (index) {
                  setState(() => _pageIndex = index);
                  _hintNotifier.value = index;
                },
                itemBuilder: _buildSpread,
              ),
            ),
          ),
        ),
        BookPageControls(
          canPrevious: _pageIndex > 0,
          canNext: _pageIndex < _itemCount - 1,
          pageLabel: 'Page ${_pageIndex + 1} / $_itemCount',
          onPrevious: () {
            if (_controller.isAttached) _controller.previousPage();
          },
          onNext: () {
            if (_controller.isAttached) _controller.nextPage();
          },
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<int>(
          valueListenable: _hintNotifier,
          builder: (context, index, _) => Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + MediaQuery.paddingOf(context).bottom),
            child: Text(
              _pageHint(index),
              textAlign: TextAlign.center,
              style: GoogleFonts.caveat(fontSize: 17, color: AppColors.inkBrown.withValues(alpha: 0.82)),
            ),
          ),
        ),
      ],
    );
  }

  String _pageHint(int index) {
    if (index == 0) return 'Tap or swipe right edge to turn cover';
    final visit = widget.visits[index - 1];
    return '${visit.eateryName} · spread ${index} of ${widget.visits.length} · tap name for full entry';
  }

  Widget _buildSpread(BuildContext context, int index) {
    if (index == 0) {
      return _JournalCover(visitCount: widget.visits.length);
    }
    final visit = widget.visits[index - 1];
    final memory = ref.watch(visitBookMemoryProvider)[visit.id] ?? const VisitBookMemory();
    final year = DateTime.tryParse(visit.date)?.year;
    final prevYear = index > 1 ? DateTime.tryParse(widget.visits[index - 2].date)?.year : null;
    final theme = spreadThemeForVisit(visit.moodTags);
    return Column(
      children: [
        if (year != null && year != prevYear)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text('— $year —', style: GoogleFonts.fraunces(fontSize: 16, color: AppColors.coffeeBrown)),
          ),
        Expanded(
          child: _BookSpread(
            visit: visit,
            memory: memory,
            paperTint: theme.paperTint,
            page: index + 1,
            total: _itemCount,
            onShare: () => widget.onShare(visit),
            onAddMemory: () => BookMemoryPickerSheet.show(
              context,
              visitId: visit.id,
              onSticker: (id) => ref.read(visitBookMemoryProvider.notifier).addSticker(visit.id, id),
              onPhoto: (url, label) => ref.read(visitBookMemoryProvider.notifier).addPhoto(visit.id, url, label: label),
            ),
            onRemoveSticker: (id) => ref.read(visitBookMemoryProvider.notifier).removeSticker(visit.id, id),
            onRemovePhoto: (i) => ref.read(visitBookMemoryProvider.notifier).removePhoto(visit.id, i),
          ),
        ),
      ],
    );
  }
}

class _BookTheatre extends StatelessWidget {
  const _BookTheatre({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 14,
      shadowColor: AppColors.inkBrown.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF4A3224), width: 2.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.inkBrown.withValues(alpha: 0.28),
              blurRadius: 32,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: child,
        ),
      ),
    );
  }
}

class _JournalCover extends StatelessWidget {
  const _JournalCover({required this.visitCount});

  final int visitCount;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3D2818), Color(0xFF5C3D2E), Color(0xFF2E1F14)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 32, 12, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FoodPhotoOrb(url: accentPhoto('journal'), size: 72),
                  const Spacer(),
                  Text(
                    'Karachi',
                    style: GoogleFonts.fraunces(fontSize: 28, fontWeight: FontWeight.w300, color: const Color(0xFFF5E6D0), fontStyle: FontStyle.italic),
                  ),
                  Text(
                    'Food Journal',
                    style: GoogleFonts.fraunces(fontSize: 34, fontWeight: FontWeight.w700, color: const Color(0xFFFFFCF6)),
                  ),
                ],
              ),
            ),
          ),
          Container(width: 2, color: Colors.black.withValues(alpha: 0.35)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 28, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    '$visitCount visits logged',
                    style: GoogleFonts.caveat(fontSize: 22, color: const Color(0xFFE8D5C0)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Every meal,\nremembered.',
                    style: GoogleFonts.caveat(fontSize: 26, height: 1.25, color: const Color(0xFFFFFCF6)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '→ turn page',
                    style: GoogleFonts.caveat(fontSize: 18, color: const Color(0xFFD4A574)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookSpread extends StatelessWidget {
  const _BookSpread({
    required this.visit,
    required this.memory,
    required this.page,
    required this.total,
    required this.onShare,
    required this.onAddMemory,
    required this.onRemoveSticker,
    required this.onRemovePhoto,
    this.paperTint = AppColors.paper,
  });

  final Visit visit;
  final VisitBookMemory memory;
  final int page;
  final int total;
  final VoidCallback onShare;
  final VoidCallback onAddMemory;
  final void Function(String stickerId) onRemoveSticker;
  final void Function(int index) onRemovePhoto;
  final Color paperTint;

  @override
  Widget build(BuildContext context) {
    final date = visit.date;
    final photos = visit.allPhotoUrls;
    final photo = photos.isNotEmpty ? photos.first : null;

    return Row(
      children: [
        Expanded(child: _BookPage(side: _BookSide.left, page: page, total: total, paperTint: paperTint, child: _leftPage(context, date, visit, onShare, memory, onAddMemory, onRemoveSticker))),
        Container(width: 1, color: AppColors.inkBrown.withValues(alpha: 0.12)),
        Expanded(child: _BookPage(side: _BookSide.right, page: page, total: total, paperTint: paperTint, child: _rightPage(context, visit, photo, memory, onRemovePhoto))),
      ],
    );
  }

  Widget _leftPage(BuildContext context, String date, Visit visit, VoidCallback onShare, VisitBookMemory memory, VoidCallback onAddMemory, void Function(String) onRemoveSticker) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: visitDateHeader(date, time: visit.time)),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              onPressed: onAddMemory,
              icon: const Icon(Icons.emoji_emotions_outlined, size: 18, color: AppColors.coffeeBrown),
              tooltip: 'Add sticker or photo',
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              onPressed: onShare,
              icon: const Icon(Icons.ios_share, size: 16, color: AppColors.coffeeBrown),
              tooltip: 'Share',
            ),
          ],
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => context.push('/visit/${visit.id}'),
          child: Text(
            visit.eateryName,
            style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.coffeeBrown, decoration: TextDecoration.underline, decorationColor: AppColors.coffeeBrown.withValues(alpha: 0.35)),
          ),
        ),
        if (visit.areaName != null) ...[
          const SizedBox(height: 6),
          Text(visit.areaName!, style: GoogleFonts.caveat(fontSize: 17, color: AppColors.inkBrown.withValues(alpha: 0.78))),
        ],
        if (visit.userName != null && visit.userName!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(visit.userName!, style: GoogleFonts.caveat(fontSize: 15, color: AppColors.coffeeBrown, fontWeight: FontWeight.w600)),
        ],
        const Spacer(),
        RatingStars(rating: visit.rating, size: 18),
        if (visit.companions != null) ...[
          const SizedBox(height: 8),
          Text('With ${visit.companions}', style: GoogleFonts.caveat(fontSize: 16, color: AppColors.textMuted)),
        ],
        if (visit.moodTags.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: visit.moodTags
                .take(4)
                .map((t) => Text('· $t', style: GoogleFonts.caveat(fontSize: 15, color: AppColors.darkGreen)))
                .toList(),
          ),
        ],
        if (visit.voiceNoteDataUrl != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              VoiceNotePlayer(dataUrl: visit.voiceNoteDataUrl!, compact: true),
              const Spacer(),
              IconButton(
                tooltip: 'Edit visit',
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.edit_outlined, size: 18, color: AppColors.textMuted),
                onPressed: () => context.push('/edit-visit/${visit.id}'),
              ),
            ],
          ),
        ],
        if (visit.totalBill != null) ...[
          const SizedBox(height: 8),
          Text(formatRs(visit.totalBill!), style: GoogleFonts.caveat(fontSize: 17, color: AppColors.rust, fontWeight: FontWeight.w600)),
        ],
        if (memory.stickerIds.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: memory.stickerIds.take(6).map((id) {
              return GestureDetector(
                onLongPress: () => onRemoveSticker(id),
                child: JournalStickerTile(id: id, size: 32),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _rightPage(BuildContext context, Visit visit, String? photo, VisitBookMemory memory, void Function(int) onRemovePhoto) {
    final photos = visit.allPhotoUrls;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (photos.isNotEmpty)
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length.clamp(0, 4),
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (_, i) => SizedBox(
                width: 110,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: VisitPhotoImage(url: photos[i], height: 88),
                ),
              ),
            ),
          )
        else if (photo != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: VisitPhotoImage(url: photo, height: 100),
          )
        else
          Align(child: FoodPhotoOrb(url: accentPhoto('journal'), size: 64)),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Text(
              visit.reviewText?.trim().isNotEmpty == true ? visit.reviewText! : 'A quiet meal — no words, just memory.',
              style: GoogleFonts.caveat(fontSize: 18, height: 1.45, color: AppColors.inkBrown),
            ),
          ),
        ),
        if (visit.items.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            'Ordered: ${visit.items.map((i) => i.name).join(', ')}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.caveat(fontSize: 16, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
          ),
        ],
        if (memory.photoDataUrls.isNotEmpty) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: memory.photoDataUrls.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (_, i) {
                final url = memory.photoDataUrls[i];
                final label = i < memory.photoLabels.length ? memory.photoLabels[i] : 'memory';
                Widget img;
                if (url.startsWith('data:')) {
                  img = Image.memory(base64Decode(url.split(',').last), width: 52, height: 52, fit: BoxFit.cover);
                } else {
                  img = CachedNetworkImage(imageUrl: url, width: 52, height: 52, fit: BoxFit.cover);
                }
                return GestureDetector(
                  onLongPress: () => onRemovePhoto(i),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(4), child: img),
                      Text(
                        memoryPhotoLabel(label),
                        style: GoogleFonts.caveat(fontSize: 11, color: AppColors.coffeeBrown),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

}

enum _BookSide { left, right }

class _BookPage extends StatelessWidget {
  const _BookPage({
    required this.side,
    required this.child,
    required this.page,
    required this.total,
    this.paperTint = AppColors.paper,
  });

  final _BookSide side;
  final Widget child;
  final int page;
  final int total;
  final Color paperTint;

  @override
  Widget build(BuildContext context) {
    final base = Color.lerp(
      side == _BookSide.left ? const Color(0xFFFFF9F0) : const Color(0xFFFFFBF4),
      paperTint,
      0.35,
    )!;

    return Stack(
      children: [
        ColoredBox(color: base),
        CustomPaint(
          painter: NotebookRuledPainter(lineSpacing: 24, showMargin: true),
          child: const SizedBox.expand(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(side == _BookSide.left ? 58 : 20, 18, 16, 28),
          child: child,
        ),
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Text(
            '$page / $total',
            textAlign: TextAlign.center,
            style: GoogleFonts.caveat(fontSize: 13, color: AppColors.inkBrown.withValues(alpha: 0.55)),
          ),
        ),
      ],
    );
  }
}
