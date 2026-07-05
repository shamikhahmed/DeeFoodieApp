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
import '../widgets/app_background.dart';
import '../widgets/eatery_card.dart';
import '../widgets/sticker_empty_state.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final favorites = ref.watch(favoritesProvider);
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
          title: Text(l10n.favoritesTitle),
        ),
        body: eateriesAsync.when(
          data: (all) {
            final list = all.where((e) => favorites.contains(e.id)).toList();
            if (list.isEmpty) {
              return StickerEmptyState(
                message: l10n.favoritesEmpty,
                photoUrl: accentPhoto('favorites'),
                actionLabel: l10n.navExplore,
                onAction: () => context.go('/explore'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.sm, AppSpacing.screenPadding, 120),
              itemCount: list.length,
              itemBuilder: (context, i) => EateryCard(
                eatery: list[i],
                index: i,
                onTap: () => openEatery(context, list[i].id),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.coffeeBrown)),
          error: (_, _) => Center(child: Text(l10n.errorExplore)),
        ),
      ),
    );
  }
}
