import 'package:flutter/material.dart';

enum ThemeMode { light, dark }

extension ThemeModeExtension on ThemeMode {
  String get name {
    switch (this) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }

  static ThemeMode fromName(String name) {
    switch (name) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.light;
    }
  }
}

class AppColors {
  //static const AppColors light = AppColors();
  //static const AppColors dark = AppColors();

  static const Color accent = Color(0xFFFF8D28);
  static const Color authCardBg = Color(0xCC5A4A42);
  static const Color authFieldBg = Color(0xFF4A3D37);
  static const Color authBg = Color(0xFF3E332D);
  static const Color accentDisabled = Color(0x99FF8D28);
  static const Color textPrimary = Colors.black;
  static const Color label = Color(0x993C3C43);
  static const Color labelSecondary = Color(0xFF727272);
  static const Color labelTertiary = Color(0x4D3C3C43);
  static const Color labelDisabled = Color(0xFFD1D1D6);
  static const Color separator = Color(0xFFE6E6E6);
  static const Color hint = Color(0xFFAEAEB2);
  static const Color textSecondary = Colors.white;
  static Color textFieldBackground = Colors.black.withValues(alpha: 0.3);
  static const Color fillsSecondary = Color(0x29787880);

  // Home sheet
  static const Color sheetBackground = Color(0xFFF2F2F7);
  static const Color cardBackground = Colors.white;
  static const Color heroPillBackground = Color(0x66000000); // black @ 40%
  static const Color searchBarBackground = Color(0xFFE5E5EA);

}

// class AppTheme {
//   final AppColors colors;
//   final ThemeMode mode;

//   const AppTheme({required this.colors, required this.mode});

//   static const AppTheme light = AppTheme(
//     colors: AppColors.light,
//     mode: ThemeMode.light,
//   );

//   static const AppTheme dark = AppTheme(
//     colors: AppColors.dark,
//     mode: ThemeMode.dark,
//   );

//   bool get isDark => mode == ThemeMode.dark;
//   bool get isLight => mode == ThemeMode.light;

//   AppTheme copyWith({AppColors? colors, ThemeMode? mode}) {
//     return AppTheme(colors: colors ?? this.colors, mode: mode ?? this.mode);
//   }
// }
