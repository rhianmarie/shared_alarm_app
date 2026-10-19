import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Backgrounds
  static const background = Color(0xFFFAF6F3);
  static const surface = Color(0xFFFFFCFA);
  static const surfaceSoft = Color(0xFFF3EDE8);

  // Lines
  static const border = Color(0xFFE8DDD6);

  // Browns
  static const primary = Color(0xFF5D4037);
  static const textDark = Color(0xFF3E2723);
  static const brown800 = Color(0xFF4E342E);
  static const textBody = Color(0xFF6D4C41);
  static const accent = Color(0xFF795548);
  static const textMuted = Color(0xFF8D6E63);
}

class AppTheme {
  /// Serif style (Lora) for titles like "Remind Me", "Schedule", "9:30".
  static TextStyle heading({
    double size = 21,
    Color color = AppColors.brown800,
    FontWeight weight = FontWeight.w400,
  }) {
    return GoogleFonts.lora(
      fontSize: size,
      height: 1.4,
      color: color,
      fontWeight: weight,
    );
  }

  static ThemeData get light {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          surface: AppColors.surface,
          onSurface: AppColors.textDark,
          outline: AppColors.border,
        );

    final base = ThemeData.light().textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.border,
      textTheme: base.apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
    );
  }
}
