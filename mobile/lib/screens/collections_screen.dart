import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../providers/collections_provider.dart';
import '../router/navigation.dart';
import '../theme/app_theme.dart';
import '../widgets/journal_screen_shell.dart';
import '../widgets/glass_surface.dart';

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final collections = ref.watch(collectionsProvider);
    final eateries = ref.watch(allEateriesProvider).asData?.value ?? [];
    final byId = {for (final e in eateries) e.id: e};

    return JournalScreenShell(
      title: l10n.collectionsTitle,
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.plus),
          onPressed: () => _createCollection(context, ref, l10n),
        ),
      ],
      body: collections.isEmpty
          ? Center(child: Text(l10n.collectionsEmpty))
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: collections.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, i) {
                final c = collections[i];
                final names = c.eateryIds.map((id) => byId[id]?.name).whereType<String>().take(3).join(' · ');
                return GlassSurface(
                  child: ListTile(
                    title: Text(c.name, style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Text(names.isEmpty ? l10n.collectionsNoPlaces : names),
                    trailing: Text('${c.eateryIds.length}'),
                    onTap: () => context.push('/collections/${c.id}'),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _createCollection(BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.collectionsNew),
        content: TextField(controller: controller, autofocus: true, decoration: InputDecoration(hintText: l10n.collectionsNameHint)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: Text(l10n.save)),
        ],
      ),
    );
    controller.dispose();
    if (name != null && name.trim().isNotEmpty) {
      await ref.read(collectionsProvider.notifier).create(name.trim());
    }
  }
}

class CollectionDetailScreen extends ConsumerWidget {
  const CollectionDetailScreen({super.key, required this.collectionId});

  final String collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final collections = ref.watch(collectionsProvider);
    final collection = collections.where((c) => c.id == collectionId).firstOrNull;
    if (collection == null) {
      return Scaffold(appBar: AppBar(), body: Center(child: Text(l10n.errorExplore)));
    }

    final eateries = ref.watch(allEateriesProvider).asData?.value ?? [];

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(CupertinoIcons.back), onPressed: () => context.pop()),
        title: Text(collection.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Text(l10n.collectionsAddFromExplore, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          ...eateries.take(40).map(
            (e) {
              final inList = collection.eateryIds.contains(e.id);
              return CheckboxListTile(
                value: inList,
                title: Text(e.name),
                subtitle: Text(e.areaName ?? ''),
                onChanged: (_) => ref.read(collectionsProvider.notifier).toggleEatery(collection.id, e.id),
              );
            },
          ),
          if (collection.eateryIds.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            ...collection.eateryIds.map((id) {
              final e = eateries.where((x) => x.id == id).firstOrNull;
              if (e == null) return const SizedBox.shrink();
              return ListTile(
                title: Text(e.name),
                onTap: () => openEatery(context, e.id),
              );
            }),
          ],
        ],
      ),
    );
  }
}
