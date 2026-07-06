import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/eatery.dart';
import '../models/taxonomy.dart';
import '../models/visit.dart';
import '../data/archive_loader.dart';
import '../providers/user_archive_prefs_provider.dart';
import '../utils/archive_merge.dart';
import '../utils/craving_match.dart';
import '../data/local_visit_store.dart';
import '../providers/local_eateries_provider.dart';
import '../providers/discount_cards_provider.dart';
import '../utils/discount_match.dart';
import '../utils/price_band.dart';
import '../data/explore_filter_prefs.dart';
import 'api_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final apiOnlineProvider = FutureProvider<bool>((ref) async {
  if (kIsWeb) return false;
  return ref.watch(apiClientProvider).checkHealth();
});

class EateryFilterState {
  const EateryFilterState({
    this.q = '',
    this.venueType,
    this.cuisine,
    this.area,
    this.unvisitedOnly = false,
    this.priceBand,
  });

  final String q;
  final String? venueType;
  final String? cuisine;
  final String? area;
  final bool unvisitedOnly;
  final PriceBand? priceBand;

  EateryFilterState copyWith({
    String? q,
    String? Function()? venueType,
    String? Function()? cuisine,
    String? Function()? area,
    bool? unvisitedOnly,
    PriceBand? Function()? priceBand,
  }) {
    return EateryFilterState(
      q: q ?? this.q,
      venueType: venueType != null ? venueType() : this.venueType,
      cuisine: cuisine != null ? cuisine() : this.cuisine,
      area: area != null ? area() : this.area,
      unvisitedOnly: unvisitedOnly ?? this.unvisitedOnly,
      priceBand: priceBand != null ? priceBand() : this.priceBand,
    );
  }
}

class EateryFilterNotifier extends Notifier<EateryFilterState> {
  @override
  EateryFilterState build() {
    _load();
    return const EateryFilterState();
  }

  Future<void> _load() async {
    final saved = await ExploreFilterPrefs.load();
    if (saved != null) state = saved;
  }

  void _persist() => ExploreFilterPrefs.save(state);

  void setQuery(String q) {
    state = state.copyWith(q: q);
    _persist();
  }

  void toggleVenueType(String? v) {
    state = state.copyWith(venueType: () => state.venueType == v ? null : v);
    _persist();
  }

  void toggleCuisine(String? c) {
    state = state.copyWith(cuisine: () => state.cuisine == c ? null : c);
    _persist();
  }

  void toggleArea(String? a) {
    state = state.copyWith(area: () => state.area == a ? null : a);
    _persist();
  }

  void toggleUnvisited() {
    state = state.copyWith(unvisitedOnly: !state.unvisitedOnly);
    _persist();
  }

  void togglePriceBand(PriceBand band) {
    state = state.copyWith(priceBand: () => state.priceBand == band ? null : band);
    _persist();
  }

  void applyCraving(String craving) {
    state = EateryFilterState(q: cravingExploreQuery(craving));
    _persist();
  }
}

final eateryFilterProvider =
    NotifierProvider<EateryFilterNotifier, EateryFilterState>(EateryFilterNotifier.new);

class DemoModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setActive(bool value) => state = value;
}

final demoModeActiveProvider = NotifierProvider<DemoModeNotifier, bool>(DemoModeNotifier.new);

class LocalVisitsNotifier extends Notifier<List<Visit>> {
  @override
  List<Visit> build() {
    _load();
    return [];
  }

  Future<void> _load() async => state = await LocalVisitStore.load();

  Future<void> _persist() async => LocalVisitStore.save(state);

  Future<void> add(Visit visit) async {
    state = [visit, ...state];
    await _persist();
  }

  Future<void> update(Visit visit) async {
    state = state.map((v) => v.id == visit.id ? visit : v).toList();
    await _persist();
  }

  Future<void> remove(String id) async {
    state = state.where((v) => v.id != id).toList();
    await _persist();
  }
}

final localVisitsProvider = NotifierProvider<LocalVisitsNotifier, List<Visit>>(LocalVisitsNotifier.new);

final eateriesProvider = FutureProvider<List<Eatery>>((ref) async {
  final filters = ref.watch(eateryFilterProvider);
  if (kIsWeb) {
    ref.read(demoModeActiveProvider.notifier).setActive(true);
    final archive = await ArchiveLoader.load();
    var demo = archive.eateries;
    if (filters.q.isNotEmpty) {
      demo = demo.where((e) => eateryMatchesQuery(e, filters.q)).toList();
    }
    if (filters.venueType != null) {
      demo = demo.where((e) => e.venueTypes.contains(filters.venueType)).toList();
    }
    if (filters.cuisine != null) {
      demo = demo.where((e) => e.cuisines.contains(filters.cuisine)).toList();
    }
    if (filters.area != null) {
      demo = demo.where((e) => e.areaName == filters.area).toList();
    }
    return demo;
  }

  final api = ref.watch(apiClientProvider);
  try {
    final list = await api.fetchEateries(
      q: filters.q,
      venueType: filters.venueType,
      cuisine: filters.cuisine,
      area: filters.area,
    );
    ref.read(demoModeActiveProvider.notifier).setActive(false);
    return list;
  } catch (_) {
    ref.read(demoModeActiveProvider.notifier).setActive(true);
    final archive = await ArchiveLoader.load();
    var demo = archive.eateries;
    if (filters.q.isNotEmpty) {
      demo = demo.where((e) => eateryMatchesQuery(e, filters.q)).toList();
    }
    if (filters.venueType != null) {
      demo = demo.where((e) => e.venueTypes.contains(filters.venueType)).toList();
    }
    if (filters.cuisine != null) {
      demo = demo.where((e) => e.cuisines.contains(filters.cuisine)).toList();
    }
    if (filters.area != null) {
      demo = demo.where((e) => e.areaName == filters.area).toList();
    }
    return demo;
  }
});

