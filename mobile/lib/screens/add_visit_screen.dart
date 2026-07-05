import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import '../utils/haptics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../data/archive_loader.dart';
import '../l10n/app_localizations.dart';
import '../models/eatery.dart';
import '../models/visit.dart';
import '../theme/app_theme.dart';
import '../widgets/journal_form.dart';
import '../widgets/journal_paper.dart';
import '../widgets/menu_item_picker.dart';
import '../data/sync_queue_store.dart';
import '../providers/sync_queue_provider.dart';
import '../providers/profile_prefs_provider.dart';

class AddVisitScreen extends ConsumerStatefulWidget {
  const AddVisitScreen({super.key, this.preselectedEateryId});

  final String? preselectedEateryId;

  @override
  ConsumerState<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends ConsumerState<AddVisitScreen> {
  String? _eateryId;
  double _rating = 4;
  final _reviewController = TextEditingController();
  final _customItemController = TextEditingController();
  final _moodTags = <String>{};
  final _selectedItems = <SelectedMenuItem>[];
  String? _photoDataUrl;
  String? _companion;

  static const _moods = ['Friends', 'Family', 'Date', 'Alone', 'Late Night', 'Celebration'];
  static const _companionOptions = ['Alone', 'Friends', 'Family', 'Work'];

  @override
  void initState() {
    super.initState();
    _eateryId = widget.preselectedEateryId;
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _customItemController.dispose();
    super.dispose();
  }

  double get _billTotal => _selectedItems.fold<double>(0, (s, i) => s + i.price);

  String? get _favoriteItem => _selectedItems.isEmpty ? null : _selectedItems.first.name;

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1400, imageQuality: 78);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() => _photoDataUrl = 'data:image/jpeg;base64,${base64Encode(bytes)}');
    AppHaptics.light();
  }

  Future<void> _save() async {
    var eateries = ref.read(allEateriesProvider).maybeWhen(data: (e) => e, orElse: () => <Eatery>[]);
    if (eateries.isEmpty) eateries = (await ArchiveLoader.load()).eateries;
    final eateryId = _eateryId ?? (eateries.isNotEmpty ? eateries.first.id : null);
    if (eateryId == null) return;

    AppHaptics.medium();
    final items = _selectedItems
        .map((i) => {'name': i.name, 'type': i.type})
        .toList();
    final api = ref.read(apiClientProvider);

    var photoUrls = <String>[];
    if (_photoDataUrl != null) {
      final apiOnline = await ref.read(apiOnlineProvider.future);
      if (apiOnline) {
        try {
          final bytes = base64Decode(_photoDataUrl!.split(',').last);
          final url = await api.uploadPhoto(bytes: bytes);
          photoUrls = [url];
        } catch (_) {}
      }
    }

    try {
      await api.createVisit(
        eateryId: eateryId,
        date: DateTime.now().toIso8601String().split('T').first,
        rating: _rating,
        reviewText: _reviewController.text.isEmpty ? null : _reviewController.text,
        moodTags: _moodTags.toList(),
        items: items,
        totalBill: _billTotal > 0 ? _billTotal : null,
        favoriteItem: _favoriteItem,
        companions: _companion,
        photoUrls: photoUrls.isNotEmpty ? photoUrls : null,
      );
      ref.invalidate(visitsProvider);
      if (mounted) context.pop();
    } catch (_) {
      await ref.read(syncQueueProvider.notifier).enqueue(SyncOpType.createVisit, {
        'eateryId': eateryId,
        'date': DateTime.now().toIso8601String().split('T').first,
        'rating': _rating,
        'reviewText': _reviewController.text.isEmpty ? null : _reviewController.text,
        'moodTags': _moodTags.toList(),
        'items': items,
        'totalBill': _billTotal > 0 ? _billTotal : null,
        'favoriteItem': _favoriteItem,
        'companions': _companion,
        'photoUrls': photoUrls,
      });
      Eatery? eatery;
      for (final e in eateries) {
        if (e.id == eateryId) {
          eatery = e;
          break;
        }
      }
      ref.read(localVisitsProvider.notifier).add(
            Visit(
              id: 'local-${DateTime.now().millisecondsSinceEpoch}',
              eateryId: eateryId,
              eateryName: eatery?.name ?? 'Unknown',
              date: DateTime.now().toIso8601String().split('T').first,
              rating: _rating,
              reviewText: _reviewController.text.isEmpty ? null : _reviewController.text,
              moodTags: _moodTags.toList(),
              userName: ref.read(userProfileProvider).displayName,
              totalBill: _billTotal > 0 ? _billTotal : null,
              favoriteItem: _favoriteItem,
              items: _selectedItems
                  .map((i) => VisitItem(name: i.name, type: i.type))
                  .toList(),
              photoUrl: _photoDataUrl,
              photoUrls: _photoDataUrl != null ? [_photoDataUrl!] : const [],
              areaName: eatery?.areaName,
              companions: _companion,
            ),
          );
      ref.invalidate(visitsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.addVisitDemoSaved)),
        );
        context.pop();
      }
    }
  }

  void _addCustomItem() {
    final name = _customItemController.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _selectedItems.add(SelectedMenuItem(name: name, price: 0));
      _customItemController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final eateriesAsync = ref.watch(allEateriesProvider);
    final eateries = eateriesAsync.value ?? <Eatery>[];
    final effectiveEateryId = _eateryId ?? (eateries.isNotEmpty ? eateries.first.id : null);
    final eateryDetail = effectiveEateryId != null ? ref.watch(eateryDetailProvider(effectiveEateryId)) : null;
    final menuItems = eateryDetail?.asData?.value?.menu?.items ?? [];

    return JournalFormScaffold(
      title: l10n.addVisit,
      leading: IconButton(icon: const Icon(CupertinoIcons.back, color: AppColors.coffeeBrown), onPressed: () => context.pop()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.sm, AppSpacing.screenPadding, 120),
        children: [
          JournalFormSection(
            title: l10n.addVisitEatery,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  key: ValueKey(effectiveEateryId),
                  initialValue: effectiveEateryId,
                  decoration: journalInputDecoration(),
                  items: eateries.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                  onChanged: (v) => setState(() {
                    _eateryId = v;
                    _selectedItems.clear();
                  }),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.addVisitRating, style: journalSectionStyle(context)),
                Slider(
                  value: _rating,
                  min: 1,
                  max: 5,
                  divisions: 8,
                  label: _rating.toStringAsFixed(1),
                  onChanged: (v) => setState(() => _rating = v),
                  activeColor: AppColors.coffeeBrown,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          MenuItemPicker(
            title: l10n.addVisitItems,
            menuItems: menuItems,
            selected: _selectedItems,
            onChanged: (v) => setState(() => _selectedItems
              ..clear()
              ..addAll(v)),
          ),
          const SizedBox(height: AppSpacing.sm),
          JournalFormSection(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customItemController,
                    style: journalInkStyle(context, size: 17),
                    decoration: journalInputDecoration(hint: l10n.addVisitCustomItem),
                    onSubmitted: (_) => _addCustomItem(),
                  ),
                ),
                IconButton(onPressed: _addCustomItem, icon: const Icon(CupertinoIcons.plus_circle_fill, color: AppColors.coffeeBrown)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          JournalFormSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _reviewController,
                  maxLines: 4,
                  style: journalInkStyle(context, size: 18),
                  decoration: journalInputDecoration(hint: l10n.addVisitReviewHint),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(l10n.visitCompanions, style: journalSectionStyle(context)),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _companionOptions.map((c) {
                    return JournalMoodChip(
                      label: c,
                      selected: _companion == c,
                      onTap: () => setState(() => _companion = c),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(l10n.addVisitMood, style: journalSectionStyle(context)),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _moods.map((m) {
                    final selected = _moodTags.contains(m);
                    return JournalMoodChip(
                      label: m,
                      selected: selected,
                      onTap: () => setState(() {
                        if (selected) {
                          _moodTags.remove(m);
                        } else {
                          _moodTags.add(m);
                        }
                      }),
                    );
                  }).toList(),
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
                if (_photoDataUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.memory(
                      base64Decode(_photoDataUrl!.split(',').last),
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: _pickPhoto,
                    icon: const Icon(CupertinoIcons.photo_on_rectangle),
                    label: Text(l10n.addVisitPhotoPick),
                  ),
                if (_photoDataUrl != null)
                  TextButton(onPressed: () => setState(() => _photoDataUrl = null), child: Text(l10n.addVisitPhotoRemove)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: effectiveEateryId == null ? null : _save,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.coffeeBrown,
              foregroundColor: AppColors.paper,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(l10n.addVisitSave),
          ),
        ],
      ),
    );
  }
}
