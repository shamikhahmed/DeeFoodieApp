import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every archive cover is venue/chain or placeholder (DFD-P0-02)', () async {
    final raw = await rootBundle.loadString('assets/demo/archive.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final eateries = json['eateries'] as List<dynamic>;

    var venueOrChain = 0;
    var placeholder = 0;

    for (final e in eateries) {
      final m = e as Map<String, dynamic>;
      final kind = m['coverPhotoKind'] as String? ?? 'placeholder';
      final url = m['coverPhotoUrl'] as String?;
      final illustration = m['cuisineIllustrationUrl'] as String?;

      if (kind == 'venue' || kind == 'chain') {
        expect(url, isNotNull, reason: '${m['name']} venue/chain missing url');
        expect(m['coverPhotoLicense'], isNotNull);
        expect(m['coverPhotoAttribution'], isNotNull);
        venueOrChain++;
      } else {
        expect(kind, 'placeholder');
        expect(url, isNull, reason: '${m['name']} placeholder must not claim a venue cover');
        expect(illustration, isNotNull, reason: '${m['name']} needs cuisine illustration');
        placeholder++;
      }
    }

    expect(eateries.length, greaterThanOrEqualTo(10000));
    expect(placeholder, greaterThan(0));
    expect(venueOrChain + placeholder, eateries.length);
  });
}
