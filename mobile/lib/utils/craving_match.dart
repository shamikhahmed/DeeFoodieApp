import '../models/eatery.dart';

String cravingExploreQuery(String craving) {
  return switch (craving) {
    'Chai & Paratha' => 'chai',
    'Street Food' => 'street',
    _ => craving,
  };
}

List<String> _cravingTerms(String craving) {
  return switch (craving) {
    'Biryani' => ['biryani'],
    'Nihari' => ['nihari'],
    'BBQ' => ['bbq', 'kabab', 'tikka', 'grill'],
    'Chai & Paratha' => ['chai', 'paratha', 'tea'],
    'Dessert' => ['dessert', 'falooda', 'kulfi', 'brownie', 'rabri', 'gulab'],
    'Street Food' => ['street', 'bun', 'samosa', 'chaat', 'dhaba'],
    _ => [craving.toLowerCase()],
  };
}

bool eateryMatchesCraving(Eatery eatery, String craving) {
  if (craving.isEmpty) return false;
  final terms = _cravingTerms(craving);
  bool hit(String? text) {
    if (text == null || text.isEmpty) return false;
    final lower = text.toLowerCase();
    return terms.any(lower.contains);
  }

  if (terms.any((t) => eatery.cuisines.any((c) => c.toLowerCase().contains(t)))) return true;
  if (terms.any((t) => eatery.venueTypes.any((v) => v.toLowerCase().contains(t)))) return true;
  if (hit(eatery.name)) return true;
  if (hit(eatery.mustTryName)) return true;
  if (hit(eatery.description)) return true;
  if (eatery.menu?.items.any((m) => hit(m.name)) == true) return true;
  return false;
}

List<Eatery> filterByCraving(List<Eatery> eateries, String craving) {
  if (craving.isEmpty) return eateries;
  return eateries.where((e) => eateryMatchesCraving(e, craving)).toList();
}

List<Eatery> sortCravingFirst(List<Eatery> eateries, String craving) {
  if (craving.isEmpty) return eateries;
  final matched = <Eatery>[];
  final rest = <Eatery>[];
  for (final e in eateries) {
    (eateryMatchesCraving(e, craving) ? matched : rest).add(e);
  }
  return [...matched, ...rest];
}

Eatery? pickSpotlight(
  List<Eatery> all, {
  String craving = '',
  String favoriteArea = '',
}) {
  if (all.isEmpty) return null;

  var pool = all;
  if (craving.isNotEmpty) {
    final matched = filterByCraving(all, craving);
    if (matched.isNotEmpty) pool = matched;
  }
  if (favoriteArea.isNotEmpty) {
    final inArea = pool.where((e) => e.areaName == favoriteArea).toList();
    if (inArea.isNotEmpty) pool = inArea;
  }

  final rated = pool.where((e) => (e.avgRating ?? 0) >= 4).toList();
  final candidates = rated.isNotEmpty ? rated : pool;
  return candidates[DateTime.now().day % candidates.length];
}

bool eateryMatchesQuery(Eatery eatery, String query) {
  if (query.isEmpty) return true;
  final q = query.toLowerCase();
  bool hit(String? text) => text != null && text.toLowerCase().contains(q);

  if (hit(eatery.name)) return true;
  if (hit(eatery.areaName)) return true;
  if (hit(eatery.mustTryName)) return true;
  if (eatery.cuisines.any((c) => hit(c))) return true;
  if (eatery.venueTypes.any((v) => hit(v))) return true;
  if (eatery.menu?.items.any((m) => hit(m.name)) == true) return true;
  return false;
}
