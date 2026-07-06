import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/menu_item_picker.dart';

class VisitTemplatesNotifier extends Notifier<Map<String, List<SelectedMenuItem>>> {
  static const _key = 'visit_templates_v1';

  @override
  Map<String, List<SelectedMenuItem>> build() {
    _load();
    return {};
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      state = m.map((eateryId, list) {
        final items = (list as List<dynamic>).map((i) {
          final map = i as Map<String, dynamic>;
          return SelectedMenuItem(
            name: map['name'] as String,
            price: (map['price'] as num?)?.toDouble() ?? 0,
            type: map['type'] as String? ?? 'food',
          );
        }).toList();
        return MapEntry(eateryId, items);
      });
    } catch (_) {}
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = state.map((id, items) => MapEntry(
          id,
          items
              .map((i) => {'name': i.name, 'price': i.price, 'type': i.type})
              .toList(),
        ));
    await prefs.setString(_key, jsonEncode(encoded));
  }

  List<SelectedMenuItem> forEatery(String eateryId) => state[eateryId] ?? const [];

  Future<void> save(String eateryId, List<SelectedMenuItem> items) async {
    if (items.isEmpty) {
      final next = Map<String, List<SelectedMenuItem>>.from(state)..remove(eateryId);
      state = next;
    } else {
      state = {...state, eateryId: items};
    }
    await _persist();
  }
}

final visitTemplatesProvider =
    NotifierProvider<VisitTemplatesNotifier, Map<String, List<SelectedMenuItem>>>(VisitTemplatesNotifier.new);
