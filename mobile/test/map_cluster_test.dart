import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:deefoodie_app/models/eatery.dart';
import 'package:deefoodie_app/utils/map_cluster.dart';

Eatery _e(String id, double lat, double lng) => Eatery(
      id: id,
      name: id,
      areaName: 'Clifton',
      lat: lat,
      lng: lng,
      venueTypes: const [],
      cuisines: const [],
      badges: const [],
    );

void main() {
  test('cluster merges nearby pins at low zoom', () {
    final pins = [
      _e('a', 24.86, 67.03),
      _e('b', 24.8605, 67.0305),
      _e('c', 24.90, 67.10),
    ];
    final out = clusterEateriesForMap(pins, 10);
    expect(out.any((p) => p.isCluster), isTrue);
    expect(out.length, lessThan(pins.length));
  });

  test('high zoom shows singles', () {
    final pins = [
      _e('a', 24.86, 67.03),
      _e('b', 24.8605, 67.0305),
    ];
    final out = clusterEateriesForMap(pins, 15);
    expect(out.every((p) => !p.isCluster), isTrue);
  });

  test('bounds filter limits pool', () {
    final pins = [
      _e('a', 24.86, 67.03),
      _e('b', 25.50, 68.00),
    ];
    final bounds = LatLngBounds(const LatLng(24.8, 67.0), const LatLng(24.9, 67.1));
    final out = clusterEateriesForMap(pins, 12, bounds: bounds);
    expect(out.length, 1);
  });
}