final allEateriesProvider = FutureProvider<List<Eatery>>((ref) async {
  final local = ref.watch(localEateriesProvider);
  List<Eatery> archive = [];
  try {
    archive = (await ArchiveLoader.load()).eateries;
  } catch (_) {}

  if (kIsWeb) {
    ref.read(demoModeActiveProvider.notifier).setActive(true);
    return [...local, ...archive];
  }

  final api = ref.watch(apiClientProvider);
  try {
    final list = await api.fetchEateries();
    ref.read(demoModeActiveProvider.notifier).setActive(false);
    final merged = archive.isEmpty ? list : mergeEateryLists(list, archive);
    return [...local, ...merged];
  } catch (_) {
    ref.read(demoModeActiveProvider.notifier).setActive(true);
    if (archive.isNotEmpty) return [...local, ...archive];
    return [...local, ...(await ArchiveLoader.load()).eateries];
  }
});

final visitsProvider = FutureProvider<List<Visit>>((ref) async {
  final local = ref.watch(localVisitsProvider);
  if (kIsWeb) {
    ref.read(demoModeActiveProvider.notifier).setActive(true);
    try {
      return [...local, ...(await ArchiveLoader.load()).visits];
    } catch (_) {
      return local;
    }
  }

  final api = ref.watch(apiClientProvider);
  try {
    final list = await api.fetchVisits();
    ref.read(demoModeActiveProvider.notifier).setActive(false);
    return [...local, ...list];
  } catch (_) {
    ref.read(demoModeActiveProvider.notifier).setActive(true);
    return [...local, ...(await ArchiveLoader.load()).visits];
  }
});

final eateryDetailProvider = FutureProvider.family<Eatery?, String>((ref, id) async {
  final local = ref.read(localEateriesProvider).where((e) => e.id == id).firstOrNull;
  if (local != null) return local;

  Eatery? archived;
  try {
    final archive = await ArchiveLoader.load();
    archived = archive.eateries.where((e) => e.id == id).firstOrNull;
  } catch (_) {}

  final api = ref.watch(apiClientProvider);
  try {
    final remote = await api.fetchEatery(id);
    return archived != null ? mergeEateryDetail(remote, archived) : remote;
  } catch (_) {
    return archived;
  }
});

