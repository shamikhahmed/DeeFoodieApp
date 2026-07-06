/// Canonical area name matching — same catalog as `karachi-areas.mjs` / Area table.

String normalizeAreaName(String name) =>
    name.trim().toLowerCase().replaceAll(RegExp(r'[.\-]+'), ' ').replaceAll(RegExp(r'\s+'), ' ');

/// True when [visitedArea] is the same catalog area as [overlayArea].
bool areasMatchCatalog(String overlayArea, String visitedArea) {
  return normalizeAreaName(overlayArea) == normalizeAreaName(visitedArea);
}

/// Passport / map overlay visited check against eatery area names from visits.
bool isAreaVisitedForOverlay(String overlayArea, Iterable<String> visitedAreas) {
  for (final v in visitedAreas) {
    if (areasMatchCatalog(overlayArea, v)) return true;
  }
  return false;
}

Set<String> visitedCatalogAreasFromVisits(
  Iterable<String> visitEateryAreaNames,
) {
  return visitEateryAreaNames.map(normalizeAreaName).toSet();
}
