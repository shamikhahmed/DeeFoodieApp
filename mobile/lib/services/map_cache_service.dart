import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path_provider/path_provider.dart';

/// Persistent Karachi map tile cache on device (flutter_map built-in provider).
class MapCacheService {
  MapCacheService._();

  static final MapCacheService instance = MapCacheService._();

  BuiltInMapCachingProvider? _provider;

  BuiltInMapCachingProvider get provider {
    final p = _provider;
    if (p == null) {
      throw StateError('MapCacheService not initialised');
    }
    return p;
  }

  Future<void> init() async {
    if (kIsWeb) return;
    if (_provider != null) return;

    final dir = await getApplicationDocumentsDirectory();
    _provider = BuiltInMapCachingProvider.getOrCreateInstance(
      cacheDirectory: '${dir.path}/karachi_map_cache',
      maxCacheSize: 280_000_000,
      overrideFreshAge: const Duration(days: 120),
    );
  }
}

/// Karachi viewport tile coords for offline prefetch.
List<({int z, int x, int y})> karachiPrefetchTiles({
  int minZoom = 9,
  int maxZoom = 13,
}) {
  const south = 24.75;
  const north = 25.12;
  const west = 66.85;
  const east = 67.28;
  final out = <({int z, int x, int y})>[];

  for (var z = minZoom; z <= maxZoom; z++) {
    final x0 = _lngToTileX(west, z);
    final x1 = _lngToTileX(east, z);
    final y0 = _latToTileY(north, z);
    final y1 = _latToTileY(south, z);
    for (var x = x0; x <= x1; x++) {
      for (var y = y0; y <= y1; y++) {
        out.add((z: z, x: x, y: y));
      }
    }
  }
  return out;
}

int _lngToTileX(double lng, int z) => ((lng + 180) / 360 * pow(2, z)).floor();

int _latToTileY(double lat, int z) {
  final latRad = lat * pi / 180;
  return ((1 - log(tan(latRad) + 1 / cos(latRad)) / pi) / 2 * pow(2, z)).floor();
}

String osmTileUrl(int z, int x, int y) => 'https://tile.openstreetmap.org/$z/$x/$y.png';
