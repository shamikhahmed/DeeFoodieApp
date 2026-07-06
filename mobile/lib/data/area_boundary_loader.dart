import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

class AreaBoundary {
  const AreaBoundary({
    required this.name,
    required this.centroid,
    required this.ring,
  });

  final String name;
  final LatLng centroid;
  final List<LatLng> ring;

  factory AreaBoundary.fromJson(Map<String, dynamic> json) {
    final centroid = json['centroid'] as Map<String, dynamic>;
    final ring = (json['ring'] as List<dynamic>)
        .map((p) => LatLng((p['lat'] as num).toDouble(), (p['lng'] as num).toDouble()))
        .toList();
    return AreaBoundary(
      name: json['name'] as String,
      centroid: LatLng((centroid['lat'] as num).toDouble(), (centroid['lng'] as num).toDouble()),
      ring: ring,
    );
  }
}

class AreaBoundaryData {
  const AreaBoundaryData({required this.areas});

  final List<AreaBoundary> areas;
}

class AreaBoundaryLoader {
  static AreaBoundaryData? _cache;

  static Future<AreaBoundaryData> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/areas/area_boundaries.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final areas = (json['areas'] as List<dynamic>)
        .map((a) => AreaBoundary.fromJson(a as Map<String, dynamic>))
        .toList();
    _cache = AreaBoundaryData(areas: areas);
    return _cache!;
  }
}
