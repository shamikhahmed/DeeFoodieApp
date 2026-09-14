import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

enum NearMeStatus { ready, loading, servicesOff, denied, deniedForever, error }

class NearMeState {
  const NearMeState({required this.status, this.position});

  final NearMeStatus status;
  final Position? position;
}

final nearMeStateProvider = FutureProvider<NearMeState>((ref) async {
  try {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      return const NearMeState(status: NearMeStatus.servicesOff);
    }
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied) {
      return const NearMeState(status: NearMeStatus.denied);
    }
    if (perm == LocationPermission.deniedForever) {
      return const NearMeState(status: NearMeStatus.deniedForever);
    }
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
    );
    return NearMeState(status: NearMeStatus.ready, position: position);
  } catch (_) {
    return const NearMeState(status: NearMeStatus.error);
  }
});

/// Back-compat for callers that only need a position.
final nearMePositionProvider = FutureProvider<Position?>((ref) async {
  final state = await ref.watch(nearMeStateProvider.future);
  return state.position;
});
