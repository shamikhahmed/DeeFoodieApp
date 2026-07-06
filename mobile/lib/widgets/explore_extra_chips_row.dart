import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/price_band.dart';
import '../api/providers.dart';

class ExploreExtraChipsRow extends ConsumerWidget {
  const ExploreExtraChipsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final filter = ref.watch(eateryFilterProvider);
    final notifier = ref.read(eateryFilterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.sm, AppSpacing.screenPadding, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilterChip(
            label: Text(l10n.exploreUnvisited),
            selected: filter.unvisitedOnly,
            onSelected: (_) => notifier.toggleUnvisited(),
          ),
          for (final band in PriceBand.values)
            FilterChip(
              label: Text(switch (band) {
                PriceBand.budget => l10n.explorePriceBudget,
                PriceBand.mid => l10n.explorePriceMid,
                PriceBand.splurge => l10n.explorePriceSplurge,
              }),
              selected: filter.priceBand == band,
              onSelected: (_) => notifier.togglePriceBand(band),
            ),
        ],
      ),
    );
  }
}
