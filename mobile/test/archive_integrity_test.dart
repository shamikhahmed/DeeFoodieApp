import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('archive.json visits link to seed eatery IDs', () async {
    final raw = await rootBundle.loadString('assets/demo/archive.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final eateries = json['eateries'] as List<dynamic>;
    final visits = json['visits'] as List<dynamic>;
    final eateryIds = eateries.map((e) => (e as Map)['id'] as String).toSet();
    final names = eateries.map((e) => (e as Map)['name'] as String).toSet();

    expect(eateries.length, greaterThanOrEqualTo(10000));
    expect(visits.length, greaterThanOrEqualTo(25));

    for (final v in visits) {
      final m = v as Map<String, dynamic>;
      expect(eateryIds.contains(m['eateryId']), isTrue, reason: 'orphan visit ${m['id']} → ${m['eateryId']}');
      expect(names.contains(m['eateryName']), isTrue);
    }

    final kolachi = eateries.firstWhere((e) => (e as Map)['name'] == 'Kolachi') as Map;
    final kolachiVisits = visits.where((v) => (v as Map)['eateryId'] == kolachi['id']);
    expect(kolachiVisits, isNotEmpty);

    final closed = eateries.where((e) => (e as Map)['status'] == 'closed').length;
    expect(closed, greaterThanOrEqualTo(2));

    final withAddr = eateries.where((e) => (e as Map)['address'] != null).length;
    expect(withAddr, greaterThan(9000));

    final kolachiAddr = kolachi['address'] as String?;
    expect(kolachiAddr, contains('DHA'));

    final wikimedia = eateries.where((e) => ((e as Map)['coverPhotoUrl'] as String? ?? '').contains('wikimedia.org')).length;
    expect(wikimedia, greaterThan(9000));
  });

  test('trail eatery names resolve in archive', () async {
    final raw = await rootBundle.loadString('assets/demo/archive.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final names = (json['eateries'] as List).map((e) => (e as Map)['name'] as String).toSet();
    final trails = json['trails'] as List<dynamic>? ?? [];
    var hits = 0;
    var total = 0;
    for (final t in trails) {
      for (final n in (t as Map)['eateryNames'] as List) {
        total++;
        if (names.contains(n)) hits++;
      }
    }
    expect(hits / total, greaterThan(0.9));
  });
}
