import 'package:flutter/material.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';

final theme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF7B1FA2),
    brightness: Brightness.light,
  ),
  dividerColor: Color(0xFFE5E5E5),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
    elevation: 0,
    backgroundColor: Color(0xFFFFFFFF),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  ),
  listTileTheme: const ListTileThemeData(iconColor: Colors.white),
  textTheme: TextTheme(
    displayLarge: AppTextStyles.displayLarge,
    displayMedium: AppTextStyles.displayMedium,
    headlineLarge: AppTextStyles.headlineLarge,
    headlineMedium: AppTextStyles.headlineMedium,
    headlineSmall: AppTextStyles.headlineSmall,
    bodyLarge: AppTextStyles.bodyLargeTheme,
  ),
);
