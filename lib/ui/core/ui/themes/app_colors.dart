import 'package:flutter/material.dart';

/// Synamyk palette: the logo's violet shading into indigo, mint for
/// success, on a soft lavender canvas with white cards.
abstract final class AppColors {
  static const primary = Color(0xFF6D35E0);
  static const primaryDark = Color(0xFF4A22B0);
  static const primarySoft = Color(0xFFF0EAFE);
  static const primaryBorder = Color(0xFFD8C9FB);

  static const headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8A3FE0), Color(0xFF5B37E3), Color(0xFF4338CA)],
  );

  static const canvas = Color(0xFFF6F4FC);
  static const canvasGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF1ECFD), Color(0xFFF8F7FC)],
  );
  static const surface = Colors.white;
  static const divider = Color(0xFFE9E5F3);

  static const textPrimary = Color(0xFF1B1530);
  static const textSecondary = Color(0xFF625B78);
  static const textMuted = Color(0xFF9D97B0);

  static const success = Color(0xFF12B886);
  static const successSoft = Color(0xFFE2F8F1);
  static const warning = Color(0xFFEA7C1C);
  static const warningSoft = Color(0xFFFDF0E3);
  static const danger = Color(0xFFDC2626);
  static const dangerSoft = Color(0xFFFDECEC);
  static const gold = Color(0xFFF5B301);
  static const goldSoft = Color(0xFFFFF6DB);
  static const pink = Color(0xFFDB2777);
  static const pinkSoft = Color(0xFFFCE7F3);

  /// Icon tile colors cycled through section/list icons.
  static const tilePalette = <(Color, Color)>[
    (Color(0xFFF08A24), Color(0xFFFFF1E2)),
    (Color(0xFFE5484D), Color(0xFFFDEBEC)),
    (Color(0xFF30A46C), Color(0xFFE6F6EC)),
    (Color(0xFF6D35E0), Color(0xFFF0EAFE)),
    (Color(0xFFD9A400), Color(0xFFFFF6D6)),
    (Color(0xFF12B886), Color(0xFFE2F8F1)),
  ];

  static const cardShadow = [
    BoxShadow(color: Color(0x146D35E0), blurRadius: 20, offset: Offset(0, 6)),
  ];
}
