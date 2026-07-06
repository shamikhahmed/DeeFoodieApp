import 'package:flutter_test/flutter_test.dart';
import 'package:deefoodie_app/models/visit.dart';
import 'package:deefoodie_app/utils/dish_rankings.dart';

void main() {
  test('ranks dishes by avg visit rating', () {
    final visits = [
      Visit(id: '1', eateryId: 'e1', eateryName: 'A', date: '2024-01-01', rating: 5, items: [VisitItem(name: 'Biryani', type: 'food')]),
      Visit(id: '2', eateryId: 'e2', eateryName: 'B', date: '2024-02-01', rating: 3, items: [VisitItem(name: 'Biryani', type: 'food')]),
      Visit(id: '3', eateryId: 'e3', eateryName: 'C', date: '2024-03-01', rating: 4, items: [VisitItem(name: 'Nihari', type: 'food')]),
    ];
    final ranks = computeDishRankings(visits);
    expect(ranks.first.name, 'Biryani');
    expect(ranks.first.avgRating, 4);
  });
}
