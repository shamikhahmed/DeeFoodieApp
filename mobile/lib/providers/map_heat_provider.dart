import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/providers.dart';

class MapHeatNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

final mapHeatModeProvider = NotifierProvider<MapHeatNotifier, bool>(MapHeatNotifier.new);

final visitedEateryIdsProvider = Provider<Set<String>>((ref) {
  final visits = ref.watch(visitsProvider);
  return visits.maybeWhen(
    data: (list) => list.map((v) => v.eateryId).toSet(),
    orElse: () => <String>{},
  );
});
