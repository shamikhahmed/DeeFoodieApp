import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../models/eatery.dart';
import '../data/area_boundary_loader.dart';
import '../utils/area_match.dart';
import '../providers/map_area_overlay_provider.dart';
import '../providers/map_heat_provider.dart';
import '../providers/plan_tonight_provider.dart';
import '../providers/trails_provider.dart';
import '../router/navigation.dart';
import '../utils/haptics.dart';
import '../utils/map_cluster.dart';
import '../theme/app_theme.dart';
import '../widgets/demo_mode_banner.dart';
import '../widgets/glass_surface.dart';
import '../widgets/plan_tonight_sheet.dart';

const _karachiCenter = LatLng(24.86, 67.03);

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();
  double _zoom = 11.5;

  void _onClusterTap(MapPinDisplay pin, WidgetRef ref) {
    if (!pin.isCluster) {
      AppHaptics.light();
      openEatery(context, pin.eatery.id);
      return;
    }
    AppHaptics.selection();
    _mapController.move(pin.center, (_zoom + 1.5).clamp(11, 16));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final eateriesAsync = ref.watch(allEateriesProvider);
    final heatOn = ref.watch(mapHeatModeProvider);
    final areaOverlayOn = ref.watch(mapAreaOverlayProvider);
    final boundaries = ref.watch(areaBoundariesProvider).asData?.value;
    final visitedIds = ref.watch(visitedEateryIdsProvider);
    final planPicks = ref.watch(planTonightProvider);
    final visits = ref.watch(visitsProvider).asData?.value ?? [];
    final visitCounts = <String, int>{};
    for (final v in visits) {
      visitCounts[v.eateryId] = (visitCounts[v.eateryId] ?? 0) + 1;
    }
    final trailNames = ref.watch(archiveTrailsProvider).asData?.value.firstOrNull?.eateryNames.toSet() ?? {};
    final bottomPad = kBottomNavigationBarHeight + MediaQuery.paddingOf(context).bottom + 8;

    return eateriesAsync.when(
      data: (eateries) {
        final pinned = eateries.where((e) => e.lat != null && e.lng != null).toList();
        final byId = {for (final e in eateries) e.id: e};
        final visitedAreaNames = <String>{};
        for (final v in visits) {
          final area = byId[v.eateryId]?.areaName;
          if (area != null && area.isNotEmpty) visitedAreaNames.add(area);
        }
        final bounds = _mapController.camera.visibleBounds;
        final displays = clusterEateriesForMap(pinned, _zoom, bounds: bounds);

        return Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: bottomPad),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _karachiCenter,
                  initialZoom: 11.5,
                  minZoom: 9,
                  maxZoom: 17,
                  onMapEvent: (event) {
                    final z = event.camera.zoom;
                    if ((z - _zoom).abs() > 0.05) {
                      setState(() => _zoom = z);
                    }
                  },
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
                  if (areaOverlayOn && boundaries != null)
                    PolygonLayer(
                      polygons: [
                        for (final b in boundaries.areas)
                          Polygon(
                            points: b.ring,
                            color: isAreaVisitedForOverlay(b.name, visitedAreaNames)
                                ? AppColors.darkGreen.withValues(alpha: 0.22)
                                : AppColors.textSubtle.withValues(alpha: 0.1),
                            borderColor: isAreaVisitedForOverlay(b.name, visitedAreaNames)
                                ? AppColors.darkGreen.withValues(alpha: 0.75)
                                : AppColors.textSubtle.withValues(alpha: 0.45),
                            borderStrokeWidth: 1.2,
                            label: b.name,
                            labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.inkBrown.withValues(alpha: 0.85),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ) ??
                                const TextStyle(fontSize: 10),
                          ),
                      ],
                    ),
                  MarkerLayer(
                    markers: [
                      for (final pin in displays)
                        Marker(
                          point: pin.center,
                          width: pin.isCluster ? 52 : _pinSize(pin.eatery, visitCounts),
                          height: pin.isCluster ? 52 : _pinSize(pin.eatery, visitCounts),
                          child: pin.isCluster
                              ? _ClusterPin(count: pin.count, onTap: () => _onClusterTap(pin, ref))
                              : _MapPin(
                                  eatery: pin.eatery,
                                  visited: !heatOn || visitedIds.contains(pin.eatery.id),
                                  visitCount: visitCounts[pin.eatery.id] ?? 0,
                                  highlighted: planPicks.contains(pin.eatery.id) ||
                                      trailNames.any((n) => pin.eatery.name.toLowerCase().contains(n.toLowerCase())),
                                  onTap: () => _onClusterTap(pin, ref),
                                  onLongPress: () {
                                    ref.read(planTonightProvider.notifier).toggle(pin.eatery.id);
                                    AppHaptics.medium();
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
                                  : l10n.mapPinClusterSummary(displays.length, pinned.length),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: GlassSurface(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm + 2,
                        ),
                        borderRadius: 14,
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.map, color: AppColors.coffeeBrown, size: 20),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                l10n.mapAreaOverlayLabel,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.inkBrown),
                              ),
                            ),
                            Switch.adaptive(
                              value: areaOverlayOn,
                              onChanged: (_) {
                                AppHaptics.selection();
                                ref.read(mapAreaOverlayProvider.notifier).toggle();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (areaOverlayOn)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: GlassSurface(
                          borderRadius: 12,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text(
                            l10n.mapAreaOverlayHint,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.inkBrown.withValues(alpha: 0.78),
                                ),
                          ),
                        ),
                      ),
                    if (heatOn)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: GlassSurface(
                          borderRadius: 12,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text(
                            l10n.mapHeatHint,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.inkBrown.withValues(alpha: 0.78)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: AppSpacing.md,
              bottom: bottomPad + 12,
              child: FloatingActionButton.extended(
                heroTag: 'plan-tonight',
                backgroundColor: AppColors.coffeeBrown,
                foregroundColor: AppColors.paper,
                onPressed: () => PlanTonightSheet.show(context),
                icon: const Icon(Icons.nightlife_outlined),
                label: Text(l10n.planTonightTitle),
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

double _pinSize(Eatery eatery, Map<String, int> visitCounts) {
  final c = visitCounts[eatery.id] ?? 0;
  return 40 + (c.clamp(0, 4) * 4).toDouble();
}

class _ClusterPin extends StatelessWidget {
  const _ClusterPin({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.coffeeBrown,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.paper, width: 2),
          boxShadow: [
            BoxShadow(color: AppColors.inkBrown.withValues(alpha: 0.2), blurRadius: 8),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          count > 99 ? '99+' : '$count',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.paper,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({
    required this.eatery,
    required this.onTap,
    this.onLongPress,
    this.visited = true,
    this.visitCount = 0,
    this.highlighted = false,
  });

  final Eatery eatery;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool visited;
  final int visitCount;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final pinColor = highlighted ? AppColors.darkGreen : (visited ? AppColors.rust : AppColors.textSubtle);
    final iconSize = 28 + (visitCount.clamp(0, 4) * 2).toDouble();

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Opacity(
        opacity: visited ? 1 : 0.65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.paper.withValues(alpha: visited ? 0.92 : 0.55),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.inkBrown.withValues(alpha: visited ? 0.15 : 0.05),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Text(
                eatery.name,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.inkBrown,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.location_on, color: pinColor, size: iconSize),
            if (visitCount > 1)
              Text('$visitCount', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.coffeeBrown)),
          ],
        ),
      ),
    );
  }
}
