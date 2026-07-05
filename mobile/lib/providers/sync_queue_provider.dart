import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/providers.dart';
import '../data/sync_queue_store.dart';

class SyncQueueNotifier extends Notifier<int> {
  @override
  int build() => 0;

  Future<void> enqueue(SyncOpType type, Map<String, dynamic> payload) async {
    await SyncQueueStore.enqueue(SyncOp(
      id: 'sync-${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      payload: payload,
      createdAt: DateTime.now(),
    ));
    state++;
  }

  Future<int> processQueue() async {
    final online = await ref.read(apiOnlineProvider.future);
    if (!online) return 0;

    final api = ref.read(apiClientProvider);
    final ops = await SyncQueueStore.load();
    var done = 0;

    for (final op in ops) {
      if (op.retries > 5) continue;
      try {
        switch (op.type) {
          case SyncOpType.createVisit:
            await api.createVisit(
              eateryId: op.payload['eateryId'] as String,
              date: op.payload['date'] as String,
              rating: (op.payload['rating'] as num).toDouble(),
              reviewText: op.payload['reviewText'] as String?,
              moodTags: List<String>.from(op.payload['moodTags'] ?? []),
              items: (op.payload['items'] as List?)
                  ?.map((i) => Map<String, String>.from(i as Map))
                  .toList(),
              totalBill: op.payload['totalBill'] == null ? null : (op.payload['totalBill'] as num).toDouble(),
              favoriteItem: op.payload['favoriteItem'] as String?,
              companions: op.payload['companions'] as String?,
              photoUrls: List<String>.from(op.payload['photoUrls'] ?? []),
            );
          case SyncOpType.createEatery:
            await api.createEatery(
              name: op.payload['name'] as String,
              areaId: op.payload['areaId'] as String,
              venueTypeIds: List<String>.from(op.payload['venueTypeIds'] ?? []),
              cuisineIds: List<String>.from(op.payload['cuisineIds'] ?? []),
              lat: (op.payload['lat'] as num).toDouble(),
              lng: (op.payload['lng'] as num).toDouble(),
              address: op.payload['address'] as String?,
              description: op.payload['description'] as String?,
              ignoreDuplicateWarning: true,
            );
          case SyncOpType.updateVisit:
            await api.updateVisit(op.payload['id'] as String, Map<String, dynamic>.from(op.payload['body'] as Map));
          case SyncOpType.deleteVisit:
            await api.deleteVisit(op.payload['id'] as String);
        }
        await SyncQueueStore.remove(op.id);
        done++;
      } catch (_) {
        await SyncQueueStore.enqueue(op.withRetry());
        await SyncQueueStore.remove(op.id);
      }
    }

    if (done > 0) {
      ref.invalidate(visitsProvider);
      ref.invalidate(allEateriesProvider);
    }
    state = done;
    return done;
  }
}

final syncQueueProvider = NotifierProvider<SyncQueueNotifier, int>(SyncQueueNotifier.new);
