import 'package:flutter_test/flutter_test.dart';
import 'package:deefoodie_app/models/eatery.dart';
import 'package:deefoodie_app/utils/chain_match.dart';

Eatery _e(String name) => Eatery(
      id: name,
      name: name,
      areaName: 'Clifton',
      lat: 24.86,
      lng: 67.03,
      venueTypes: const [],
      cuisines: const [],
      badges: const [],
    );

void main() {
  test('matches McDonald and KFC names', () {
    expect(eateryMatchesChain(_e("McDonald's Clifton"), "McDonald's"), isTrue);
    expect(eateryMatchesChain(_e('KFC Tipu Sultan'), 'KFC'), isTrue);
    expect(eateryMatchesChain(_e('Kolachi'), 'KFC'), isFalse);
  });

  test('filterByChains returns only matches', () {
    final all = [_e("Hardee's DHA"), _e('Kolachi'), _e('KFC North Nazimabad')];
    final out = filterByChains(all, ["Hardee's", 'KFC']);
    expect(out.length, 2);
  });
}
