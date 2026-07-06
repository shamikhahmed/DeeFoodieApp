import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../models/eatery.dart';
import '../providers/near_me_provider.dart';
import '../theme/app_theme.dart';
import '../utils/geo.dart';
import '../widgets/glass_surface.dart';
import '../router/navigation.dart';

class HomeNearMeBanner extends ConsumerWidget {
  const HomeNearMeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final pos = ref.watch(nearMePositionProvider);
    final eateries = ref.watch(allEateriesProvider);

    return pos.when(
      data: (position) {
        if (position == null) return const SizedBox.shrink();
        return eateries.maybeWhen(
          data: (all) {
            final near = nearbySorted<Eatery>(
              lat: position.latitude,
              lng: position.longitude,
              items: all,
              itemLat: (e) => e.lat,
              itemLng: (e) => e.lng,
              maxKm: 4,
            ).take(3).toList();
            if (near.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.go('/map'),
                  borderRadius: BorderRadius.circular(18),
                  child: GlassSurface(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.nearMeTitle, style: Theme.of(context).textTheme.titleSmall),
                        Text(l10n.nearMeSubtitle, style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 8),
                        ...near.map((e) => ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(e.name, style: Theme.of(context).textTheme.bodyMedium),
                              subtitle: Text(e.areaName ?? '', style: Theme.of(context).textTheme.bodySmall),
                              trailing: const Icon(Icons.chevron_right, size: 18),
                              onTap: () => openEatery(context, e.id),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
