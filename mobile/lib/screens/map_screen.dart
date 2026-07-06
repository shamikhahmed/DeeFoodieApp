import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../models/eatery.dart';
import '../providers/map_heat_provider.dart';
import '../router/navigation.dart';
import '../utils/eatery_display.dart';
import '../utils/haptics.dart';
import '../utils/map_markers.dart';
import '../theme/app_theme.dart';
import '../widgets/demo_mode_banner.dart';
import '../widgets/glass_surface.dart';

const _karachiCenter = LatLng(24.86, 67.03);

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final eateriesAsync = ref.watch(allEateriesProvider);
    final heatOn = ref.watch(mapHeatModeProvider);
    final visitedIds = ref.watch(visitedEateryIdsProvider);
    final bottomPad = kBottomNavigationBarHeight + MediaQuery.paddingOf(context).bottom + 12;

    return eateriesAsync.when(
      data: (eateries) {
        final pinned = eateries.where((e) => e.lat != null && e.lng != null).toList();
        final shown = eateriesForMap(pinned);
        final capped = pinned.length > shown.length;

        return Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: bottomPad),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _karachiCenter,
                  initialZoom: 11.5,
                  minZoom: 9,
                  maxZoom: 17,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.deefoodieapp.app',
                    tileBuilder: heatOn
                        ? (context, widget, tile) => ColorFiltered(
                              colorFilter: const ColorFilter.matrix([
                                0.5, 0, 0, 0, 0,
                                0, 0.5, 0, 0, 0,
                                0, 0, 0.5, 0, 0,
                                0, 0, 0, 1, 0,
                              ]),
                              child: widget,
                            )
                        : null,
                  ),
                  MarkerLayer(
                    markers: [
                      for (final e in shown)
                        Marker(
                          point: LatLng(e.lat!, e.lng!),
                          width: 44,
                          height: 44,
                          child: _MapPin(
                            eatery: e,
                            visited: !heatOn || visitedIds.contains(e.id),
                            onTap: () {
                              AppHaptics.light();
                              openEatery(context, e.id);
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const DemoModeBanner(),
                    GlassSurface(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm + 2,
                      ),
                      borderRadius: 14,
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.map_pin_ellipse, color: AppColors.coffeeBrown, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              heatOn
                                  ? l10n.mapHeatSummary(visitedIds.length, pinned.length)
                                  : capped
                                      ? '${shown.length} of ${pinned.length} pins (zoom areas for detail)'
                                      : l10n.mapPinCount(pinned.length),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.inkBrown),
                            ),
                          ),
                          Switch.adaptive(
                            value: heatOn,
                            onChanged: (_) {
                              AppHaptics.selection();
                              ref.read(mapHeatModeProvider.notifier).toggle();
                            },
                          ),
                        ],
                      ),
                    ),
                    if (heatOn)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: GlassSurface(
                          borderRadius: 12,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text(l10n.mapHeatHint, style: Theme.of(context).textTheme.bodySmall),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.coffeeBrown)),
      error: (e, _) => Center(child: Text(l10n.errorExplore)),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.eatery, required this.onTap, this.visited = true});

  final Eatery eatery;
  final VoidCallback onTap;
  final bool visited;

  @override
  Widget build(BuildContext context) {
    final pinColor = visited ? AppColors.rust : AppColors.textSubtle;
    final labelAlpha = visited ? 0.92 : 0.55;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: visited ? 1 : 0.65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.paper.withValues(alpha: labelAlpha),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.inkBrown.withValues(alpha: visited ? 0.15 : 0.05),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    eatery.name,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.inkBrown,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (visited && hasDisplayRating(eatery))
                    Text(
                      '★ ${displayRating(eatery).toStringAsFixed(1)}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 8,
                            color: AppColors.rust,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                ],
              ),
            ),
            Icon(Icons.location_on, color: pinColor, size: 32),
          ],
        ),
      ),
    );
  }
}
