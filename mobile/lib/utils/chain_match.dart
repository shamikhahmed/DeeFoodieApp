import '../models/eatery.dart';

String _norm(String s) => s.toLowerCase().replaceAll("'", '').replaceAll('’', '').trim();

bool eateryMatchesChain(Eatery eatery, String chain) {
  final name = _norm(eatery.name);
  final needle = _norm(chain);
  if (needle.isEmpty) return false;
  return name.contains(needle);
}

List<Eatery> filterByChains(List<Eatery> eateries, List<String> chains) {
  if (chains.isEmpty) return [];
  return eateries.where((e) => chains.any((c) => eateryMatchesChain(e, c))).toList();
}

List<Eatery> sortChainsFirst(List<Eatery> eateries, List<String> chains) {
  if (chains.isEmpty) return eateries;
  final matched = <Eatery>[];
  final rest = <Eatery>[];
  for (final e in eateries) {
    if (chains.any((c) => eateryMatchesChain(e, c))) {
      matched.add(e);
    } else {
      rest.add(e);
    }
  }
  return [...matched, ...rest];
}
