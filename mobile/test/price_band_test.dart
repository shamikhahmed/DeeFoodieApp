import 'package:flutter_test/flutter_test.dart';
import 'package:deefoodie_app/models/eatery.dart';
import 'package:deefoodie_app/models/menu_item.dart';
import 'package:deefoodie_app/utils/price_band.dart';

Eatery _e(double? price) => Eatery(
      id: '1',
      name: 'Test',
      venueTypes: const [],
      cuisines: const [],
      badges: const [],
      mustTryPrice: price,
    );

void main() {
  test('price bands from mustTryPrice', () {
    expect(priceBandForEatery(_e(300)), PriceBand.budget);
    expect(priceBandForEatery(_e(800)), PriceBand.mid);
    expect(priceBandForEatery(_e(2000)), PriceBand.splurge);
  });
}
