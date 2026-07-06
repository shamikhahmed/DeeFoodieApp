import 'dart:math';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/eatery.dart';

class MapPinDisplay {
  MapPinDisplay.single(this.eatery)
      : center = LatLng(eatery.lat!, eatery.lng!),
        count = 1,
        eateries = [eatery];

  MapPinDisplay.cluster({
    required this.center,
    required this.eateries,
  })  : count = eateries.length,
        eatery = eateries.first;

  final LatLng center;
  final int count;
  final List<Eatery> eateries;
  final Eatery eatery;

  bool get isCluster => count > 1;
}

List<MapPinDisplay> clusterEateriesForMap(
  List<Eatery> pinned,
  double zoom, {
  LatLngBounds? bounds,
  int maxPins = 250,
}) {
  var pool = pinned;
  if (bounds != null) {
    pool = pinned
        .where((e) => bounds.contains(LatLng(e.lat!, e.lng!)))
        .toList();
  }
  if (pool.isEmpty) return [];

  final cellDeg = max(0.015, 0.9 / pow(2, zoom - 9));
  final cells = <String, List<Eatery>>{};
  for (final e in pool) {
    final key = '${(e.lat! / cellDeg).floor()}_${(e.lng! / cellDeg).floor()}';
    cells.putIfAbsent(key, () => []).add(e);
  }

  final clusterMin = zoom >= 13 ? 999 : zoom >= 11 ? 2 : 2;
  final out = <MapPinDisplay>[];

  for (final group in cells.values) {
    if (group.length >= clusterMin && zoom < 13) {
      final lat = group.map((e) => e.lat!).reduce((a, b) => a + b) / group.length;
      final lng = group.map((e) => e.lng!).reduce((a, b) => a + b) / group.length;
      out.add(MapPinDisplay.cluster(center: LatLng(lat, lng), eateries: group));
    } else {
      for (final e in group) {
        out.add(MapPinDisplay.single(e));
      }
    }
  }

  if (out.length <= maxPins) return out;
  final step = out.length / maxPins;
  return List.generate(maxPins, (i) => out[(i * step).floor()]);
}
