import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
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
    final near = ref.watch(nearMeStateProvider);
    final eateries = ref.watch(allEateriesProvider);

    return near.when(
      data: (state) {
        if (state.status == NearMeStatus.servicesOff) {
          return _StatusCard(
            title: l10n.locationServicesOffTitle,
            body: l10n.locationServicesOffBody,
          );
        }
        if (state.status == NearMeStatus.denied ||
            state.status == NearMeStatus.deniedForever) {
          return _StatusCard(
            title: l10n.locationDeniedTitle,
            body: l10n.locationDeniedBody,
            actionLabel: l10n.locationDeniedOpenSettings,
            onAction: () => Geolocator.openAppSettings(),
          );
        }
        final position = state.position;
        if (position == null) return const SizedBox.shrink();
        return eateries.maybeWhen(
          data: (all) {
            final nearby = nearbySorted<Eatery>(
              lat: position.latitude,
              lng: position.longitude,
              items: all,
              itemLat: (e) => e.lat,
              itemLng: (e) => e.lng,
              maxKm: 4,
            ).take(3).toList();
            if (nearby.isEmpty) return const SizedBox.shrink();
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
                        ...nearby.map((e) => ListTile(
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

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GlassSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(body, style: Theme.of(context).textTheme.bodySmall),
            if (actionLabel != null && onAction != null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(onPressed: onAction, child: Text(actionLabel!)),
              ),
          ],
        ),
      ),
    );
  }
}
