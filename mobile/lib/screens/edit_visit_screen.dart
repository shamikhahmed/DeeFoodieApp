import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../models/visit.dart';
import '../providers/custom_moods_provider.dart';
import '../providers/profile_prefs_provider.dart';
import '../theme/app_theme.dart';
import '../utils/haptics.dart';
import '../widgets/journal_form.dart';
import '../widgets/journal_paper.dart';
import '../widgets/menu_item_picker.dart';
import '../widgets/journal_paper.dart';
import '../widgets/visit_photo_image.dart';
import '../widgets/voice_note_player.dart';

class EditVisitScreen extends ConsumerStatefulWidget {
  const EditVisitScreen({super.key, required this.visitId});

  final String visitId;

  @override
  ConsumerState<EditVisitScreen> createState() => _EditVisitScreenState();
}

class _EditVisitScreenState extends ConsumerState<EditVisitScreen> {
  Visit? _visit;
  double _rating = 4;
  DateTime _date = DateTime.now();
  TimeOfDay? _visitTime;
  final _review = TextEditingController();
  final _memory = TextEditingController();
  final _customMood = TextEditingController();
  final _moods = <String>{};
  final _items = <SelectedMenuItem>[];
  final _photos = <String>[];
  String? _companion;
  String? _voiceNoteDataUrl;

  static const _defaultMoods = ['Friends', 'Family', 'Date', 'Alone', 'Late Night', 'Celebration'];
  static const _companionOptions = ['Alone', 'Friends', 'Family', 'Work', 'Date'];

  @override
  void dispose() {
    _review.dispose();
    _memory.dispose();
    _customMood.dispose();
    super.dispose();
  }

  void _init(Visit v) {
    _visit = v;
    _rating = v.rating;
    _date = DateTime.tryParse(v.date) ?? DateTime.now();
    _review.text = v.reviewText ?? '';
    _memory.text = v.memoryNote ?? '';
    _moods.addAll(v.moodTags);
    _photos.addAll(v.allPhotoUrls);
    _companion = v.companions;
    _voiceNoteDataUrl = v.voiceNoteDataUrl;
    if (v.time != null && v.time!.contains(':')) {
      final parts = v.time!.split(':');
      _visitTime = TimeOfDay(hour: int.tryParse(parts[0]) ?? 12, minute: int.tryParse(parts[1]) ?? 0);
    }
    _items.addAll(v.items.map((i) => SelectedMenuItem(name: i.name, price: 0, type: i.type)));
  }

