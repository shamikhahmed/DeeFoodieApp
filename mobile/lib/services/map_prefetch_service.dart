import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'map_cache_service.dart';

class MapPrefetchProgress {
  const MapPrefetchProgress({
    required this.done,
    required this.total,
    required this.running,
    required this.complete,
  });

  final int done;
  final int total;
  final bool running;
  final bool complete;

  double get fraction => total == 0 ? 1 : done / total;
}

class MapPrefetchService {
  MapPrefetchService._();

  static final MapPrefetchService instance = MapPrefetchService._();

  static const _prefsKey = 'karachi_map_prefetch_v1_done';

  final _progress = StreamController<MapPrefetchProgress>.broadcast();
  MapPrefetchProgress _state = const MapPrefetchProgress(done: 0, total: 0, running: false, complete: false);

  Stream<MapPrefetchProgress> get progress => _progress.stream;
  MapPrefetchProgress get snapshot => _state;

  Future<void> startIfNeeded() async {
    if (kIsWeb) {
      _emit(const MapPrefetchProgress(done: 1, total: 1, running: false, complete: true));
      return;
    }
    await MapCacheService.instance.init();
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_prefsKey) == true) {
      _emit(const MapPrefetchProgress(done: 1, total: 1, running: false, complete: true));
      return;
    }
    unawaited(_downloadKarachi());
  }

  Future<void> forceRedownload() async {
    if (kIsWeb) return;
    await MapCacheService.instance.init();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, false);
    await _downloadKarachi();
  }

  Future<void> _downloadKarachi() async {
    final tiles = karachiPrefetchTiles();
    _emit(MapPrefetchProgress(done: 0, total: tiles.length, running: true, complete: false));

    final cache = MapCacheService.instance.provider;
    final client = http.Client();
    var done = 0;

    try {
      for (var i = 0; i < tiles.length; i += 6) {
        final batch = tiles.skip(i).take(6);
        await Future.wait(batch.map((t) async {
          final url = osmTileUrl(t.z, t.x, t.y);
          try {
            final existing = await cache.getTile(url);
            if (existing != null && !existing.metadata.isStale) return;
            final res = await client.get(
              Uri.parse(url),
              headers: const {'User-Agent': 'com.deefoodieapp.app'},
            );
            if (res.statusCode == 200) {
              await cache.putTile(
                url: url,
                metadata: CachedMapTileMetadata.fromHttpHeaders(
                  res.headers,
                  warnOnFallbackUsage: Uri.parse(url),
                  fallbackFreshnessAge: const Duration(days: 120),
                ),
                bytes: res.bodyBytes,
              );
            }
          } catch (_) {
            // skip failed tile; browse will retry
          } finally {
            done++;
            _emit(MapPrefetchProgress(done: done, total: tiles.length, running: true, complete: false));
          }
        }));
        await Future.delayed(const Duration(milliseconds: 40));
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKey, true);
      _emit(MapPrefetchProgress(done: tiles.length, total: tiles.length, running: false, complete: true));
    } finally {
      client.close();
    }
  }

  void _emit(MapPrefetchProgress next) {
    _state = next;
    if (!_progress.isClosed) _progress.add(next);
  }
}
