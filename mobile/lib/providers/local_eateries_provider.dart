import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local_eatery_store.dart';
import '../models/eatery.dart';

class LocalEateriesNotifier extends Notifier<List<Eatery>> {
  @override
  List<Eatery> build() {
    _load();
    return [];
  }

  Future<void> _load() async => state = await LocalEateryStore.load();

  Future<void> add(Eatery eatery) async {
    state = [eatery, ...state];
    await LocalEateryStore.save(state);
  }
}

final localEateriesProvider = NotifierProvider<LocalEateriesNotifier, List<Eatery>>(LocalEateriesNotifier.new);
