import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/providers.dart';
import '../utils/eatery_display.dart';
import '../models/visit.dart';

class YearInFoodData {
  const YearInFoodData({
    required this.year,
    required this.visitCount,
    required this.uniquePlaces,
    required this.totalSpent,
    required this.topArea,
    required this.topDish,
    required this.topMood,
    required this.bestVisit,
    required this.busiestMonth,
    required this.narrative,
  });

  final int year;
  final int visitCount;
  final int uniquePlaces;
  final double totalSpent;
  final String topArea;
  final String topDish;
  final String topMood;
  final Visit? bestVisit;
  final String busiestMonth;
  final List<String> narrative;
}

final yearInFoodProvider = Provider<AsyncValue<YearInFoodData>>((ref) {
  final visits = ref.watch(visitsProvider);
  final eateries = ref.watch(allEateriesProvider);

  return visits.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (visitList) => eateries.when(
      loading: () => const AsyncValue.loading(),
      error: (e, st) => AsyncValue.error(e, st),
      data: (eateryList) {
        final year = DateTime.now().year;
        final yearVisits = visitList.where((v) => _yearOf(v.date) == year).toList();
        if (yearVisits.isEmpty) {
          return AsyncValue.data(
            YearInFoodData(
              year: year,
              visitCount: 0,
              uniquePlaces: 0,
              totalSpent: 0,
              topArea: '—',
              topDish: '—',
              topMood: '—',
              bestVisit: null,
              busiestMonth: '—',
              narrative: ['Log your first visit this year to unlock your Karachi food story.'],
            ),
          );
        }

        final byEatery = {for (final e in eateryList) e.id: e};
        final areas = <String, int>{};
        final moods = <String, int>{};
        final dishes = <String, int>{};
        final months = <int, int>{};
        var spent = 0.0;
        Visit? best;

        for (final v in yearVisits) {
          final area = byEatery[v.eateryId]?.areaName;
          if (area != null) areas[area] = (areas[area] ?? 0) + 1;
          for (final m in v.moodTags) moods[m] = (moods[m] ?? 0) + 1;
          for (final i in v.items) dishes[i.name] = (dishes[i.name] ?? 0) + 1;
          if (v.favoriteItem != null) dishes[v.favoriteItem!] = (dishes[v.favoriteItem!] ?? 0) + 1;
          if (v.totalBill != null) spent += v.totalBill!;
          final month = _monthOf(v.date);
          if (month != null) months[month] = (months[month] ?? 0) + 1;
          if (best == null || v.rating > best.rating) best = v;
        }

        final topArea = _topKey(areas) ?? 'Karachi';
        final topDish = _topKey(dishes) ?? 'everything';
        final topMood = _topKey(moods) ?? 'exploring';
        final busiestMonth = _monthName(_topKeyInt(months) ?? 1);

        final narrative = <String>[
          'In $year you logged ${yearVisits.length} visits across ${yearVisits.map((v) => v.eateryId).toSet().length} places.',
          if (spent > 0) 'You spent roughly ${formatRs(spent)} eating out — avg ${formatRs(spent / yearVisits.length)} per visit.',
          '$topArea was your most-visited area.',
          if (topDish != 'everything') 'Your most-ordered item: $topDish.',
          if (best != null) 'Highest-rated outing: ${best.eateryName} at ${best.rating.toStringAsFixed(1)} stars.',
          'Most visits happened in $busiestMonth.',
        ];

        return AsyncValue.data(
          YearInFoodData(
            year: year,
            visitCount: yearVisits.length,
            uniquePlaces: yearVisits.map((v) => v.eateryId).toSet().length,
            totalSpent: spent,
            topArea: topArea,
            topDish: topDish,
            topMood: topMood,
            bestVisit: best,
            busiestMonth: busiestMonth,
            narrative: narrative,
          ),
        );
      },
    ),
  );
});

int _yearOf(String iso) {
  try {
    return DateTime.parse(iso).year;
  } catch (_) {
    return int.tryParse(iso.substring(0, 4)) ?? DateTime.now().year;
  }
}

int? _monthOf(String iso) {
  try {
    return DateTime.parse(iso).month;
  } catch (_) {
    return null;
  }
}

String? _topKey(Map<String, int> map) {
  if (map.isEmpty) return null;
  return map.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
}

int? _topKeyInt(Map<int, int> map) {
  if (map.isEmpty) return null;
  return map.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
}

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
String _monthName(int m) => _months[(m - 1).clamp(0, 11)];