  Future<void> _pickVoiceNote() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio, withData: true);
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return;
    final ext = (file.extension ?? 'm4a').toLowerCase();
    final mime = switch (ext) {
      'mp3' => 'audio/mpeg',
      'wav' => 'audio/wav',
      'webm' => 'audio/webm',
      'ogg' => 'audio/ogg',
      'aac' => 'audio/aac',
      _ => 'audio/mp4',
    };
    setState(() => _voiceNoteDataUrl = 'data:$mime;base64,${base64Encode(bytes)}');
    AppHaptics.light();
  }

  Future<void> _pickPhoto() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1400, imageQuality: 78);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() => _photos.add('data:image/jpeg;base64,${base64Encode(bytes)}'));
    AppHaptics.light();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(1990), lastDate: DateTime.now());
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _visitTime ?? TimeOfDay.now());
    if (picked != null) setState(() => _visitTime = picked);
  }

  String? _visitTimeString() {
    if (_visitTime == null) return null;
    final h = _visitTime!.hour.toString().padLeft(2, '0');
    final m = _visitTime!.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _save() async {
    final v = _visit;
    if (v == null) return;
    AppHaptics.medium();

    final api = ref.read(apiClientProvider);
    var photoUrls = List<String>.from(_photos);
    if (!v.id.startsWith('local-')) {
      final apiOnline = await ref.read(apiOnlineProvider.future);
      if (apiOnline) {
        final uploaded = <String>[];
        for (final p in _photos) {
          if (p.startsWith('data:')) {
            try {
              final bytes = base64Decode(p.split(',').last);
              uploaded.add(await api.uploadPhoto(bytes: bytes, visitId: v.id));
            } catch (_) {
              uploaded.add(p);
            }
          } else {
            uploaded.add(p);
          }
        }
        photoUrls = uploaded;
      }
    }

    final updated = v.copyWith(
      date: _date.toIso8601String().split('T').first,
      rating: _rating,
      reviewText: _review.text.trim().isEmpty ? null : _review.text.trim(),
      memoryNote: _memory.text.trim().isEmpty ? null : _memory.text.trim(),
      moodTags: _moods.toList(),
      companions: _companion,
      items: _items.map((i) => VisitItem(name: i.name, type: i.type)).toList(),
      photoUrls: photoUrls,
      photoUrl: photoUrls.isNotEmpty ? photoUrls.first : null,
      voiceNoteDataUrl: _voiceNoteDataUrl,
      favoriteItem: _items.isEmpty ? v.favoriteItem : _items.first.name,
      totalBill: _items.fold<double>(0, (s, i) => s + i.price),
      time: _visitTimeString(),
    );

    if (v.id.startsWith('local-')) {
      await ref.read(localVisitsProvider.notifier).update(updated);
    } else {
      try {
        await ref.read(apiClientProvider).updateVisit(v.id, {
          'date': updated.date,
          'rating': updated.rating,
          'reviewText': updated.reviewText,
          'memoryNote': updated.memoryNote,
          'moodTags': updated.moodTags,
          'companions': updated.companions,
          'items': updated.items.map((i) => {'name': i.name, 'type': i.type}).toList(),
          'favoriteItem': updated.favoriteItem,
          'totalBill': updated.totalBill,
          'photoUrls': photoUrls,
        });
      } catch (_) {
        await ref.read(localVisitsProvider.notifier).add(updated);
      }
    }
    ref.invalidate(visitsProvider);
    ref.invalidate(visitDetailProvider(v.id));
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.visitDeleteTitle),
        content: Text(l10n.visitDeleteBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.visitDeleteConfirm)),
        ],
      ),
    );
    if (ok != true || _visit == null) return;

    if (_visit!.id.startsWith('local-')) {
      await ref.read(localVisitsProvider.notifier).remove(_visit!.id);
    } else {
      try {
        await ref.read(apiClientProvider).deleteVisit(_visit!.id);
      } catch (_) {
        await ref.read(localVisitsProvider.notifier).remove(_visit!.id);
      }
    }
    ref.invalidate(visitsProvider);
    if (mounted) context.go('/journal');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final visitAsync = ref.watch(visitDetailProvider(widget.visitId));
    final customMoods = ref.watch(customMoodsProvider);

    return visitAsync.when(
      data: (v) {
        if (v == null) return Scaffold(body: Center(child: Text(l10n.visitNotFound)));
        if (_visit == null) _init(v);

        return JournalFormScaffold(
          title: l10n.editVisitTitle,
          leading: IconButton(icon: const Icon(CupertinoIcons.back, color: AppColors.coffeeBrown), onPressed: () => context.pop()),
          actions: [
            IconButton(icon: const Icon(CupertinoIcons.trash, color: AppColors.rust), onPressed: _delete),
          ],
          body: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.sm, AppSpacing.screenPadding, 120),
            children: [
              JournalFormSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v.eateryName, style: journalHandStyle(context, size: 20, weight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _pickDate,
                          icon: const Icon(CupertinoIcons.calendar),
                          label: Text(_date.toIso8601String().split('T').first),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: _pickTime,
                          icon: const Icon(CupertinoIcons.time),
                          label: Text(_visitTime?.format(context) ?? l10n.addVisitTime),
                        ),
                      ],
                    ),
                    Slider(value: _rating, min: 1, max: 5, divisions: 8, label: _rating.toStringAsFixed(1), onChanged: (x) => setState(() => _rating = x), activeColor: AppColors.coffeeBrown),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              JournalFormSection(
                title: l10n.visitCompanions,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _companionOptions.map((c) => JournalMoodChip(
                        label: c,
                        selected: _companion == c,
                        onTap: () => setState(() => _companion = c),
                      )).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              JournalFormSection(
                title: l10n.addVisitMood,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [..._defaultMoods, ...customMoods].map((m) => JournalMoodChip(
                            label: m,
                            selected: _moods.contains(m),
                            onTap: () => setState(() => _moods.contains(m) ? _moods.remove(m) : _moods.add(m)),
                          )).toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: _customMood, decoration: journalInputDecoration(hint: l10n.customMoodHint), style: journalInkStyle(context))),
                        IconButton(
                          onPressed: () async {
                            await ref.read(customMoodsProvider.notifier).add(_customMood.text);
                            setState(() => _moods.add(_customMood.text.trim()));
                            _customMood.clear();
                          },
                          icon: const Icon(CupertinoIcons.plus_circle_fill, color: AppColors.coffeeBrown),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              JournalFormSection(
                title: l10n.addVisitPhoto,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_photos.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _photos.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (_, i) => Stack(
                            children: [
                              VisitPhotoImage(url: _photos[i], height: 96, borderRadius: 6),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () => setState(() => _photos.removeAt(i)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    TextButton.icon(onPressed: _pickPhoto, icon: const Icon(CupertinoIcons.photo), label: Text(l10n.addVisitPhotoPick)),
                    TextButton.icon(
                      onPressed: _pickVoiceNote,
                      icon: const Icon(CupertinoIcons.mic),
                      label: Text(_voiceNoteDataUrl == null ? l10n.visitVoiceAdd : l10n.visitVoiceAttached),
                    ),
                    if (_voiceNoteDataUrl != null) ...[
                      VoiceNotePlayer(dataUrl: _voiceNoteDataUrl!),
                      TextButton(onPressed: () => setState(() => _voiceNoteDataUrl = null), child: Text(l10n.visitVoiceRemove)),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              JournalFormSection(
                child: Column(
                  children: [
                    TextField(controller: _review, maxLines: 4, style: journalInkStyle(context, size: 18), decoration: journalInputDecoration(hint: l10n.addVisitReviewHint)),
                    const SizedBox(height: 8),
                    TextField(controller: _memory, style: journalInkStyle(context, size: 17), decoration: journalInputDecoration(hint: l10n.visitMemoryHint)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(backgroundColor: AppColors.coffeeBrown, foregroundColor: AppColors.paper, padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(l10n.save),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => Scaffold(body: Center(child: Text(l10n.errorExplore))),
    );
  }
}
