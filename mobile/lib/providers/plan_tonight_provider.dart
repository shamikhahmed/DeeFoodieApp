import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlanTonightNotifier extends Notifier<Set<String>> {
  static const maxStops = 3;

  @override
  Set<String> build() => {};

  bool get isFull => state.length >= maxStops;

  void toggle(String eateryId) {
    if (state.contains(eateryId)) {
      state = Set<String>.from(state)..remove(eateryId);
      return;
    }
    if (state.length >= maxStops) return;
    state = {...state, eateryId};
  }

  void clear() => state = {};
}

final planTonightProvider = NotifierProvider<PlanTonightNotifier, Set<String>>(PlanTonightNotifier.new);
