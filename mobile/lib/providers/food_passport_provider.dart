import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/providers.dart';
import '../models/eatery.dart';
import '../models/visit.dart';

class AreaStamp {
  const AreaStamp({
    required this.areaName,
    required this.visited,
    required this.visitCount,
    required this.eateryCount,
    this.lastVisitDate,
  });

  final String areaName;
  final bool visited;
  final int visitCount;
  final int eateryCount;
  final String? lastVisitDate;
}

class FoodPassportData {
  const FoodPassportData({
    required this.stamps,
    required this.karachiScorePct,
    required this.areasVisited,
    required this.totalAreas,
    required this.totalVisits,
  });

  final List<AreaStamp> stamps;
  final int karachiScorePct;
  final int areasVisited;
  final int totalAreas;
  final int totalVisits;
}

final foodPassportProvider = Provider<AsyncValue<FoodPassportData>>((ref) {
  final visits = ref.watch(visitsProvider);
  final eateries = ref.watch(allEateriesProvider);
  final areas = ref.watch(areasProvider);

  return visits.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (visitList) => eateries.when(
      loading: () => const AsyncValue.loading(),
      error: (e, st) => AsyncValue.error(e, st),
      data: (eateryList) => areas.when(
        loading: () => const AsyncValue.loading(),
        error: (e, st) => AsyncValue.error(e, st),
        data: (areaList) {
          final stamps = _buildStamps(visitList, eateryList, areaList.map((a) => a.name).toList());
          final score = computeKarachiScorePct(visitList, eateryList, areaList.length);
          return AsyncValue.data(
            FoodPassportData(
              stamps: stamps,
              karachiScorePct: score,
              areasVisited: stamps.where((s) => s.visited).length,
              totalAreas: areaList.length,
              totalVisits: visitList.length,
            ),
          );
        },
      ),
    ),
  );
});

List<AreaStamp> _buildStamps(List<Visit> visits, List<Eatery> eateries, List<String> areaNames) {
  final eateryById = {for (final e in eateries) e.id: e};
  final visitsByArea = <String, List<Visit>>{};

  for (final v in visits) {
    final area = eateryById[v.eateryId]?.areaName;
    if (area == null) continue;
    visitsByArea.putIfAbsent(area, () => []).add(v);
  }

  final eateryCountByArea = <String, int>{};
  for (final e in eateries) {
    if (e.areaName == null) continue;
    eateryCountByArea[e.areaName!] = (eateryCountByArea[e.areaName!] ?? 0) + 1;
  }

  return areaNames.map((name) {
    final areaVisits = visitsByArea[name] ?? [];
    areaVisits.sort((a, b) => b.date.compareTo(a.date));
    return AreaStamp(
      areaName: name,
      visited: areaVisits.isNotEmpty,
      visitCount: areaVisits.length,
      eateryCount: eateryCountByArea[name] ?? 0,
      lastVisitDate: areaVisits.isEmpty ? null : areaVisits.first.date,
    );
  }).toList()
    ..sort((a, b) {
      if (a.visited != b.visited) return a.visited ? -1 : 1;
      return a.areaName.compareTo(b.areaName);
    });
}
