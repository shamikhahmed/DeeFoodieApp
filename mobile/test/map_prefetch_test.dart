import 'package:flutter_test/flutter_test.dart';
import 'package:deefoodie_app/services/map_cache_service.dart';

void main() {
  test('karachi prefetch tile count is reasonable', () {
    final tiles = karachiPrefetchTiles();
    expect(tiles.length, greaterThan(100));
    expect(tiles.length, lessThan(2500));
  });
}
