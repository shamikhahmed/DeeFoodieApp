import 'dart:math';

double haversineKm(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371.0;
  final dLat = _rad(lat2 - lat1);
  final dLng = _rad(lng2 - lng1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_rad(lat1)) * cos(_rad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
  return r * 2 * atan2(sqrt(a), sqrt(1 - a));
}

double _rad(double deg) => deg * pi / 180;

List<T> nearbySorted<T>({
  required double lat,
  required double lng,
  required List<T> items,
  required double? Function(T) itemLat,
  required double? Function(T) itemLng,
  double maxKm = 5,
}) {
  final scored = <({T item, double km})>[];
  for (final item in items) {
    final ilat = itemLat(item);
    final ilng = itemLng(item);
    if (ilat == null || ilng == null) continue;
    final km = haversineKm(lat, lng, ilat, ilng);
    if (km <= maxKm) scored.add((item: item, km: km));
  }
  scored.sort((a, b) => a.km.compareTo(b.km));
  return scored.map((s) => s.item).toList();
}
