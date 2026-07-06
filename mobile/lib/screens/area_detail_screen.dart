import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../constants/area_stories.dart';
import '../constants/food_visuals.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../router/navigation.dart';
import '../utils/eatery_display.dart';
import '../widgets/eatery_card.dart';

class AreaDetailScreen extends ConsumerWidget {
  const AreaDetailScreen({super.key, required this.areaName});

  final String areaName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          title: Text(areaName),
        ),
        body: eateriesAsync.when(
          data: (all) {
            final list = all.where((e) => e.areaName == areaName).toList()
              ..sort((a, b) => displayRating(b).compareTo(displayRating(a)));
            if (list.isEmpty) {
              return Center(child: Text(l10n.emptyExplore));
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.sm, AppSpacing.screenPadding, 120),
              itemCount: list.length + 2,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: areaPhoto(areaName),
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  AppColors.inkBrown.withValues(alpha: 0.72),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: AppSpacing.md,
                          right: AppSpacing.md,
                          bottom: AppSpacing.md,
                          child: Text(
                            areaName,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.paper),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (i == 1) {
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(areaStory(areaName), style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: AppSpacing.sm),
                        Text(l10n.areaEateryCount(list.length), style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  );
                }
                final e = list[i - 2];
                return EateryCard(
                  eatery: e,
                  index: i,
                  onTap: () => openEatery(context, e.id),
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
