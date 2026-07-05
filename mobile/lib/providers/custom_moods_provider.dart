import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomMoodsNotifier extends Notifier<List<String>> {
  static const _key = 'custom_mood_tags';

  @override
  List<String> build() {
    _load();
    return [];
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getStringList(_key) ?? [];
  }

  Future<void> add(String mood) async {
    final trimmed = mood.trim();
    if (trimmed.isEmpty || state.contains(trimmed)) return;
    state = [...state, trimmed];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, state);
  }
}

final customMoodsProvider = NotifierProvider<CustomMoodsNotifier, List<String>>(CustomMoodsNotifier.new);
