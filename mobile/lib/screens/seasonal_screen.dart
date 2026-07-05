import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../constants/seasonal_collections.dart';
import '../l10n/app_localizations.dart';
import '../models/eatery.dart';
import '../theme/app_theme.dart';
import '../utils/haptics.dart';
import '../widgets/app_background.dart';
import '../widgets/content_sheet.dart';
import '../widgets/eatery_card.dart';
import '../widgets/glass_surface.dart';

class SeasonalScreen extends ConsumerWidget {
  const SeasonalScreen({super.key, required this.collectionId});

  final String collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final collection = seasonalCollections.firstWhere(
      (c) => c.id == collectionId,
      orElse: () => seasonalCollections.first,
    );
    final eateries = ref.watch(allEateriesProvider);

    return AppBackground(
      variant: AppBackgroundVariant.home,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(collection.title),
        ),
        body: eateries.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) {
            final matched = _matchEateries(list, collection);
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlassSurface(
                    borderRadius: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(collection.emoji, style: const TextStyle(fontSize: 36)),
                          const SizedBox(height: 8),
                          Text(
                            collection.subtitle,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.inkBrown, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (seasonalCollections.length > 1)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: seasonalCollections.map((c) {
                          final selected = c.id == collection.id;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text('${c.emoji} ${c.title}'),
                              selected: selected,
                              onSelected: (_) {
                                AppHaptics.selection();
                                context.go('/seasonal/${c.id}');
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 16),
                  ContentSheet(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.seasonalPicks, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        if (matched.isEmpty)
                          Text(l10n.seasonalEmpty)
                        else
                          ...matched.map((e) => Padding(padding: const EdgeInsets.only(bottom: 12), child: EateryCard(eatery: e))),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Eatery> _matchEateries(List<Eatery> list, SeasonalCollection collection) {
    final hints = collection.eateryNameHints.map((h) => h.toLowerCase()).toSet();
    final tags = collection.filterTags.map((t) => t.toLowerCase()).toSet();
    final scored = <({Eatery eatery, int score})>[];

    for (final e in list) {
      var score = 0;
      final name = e.name.toLowerCase();
      for (final h in hints) {
        if (name.contains(h)) score += 3;
      }
      for (final vt in e.venueTypes) {
        if (tags.contains(vt.toLowerCase())) score += 2;
      }
      for (final c in e.cuisines) {
        if (tags.contains(c.toLowerCase())) score += 2;
      }
      if (score > 0) scored.add((eatery: e, score: score));
    }

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.take(12).map((s) => s.eatery).toList();
  }
}
