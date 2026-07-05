import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../constants/food_visuals.dart';
import '../l10n/app_localizations.dart';
import '../models/eatery.dart';
import '../providers/local_eateries_provider.dart';
import '../data/sync_queue_store.dart';
import '../providers/sync_queue_provider.dart';
import '../utils/geocode.dart';
import '../router/navigation.dart';
import '../theme/app_theme.dart';
import '../utils/duplicate_eatery.dart';
import '../utils/haptics.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_surface.dart';

class AddEateryScreen extends ConsumerStatefulWidget {
  const AddEateryScreen({super.key});

  @override
  ConsumerState<AddEateryScreen> createState() => _AddEateryScreenState();
}

class _AddEateryScreenState extends ConsumerState<AddEateryScreen> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _address = TextEditingController();
  String? _area;
  final _venueTypes = <String>{};
  final _cuisines = <String>{};

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _name.text.trim();
    final area = _area;
    if (name.isEmpty || area == null) return;

    final all = ref.read(allEateriesProvider).asData?.value ?? [];
    final similar = findSimilarEateries(all, name: name, area: area);
    if (similar.isNotEmpty && mounted) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.addEateryDuplicateTitle),
          content: Text('${similar.first.name} — ${similar.first.areaName}\n\n${l10n.addEateryDuplicateBody}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.addEateryUseExisting),
            ),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.addEateryAddAnyway)),
          ],
        ),
      );
      if (proceed != true) {
        if (mounted) openEatery(context, similar.first.id);
        return;
      }
    }

    AppHaptics.medium();
    final areas = ref.read(areasProvider).asData?.value ?? [];
    final venueTypes = ref.read(venueTypesProvider).asData?.value ?? [];
    final cuisines = ref.read(cuisinesProvider).asData?.value ?? [];
    final areaEntry = areas.where((a) => a.name == area).firstOrNull;
    final coords = await geocodeKarachi(_address.text.trim().isEmpty ? '$name $area' : _address.text.trim());
    final lat = coords?.lat ?? 24.86;
    final lng = coords?.lng ?? 67.03;

    final apiOnline = await ref.read(apiOnlineProvider.future);
    if (apiOnline && areaEntry != null) {
      final api = ref.read(apiClientProvider);
      try {
        final vtIds = venueTypes.where((v) => _venueTypes.contains(v.name)).map((v) => v.id).toList();
        final cuIds = cuisines.where((c) => _cuisines.contains(c.name)).map((c) => c.id).toList();
        final result = await api.createEatery(
          name: name,
          areaId: areaEntry.id,
          venueTypeIds: vtIds,
          cuisineIds: cuIds,
          lat: lat,
          lng: lng,
          address: _address.text.trim().isEmpty ? null : _address.text.trim(),
          description: _description.text.trim().isEmpty ? null : _description.text.trim(),
          ignoreDuplicateWarning: similar.isNotEmpty,
        );
        if (result['duplicateWarning'] == true) {
          final sim = (result['similar'] as List<dynamic>?)?.first as Map<String, dynamic>?;
          if (sim != null && mounted) openEatery(context, sim['id'] as String);
          return;
        }
        ref.invalidate(allEateriesProvider);
        final id = result['id'] as String;
        ref.invalidate(eateryDetailProvider(id));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.addEaterySaved)));
          context.go('/eatery/$id');
        }
        return;
      } catch (_) {
        await ref.read(syncQueueProvider.notifier).enqueue(SyncOpType.createEatery, {
          'name': name,
          'areaId': areaEntry.id,
          'venueTypeIds': venueTypes.where((v) => _venueTypes.contains(v.name)).map((v) => v.id).toList(),
          'cuisineIds': cuisines.where((c) => _cuisines.contains(c.name)).map((c) => c.id).toList(),
          'lat': lat,
          'lng': lng,
          'address': _address.text.trim().isEmpty ? null : _address.text.trim(),
          'description': _description.text.trim().isEmpty ? null : _description.text.trim(),
        });
      }
    }

    final eatery = Eatery(
      id: 'local-eatery-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      areaName: area,
      venueTypes: _venueTypes.toList(),
      cuisines: _cuisines.toList(),
      badges: const [],
      description: _description.text.trim().isEmpty ? null : _description.text.trim(),
      address: _address.text.trim().isEmpty ? null : _address.text.trim(),
      coverPhotoUrl: accentPhoto('hero'),
      lat: lat,
      lng: lng,
      createdAt: DateTime.now(),
    );

    await ref.read(localEateriesProvider.notifier).add(eatery);
    ref.invalidate(allEateriesProvider);
    ref.invalidate(eateryDetailProvider(eatery.id));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.addEaterySaved)));
      context.go('/eatery/${eatery.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final areas = ref.watch(areasProvider).asData?.value ?? [];
    final venueTypes = ref.watch(venueTypesProvider).asData?.value ?? [];
    final cuisines = ref.watch(cuisinesProvider).asData?.value ?? [];

    return AppBackground(
      variant: AppBackgroundVariant.explore,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(icon: const Icon(CupertinoIcons.back), onPressed: () => context.pop()),
          title: Text(l10n.addEateryTitle),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 120),
          children: [
            GlassSurface(
              child: Column(
                children: [
                  TextField(controller: _name, decoration: InputDecoration(labelText: l10n.addEateryName)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _area,
                    decoration: InputDecoration(labelText: l10n.addEateryArea),
                    items: areas.map((a) => DropdownMenuItem(value: a.name, child: Text(a.name))).toList(),
                    onChanged: (v) => setState(() => _area = v),
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: _address, decoration: InputDecoration(labelText: l10n.addEateryAddress)),
                  const SizedBox(height: 12),
                  TextField(controller: _description, maxLines: 3, decoration: InputDecoration(labelText: l10n.addEateryDescription)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            GlassSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Venue type', style: Theme.of(context).textTheme.titleSmall),
                  Wrap(
                    spacing: 8,
                    children: venueTypes
                        .map((v) => FilterChip(
                              label: Text(v.name),
                              selected: _venueTypes.contains(v.name),
                              onSelected: (s) => setState(() => s ? _venueTypes.add(v.name) : _venueTypes.remove(v.name)),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Text('Cuisine', style: Theme.of(context).textTheme.titleSmall),
                  Wrap(
                    spacing: 8,
                    children: cuisines
                        .map((c) => FilterChip(
                              label: Text(c.name),
                              selected: _cuisines.contains(c.name),
                              onSelected: (s) => setState(() => s ? _cuisines.add(c.name) : _cuisines.remove(c.name)),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: _save, child: Text(l10n.addEaterySave)),
          ],
        ),
      ),
    );
  }
}
