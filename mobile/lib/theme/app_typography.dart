import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

TextTheme buildAppTextTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final primary = isDark ? AppColors.paper : AppColors.textPrimary;
  final secondary = isDark
      ? AppColors.paper.withValues(alpha: 0.82)
      : AppColors.textSecondary;
  final muted = isDark
      ? AppColors.paper.withValues(alpha: 0.78)
      : AppColors.textMuted;

  final display = GoogleFonts.fraunces(color: primary);
  final body = GoogleFonts.inter(color: primary);
  final hand = GoogleFonts.caveat(color: secondary);

  return TextTheme(
    displayLarge: display.copyWith(
      fontSize: 34,
      fontWeight: FontWeight.w600,
      height: 1.15,
      letterSpacing: -0.5,
    ),
    displayMedium: display.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),
    displaySmall: display.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      height: 1.25,
    ),
    headlineSmall: display.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    headlineMedium: display.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    titleLarge: display.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.35,
      color: primary,
    ),
    titleMedium: display.copyWith(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: primary,
    ),
    titleSmall: body.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: primary,
    ),
    bodyLarge: body.copyWith(fontSize: 16, height: 1.5, color: primary),
    bodyMedium: body.copyWith(fontSize: 14, height: 1.5, color: primary),
    bodySmall: body.copyWith(fontSize: 12, height: 1.45, color: secondary, fontWeight: FontWeight.w500),
    labelLarge: hand.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: secondary,
    ),
    labelMedium: body.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
      color: primary,
    ),
    labelSmall: body.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      color: secondary,
    ),
  );
}
