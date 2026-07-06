import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/area_boundary_loader.dart';

class MapAreaOverlayNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

final mapAreaOverlayProvider = NotifierProvider<MapAreaOverlayNotifier, bool>(MapAreaOverlayNotifier.new);

final areaBoundariesProvider = FutureProvider<AreaBoundaryData>((ref) {
  return AreaBoundaryLoader.load();
});
