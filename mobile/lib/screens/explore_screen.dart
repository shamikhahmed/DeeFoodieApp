import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/providers.dart';
import '../providers/user_archive_prefs_provider.dart';
import '../router/navigation.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/tab_screen_scaffold.dart';
import '../constants/food_visuals.dart';
import '../widgets/eatery_card.dart';
import '../widgets/glass_surface.dart';
import '../providers/discount_cards_provider.dart';
import '../widgets/explore_filter_chip.dart';
import '../widgets/sticker_empty_state.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _scrollController = ScrollController();
  bool _showFilters = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final eateries = ref.watch(sortedEateriesProvider);

    return TabScreenScaffold(
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.md,
                AppSpacing.screenPadding,
                AppSpacing.sm,
              ),
              child: Text(l10n.exploreTitle, style: Theme.of(context).textTheme.displaySmall),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: GlassSurface(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: TextField(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.inkBrown),
                  decoration: InputDecoration(
                    hintText: l10n.searchHint,
                    border: InputBorder.none,
                    prefixIcon: const Icon(CupertinoIcons.search, color: AppColors.coffeeBrown, size: 20),
                    prefixIconConstraints: const BoxConstraints(minWidth: 36),
                  ),
                  onChanged: (q) => ref.read(eateryFilterProvider.notifier).setQuery(q),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const _SortChipsRow(),
            const SizedBox(height: AppSpacing.sm),
            const _MyDealsChipRow(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: GlassSurface(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => setState(() => _showFilters = !_showFilters),
                    icon: Icon(_showFilters ? CupertinoIcons.chevron_up : CupertinoIcons.slider_horizontal_3),
                    label: Text(_showFilters ? l10n.exploreHideFilters : l10n.exploreFilters),
                  ),
                ),
              ),
            ),
            if (_showFilters) ...[
              const SizedBox(height: AppSpacing.sm),
              const _FilterChipsRow(),
            ],
            eateries.when(
              data: (list) => list.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, 0, AppSpacing.screenPadding, AppSpacing.sm),
                      child: GlassSurface(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                        child: Text(l10n.exploreResultCount(list.length), style: Theme.of(context).textTheme.labelLarge),
                      ),
                    )
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: eateries.when(
                data: (list) => list.isEmpty
                    ? StickerEmptyState(message: l10n.emptyExplore, photoUrl: accentPhoto('explore'))
                    : RefreshIndicator(
                        color: AppColors.coffeeBrown,
                        onRefresh: () async {
                          HapticFeedback.lightImpact();
                          ref.invalidate(eateriesProvider);
                          await ref.read(eateriesProvider.future);
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.screenPadding,
                            4,
                            AppSpacing.screenPadding,
                            120,
                          ),
                          itemCount: list.length,
                          itemBuilder: (context, i) => EateryCard(
                            eatery: list[i],
                            index: i,
                            onTap: () => openEatery(context, list[i].id),
                          ),
                        ),
                      ),
                loading: () => ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
                  itemCount: 6,
                  itemBuilder: (_, __) => const EateryCardSkeleton(),
                ),
                error: (e, _) => StickerEmptyState(
                  message: l10n.errorExplore,
                  photoUrl: accentPhoto('explore'),
                  actionLabel: l10n.tryAgain,
                  onAction: () => ref.invalidate(eateriesProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyDealsChipRow extends ConsumerWidget {
  const _MyDealsChipRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final on = ref.watch(myDealsFilterProvider);
    final cards = ref.watch(discountCardsProvider);
    if (cards.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FilterChip(
          avatar: const Icon(Icons.local_offer_outlined, size: 18),
          label: Text(l10n.exploreMyDeals),
          selected: on,
          onSelected: (_) {
            HapticFeedback.selectionClick();
            ref.read(myDealsFilterProvider.notifier).toggle();
          },
        ),
      ),
    );
  }
}

class _SortChipsRow extends ConsumerWidget {
  const _SortChipsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sort = ref.watch(exploreSortProvider);
    final notifier = ref.read(exploreSortProvider.notifier);

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        children: [
          _SortChip(
            label: l10n.exploreSortRating,
            selected: sort == ExploreSort.rating,
            onTap: () => notifier.setSort(ExploreSort.rating),
          ),
          const SizedBox(width: AppSpacing.sm),
          _SortChip(
            label: l10n.exploreSortName,
            selected: sort == ExploreSort.name,
            onTap: () => notifier.setSort(ExploreSort.name),
          ),
          const SizedBox(width: AppSpacing.sm),
          _SortChip(
            label: l10n.exploreSortArea,
            selected: sort == ExploreSort.area,
            onTap: () => notifier.setSort(ExploreSort.area),
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        HapticFeedback.selectionClick();
        onTap();
      },
    );
  }
}

class _FilterChipsRow extends ConsumerWidget {
  const _FilterChipsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venueTypes = ref.watch(venueTypesProvider).value ?? [];
    final cuisines = ref.watch(cuisinesProvider).value ?? [];
    final areas = ref.watch(areasProvider).value ?? [];
    final filter = ref.watch(eateryFilterProvider);
    final notifier = ref.read(eateryFilterProvider.notifier);

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        children: [
          for (final v in venueTypes)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ExploreFilterChip(
                label: v.name,
                selected: filter.venueType == v.name,
                onTap: () {
                  HapticFeedback.selectionClick();
                  notifier.toggleVenueType(v.name);
                },
              ),
            ),
          for (final c in cuisines)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ExploreFilterChip(
                label: c.name,
                selected: filter.cuisine == c.name,
                accent: AppColors.rust,
                onTap: () {
                  HapticFeedback.selectionClick();
                  notifier.toggleCuisine(c.name);
                },
              ),
            ),
          for (final a in areas)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ExploreFilterChip(
                label: a.name,
                selected: filter.area == a.name,
                accent: AppColors.darkGreen,
                onTap: () {
                  HapticFeedback.selectionClick();
                  notifier.toggleArea(a.name);
                },
              ),
            ),
        ],
      ),
    );
  }
}
