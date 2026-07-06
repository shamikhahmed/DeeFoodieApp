import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/map_prefetch_service.dart';

class MapPrefetchNotifier extends Notifier<MapPrefetchProgress> {
  StreamSubscription<MapPrefetchProgress>? _sub;

  @override
  MapPrefetchProgress build() {
    ref.onDispose(() => _sub?.cancel());
    _sub = MapPrefetchService.instance.progress.listen((p) => state = p);
    return MapPrefetchService.instance.snapshot;
  }
}

final mapPrefetchProvider = NotifierProvider<MapPrefetchNotifier, MapPrefetchProgress>(MapPrefetchNotifier.new);
