import '../models/eatery.dart';

Eatery mergeEateryDetail(Eatery primary, Eatery? archive) {
  if (archive == null) return primary;
  return Eatery(
    id: primary.id,
    name: primary.name,
    venueTypes: primary.venueTypes.isNotEmpty ? primary.venueTypes : archive.venueTypes,
    cuisines: primary.cuisines.isNotEmpty ? primary.cuisines : archive.cuisines,
    badges: primary.badges.isNotEmpty ? primary.badges : archive.badges,
    areaName: primary.areaName ?? archive.areaName,
    address: primary.address ?? archive.address,
    description: primary.description ?? archive.description,
    coverPhotoUrl: primary.coverPhotoUrl ?? archive.coverPhotoUrl,
    avgRating: primary.avgRating ?? archive.avgRating,
    status: primary.status,
    createdAt: primary.createdAt ?? archive.createdAt,
    lat: primary.lat ?? archive.lat,
    lng: primary.lng ?? archive.lng,
    menu: (primary.menu != null && primary.menu!.items.isNotEmpty) ? primary.menu : archive.menu,
    mustTryName: archive.mustTryName ?? primary.mustTryName,
    mustTryPrice: archive.mustTryPrice ?? primary.mustTryPrice,
    visitCount: archive.visitCount > 0 ? archive.visitCount : primary.visitCount,
  );
}

List<Eatery> mergeEateryLists(List<Eatery> primary, List<Eatery> archive) {
  final byId = {for (final e in archive) e.id: e};
  return primary.map((e) => mergeEateryDetail(e, byId[e.id])).toList();
}

class PersonalStats {
  const PersonalStats({
    required this.visitCount,
    required this.uniqueEateries,
    required this.areasVisited,
    required this.totalSpent,
    required this.avgPerVisit,
    required this.avgRating,
  });

  final int visitCount;
  final int uniqueEateries;
  final int areasVisited;
  final double totalSpent;
  final double avgPerVisit;
  final double avgRating;
}
