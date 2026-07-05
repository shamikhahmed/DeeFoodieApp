import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_archive_prefs_provider.dart';
import '../router/navigation.dart';
import '../constants/food_visuals.dart';
import '../theme/app_theme.dart';
import '../utils/eatery_display.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_surface.dart';
import '../widgets/sticker_empty_state.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final wishlist = ref.watch(wishlistProvider);
    final eateriesAsync = ref.watch(allEateriesProvider);

    return AppBackground(
      variant: AppBackgroundVariant.profile,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.wishlistTitle),
        ),
        body: eateriesAsync.when(
          data: (all) {
            if (wishlist.isEmpty) {
              return StickerEmptyState(
                message: l10n.wishlistEmpty,
                photoUrl: accentPhoto('wishlist'),
                actionLabel: l10n.navExplore,
                onAction: () => context.go('/explore'),
              );
            }
            final byId = {for (final e in all) e.id: e};
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.sm, AppSpacing.screenPadding, 120),
              itemCount: wishlist.length,
              itemBuilder: (context, i) {
                final entry = wishlist[i];
                final eatery = byId[entry.eateryId];
                if (eatery == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GlassSurface(
                    child: InkWell(
                      onTap: () => openEatery(context, eatery.id),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(eatery.name, style: Theme.of(context).textTheme.titleMedium),
                                if (eatery.areaName != null)
                                  Text(eatery.areaName!, style: Theme.of(context).textTheme.bodySmall),
                                if (hasDisplayRating(eatery)) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, color: AppColors.rust, size: 14),
                                      const SizedBox(width: 4),
                                      Text(displayRating(eatery).toStringAsFixed(1), style: Theme.of(context).textTheme.labelSmall),
                                    ],
                                  ),
                                ],
                                if (mustTryItem(eatery) case final mt?) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    mt.price > 0 ? '${mt.name} · ${formatRs(mt.price)}' : mt.name,
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.darkGreen),
                                  ),
                                ],
                                if (entry.reason.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(entry.reason, style: Theme.of(context).textTheme.bodyMedium),
                                ],
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(CupertinoIcons.trash, size: 20),
                            onPressed: () => ref.read(wishlistProvider.notifier).remove(entry.eateryId),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.coffeeBrown)),
          error: (_, _) => Center(child: Text(l10n.errorExplore)),
        ),
      ),
    );
  }
}
