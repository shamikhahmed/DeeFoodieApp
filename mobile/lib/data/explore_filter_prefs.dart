import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/providers.dart';
import '../utils/price_band.dart';

class ExploreFilterPrefs {
  static const _key = 'explore_filter_v1';

  static Future<EateryFilterState?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      return EateryFilterState(
        q: m['q'] as String? ?? '',
        venueType: m['venueType'] as String?,
        cuisine: m['cuisine'] as String?,
        area: m['area'] as String?,
        unvisitedOnly: m['unvisitedOnly'] as bool? ?? false,
        priceBand: m['priceBand'] == null ? null : PriceBand.values[m['priceBand'] as int],
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> save(EateryFilterState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode({
      'q': state.q,
      'venueType': state.venueType,
      'cuisine': state.cuisine,
      'area': state.area,
      'unvisitedOnly': state.unvisitedOnly,
      'priceBand': state.priceBand?.index,
    }));
  }
}
