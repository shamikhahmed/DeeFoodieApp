import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasteProfile {
  const TasteProfile({
    this.gender = '',
    this.spiceLevel = '',
    this.sweetsPreference = '',
    this.favoriteCuisines = const [],
    this.dietaryNotes = '',
    this.budgetRange = '',
    this.avoids = const [],
  });

  final String gender;
  final String spiceLevel;
  final String sweetsPreference;
  final List<String> favoriteCuisines;
  final String dietaryNotes;
  final String budgetRange;
  final List<String> avoids;

  Map<String, dynamic> toJson() => {
        'gender': gender,
        'spiceLevel': spiceLevel,
        'sweetsPreference': sweetsPreference,
        'favoriteCuisines': favoriteCuisines,
        'dietaryNotes': dietaryNotes,
        'budgetRange': budgetRange,
        'avoids': avoids,
      };

  factory TasteProfile.fromJson(Map<String, dynamic> json) => TasteProfile(
        gender: json['gender'] as String? ?? '',
        spiceLevel: json['spiceLevel'] as String? ?? '',
        sweetsPreference: json['sweetsPreference'] as String? ?? '',
        favoriteCuisines: List<String>.from(json['favoriteCuisines'] ?? []),
        dietaryNotes: json['dietaryNotes'] as String? ?? '',
        budgetRange: json['budgetRange'] as String? ?? '',
        avoids: List<String>.from(json['avoids'] ?? []),
      );

  TasteProfile copyWith({
    String? gender,
    String? spiceLevel,
    String? sweetsPreference,
    List<String>? favoriteCuisines,
    String? dietaryNotes,
    String? budgetRange,
    List<String>? avoids,
  }) {
    return TasteProfile(
      gender: gender ?? this.gender,
      spiceLevel: spiceLevel ?? this.spiceLevel,
      sweetsPreference: sweetsPreference ?? this.sweetsPreference,
      favoriteCuisines: favoriteCuisines ?? this.favoriteCuisines,
      dietaryNotes: dietaryNotes ?? this.dietaryNotes,
      budgetRange: budgetRange ?? this.budgetRange,
      avoids: avoids ?? this.avoids,
    );
  }
}

class TasteProfileNotifier extends Notifier<TasteProfile> {
  static const _key = 'taste_profile_json';

  @override
  TasteProfile build() {
    _load();
    return const TasteProfile();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      state = TasteProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }
  }

  Future<void> save(TasteProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(profile.toJson()));
    state = profile;
  }

  Future<void> patch(TasteProfile Function(TasteProfile) fn) async {
    await save(fn(state));
  }
}

final tasteProfileProvider = NotifierProvider<TasteProfileNotifier, TasteProfile>(TasteProfileNotifier.new);
