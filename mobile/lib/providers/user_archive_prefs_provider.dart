import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistEntry {
  const WishlistEntry({required this.eateryId, this.reason = ''});

  final String eateryId;
  final String reason;

  Map<String, dynamic> toJson() => {'eateryId': eateryId, 'reason': reason};

  factory WishlistEntry.fromJson(Map<String, dynamic> json) => WishlistEntry(
        eateryId: json['eateryId'] as String,
        reason: json['reason'] as String? ?? '',
      );
}

class FavoritesNotifier extends Notifier<Set<String>> {
  static const _key = 'favorite_eatery_ids';

  @override
  Set<String> build() {
    _load();
    return {};
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key);
    if (raw != null) state = raw.toSet();
  }

  Future<void> toggle(String eateryId) async {
    final next = Set<String>.from(state);
    if (next.contains(eateryId)) {
      next.remove(eateryId);
    } else {
      next.add(eateryId);
    }
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, next.toList());
  }

  bool isFavorite(String id) => state.contains(id);
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);

class WishlistNotifier extends Notifier<List<WishlistEntry>> {
  static const _key = 'wishlist_entries';

  @override
  List<WishlistEntry> build() {
    _load();
    return [];
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    final list = (jsonDecode(raw) as List<dynamic>)
        .map((e) => WishlistEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    state = list;
  }

  Future<void> add(String eateryId, {String reason = ''}) async {
    if (state.any((e) => e.eateryId == eateryId)) return;
    state = [...state, WishlistEntry(eateryId: eateryId, reason: reason)];
    await _persist();
  }

  Future<void> remove(String eateryId) async {
    state = state.where((e) => e.eateryId != eateryId).toList();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.map((e) => e.toJson()).toList()));
  }
}

final wishlistProvider = NotifierProvider<WishlistNotifier, List<WishlistEntry>>(WishlistNotifier.new);

enum ExploreSort { rating, name, area }

class ExploreSortNotifier extends Notifier<ExploreSort> {
  @override
  ExploreSort build() => ExploreSort.rating;

  void setSort(ExploreSort sort) => state = sort;
}

final exploreSortProvider = NotifierProvider<ExploreSortNotifier, ExploreSort>(ExploreSortNotifier.new);

enum JournalMoodFilter { all, friends, family, date, alone, lateNight, celebration }

class JournalMoodFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setFilter(String? mood) => state = mood;
}

final journalMoodFilterProvider = NotifierProvider<JournalMoodFilterNotifier, String?>(JournalMoodFilterNotifier.new);
