import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

export 'app_colors.dart';
export 'app_spacing.dart';
export 'app_typography.dart';

ThemeData buildAppTheme({Brightness brightness = Brightness.light}) {
  final isDark = brightness == Brightness.dark;
  final textTheme = buildAppTextTheme(brightness);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: isDark ? const Color(0xFF1A1410) : AppColors.cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.coffeeBrown,
      brightness: brightness,
      surface: isDark ? const Color(0xFF2A2218) : AppColors.paper,
      primary: AppColors.coffeeBrown,
      secondary: AppColors.darkGreen,
    ),
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: isDark ? AppColors.paper : AppColors.inkBrown,
      titleTextStyle: textTheme.titleLarge?.copyWith(color: isDark ? AppColors.paper : AppColors.inkBrown),
      iconTheme: IconThemeData(color: isDark ? AppColors.paper : AppColors.inkBrown),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.transparent,
      indicatorColor: AppColors.coffeeBrown.withValues(alpha: isDark ? 0.25 : 0.15),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return textTheme.labelSmall?.copyWith(
          color: selected
              ? AppColors.coffeeBrown
              : (isDark ? AppColors.paper.withValues(alpha: 0.78) : AppColors.textSecondary),
          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected
              ? AppColors.coffeeBrown
              : (isDark ? AppColors.paper.withValues(alpha: 0.78) : AppColors.textSecondary),
          size: 22,
        );
      }),
      height: 64,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.paper.withValues(alpha: isDark ? 0.12 : 0.92),
      selectedColor: AppColors.coffeeBrown.withValues(alpha: 0.22),
      checkmarkColor: AppColors.coffeeBrown,
      labelStyle: textTheme.labelMedium?.copyWith(
        color: isDark ? AppColors.paper : AppColors.inkBrown,
        fontWeight: FontWeight.w600,
      ),
      secondaryLabelStyle: textTheme.labelMedium?.copyWith(color: AppColors.coffeeBrown),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide(color: AppColors.inkBrown.withValues(alpha: isDark ? 0.2 : 0.12)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.coffeeBrown,
        textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      border: InputBorder.none,
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: isDark ? AppColors.paper.withValues(alpha: 0.72) : AppColors.textMuted,
      ),
      contentPadding: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.coffeeBrown,
        foregroundColor: AppColors.paper,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm + 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.paper),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.inkBrown.withValues(alpha: isDark ? 0.15 : 0.08),
      thickness: 1,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: brightness,
      primaryColor: AppColors.coffeeBrown,
    ),
  );
}

ThemeData buildDarkAppTheme() => buildAppTheme(brightness: Brightness.dark);
