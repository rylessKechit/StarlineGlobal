import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'starlane_colors.dart';

class StarlaneTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: StarlaneColors.gold500,
        primaryContainer: StarlaneColors.gold100,
        secondary: StarlaneColors.navy500,
        secondaryContainer: StarlaneColors.navy100,
        tertiary: StarlaneColors.emerald500,
        tertiaryContainer: StarlaneColors.emerald100,
        surface: StarlaneColors.white,
        surfaceVariant: StarlaneColors.gray50,
        background: StarlaneColors.gray50,
        error: StarlaneColors.error,
        onPrimary: StarlaneColors.white,
        onSecondary: StarlaneColors.white,
        onTertiary: StarlaneColors.white,
        onSurface: StarlaneColors.gray900,
        onBackground: StarlaneColors.gray900,
        onError: StarlaneColors.white,
        outline: StarlaneColors.gray300,
        shadow: StarlaneColors.black.withOpacity(0.1),
      ),

      // Typography
      textTheme: GoogleFonts.interTextTheme().copyWith(
        // Display
        displayLarge: GoogleFonts.montserrat(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          height: 1.12,
          letterSpacing: -0.25,
          color: StarlaneColors.gray900,
        ),
        displayMedium: GoogleFonts.montserrat(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          height: 1.16,
          color: StarlaneColors.gray900,
        ),
        displaySmall: GoogleFonts.montserrat(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          height: 1.22,
          color: StarlaneColors.gray900,
        ),

        // Headline
        headlineLarge: GoogleFonts.montserrat(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          height: 1.25,
          color: StarlaneColors.gray900,
        ),
        headlineMedium: GoogleFonts.montserrat(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          height: 1.29,
          color: StarlaneColors.gray900,
        ),
        headlineSmall: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.33,
          color: StarlaneColors.gray900,
        ),

        // Title
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          height: 1.27,
          color: StarlaneColors.gray900,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
          letterSpacing: 0.15,
          color: StarlaneColors.gray900,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.43,
          letterSpacing: 0.1,
          color: StarlaneColors.gray900,
        ),

        // Body
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.5,
          color: StarlaneColors.gray700,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.43,
          letterSpacing: 0.25,
          color: StarlaneColors.gray700,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.33,
          letterSpacing: 0.4,
          color: StarlaneColors.gray600,
        ),

        // Label
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.43,
          letterSpacing: 0.1,
          color: StarlaneColors.gray900,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.33,
          letterSpacing: 0.5,
          color: StarlaneColors.gray700,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          height: 1.45,
          letterSpacing: 0.5,
          color: StarlaneColors.gray600,
        ),
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: StarlaneColors.white,
        foregroundColor: StarlaneColors.gray900,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: StarlaneColors.black.withOpacity(0.1),
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: StarlaneColors.gray900,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: StarlaneColors.gold500,
          foregroundColor: StarlaneColors.white,
          elevation: 2,
          shadowColor: StarlaneColors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: StarlaneColors.gold600,
          side: const BorderSide(color: StarlaneColors.gold500, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: StarlaneColors.gold600,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: StarlaneColors.gray50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: StarlaneColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: StarlaneColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: StarlaneColors.gold500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: StarlaneColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: StarlaneColors.error, width: 2),
        ),
        hintStyle: GoogleFonts.inter(
          color: StarlaneColors.gray500,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.inter(
          color: StarlaneColors.gray600,
          fontSize: 14,
        ),
        floatingLabelStyle: GoogleFonts.inter(
          color: StarlaneColors.gold600,
          fontSize: 14,
        ),
      ),

      // Card Theme - FIXED
      cardTheme: CardThemeData(
        color: StarlaneColors.white,
        elevation: 4,
        shadowColor: StarlaneColors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: StarlaneColors.white,
        selectedItemColor: StarlaneColors.gold600,
        unselectedItemColor: StarlaneColors.gray400,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: StarlaneColors.gray200,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      colorScheme: ColorScheme.dark(
        primary: StarlaneColors.gold400,
        primaryContainer: StarlaneColors.gold800,
        secondary: StarlaneColors.navy200,
        secondaryContainer: StarlaneColors.navy700,
        tertiary: StarlaneColors.emerald400,
        tertiaryContainer: StarlaneColors.emerald800,
        surface: StarlaneColors.navy800,
        surfaceVariant: StarlaneColors.navy700,
        background: StarlaneColors.navy900,
        error: StarlaneColors.error,
        onPrimary: StarlaneColors.navy900,
        onSecondary: StarlaneColors.navy900,
        onTertiary: StarlaneColors.navy900,
        onSurface: StarlaneColors.gray100,
        onBackground: StarlaneColors.gray100,
        onError: StarlaneColors.white,
        outline: StarlaneColors.gray600,
        shadow: StarlaneColors.black.withOpacity(0.3),
      ),
      // ... dark theme configurations
    );
  }
}