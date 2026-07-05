import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodCollection {
  const FoodCollection({required this.id, required this.name, required this.eateryIds, this.pinned = false});

  final String id;
  final String name;
  final List<String> eateryIds;
  final bool pinned;

  FoodCollection copyWith({String? name, List<String>? eateryIds, bool? pinned}) => FoodCollection(
        id: id,
        name: name ?? this.name,
        eateryIds: eateryIds ?? this.eateryIds,
        pinned: pinned ?? this.pinned,
      );

  factory FoodCollection.fromJson(Map<String, dynamic> j) => FoodCollection(
        id: j['id'] as String,
        name: j['name'] as String,
        eateryIds: List<String>.from(j['eateryIds'] ?? []),
        pinned: j['pinned'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'eateryIds': eateryIds, 'pinned': pinned};
}

class CollectionsNotifier extends Notifier<List<FoodCollection>> {
  static const _key = 'food_collections';

  @override
  List<FoodCollection> build() {
    _load();
    return [];
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    state = (jsonDecode(raw) as List).map((e) => FoodCollection.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.map((c) => c.toJson()).toList()));
  }

  Future<void> create(String name) async {
    final c = FoodCollection(id: 'col-${DateTime.now().millisecondsSinceEpoch}', name: name, eateryIds: []);
    state = [c, ...state];
    await _persist();
  }

  Future<void> remove(String id) async {
    state = state.where((c) => c.id != id).toList();
    await _persist();
  }

  Future<void> toggleEatery(String collectionId, String eateryId) async {
    state = state.map((c) {
      if (c.id != collectionId) return c;
      final ids = [...c.eateryIds];
      if (ids.contains(eateryId)) {
        ids.remove(eateryId);
      } else {
        ids.add(eateryId);
      }
      return c.copyWith(eateryIds: ids);
    }).toList();
    await _persist();
  }
}

final collectionsProvider = NotifierProvider<CollectionsNotifier, List<FoodCollection>>(CollectionsNotifier.new);
