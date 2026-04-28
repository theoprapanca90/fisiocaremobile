import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF009689);
  static const Color primaryDark = Color(0xFF009689);
  static const Color primaryLight = Color(0xFF00BBA7);
  static const Color primaryGradientStart = Color(0xFF00BBA7);
  static const Color primaryGradientEnd = Color(0xFF009689);
  static const Color primaryText = Color(0xFF0F172B);
  static const Color secondaryText = Color(0xFF45556C);
  static const Color hintText = Color(0xFF717182);
  static const Color lightText = Color(0xFF62748E);
  static const Color inputBg = Color(0xFFF3F3F5);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color scaffoldBg = Color(0xFFF8FAFC);
  static const Color borderColor = Color(0x1A000000);
  static const Color firefly = Color(0xFF0F2B28);
  static const Color acapulco = Color(0xFF6EA8A2);
  static const Color scandal = Color(0xFFD9EFED);
  static const Color goldenTainoi = Color(0xFFFFD166);
  static const Color polar = Color(0xFFDDD6FE);
  static const Color dodgerBlue = Color(0xFF3B82F6);
  static const Color zumthor = Color(0xFFEFF6FF);
  static const Color tealGradientBg = Color(0xFFB2EDE7);
  static const Color nutmegWoodFinish = Color(0xFF6B4000);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF22C55E);
  static const Color warningYellow = Color(0xFFF59E0B);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: AppColors.scaffoldBg,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(double.infinity, 44),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.hintText, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
