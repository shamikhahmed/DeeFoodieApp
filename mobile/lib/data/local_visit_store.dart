import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/visit.dart';

class LocalVisitStore {
  static const _key = 'local_visits_json';

  static Future<List<Visit>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Visit.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> save(List<Visit> visits) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(visits.map((v) => v.toJson()).toList()));
  }
}
