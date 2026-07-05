import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../providers/user_archive_prefs_provider.dart';
import '../models/visit.dart';
import '../router/navigation.dart';
import '../utils/eatery_display.dart';
import '../widgets/content_sheet.dart';
import '../widgets/eatery_visit_card.dart';
import '../widgets/glass_surface.dart';
import '../widgets/primary_button.dart';
import '../widgets/nearby_eateries_section.dart';
import '../widgets/pioneer_badge.dart';
import '../widgets/eatery_details_section.dart';
import '../widgets/discount_deals_section.dart';
import '../widgets/section_header.dart';
import '../utils/eatery_cover.dart';

class EateryProfileScreen extends ConsumerWidget {
  const EateryProfileScreen({super.key, required this.eateryId});

  final String eateryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final eateryAsync = ref.watch(eateryDetailProvider(eateryId));
    final visitsAsync = ref.watch(visitsProvider);

    return eateryAsync.when(
      data: (eatery) {
        if (eatery == null) {
          return Scaffold(
            backgroundColor: AppColors.paper,
            appBar: AppBar(leading: IconButton(icon: const Icon(CupertinoIcons.back), onPressed: () => context.pop())),
            body: Center(child: Text(l10n.eateryNotFound)),
          );
        }
        final visits = visitsAsync.maybeWhen(
          data: (all) => sortVisitsByDate(all.where((v) => v.eateryId == eateryId).toList()),
          orElse: () => <Visit>[],
        );
        final favorites = ref.watch(favoritesProvider);
        final wishlist = ref.watch(wishlistProvider);
        final isFavorite = favorites.contains(eateryId);
        final onWishlist = wishlist.any((w) => w.eateryId == eateryId);
        final mustTry = mustTryFromVisits(eatery, visitsAsync.asData?.value ?? []) ?? mustTryItem(eatery);

        return Scaffold(
          backgroundColor: AppColors.cream,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.coffeeBrown,
                foregroundColor: AppColors.paper,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                leading: IconButton(
                  icon: const Icon(CupertinoIcons.back),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButton(
                    icon: Icon(isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart),
                    color: isFavorite ? AppColors.rust : AppColors.paper,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ref.read(favoritesProvider.notifier).toggle(eateryId);
                    },
                  ),
                  IconButton(
                    icon: Icon(onWishlist ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark),
                    onPressed: () async {
                      HapticFeedback.lightImpact();
                      if (onWishlist) {
                        await ref.read(wishlistProvider.notifier).remove(eateryId);
                      } else {
                        await ref.read(wishlistProvider.notifier).add(eateryId);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.wishlistAdd), duration: const Duration(seconds: 2)),
                          );
                        }
                      }
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (eateryHasNetworkCover(eatery))
                        CachedNetworkImage(
                          imageUrl: eatery.coverPhotoUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => Image.asset(eateryCoverAsset(eatery), fit: BoxFit.cover),
                        )
                      else
                        Image.asset(eateryCoverAsset(eatery), fit: BoxFit.cover),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.15),
                              Colors.black.withValues(alpha: 0.65),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: AppSpacing.md,
                        right: AppSpacing.md,
                        bottom: 20,
                        child: Text(
                          eatery.name,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: AppColors.paper,
                                shadows: const [Shadow(blurRadius: 12, color: Colors.black54)],
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ContentSheet(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PioneerBadge(eateryId: eateryId),
                      const SizedBox(height: AppSpacing.md),
                      DiscountDealsSection(eateryName: eatery.name),
                      EateryDetailsSection(eatery: eatery),
                      if (eatery.areaName != null)
                        Text(eatery.areaName!, style: Theme.of(context).textTheme.bodyMedium),
                      if (hasDisplayRating(eatery)) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.rust, size: 22),
                            const SizedBox(width: 6),
                            Text(displayRating(eatery).toStringAsFixed(1), style: Theme.of(context).textTheme.titleLarge),
                            if (eatery.visitCount > 0) ...[
                              const SizedBox(width: AppSpacing.sm),
                              Text(l10n.eateryVisitCount(eatery.visitCount), style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ],
                        ),
                      ],
                      if (eatery.badges.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: eatery.badges
                              .map(
                                (b) => Chip(
                                  label: Text(b),
                                  backgroundColor: AppColors.coffeeBrown.withValues(alpha: 0.12),
                                  labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppColors.coffeeBrown,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      if (eatery.description != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(eatery.description!, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.55)),
                      ],
                      if (eatery.venueTypes.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ...eatery.venueTypes.map((t) => Chip(label: Text(t))),
                            ...eatery.cuisines.map((c) => Chip(label: Text(c))),
                          ],
                        ),
                      ],
                      if (mustTry != null) ...[
                        const SizedBox(height: AppSpacing.lg),
                        SectionHeader(title: l10n.eateryMustTry),
                        GlassSurface(
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.rust.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.restaurant_menu_rounded, color: AppColors.rust),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(mustTry.name, style: Theme.of(context).textTheme.titleMedium),
                                    if (mustTry.price > 0)
                                      Text(formatRs(mustTry.price), style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.coffeeBrown)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (eatery.menu != null && eatery.menu!.items.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.lg),
                        SectionHeader(
                          title: l10n.eateryMenu,
                          subtitle: l10n.eateryMenuYear(eatery.menu!.effectiveYear),
                        ),
                        GlassSurface(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              for (var i = 0; i < eatery.menu!.items.length; i++) ...[
                                if (i > 0)
                                  Divider(height: 1, indent: AppSpacing.md, endIndent: AppSpacing.md, color: AppColors.inkBrown.withValues(alpha: 0.1)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 4),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(eatery.menu!.items[i].name, style: Theme.of(context).textTheme.bodyLarge)),
                                      Text(formatRs(eatery.menu!.items[i].price), style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.coffeeBrown, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      PrimaryButton(
                        label: l10n.addVisit,
                        icon: CupertinoIcons.plus,
                        onPressed: () => context.push('/add-visit?eateryId=$eateryId'),
                      ),
                      if (visits.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.lg),
                        SectionHeader(title: l10n.eateryVisitsHere, subtitle: l10n.compareVisitsHint(visits.length)),
                        ...visits.map((v) => EateryVisitCard(visit: v, onTap: () => openVisit(context, v.id))),
                      ] else ...[
                        const SizedBox(height: AppSpacing.lg),
                        GlassSurface(
                          child: Text(l10n.eateryNoVisitsYet, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      NearbyEateriesSection(eatery: eatery),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.paper,
        body: Center(child: CircularProgressIndicator(color: AppColors.coffeeBrown)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.paper,
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(icon: const Icon(CupertinoIcons.back), onPressed: () => context.pop()),
              ),
              Expanded(child: Center(child: Text(l10n.errorExplore))),
            ],
          ),
        ),
      ),
    );
  }
}
