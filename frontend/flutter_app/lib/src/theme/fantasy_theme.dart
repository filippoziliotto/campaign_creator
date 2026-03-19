import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FantasyPalette {
  static const abyss = Color(0xFF0E0A08);
  static const shadow = Color(0xFF1A100D);
  static const ember = Color(0xFF7C241B);
  static const emberBright = Color(0xFFB44428);
  static const bronze = Color(0xFFC9994B);
  static const parchment = Color(0xFFF4E7C8);
  static const parchmentDeep = Color(0xFFE7D3A6);
  static const ink = Color(0xFF21140C);
  static const moss = Color(0xFF32443A);
  static const mist = Color(0xFFA89275);
  static const outline = Color(0xFF6A4A2A);
  static const card = Color(0xFF1B120E);
  static const cardSoft = Color(0xFF241814);
}

ThemeData buildFantasyTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: FantasyPalette.emberBright,
    brightness: Brightness.dark,
  ).copyWith(
    primary: FantasyPalette.bronze,
    onPrimary: FantasyPalette.ink,
    secondary: FantasyPalette.emberBright,
    onSecondary: FantasyPalette.parchment,
    surface: FantasyPalette.card,
    onSurface: FantasyPalette.parchment,
    outline: FantasyPalette.outline,
    outlineVariant: FantasyPalette.mist,
    primaryContainer: FantasyPalette.ember,
    onPrimaryContainer: FantasyPalette.parchment,
    secondaryContainer: FantasyPalette.moss,
    onSecondaryContainer: FantasyPalette.parchment,
    tertiary: FantasyPalette.parchmentDeep,
    onTertiary: FantasyPalette.ink,
    tertiaryContainer: FantasyPalette.cardSoft,
    onTertiaryContainer: FantasyPalette.parchment,
    error: const Color(0xFFE67E6A),
    onError: FantasyPalette.ink,
    errorContainer: const Color(0xFF5F241D),
    onErrorContainer: const Color(0xFFFFD8D0),
    surfaceContainerHighest: FantasyPalette.cardSoft,
    onSurfaceVariant: FantasyPalette.mist,
    surfaceTint: Colors.transparent,
    inverseSurface: FantasyPalette.parchment,
    onInverseSurface: FantasyPalette.ink,
    inversePrimary: FantasyPalette.emberBright,
    scrim: Colors.black,
  );

  final baseTextTheme = GoogleFonts.crimsonTextTextTheme(
    ThemeData(brightness: Brightness.dark).textTheme,
  ).apply(
    bodyColor: FantasyPalette.parchment,
    displayColor: FantasyPalette.parchment,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: FantasyPalette.abyss,
    textTheme: baseTextTheme.copyWith(
      displayLarge: GoogleFonts.cinzelDecorative(
        color: FantasyPalette.parchment,
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
      headlineLarge: GoogleFonts.cinzel(
        color: FantasyPalette.parchment,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.9,
      ),
      headlineMedium: GoogleFonts.cinzel(
        color: FantasyPalette.parchment,
        fontSize: 23,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
      ),
      titleLarge: GoogleFonts.cinzel(
        color: FantasyPalette.parchment,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
      ),
      titleMedium: GoogleFonts.cinzel(
        color: FantasyPalette.parchmentDeep,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
      ),
      titleSmall: GoogleFonts.cinzel(
        color: FantasyPalette.bronze,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
      bodyLarge: GoogleFonts.crimsonText(
        color: FantasyPalette.parchment,
        fontSize: 20,
        height: 1.45,
      ),
      bodyMedium: GoogleFonts.crimsonText(
        color: FantasyPalette.parchment,
        fontSize: 17,
        height: 1.45,
      ),
      bodySmall: GoogleFonts.crimsonText(
        color: FantasyPalette.mist,
        fontSize: 14,
        height: 1.35,
      ),
      labelLarge: GoogleFonts.cinzel(
        color: FantasyPalette.parchment,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.9,
      ),
      labelMedium: GoogleFonts.cinzel(
        color: FantasyPalette.bronze,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: FantasyPalette.parchment,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.cinzelDecorative(
        color: FantasyPalette.parchment,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardThemeData(
      color: FantasyPalette.card.withValues(alpha: 0.92),
      margin: EdgeInsets.zero,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: FantasyPalette.bronze.withValues(alpha: 0.28),
          width: 1.1,
        ),
      ),
    ),
    dividerColor: FantasyPalette.outline.withValues(alpha: 0.45),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: FantasyPalette.parchment.withValues(alpha: 0.06),
      hintStyle: GoogleFonts.crimsonText(
        color: FantasyPalette.mist.withValues(alpha: 0.82),
        fontSize: 16,
      ),
      labelStyle: GoogleFonts.cinzel(
        color: FantasyPalette.parchmentDeep,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: FantasyPalette.outline.withValues(alpha: 0.55),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        borderSide: BorderSide(
          color: FantasyPalette.bronze,
          width: 1.4,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: FantasyPalette.bronze,
      circularTrackColor: FantasyPalette.cardSoft,
      linearTrackColor: FantasyPalette.cardSoft,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return FantasyPalette.parchment;
        }
        return FantasyPalette.mist;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return FantasyPalette.emberBright;
        }
        return FantasyPalette.outline.withValues(alpha: 0.6);
      }),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: FantasyPalette.emberBright,
        foregroundColor: FantasyPalette.parchment,
        disabledBackgroundColor: FantasyPalette.cardSoft,
        disabledForegroundColor: FantasyPalette.mist,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: GoogleFonts.cinzel(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.9,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: FantasyPalette.parchment,
        side: BorderSide(
          color: FantasyPalette.bronze.withValues(alpha: 0.6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: GoogleFonts.cinzel(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: FantasyPalette.cardSoft,
      contentTextStyle: GoogleFonts.crimsonText(
        color: FantasyPalette.parchment,
        fontSize: 16,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}
