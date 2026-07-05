import 'package:flutter/material.dart';

class AppColors {
  static const cream = Color(0xFFF3E7D3);
  static const paper = Color(0xFFFBF6EA);
  static const coffeeBrown = Color(0xFF6F4E37);
  static const darkGreen = Color(0xFF2F4A3C);
  static const rust = Color(0xFFB5432D);
  static const inkBrown = Color(0xFF1A1008);

  static const textPrimary = inkBrown;
  static Color textSecondary = inkBrown.withValues(alpha: 0.92);
  static Color textMuted = inkBrown.withValues(alpha: 0.88);
  static Color textSubtle = inkBrown.withValues(alpha: 0.76);

  static const accent = coffeeBrown;
  static const rating = rust;

  static const glassWarm = Color(0xFFFFFDF8);
  static const glassCool = Color(0xFFF2F6F3);
  static const glassTintOpacity = 0.97;

  static Color scrimLight = cream.withValues(alpha: 0.68);
  static Color scrimDark = const Color(0xFF1A1410).withValues(alpha: 0.82);

  static Color glassBorder(bool isDark) =>
      Colors.white.withValues(alpha: isDark ? 0.12 : 0.35);

  static Color glassShadow(bool isDark) =>
      inkBrown.withValues(alpha: isDark ? 0.25 : 0.08);
}
