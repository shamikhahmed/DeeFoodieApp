import 'package:flutter_test/flutter_test.dart';
import 'package:deefoodie_app/utils/area_match.dart';

void main() {
  group('area_match', () {
    test('exact catalog match', () {
      expect(isAreaVisitedForOverlay('Clifton', {'Clifton'}), isTrue);
    });

    test('normalized punctuation', () {
      expect(isAreaVisitedForOverlay('Federal B Area', {'Federal B  Area'}), isTrue);
    });

    test('no false parent prefix', () {
      expect(isAreaVisitedForOverlay('Clifton', {'Clifton Block 2'}), isFalse);
      expect(isAreaVisitedForOverlay('Clifton Block 2', {'Clifton Block 2'}), isTrue);
    });
  });
}
