import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../models/eatery.dart';
import '../providers/user_archive_prefs_provider.dart';
import '../utils/eatery_display.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_prefs_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/tab_screen_scaffold.dart';
import '../widgets/demo_mode_banner.dart';
import '../widgets/eatery_card.dart';
import '../widgets/glass_surface.dart';
import '../widgets/home_hero.dart';
import '../widgets/horizontal_section.dart';
import '../widgets/home_stats_strip.dart';
import '../widgets/home_area_chips.dart';
import '../widgets/home_spotlight_card.dart';
import '../router/navigation.dart';
import '../widgets/home_personal_dashboard.dart';
import '../widgets/home_review_card.dart';
import '../constants/food_visuals.dart';
import '../utils/craving_match.dart';
import '../utils/chain_match.dart';
import '../providers/taste_profile_provider.dart';
import '../providers/map_heat_provider.dart';
import '../utils/dictionary_lookup.dart';
import '../widgets/home_craving_banner.dart';
import '../widgets/friend_activity_card.dart';
import '../widgets/home_seasonal_strip.dart';
import '../widgets/home_near_me_banner.dart';
import '../widgets/home_mood_strip.dart';
import '../widgets/sync_queue_banner.dart';
import '../widgets/quick_log_sheet.dart';
import '../widgets/stagger_entrance.dart';
import '../widgets/visit_preview_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    HapticFeedback.lightImpact();
    ref.invalidate(allEateriesProvider);
    ref.invalidate(visitsProvider);
    ref.invalidate(areasProvider);
    await Future.wait([
      ref.read(allEateriesProvider.future),
      ref.read(visitsProvider.future),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final eateriesAsync = ref.watch(allEateriesProvider);
    final visitsAsync = ref.watch(visitsProvider);
    final areasAsync = ref.watch(areasProvider);
    final onboarding = ref.watch(onboardingAnswersProvider).asData?.value;
    final taste = ref.watch(tasteProfileProvider);

    final craving = onboarding?.craving ?? '';
    final favoriteArea = onboarding?.favoriteArea ?? '';
    final chains = taste.favoriteChains;

    final greeting = onboarding != null && onboarding.craving.isNotEmpty
        ? '${l10n.homeGreeting} · ${onboarding.craving}'
        : l10n.homeGreeting;

    final stats = ref.watch(personalStatsProvider);

    return TabScreenScaffold(
      child: SafeArea(
        child: RefreshIndicator(
          color: AppColors.coffeeBrown,
          onRefresh: _refresh,
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.sm,
              AppSpacing.screenPadding,
              120,
            ),
            children: [
              // offline pill only when needed — no giant banner
              const DemoModeBanner(),
              const SyncQueueBanner(),
              const FriendActivityCard(),
              StaggerEntrance(
                index: 0,
                child: HomeHero(
                  greeting: greeting,
                  appName: l10n.appName,
                  scoreLabel: l10n.homeKarachiScore,
                  onScoreTap: () {
                    ref.read(mapHeatModeProvider.notifier).enable();
                    context.go('/map');
                  },
                  accentPhotoUrl: craving.isNotEmpty ? cravingPhoto(craving) : accentPhoto('hero'),
                  subtitle: eateriesAsync.maybeWhen(
                    data: (e) => '${e.length} Karachi eateries in the city archive',
                    orElse: () => null,
                  ),
                  karachiScorePct: visitsAsync.maybeWhen(
                    data: (visits) => eateriesAsync.maybeWhen(
                      data: (eateries) => areasAsync.maybeWhen(
                        data: (areas) => computeKarachiScorePct(visits, eateries, areas.length),
                        orElse: () => null,
                      ),
                      orElse: () => null,
                    ),
                    orElse: () => null,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const StaggerEntrance(index: 1, child: HomeSeasonalStrip()),
              const SizedBox(height: AppSpacing.md),
              const StaggerEntrance(index: 2, child: HomeNearMeBanner()),
              if (craving.isNotEmpty)
                eateriesAsync.maybeWhen(
                  data: (all) {
                    final matches = filterByCraving(all, craving);
                    if (matches.isEmpty) return const SizedBox.shrink();
                    return StaggerEntrance(
                      index: 1,
                      child: HomeCravingBanner(
                        craving: craving,
                        matchCount: matches.length,
                        title: l10n.homeCravingTitle(craving),
                        subtitle: l10n.homeCravingSubtitle,
                        actionLabel: l10n.homeCravingCta,
                        onTap: () {
                          ref.read(eateryFilterProvider.notifier).applyCraving(craving);
                          context.go('/explore');
                        },
                      ),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
              if (craving.isNotEmpty && dictionaryEntryForCraving(craving) != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => context.push('/dictionary'),
                      icon: const Icon(Icons.menu_book_outlined, size: 18),
                      label: Text(l10n.dictionaryFromCraving(dictionaryEntryForCraving(craving)!.term)),
                    ),
                  ),
                ),
              if (craving.isNotEmpty) const SizedBox(height: AppSpacing.md),
              if (chains.isNotEmpty)
                eateriesAsync.maybeWhen(
                  data: (all) {
                    final matches = filterByChains(all, chains).take(12).toList();
                    if (matches.isEmpty) return const SizedBox.shrink();
                    return StaggerEntrance(
                      index: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.homeChainsTitle, style: Theme.of(context).textTheme.titleMedium),
                                Text(
                                  l10n.homeChainsSubtitle,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 168,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              itemCount: matches.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 12),
                              itemBuilder: (context, i) => HomeMustTryCard(
                                eatery: matches[i],
                                highlight: true,
                                onTap: () => openEatery(context, matches[i].id),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
              if (chains.isNotEmpty) const SizedBox(height: AppSpacing.md),
              eateriesAsync.maybeWhen(
                data: (all) {
                  final pick = pickSpotlight(all, craving: craving, favoriteArea: favoriteArea);
                  if (pick == null) return const SizedBox.shrink();
                  final spotlightTitle = craving.isNotEmpty
                      ? l10n.homeSpotlightCraving(craving)
                      : l10n.homeSpotlight;
                  return StaggerEntrance(
                    index: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Text(spotlightTitle, style: Theme.of(context).textTheme.titleMedium),
                        ),
                        HomeSpotlightCard(
                          eatery: pick,
                          subtitle: pick.cuisines.isNotEmpty ? pick.cuisines.first : 'Karachi',
                          onTap: () => openEatery(context, pick.id),
                        ),
                      ],
                    ),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.md),
              eateriesAsync.maybeWhen(
                data: (all) {
                  final withMustTry = all.where((e) => mustTryItem(e) != null).toList();
                  final mustTry = sortCravingFirst(withMustTry, craving).take(12).toList();
                  if (mustTry.isEmpty) return const SizedBox.shrink();
                  return StaggerEntrance(
                    index: 4,
                    child: HorizontalSection(
                      title: l10n.homeMustTry,
                      itemCount: mustTry.length,
                      height: 168,
                      itemBuilder: (context, i) => HomeMustTryCard(
                        eatery: mustTry[i],
                        highlight: craving.isNotEmpty && eateryMatchesCraving(mustTry[i], craving),
                        onTap: () => openEatery(context, mustTry[i].id),
                      ),
                    ),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              StaggerEntrance(
                index: 5,
                child: HomePersonalDashboard(
                  stats: stats,
                  onJournalTap: () => context.go('/journal'),
                  onPassportTap: () => context.push('/passport'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              StaggerEntrance(index: 6, child: HomeMoodStrip(title: l10n.homeMoodStrip)),
              const SizedBox(height: AppSpacing.md),
              eateriesAsync.maybeWhen(
                data: (all) => areasAsync.maybeWhen(
                  data: (areas) => visitsAsync.maybeWhen(
                    data: (visits) => StaggerEntrance(
                      index: 7,
                      child: HomeStatsStrip(
                        eateryCount: all.length,
                        visitCount: visits.length,
                        areaCount: areas.length,
                        eateriesLabel: l10n.homeArchiveEateries,
                        visitsLabel: l10n.homeArchiveVisits,
                        areasLabel: l10n.homeArchiveAreas,
                      ),
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
                orElse: () => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.md),
              StaggerEntrance(
                index: 6,
                child: const _DiscoverLinks(),
              ),
              const SizedBox(height: AppSpacing.md),
              StaggerEntrance(
                index: 7,
                child: _QuickActions(
                  onExplore: () => context.go('/explore'),
                  onAddVisit: () => context.push('/add-visit'),
                  onQuickLog: () => QuickLogSheet.show(context),
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              areasAsync.maybeWhen(
                data: (areas) => StaggerEntrance(
                  index: 8,
                  child: HomeAreaChips(
                    title: l10n.homeBrowseAreas,
                    areas: areas.take(10).map((a) => a.name).toList(),
                    onAreaTap: (area) {
                      ref.read(eateryFilterProvider.notifier).toggleArea(area);
                      context.go('/explore');
                    },
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.md),
              visitsAsync.when(
                data: (visits) {
                  final recent = sortVisitsByDate(visits).take(6).toList();
                  if (recent.isEmpty) return const SizedBox.shrink();
                  return StaggerEntrance(
                    index: 9,
                    child: HorizontalSection(
                      title: l10n.homeRecentVisits,
                      actionLabel: l10n.homeSeeAll,
                      onAction: () => context.go('/journal'),
                      itemCount: recent.length,
                      height: 172,
                      itemBuilder: (context, i) => VisitPreviewCard(
                        visit: recent[i],
                        onTap: () => openVisit(context, recent[i].id),
                      ),
                    ),
                  );
                },
                loading: () => Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.coffeeBrown.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
                error: (_, _) => const SizedBox.shrink(),
              ),
              visitsAsync.maybeWhen(
                data: (visits) {
                  final withReviews = sortVisitsByDate(visits)
                      .where((v) => v.reviewText != null && v.reviewText!.trim().isNotEmpty)
                      .take(8)
                      .toList();
                  if (withReviews.isEmpty) return const SizedBox.shrink();
                  return StaggerEntrance(
                    index: 10,
                    child: HorizontalSection(
                      title: l10n.homeLatestReviews,
                      actionLabel: l10n.homeSeeAll,
                      onAction: () => context.go('/journal'),
                      itemCount: withReviews.length,
                      height: 200,
                      itemBuilder: (context, i) => HomeReviewCard(
                        eateryName: withReviews[i].eateryName,
                        rating: withReviews[i].rating,
                        reviewText: withReviews[i].reviewText!,
                        userName: withReviews[i].userName,
                        onTap: () => openVisit(context, withReviews[i].id),
                      ),
                    ),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
              eateriesAsync.when(
                data: (all) {
                  final recent = sortByCreatedAt(all).take(8).toList();
                  final rated = sortByRating(all).where((e) => (e.avgRating ?? 0) > 0).take(6).toList();
                  final random = all.isEmpty ? null : all[DateTime.now().millisecond % all.length];

                  return Column(
                    children: [
                      if (recent.isNotEmpty)
                        StaggerEntrance(
                          index: 11,
                          child: HorizontalSection(
                            title: l10n.homeRecentlyAdded,
                            itemCount: recent.length,
                            height: 220,
                            itemBuilder: (context, i) => EateryCard(
                              eatery: recent[i],
                              index: i,
                              compact: true,
                              onTap: () => openEatery(context, recent[i].id),
                            ),
                          ),
                        ),
                      if (random != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        StaggerEntrance(
                          index: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                child: Text(
                                  l10n.homeRandomRecommendation,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              EateryCard(
                                eatery: random,
                                index: 0,
                                onTap: () => openEatery(context, random.id),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (rated.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        StaggerEntrance(
                          index: 9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                child: Text(
                                  l10n.homeHighestRated,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              ...rated.take(3).map(
                                    (e) => EateryCard(
                                      eatery: e,
                                      index: 0,
                                      onTap: () => openEatery(context, e.id),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      StaggerEntrance(
                        index: 10,
                        child: const _HomeWishlistPreview(),
                      ),
                    ],
                  );
                },
                loading: () => Column(
                  children: List.generate(3, (_) => const EateryCardSkeleton()),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiscoverLinks extends StatelessWidget {
  const _DiscoverLinks();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.homeDiscover, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _DiscoverChip(
              icon: CupertinoIcons.map_pin_ellipse,
              label: l10n.homeLinkAreas,
              onTap: () => context.push('/areas'),
            ),
            _DiscoverChip(
              icon: CupertinoIcons.heart,
              label: l10n.homeLinkFavorites,
              onTap: () => context.push('/favorites'),
            ),
            _DiscoverChip(
              icon: CupertinoIcons.bookmark,
              label: l10n.homeLinkWishlist,
              onTap: () => context.push('/wishlist'),
            ),
            _DiscoverChip(
              icon: CupertinoIcons.search,
              label: l10n.homeLinkDishes,
              onTap: () => context.push('/dishes'),
            ),
            _DiscoverChip(
              icon: CupertinoIcons.checkmark_seal,
              label: l10n.homeLinkPassport,
              onTap: () => context.push('/passport'),
            ),
            _DiscoverChip(
              icon: CupertinoIcons.flag,
              label: l10n.homeLinkTrails,
              onTap: () => context.push('/trails'),
            ),
            _DiscoverChip(
              icon: CupertinoIcons.gift,
              label: l10n.homeLinkWrapped,
              onTap: () => context.push('/wrapped'),
            ),
            _DiscoverChip(
              icon: CupertinoIcons.moon_stars,
              label: l10n.homeLinkSeasonal,
              onTap: () => context.push('/seasonal/ramadan-iftar'),
            ),
            _DiscoverChip(icon: CupertinoIcons.rectangle_stack, label: l10n.homeLinkCollections, onTap: () => context.push('/collections')),
            _DiscoverChip(icon: CupertinoIcons.cart, label: l10n.homeLinkOrder, onTap: () => context.push('/order')),
            _DiscoverChip(icon: CupertinoIcons.heart_slash, label: l10n.homeLinkMissIt, onTap: () => context.push('/miss-it')),
            _DiscoverChip(icon: CupertinoIcons.book, label: l10n.homeLinkDictionary, onTap: () => context.push('/dictionary')),
            _DiscoverChip(icon: CupertinoIcons.plus_rectangle, label: l10n.homeLinkAddEatery, onTap: () => context.push('/add-eatery')),
          ],
        ),
      ],
    );
  }
}

class _DiscoverChip extends StatelessWidget {
  const _DiscoverChip({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(14),
        child: GlassSurface(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          borderRadius: 14,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.coffeeBrown),
              const SizedBox(width: 6),
              Text(label, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeWishlistPreview extends ConsumerWidget {
  const _HomeWishlistPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final wishlist = ref.watch(wishlistProvider);
    final eateriesAsync = ref.watch(allEateriesProvider);

    return GlassSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(l10n.homeWishlist, style: Theme.of(context).textTheme.titleMedium)),
              if (wishlist.isNotEmpty)
                TextButton(
                  onPressed: () => context.push('/wishlist'),
                  child: Text(l10n.homeSeeAll),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (wishlist.isEmpty)
            Text(l10n.homeWishlistEmpty, style: Theme.of(context).textTheme.bodyMedium)
          else
            eateriesAsync.maybeWhen(
              data: (all) {
                final byId = {for (final e in all) e.id: e};
                final preview = wishlist.take(3).map((w) => byId[w.eateryId]).whereType<Eatery>().toList();
                return Column(
                  children: preview
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: InkWell(
                            onTap: () => openEatery(context, e.id),
                            child: Row(
                              children: [
                                const Icon(CupertinoIcons.bookmark_fill, size: 14, color: AppColors.rust),
                                const SizedBox(width: 8),
                                Expanded(child: Text(e.name, style: Theme.of(context).textTheme.bodyMedium)),
                                if (hasDisplayRating(e)) ...[
                                  const Icon(Icons.star_rounded, color: AppColors.rust, size: 12),
                                  const SizedBox(width: 2),
                                  Text(displayRating(e).toStringAsFixed(1), style: Theme.of(context).textTheme.labelSmall),
                                  const SizedBox(width: 6),
                                ],
                                if (e.areaName != null)
                                  Text(e.areaName!, style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onExplore, required this.onAddVisit, required this.onQuickLog});

  final VoidCallback onExplore;
  final VoidCallback onAddVisit;
  final VoidCallback onQuickLog;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _ActionPill(
            icon: CupertinoIcons.compass,
            label: l10n.navExplore,
            onTap: onExplore,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _ActionPill(
            icon: CupertinoIcons.bolt,
            label: l10n.quickLogTitle,
            onTap: onQuickLog,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _ActionPill(
            icon: CupertinoIcons.plus_circle,
            label: l10n.addVisit,
            filled: true,
            onTap: onAddVisit,
          ),
        ),
      ],
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: GlassSurface(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 4),
          borderRadius: 16,
          tintOpacity: filled ? 0.68 : 0.55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: AppColors.coffeeBrown),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
