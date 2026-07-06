import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('area_boundaries.json has 67 catalog areas with valid rings', () async {
    final raw = await rootBundle.loadString('assets/areas/area_boundaries.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final areas = json['areas'] as List<dynamic>;
    expect(areas.length, 67);

    final sources = <String>{};
    for (final a in areas) {
      final map = a as Map<String, dynamic>;
      final ring = map['ring'] as List<dynamic>;
      expect(ring.length, greaterThanOrEqualTo(4), reason: map['name']);
      sources.add(map['source'] as String);
      for (final p in ring) {
        final pt = p as Map<String, dynamic>;
        expect(pt['lat'], isA<num>());
        expect(pt['lng'], isA<num>());
      }
    }
    expect(sources.contains('osm-overpass'), isTrue);
  });
}
