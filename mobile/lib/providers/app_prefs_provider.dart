import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPrefs {
  static const _completedKey = 'onboarding_completed';
  static const _intentKey = 'onboarding_intent';
  static const _areaKey = 'onboarding_favorite_area';
  static const _moodKey = 'onboarding_mood';

  static Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_completedKey) ?? false;
  }

  static const _cravingKey = 'onboarding_craving';

  static Future<void> save({
    required String intent,
    required String favoriteArea,
    required String mood,
    String craving = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_completedKey, true);
    await prefs.setString(_intentKey, intent);
    await prefs.setString(_areaKey, favoriteArea);
    await prefs.setString(_moodKey, mood);
    await prefs.setString(_cravingKey, craving);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedKey);
    await prefs.remove(_intentKey);
    await prefs.remove(_areaKey);
    await prefs.remove(_moodKey);
    await prefs.remove(_cravingKey);
  }

  static Future<OnboardingAnswers?> load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_completedKey) ?? false)) return null;
    return OnboardingAnswers(
      intent: prefs.getString(_intentKey) ?? '',
      favoriteArea: prefs.getString(_areaKey) ?? '',
      mood: prefs.getString(_moodKey) ?? '',
      craving: prefs.getString(_cravingKey) ?? '',
    );
  }
}

class OnboardingAnswers {
  const OnboardingAnswers({
    required this.intent,
    required this.favoriteArea,
    required this.mood,
    this.craving = '',
  });

  final String intent;
  final String favoriteArea;
  final String mood;
  final String craving;
}

final onboardingAnswersProvider = FutureProvider<OnboardingAnswers?>((ref) {
  return OnboardingPrefs.load();
});

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale?> {
  static const _key = 'app_locale';

  @override
  Locale? build() {
    _load();
    return null;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null) state = Locale(code);
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_key);
      state = null;
    } else {
      await prefs.setString(_key, locale.languageCode);
      state = locale;
    }
  }

  Future<void> toggleEnUr() async {
    final next = state?.languageCode == 'ur' ? const Locale('en') : const Locale('ur');
    await setLocale(next);
  }
}
