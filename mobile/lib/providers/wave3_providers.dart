import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/providers.dart';
import '../models/eatery.dart';

class OrderItemStat {
  const OrderItemStat({required this.name, required this.count, required this.avgRating});

  final String name;
  final int count;
  final double avgRating;
}

final theOrderProvider = Provider<AsyncValue<List<OrderItemStat>>>((ref) {
  final visits = ref.watch(visitsProvider);
  return visits.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (list) {
      final counts = <String, int>{};
      final ratingSum = <String, double>{};
      final ratingCount = <String, int>{};

      for (final v in list) {
        for (final item in v.items) {
          counts[item.name] = (counts[item.name] ?? 0) + 1;
        }
        if (v.favoriteItem != null) {
          counts[v.favoriteItem!] = (counts[v.favoriteItem!] ?? 0) + 1;
        }
        final targets = [...v.items.map((i) => i.name), if (v.favoriteItem != null) v.favoriteItem!];
        for (final t in targets.toSet()) {
          ratingSum[t] = (ratingSum[t] ?? 0) + v.rating;
          ratingCount[t] = (ratingCount[t] ?? 0) + 1;
        }
      }

      final stats = counts.entries
          .map(
            (e) => OrderItemStat(
              name: e.key,
              count: e.value,
              avgRating: ratingCount[e.key] == null || ratingCount[e.key]! == 0
                  ? 0
                  : ratingSum[e.key]! / ratingCount[e.key]!,
            ),
          )
          .toList()
        ..sort((a, b) => b.count.compareTo(a.count));

      return AsyncValue.data(stats.take(30).toList());
    },
  );
});

final closedEateriesProvider = Provider<AsyncValue<List<Eatery>>>((ref) {
  final eateries = ref.watch(allEateriesProvider);
  return eateries.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (list) => AsyncValue.data(list.where((e) => e.status == 'closed').toList()),
  );
});
