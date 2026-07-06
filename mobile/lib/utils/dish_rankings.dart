import '../models/visit.dart';

class DishRanking {
  const DishRanking({
    required this.name,
    required this.avgRating,
    required this.visitCount,
    required this.eateryIds,
  });

  final String name;
  final double avgRating;
  final int visitCount;
  final Set<String> eateryIds;
}

List<DishRanking> computeDishRankings(List<Visit> visits) {
  final byName = <String, List<double>>{};
  final eateryByName = <String, Set<String>>{};

  for (final v in visits) {
    for (final item in v.items) {
      final key = item.name.trim();
      if (key.isEmpty) continue;
      byName.putIfAbsent(key, () => []).add(v.rating);
      eateryByName.putIfAbsent(key, () => {}).add(v.eateryId);
    }
    if (v.favoriteItem != null && v.favoriteItem!.trim().isNotEmpty) {
      final key = v.favoriteItem!.trim();
      byName.putIfAbsent(key, () => []).add(v.rating);
      eateryByName.putIfAbsent(key, () => {}).add(v.eateryId);
    }
  }

  final out = <DishRanking>[];
  for (final entry in byName.entries) {
    final ratings = entry.value;
    final avg = ratings.fold<double>(0, (s, r) => s + r) / ratings.length;
    out.add(DishRanking(
      name: entry.key,
      avgRating: avg,
      visitCount: ratings.length,
      eateryIds: eateryByName[entry.key] ?? {},
    ));
  }
  out.sort((a, b) {
    final byRating = b.avgRating.compareTo(a.avgRating);
    if (byRating != 0) return byRating;
    return b.visitCount.compareTo(a.visitCount);
  });
  return out;
}

DishRanking? rankingForDish(List<Visit> visits, String dishName) {
  final q = dishName.toLowerCase();
  for (final r in computeDishRankings(visits)) {
    if (r.name.toLowerCase() == q) return r;
  }
  return null;
}