final visitDetailProvider = FutureProvider.family<Visit?, String>((ref, id) async {
  if (id.startsWith('local-')) {
    try {
      return ref.read(localVisitsProvider).firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }
  final visits = await ref.watch(visitsProvider.future);
  try {
    return visits.firstWhere((v) => v.id == id);
  } catch (_) {
    return null;
  }
});

final venueTypesProvider = FutureProvider<List<NamedEntry>>((ref) async {
  if (kIsWeb) {
    final archive = await ArchiveLoader.load();
    final names = archive.eateries.expand((e) => e.venueTypes).toSet().toList()..sort();
    return names.asMap().entries.map((e) => NamedEntry(id: '${e.key}', name: e.value)).toList();
  }
  try {
    return await ref.watch(apiClientProvider).fetchVenueTypes();
  } catch (_) {
    final archive = await ArchiveLoader.load();
    final names = archive.eateries.expand((e) => e.venueTypes).toSet().toList()..sort();
    return names.asMap().entries.map((e) => NamedEntry(id: '${e.key}', name: e.value)).toList();
  }
});

final cuisinesProvider = FutureProvider<List<NamedEntry>>((ref) async {
  if (kIsWeb) {
    final archive = await ArchiveLoader.load();
    final names = archive.eateries.expand((e) => e.cuisines).toSet().toList()..sort();
    return names.asMap().entries.map((e) => NamedEntry(id: '${e.key}', name: e.value)).toList();
  }
  try {
    return await ref.watch(apiClientProvider).fetchCuisines();
  } catch (_) {
    final archive = await ArchiveLoader.load();
    final names = archive.eateries.expand((e) => e.cuisines).toSet().toList()..sort();
    return names.asMap().entries.map((e) => NamedEntry(id: '${e.key}', name: e.value)).toList();
  }
});

final areasProvider = FutureProvider<List<NamedEntry>>((ref) async {
  if (kIsWeb) {
    final archive = await ArchiveLoader.load();
    final names = archive.eateries.map((e) => e.areaName).whereType<String>().toSet().toList()..sort();
    return names.asMap().entries.map((e) => NamedEntry(id: '${e.key}', name: e.value)).toList();
  }
  try {
    return await ref.watch(apiClientProvider).fetchAreas();
  } catch (_) {
    final archive = await ArchiveLoader.load();
    final names = archive.eateries.map((e) => e.areaName).whereType<String>().toSet().toList()..sort();
    return names.asMap().entries.map((e) => NamedEntry(id: '${e.key}', name: e.value)).toList();
  }
});

List<Eatery> sortByCreatedAt(List<Eatery> list) {
  final copy = [...list];
  copy.sort((a, b) {
    final ad = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bd = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    return bd.compareTo(ad);
  });
  return copy;
}

List<Eatery> sortByRating(List<Eatery> list) {
  final copy = [...list];
  copy.sort((a, b) => (b.avgRating ?? 0).compareTo(a.avgRating ?? 0));
  return copy;
}

List<Visit> sortVisitsByDate(List<Visit> list) {
  final copy = [...list];
  copy.sort((a, b) => b.date.compareTo(a.date));
  return copy;
}

List<Eatery> sortEateries(List<Eatery> list, ExploreSort sort) {
  final copy = [...list];
  switch (sort) {
    case ExploreSort.rating:
      copy.sort((a, b) => (b.avgRating ?? 0).compareTo(a.avgRating ?? 0));
    case ExploreSort.name:
      copy.sort((a, b) => a.name.compareTo(b.name));
    case ExploreSort.area:
      copy.sort((a, b) => (a.areaName ?? '').compareTo(b.areaName ?? ''));
  }
  return copy;
}

final sortedEateriesProvider = Provider<AsyncValue<List<Eatery>>>((ref) {
  final eateries = ref.watch(eateriesProvider);
  final sort = ref.watch(exploreSortProvider);
  final myDealsOnly = ref.watch(myDealsFilterProvider);
  final cards = ref.watch(discountCardsProvider);
  final filters = ref.watch(eateryFilterProvider);
  final visitedIds = ref.watch(visitsProvider).maybeWhen(
        data: (v) => v.map((x) => x.eateryId).toSet(),
        orElse: () => <String>{},
      );
  return eateries.whenData((list) {
    var filtered = list;
    if (myDealsOnly && cards.isNotEmpty) {
      filtered = filtered.where((e) => dealsForUserAtEatery(cards, e.name).isNotEmpty).toList();
    }
    if (filters.unvisitedOnly) {
      filtered = filtered.where((e) => !visitedIds.contains(e.id)).toList();
    }
    if (filters.priceBand != null) {
      filtered = filtered.where((e) => priceBandForEatery(e) == filters.priceBand).toList();
    }
    return sortEateries(filtered, sort);
  });
});

final filteredVisitsProvider = Provider<AsyncValue<List<Visit>>>((ref) {
  final visits = ref.watch(visitsProvider);
  final mood = ref.watch(journalMoodFilterProvider);
  return visits.whenData((list) {
    if (mood == null) return list;
    return list.where((v) => v.moodTags.contains(mood)).toList();
  });
});

int computeKarachiScorePct(List<Visit> visits, List<Eatery> eateries, int totalAreas) {
  if (totalAreas == 0) return 0;
  final areaByEateryId = {for (final e in eateries) e.id: e.areaName};
  final visitedAreas = <String>{};
  for (final v in visits) {
    final area = areaByEateryId[v.eateryId];
    if (area != null && area.isNotEmpty) visitedAreas.add(area);
  }
  return ((visitedAreas.length / totalAreas) * 100).round().clamp(0, 100);
}

final personalStatsProvider = Provider<PersonalStats>((ref) {
  final visits = ref.watch(visitsProvider).asData?.value ?? [];
  final eateries = ref.watch(allEateriesProvider).asData?.value ?? [];
  final areaById = {for (final e in eateries) e.id: e.areaName};

  final uniqueIds = visits.map((v) => v.eateryId).toSet();
  final areas = <String>{};
  for (final id in uniqueIds) {
    final area = areaById[id];
    if (area != null && area.isNotEmpty) areas.add(area);
  }

  final bills = visits.where((v) => v.totalBill != null).map((v) => v.totalBill!).toList();
  final totalSpent = bills.fold<double>(0, (sum, b) => sum + b);
  final avgPerVisit = bills.isEmpty ? 0.0 : totalSpent / bills.length;
  final avgRating = visits.isEmpty
      ? 0.0
      : visits.fold<double>(0, (sum, v) => sum + v.rating) / visits.length;

  return PersonalStats(
    visitCount: visits.length,
    uniqueEateries: uniqueIds.length,
    areasVisited: areas.length,
    totalSpent: totalSpent,
    avgPerVisit: avgPerVisit,
    avgRating: avgRating,
  );
});
