import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiscountCardsNotifier extends Notifier<Set<String>> {
  static const _key = 'user_discount_program_ids';

  @override
  Set<String> build() {
    _load();
    return {};
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key);
    if (list != null) state = list.toSet();
  }

  Future<void> toggle(String programId) async {
    final next = Set<String>.from(state);
    if (next.contains(programId)) {
      next.remove(programId);
    } else {
      next.add(programId);
    }
    await _persist(next);
  }

  Future<void> setAll(Set<String> ids) async {
    await _persist(ids);
  }

  Future<void> _persist(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids.toList());
    state = ids;
  }
}

final discountCardsProvider = NotifierProvider<DiscountCardsNotifier, Set<String>>(DiscountCardsNotifier.new);

final myDealsFilterProvider = NotifierProvider<MyDealsFilterNotifier, bool>(MyDealsFilterNotifier.new);

class MyDealsFilterNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void set(bool v) => state = v;
}
