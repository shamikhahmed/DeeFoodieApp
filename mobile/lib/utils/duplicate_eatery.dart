import '../models/eatery.dart';

List<Eatery> findSimilarEateries(List<Eatery> all, {required String name, required String area}) {
  final needle = _norm(name);
  if (needle.isEmpty) return [];
  return all
      .where((e) {
        final sameArea = e.areaName != null && _norm(e.areaName!) == _norm(area);
        if (!sameArea) return false;
        final en = _norm(e.name);
        return en == needle || en.contains(needle) || needle.contains(en) || _levenshtein(en, needle) <= 2;
      })
      .take(5)
      .toList();
}

String _norm(String s) => s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

int _levenshtein(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  final m = List.generate(a.length + 1, (_) => List.filled(b.length + 1, 0));
  for (var i = 0; i <= a.length; i++) m[i][0] = i;
  for (var j = 0; j <= b.length; j++) m[0][j] = j;
  for (var i = 1; i <= a.length; i++) {
    for (var j = 1; j <= b.length; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      m[i][j] = [m[i - 1][j] + 1, m[i][j - 1] + 1, m[i - 1][j - 1] + cost].reduce((x, y) => x < y ? x : y);
    }
  }
  return m[a.length][b.length];
}
