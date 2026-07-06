import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../router/navigation.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../utils/eatery_display.dart';
import '../widgets/glass_surface.dart';

class DishesScreen extends ConsumerStatefulWidget {
  const DishesScreen({super.key});

  @override
  ConsumerState<DishesScreen> createState() => _DishesScreenState();
}

class _DishesScreenState extends ConsumerState<DishesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          title: Text(l10n.dishesTitle),
        ),
        body: eateriesAsync.when(
          data: (eateries) {
            final dishes = <({String dish, String eateryId, String eateryName, double price})>[];
            for (final e in eateries) {
              final menu = e.menu;
              if (menu == null) continue;
              for (final item in menu.items) {
                dishes.add((dish: item.name, eateryId: e.id, eateryName: e.name, price: item.price));
              }
            }
            final q = _query.toLowerCase();
            final filtered = q.isEmpty
                ? dishes
                : dishes.where((d) => d.dish.toLowerCase().contains(q) || d.eateryName.toLowerCase().contains(q)).toList();
            filtered.sort((a, b) => a.dish.compareTo(b.dish));

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: GlassSurface(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: l10n.dishesSearchHint,
                        border: InputBorder.none,
                        prefixIcon: const Icon(CupertinoIcons.search, color: AppColors.coffeeBrown, size: 20),
                      ),
                      onChanged: (v) => setState(() => _query = v),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(l10n.dishesResultCount(filtered.length), style: Theme.of(context).textTheme.labelLarge),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, 0, AppSpacing.screenPadding, 120),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final d = filtered[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => context.push('/dish/${Uri.encodeComponent(d.dish)}'),
                            borderRadius: BorderRadius.circular(14),
                            child: GlassSurface(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(d.dish, style: Theme.of(context).textTheme.titleSmall),
                                        Text(d.eateryName, style: Theme.of(context).textTheme.bodySmall),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    formatRs(d.price),
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.coffeeBrown),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
