import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../models/eatery.dart';
import '../theme/app_theme.dart';
import '../utils/dish_rankings.dart';
import '../utils/eatery_display.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_surface.dart';
import '../router/navigation.dart';

class DishDetailScreen extends ConsumerWidget {
  const DishDetailScreen({super.key, required this.dishName});

  final String dishName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final visits = ref.watch(visitsProvider);
    final eateries = ref.watch(allEateriesProvider);

    return AppBackground(
      variant: AppBackgroundVariant.explore,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(icon: const Icon(CupertinoIcons.back), onPressed: () => context.pop()),
          title: Text(dishName),
        ),
        body: visits.when(
          data: (allVisits) {
            final ranking = rankingForDish(allVisits, dishName);
            final menuHits = eateries.maybeWhen(
              data: (list) => list
                  .where((e) => e.menu?.items.any((i) => i.name.toLowerCase() == dishName.toLowerCase()) ?? false)
                  .toList(),
              orElse: () => <Eatery>[],
            );

            return ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.sm, AppSpacing.screenPadding, 120),
              children: [
                if (ranking != null)
                  GlassSurface(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.dishRankingTitle, style: Theme.of(context).textTheme.titleSmall),
                        Text(
                          '${ranking.avgRating.toStringAsFixed(1)}★ · ${ranking.visitCount} visits logged',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                Text(l10n.dishOnMenuAt, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                if (menuHits.isEmpty)
                  Text(l10n.dishNoMenuHits, style: Theme.of(context).textTheme.bodyMedium)
                else
                  ...menuHits.take(20).map((e) {
                    final item = e.menu!.items.firstWhere((i) => i.name.toLowerCase() == dishName.toLowerCase());
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: GlassSurface(
                        child: ListTile(
                          title: Text(e.name),
                          subtitle: Text(e.areaName ?? ''),
                          trailing: Text(formatRs(item.price), style: Theme.of(context).textTheme.labelLarge),
                          onTap: () => openEatery(context, e.id),
                        ),
                      ),
                    );
                  }),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.coffeeBrown)),
          error: (_, _) => Center(child: Text(l10n.errorExplore)),
        ),
      ),
    );
  }
}
