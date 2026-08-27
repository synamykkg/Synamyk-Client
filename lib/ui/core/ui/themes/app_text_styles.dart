import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyles {
  static TextStyle get _base => GoogleFonts.inter();

  // Headings & Titles
  static TextStyle get h1 => _base.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle get h2 => _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle get h2Bold => h2.copyWith(fontWeight: FontWeight.bold);

  static TextStyle get h3 => _base.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle get appBarTitle => h3;

  static TextStyle get h4 => _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  // Body Text
  static TextStyle get bodyLarge => _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static TextStyle get bodyMedium => _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static TextStyle get bodySmall => _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle get caption => _base.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  // Material Theme Styles
  static TextStyle get displayLarge => _base.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle get displayMedium => _base.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle get headlineLarge => _base.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle get headlineMedium => _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle get headlineSmall => _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle get bodyLargeTheme => _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF1A1A1A),
  );

  // Specific Colors/Variants found in app

  // Home Page
  static TextStyle get homeTitle => h2Bold;
  static TextStyle get homeTitleAccent => h2Bold.copyWith(color: Colors.purple);
  static TextStyle get ortCardTitle =>
      h4.copyWith(color: const Color(0xFF3A005E));
  static TextStyle get ortCardDesc => caption; // Inter 10 w400 black

  // Profile Page
  static TextStyle get profileStatValue => h2; // Inter 24 w500
  static TextStyle get profileStatLabel =>
      bodySmall.copyWith(color: const Color(0xFFA5A3A9));
  static TextStyle get profileName => h4; // Inter 18 w500
  static TextStyle get profileDesc =>
      bodySmall.copyWith(color: const Color(0xFF808080));
  static TextStyle get settingsItem =>
      bodyMedium.copyWith(fontWeight: FontWeight.w500); // Inter 14 w500

  // ORT Test Page
  static TextStyle get buttonText => bodyMedium.copyWith(color: Colors.white);
  static TextStyle get buttonTextPurple =>
      bodyMedium.copyWith(color: const Color(0xFF7B1FA2));
  static TextStyle get questionTitle => h4;
  static TextStyle get questionText => bodyMedium; // Inter 14 w400
  static TextStyle get resultTitle => h1; // Inter 26 w500
  static TextStyle get resultSubtitle => bodySmall; // Inter 12 w400
  static TextStyle get statValueGreen =>
      h4.copyWith(color: const Color(0xFF08A64A));
  static TextStyle get statLabel =>
      bodySmall.copyWith(color: const Color(0xFF666666));
  static TextStyle get modalText =>
      bodySmall.copyWith(color: const Color(0xFF7B1FA2));

  // News Page
  static TextStyle get newsTitle => h4.copyWith(color: const Color(0xFF1A1A1A));
  static TextStyle get newsSubtitle =>
      bodySmall.copyWith(color: const Color(0xFF1A1A1A));
  static TextStyle get newsDate =>
      bodySmall.copyWith(color: const Color(0xFF666666));

  static TextStyle get editProfileButton => _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF7B1FA2),
    height: 1.0, // line-height: 100%
  );

  // Home Tests List Page
  static TextStyle get testCardLabel => _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    color: const Color(0xFF1A1A1A),
    height: 1.0,
    letterSpacing: 0.0,
  );

  static TextStyle get testCardTitle => _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
    color: const Color(0xFF1A1A1A),
    height: 1.0,
    letterSpacing: 0.0,
  );

  static TextStyle get testCardMetadata => _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    color: const Color(0xFF1A1A1A),
    height: 1.0,
    letterSpacing: 0.0,
  );

  // Auth Page
  static TextStyle get authTitle => _base.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle get authSubTitle => bodyMedium.copyWith();

  
}
