import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/area_tile.dart';

class AreasScreen extends ConsumerWidget {
  const AreasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final areasAsync = ref.watch(areasProvider);
    final eateriesAsync = ref.watch(allEateriesProvider);

    return AppBackground(
      variant: AppBackgroundVariant.explore,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.areasTitle),
        ),
        body: areasAsync.when(
          data: (areas) {
            final eateries = eateriesAsync.asData?.value ?? [];
            final counts = <String, int>{};
            for (final e in eateries) {
              final a = e.areaName;
              if (a != null) counts[a] = (counts[a] ?? 0) + 1;
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.sm, AppSpacing.screenPadding, 120),
              itemCount: areas.length,
              itemBuilder: (context, i) {
                final area = areas[i];
                final count = counts[area.name] ?? 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AreaTile(
                    name: area.name,
                    eateryCount: count,
                    countLabel: l10n.areaEateryCount(count),
                    onTap: () => context.push('/area/${Uri.encodeComponent(area.name)}'),
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
