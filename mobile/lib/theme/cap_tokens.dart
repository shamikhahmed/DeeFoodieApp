import 'package:flutter/material.dart';

/// Cap Foundation tokens as a [ThemeExtension] (FND-05).
/// Brand accent overridden for DeeFoodie (coffee brown family).
@immutable
class CapTokens extends ThemeExtension<CapTokens> {
  const CapTokens({
    required this.bg,
    required this.bgGrouped,
    required this.surface,
    required this.surface2,
    required this.separator,
    required this.text,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentContrast,
    required this.accentText,
    required this.success,
    required this.successText,
    required this.warning,
    required this.warningText,
    required this.danger,
    required this.dangerText,
    required this.focus,
    required this.scrim,
    required this.materialBar,
    required this.space3,
    required this.space5,
    required this.space7,
    required this.radiusMd,
    required this.radiusLg,
    required this.rowMinHeight,
  });

  final Color bg;
  final Color bgGrouped;
  final Color surface;
  final Color surface2;
  final Color separator;
  final Color text;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color accentContrast;
  final Color accentText;
  final Color success;
  final Color successText;
  final Color warning;
  final Color warningText;
  final Color danger;
  final Color dangerText;
  final Color focus;
  final Color scrim;
  final Color materialBar;
  final double space3;
  final double space5;
  final double space7;
  final double radiusMd;
  final double radiusLg;
  final double rowMinHeight;

  /// DeeFoodie light brand (cream paper + coffee accent).
  static const light = CapTokens(
    bg: Color(0xFFF7F1E8),
    bgGrouped: Color(0xFFFFFCF6),
    surface: Color(0xFFFFFDF8),
    surface2: Color(0xFFF2E8DA),
    separator: Color(0x4A3C3C43),
    text: Color(0xFF2C1810),
    textSecondary: Color(0x993C3C43),
    textTertiary: Color(0x4D3C3C43),
    accent: Color(0xFF6B3F2A),
    accentContrast: Color(0xFFFFFDF8),
    accentText: Color(0xFF5A3422),
    success: Color(0xFF2D6A4F),
    successText: Color(0xFF1B4332),
    warning: Color(0xFFB25000),
    warningText: Color(0xFF8A3D00),
    danger: Color(0xFFC23B22),
    dangerText: Color(0xFF9B2C14),
    focus: Color(0xFF0A84FF),
    scrim: Color(0x66000000),
    materialBar: Color(0xD9FFFDF8),
    space3: 8,
    space5: 16,
    space7: 24,
    radiusMd: 14,
    radiusLg: 20,
    rowMinHeight: 44,
  );

  static const dark = CapTokens(
    bg: Color(0xFF1A1410),
    bgGrouped: Color(0xFF2A2218),
    surface: Color(0xFF2A2218),
    surface2: Color(0xFF3A2E22),
    separator: Color(0xA6545458),
    text: Color(0xFFFFFDF8),
    textSecondary: Color(0x99EBEBF5),
    textTertiary: Color(0x4DEBEBF5),
    accent: Color(0xFFC4A484),
    accentContrast: Color(0xFF1A1410),
    accentText: Color(0xFFD4B494),
    success: Color(0xFF34C759),
    successText: Color(0xFF30D158),
    warning: Color(0xFFFF9F0A),
    warningText: Color(0xFFFFD60A),
    danger: Color(0xFFFF453A),
    dangerText: Color(0xFFFF6961),
    focus: Color(0xFF0A84FF),
    scrim: Color(0x99000000),
    materialBar: Color(0xD92A2218),
    space3: 8,
    space5: 16,
    space7: 24,
    radiusMd: 14,
    radiusLg: 20,
    rowMinHeight: 44,
  );

  @override
  CapTokens copyWith({
    Color? accent,
    Color? accentContrast,
    Color? accentText,
  }) {
    return CapTokens(
      bg: bg,
      bgGrouped: bgGrouped,
      surface: surface,
      surface2: surface2,
      separator: separator,
      text: text,
      textSecondary: textSecondary,
      textTertiary: textTertiary,
      accent: accent ?? this.accent,
      accentContrast: accentContrast ?? this.accentContrast,
      accentText: accentText ?? this.accentText,
      success: success,
      successText: successText,
      warning: warning,
      warningText: warningText,
      danger: danger,
      dangerText: dangerText,
      focus: focus,
      scrim: scrim,
      materialBar: materialBar,
      space3: space3,
      space5: space5,
      space7: space7,
      radiusMd: radiusMd,
      radiusLg: radiusLg,
      rowMinHeight: rowMinHeight,
    );
  }

  @override
  CapTokens lerp(ThemeExtension<CapTokens>? other, double t) {
    if (other is! CapTokens) return this;
    return CapTokens(
      bg: Color.lerp(bg, other.bg, t)!,
      bgGrouped: Color.lerp(bgGrouped, other.bgGrouped, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      separator: Color.lerp(separator, other.separator, t)!,
      text: Color.lerp(text, other.text, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentContrast: Color.lerp(accentContrast, other.accentContrast, t)!,
      accentText: Color.lerp(accentText, other.accentText, t)!,
      success: Color.lerp(success, other.success, t)!,
      successText: Color.lerp(successText, other.successText, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningText: Color.lerp(warningText, other.warningText, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerText: Color.lerp(dangerText, other.dangerText, t)!,
      focus: Color.lerp(focus, other.focus, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      materialBar: Color.lerp(materialBar, other.materialBar, t)!,
      space3: space3,
      space5: space5,
      space7: space7,
      radiusMd: radiusMd,
      radiusLg: radiusLg,
      rowMinHeight: rowMinHeight,
    );
  }
}

extension CapTokensContext on BuildContext {
  CapTokens get capTokens =>
      Theme.of(this).extension<CapTokens>() ?? CapTokens.light;
}
