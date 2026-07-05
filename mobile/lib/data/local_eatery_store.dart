import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/eatery.dart';

class LocalEateryStore {
  static const _key = 'local_eateries_json';

  static Future<List<Eatery>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Eatery.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> save(List<Eatery> eateries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(eateries.map((e) => e.toJson()).toList()));
  }
}

extension EateryJson on Eatery {
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'venueTypes': venueTypes,
        'cuisines': cuisines,
        'badges': badges,
        'areaName': areaName,
        'address': address,
        'description': description,
        'coverPhotoUrl': coverPhotoUrl,
        'avgRating': avgRating,
        'status': status,
        'createdAt': createdAt?.toIso8601String(),
        'lat': lat,
        'lng': lng,
        'mustTryName': mustTryName,
        'mustTryPrice': mustTryPrice,
        'visitCount': visitCount,
      };
}
