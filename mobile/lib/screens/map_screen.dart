import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../api/providers.dart';
import '../data/area_boundary_loader.dart';
import '../l10n/app_localizations.dart';
import '../models/eatery.dart';
import '../providers/map_area_overlay_provider.dart';
import '../providers/map_heat_provider.dart';
import '../providers/map_prefetch_provider.dart';
import '../providers/plan_tonight_provider.dart';
import '../providers/trails_provider.dart';
import '../router/navigation.dart';
import '../services/map_cache_service.dart';
import '../theme/app_theme.dart';
import '../utils/area_match.dart';
import '../utils/haptics.dart';
import '../utils/map_cluster.dart';
import '../widgets/demo_mode_banner.dart';
import '../widgets/glass_surface.dart';
import '../widgets/plan_tonight_sheet.dart';

const _karachiCenter = LatLng(24.86, 67.03);

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with AutomaticKeepAliveClientMixin {
  final _mapController = MapController();
  double _zoom = 11.5;
  double _clusterZoom = 11.5;
  LatLngBounds? _visibleBounds;
  Timer? _zoomDebounce;
  NetworkTileProvider? _tileProvider;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _setupTileProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _visibleBounds = _mapController.camera.visibleBounds);
      }
    });
  }

  Future<void> _setupTileProvider() async {
    if (kIsWeb) return;
    await MapCacheService.instance.init();
    if (!mounted) return;
    setState(() {
      _tileProvider = NetworkTileProvider(
        headers: const {'User-Agent': 'com.deefoodieapp.app'},
        cachingProvider: MapCacheService.instance.provider,
        abortObsoleteRequests: true,
      );
    });
  }

  @override
  void dispose() {
    _zoomDebounce?.cancel();
    _tileProvider?.dispose();
    super.dispose();
  }

  void _onMapEvent(MapEvent event) {
    final z = event.camera.zoom;
    if ((z - _zoom).abs() > 0.04) {
      _zoom = z;
      _zoomDebounce?.cancel();
      _zoomDebounce = Timer(const Duration(milliseconds: 100), () {
        if (mounted) setState(() => _clusterZoom = _zoom);
      });
    }
    if (event is MapEventMoveEnd || event is MapEventFlingAnimationEnd) {
      setState(() => _visibleBounds = event.camera.visibleBounds);
    }
  }

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
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final eateriesAsync = ref.watch(allEateriesProvider);
    final heatOn = ref.watch(mapHeatModeProvider);
    final areaOverlayOn = ref.watch(mapAreaOverlayProvider);
    final boundaries = ref.watch(areaBoundariesProvider).asData?.value;
    final visitedIds = ref.watch(visitedEateryIdsProvider);
    final planPicks = ref.watch(planTonightProvider);
    final visits = ref.watch(visitsProvider).asData?.value ?? [];
    final prefetch = ref.watch(mapPrefetchProvider);
    final trailNames = ref.watch(archiveTrailsProvider).asData?.value.firstOrNull?.eateryNames.toSet() ?? {};
    final bottomPad = kBottomNavigationBarHeight + MediaQuery.paddingOf(context).bottom + 8;

    final visitCounts = <String, int>{};
    for (final v in visits) {
      visitCounts[v.eateryId] = (visitCounts[v.eateryId] ?? 0) + 1;
    }

    return eateriesAsync.when(
      data: (eateries) {
        final pinned = eateries.where((e) => e.lat != null && e.lng != null).toList();
        final byId = {for (final e in eateries) e.id: e};
        final visitedAreaNames = <String>{};
        for (final v in visits) {
          final area = byId[v.eateryId]?.areaName;
          if (area != null && area.isNotEmpty) visitedAreaNames.add(area);
        }
        final bounds = _visibleBounds ?? _mapController.camera.visibleBounds;
        final displays = clusterEateriesForMap(pinned, _clusterZoom, bounds: bounds);
        final showAreaLabels = _clusterZoom >= 12;
        final visiblePolygons = areaOverlayOn && boundaries != null
            ? boundaries.areas.where((b) => _polygonIntersectsBounds(b, bounds)).toList()
            : const <AreaBoundary>[];

        return Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: bottomPad),
              child: RepaintBoundary(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _karachiCenter,
                    initialZoom: 11.5,
                    minZoom: 9,
                    maxZoom: 17,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    ),
                    onMapEvent: _onMapEvent,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.deefoodieapp.app',
                      tileProvider: kIsWeb
                          ? NetworkTileProvider(
                              headers: const {'User-Agent': 'com.deefoodieapp.app'},
                            )
                          : _tileProvider,
                      panBuffer: 1,
                    ),
                    if (visiblePolygons.isNotEmpty)
                      PolygonLayer(
                        polygons: [
                          for (final b in visiblePolygons)
                            Polygon(
                              points: b.ring,
                              color: isAreaVisitedForOverlay(b.name, visitedAreaNames)
                                  ? AppColors.darkGreen.withValues(alpha: 0.2)
                                  : AppColors.textSubtle.withValues(alpha: 0.08),
                              borderColor: isAreaVisitedForOverlay(b.name, visitedAreaNames)
                                  ? AppColors.darkGreen.withValues(alpha: 0.7)
                                  : AppColors.textSubtle.withValues(alpha: 0.4),
                              borderStrokeWidth: 1,
                              label: showAreaLabels ? b.name : null,
                              labelStyle: (Theme.of(context).textTheme.labelSmall ?? const TextStyle(fontSize: 10)).copyWith(
                                    color: AppColors.inkBrown.withValues(alpha: 0.85),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                        ],
                      ),
                    MarkerLayer(
                      markers: [
                        for (final pin in displays)
                          Marker(
                            point: pin.center,
                            width: pin.isCluster ? 48 : _pinSize(pin.eatery, visitCounts),
                            height: pin.isCluster ? 48 : _pinSize(pin.eatery, visitCounts),
                            alignment: Alignment.topCenter,
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
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const DemoModeBanner(),
                    if (!prefetch.complete && prefetch.total > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GlassSurface(
                          borderRadius: 12,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                l10n.mapOfflineDownloadLabel,
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.inkBrown),
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: prefetch.fraction,
                                  minHeight: 4,
                                  backgroundColor: AppColors.coffeeBrown.withValues(alpha: 0.12),
                                  color: AppColors.darkGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    _MapToggleCard(
                      icon: CupertinoIcons.map_pin_ellipse,
                      label: heatOn
                          ? l10n.mapHeatSummary(visitedIds.length, pinned.length)
                          : l10n.mapPinClusterSummary(displays.length, pinned.length),
                      value: heatOn,
                      onChanged: () {
                        AppHaptics.selection();
                        ref.read(mapHeatModeProvider.notifier).toggle();
                      },
                    ),
                    const SizedBox(height: 8),
                    _MapToggleCard(
                      icon: CupertinoIcons.map,
                      label: l10n.mapAreaOverlayLabel,
                      value: areaOverlayOn,
                      onChanged: () {
                        AppHaptics.selection();
                        ref.read(mapAreaOverlayProvider.notifier).toggle();
                      },
                    ),
                    if (areaOverlayOn)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          l10n.mapAreaOverlayHint,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.inkBrown.withValues(alpha: 0.78),
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
                elevation: 2,
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

bool _polygonIntersectsBounds(AreaBoundary boundary, LatLngBounds bounds) {
  for (final p in boundary.ring) {
    if (bounds.contains(p)) return true;
  }
  return bounds.contains(boundary.centroid);
}

double _pinSize(Eatery eatery, Map<String, int> visitCounts) {
  final c = visitCounts[eatery.id] ?? 0;
  return 36 + (c.clamp(0, 4) * 3).toDouble();
}

class _MapToggleCard extends StatelessWidget {
  const _MapToggleCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
      borderRadius: 14,
      child: Row(
        children: [
          Icon(icon, color: AppColors.coffeeBrown, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.inkBrown),
            ),
          ),
          Switch.adaptive(value: value, onChanged: (_) => onChanged()),
        ],
      ),
    );
  }
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
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.coffeeBrown,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.paper, width: 2),
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

class _MapPin extends StatefulWidget {
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
  State<_MapPin> createState() => _MapPinState();
}

class _MapPinState extends State<_MapPin> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final pinColor = widget.highlighted
        ? AppColors.darkGreen
        : (widget.visited ? AppColors.rust : AppColors.textSubtle);
    final iconSize = 26 + (widget.visitCount.clamp(0, 4) * 2).toDouble();

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Opacity(
          opacity: widget.visited ? 1 : 0.55,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, color: pinColor, size: iconSize),
              if (widget.visitCount > 1)
                Text(
                  '${widget.visitCount}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.coffeeBrown),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
