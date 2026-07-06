import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class JournalSpreadTheme {
  const JournalSpreadTheme({required this.paperTint, this.accent, this.marginColor});

  final Color paperTint;
  final Color? accent;
  final Color? marginColor;
}

JournalSpreadTheme spreadThemeForVisit(List<String> moodTags) {
  final moods = moodTags.map((m) => m.toLowerCase()).toSet();
  if (moods.contains('late night')) {
    return JournalSpreadTheme(
      paperTint: const Color(0xFFF5F0E8),
      accent: AppColors.coffeeBrown,
      marginColor: AppColors.inkBrown.withValues(alpha: 0.18),
    );
  }
  if (moods.contains('celebration') || moods.contains('birthday')) {
    return JournalSpreadTheme(
      paperTint: const Color(0xFFFFF8E8),
      accent: AppColors.rust,
      marginColor: AppColors.rust.withValues(alpha: 0.22),
    );
  }
  if (moods.contains('date')) {
    return JournalSpreadTheme(
      paperTint: const Color(0xFFFFF5F5),
      accent: AppColors.rust,
    );
  }
  if (moods.contains('family')) {
    return JournalSpreadTheme(
      paperTint: const Color(0xFFF4FAF4),
      accent: AppColors.darkGreen,
    );
  }
  if (moods.contains('friends')) {
    return JournalSpreadTheme(
      paperTint: const Color(0xFFF7F3FF),
      accent: AppColors.coffeeBrown,
    );
  }
  return const JournalSpreadTheme(paperTint: AppColors.paper);
}
