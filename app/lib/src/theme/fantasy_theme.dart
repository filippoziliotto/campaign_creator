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

  static const dawn = Color(0xFFF7F1E2);
  static const dawnDeep = Color(0xFFEEE0C6);
  static const ivory = Color(0xFFFFFBF2);
  static const ivorySoft = Color(0xFFF3E8D4);
  static const cedar = Color(0xFF6D5945);
  static const outlineLight = Color(0xFFAC8E68);

  static const stoneLight = Color(0xFFEEE8DC);
  static const stoneMid = Color(0xFFE2D9CC);
  static const paper = Color(0xFFFDFAF6);
  static const paperSoft = Color(0xFFF5EDE0);
  static const inkDeep = Color(0xFF1C0F08);
  static const cedarDeep = Color(0xFF5A4232);
  static const goldBorder = Color(0xFF8C6B42);
}

@immutable
class FantasyThemeColors extends ThemeExtension<FantasyThemeColors> {
  const FantasyThemeColors({
    required this.canvas,
    required this.canvasAlt,
    required this.card,
    required this.cardSoft,
    required this.foreground,
    required this.foregroundMuted,
    required this.outline,
    required this.accent,
    required this.accentStrong,
    required this.onAccent,
    required this.onArtwork,
    required this.onArtworkMuted,
    required this.paper,
    required this.paperDeep,
    required this.paperInk,
  });

  final Color canvas;
  final Color canvasAlt;
  final Color card;
  final Color cardSoft;
  final Color foreground;
  final Color foregroundMuted;
  final Color outline;
  final Color accent;
  final Color accentStrong;
  final Color onAccent;
  final Color onArtwork;
  final Color onArtworkMuted;
  final Color paper;
  final Color paperDeep;
  final Color paperInk;

  static const FantasyThemeColors dark = FantasyThemeColors(
    canvas: FantasyPalette.abyss,
    canvasAlt: FantasyPalette.shadow,
    card: FantasyPalette.card,
    cardSoft: FantasyPalette.cardSoft,
    foreground: FantasyPalette.parchment,
    foregroundMuted: FantasyPalette.mist,
    outline: FantasyPalette.outline,
    accent: FantasyPalette.bronze,
    accentStrong: FantasyPalette.emberBright,
    onAccent: FantasyPalette.ink,
    onArtwork: FantasyPalette.parchment,
    onArtworkMuted: Color(0xE0F4E7C8),
    paper: FantasyPalette.parchment,
    paperDeep: FantasyPalette.parchmentDeep,
    paperInk: FantasyPalette.ink,
  );

  static const FantasyThemeColors light = FantasyThemeColors(
    canvas: FantasyPalette.stoneLight,
    canvasAlt: FantasyPalette.stoneMid,
    card: FantasyPalette.paper,
    cardSoft: FantasyPalette.paperSoft,
    foreground: FantasyPalette.inkDeep,
    foregroundMuted: FantasyPalette.cedarDeep,
    outline: FantasyPalette.goldBorder,
    accent: FantasyPalette.bronze,
    accentStrong: FantasyPalette.emberBright,
    onAccent: FantasyPalette.ink,
    onArtwork: FantasyPalette.parchment,
    onArtworkMuted: Color(0xE0F4E7C8),
    paper: FantasyPalette.parchment,
    paperDeep: FantasyPalette.parchmentDeep,
    paperInk: FantasyPalette.ink,
  );

  @override
  FantasyThemeColors copyWith({
    Color? canvas,
    Color? canvasAlt,
    Color? card,
    Color? cardSoft,
    Color? foreground,
    Color? foregroundMuted,
    Color? outline,
    Color? accent,
    Color? accentStrong,
    Color? onAccent,
    Color? onArtwork,
    Color? onArtworkMuted,
    Color? paper,
    Color? paperDeep,
    Color? paperInk,
  }) {
    return FantasyThemeColors(
      canvas: canvas ?? this.canvas,
      canvasAlt: canvasAlt ?? this.canvasAlt,
      card: card ?? this.card,
      cardSoft: cardSoft ?? this.cardSoft,
      foreground: foreground ?? this.foreground,
      foregroundMuted: foregroundMuted ?? this.foregroundMuted,
      outline: outline ?? this.outline,
      accent: accent ?? this.accent,
      accentStrong: accentStrong ?? this.accentStrong,
      onAccent: onAccent ?? this.onAccent,
      onArtwork: onArtwork ?? this.onArtwork,
      onArtworkMuted: onArtworkMuted ?? this.onArtworkMuted,
      paper: paper ?? this.paper,
      paperDeep: paperDeep ?? this.paperDeep,
      paperInk: paperInk ?? this.paperInk,
    );
  }

  @override
  FantasyThemeColors lerp(
    covariant ThemeExtension<FantasyThemeColors>? other,
    double t,
  ) {
    if (other is! FantasyThemeColors) {
      return this;
    }

    return FantasyThemeColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      canvasAlt: Color.lerp(canvasAlt, other.canvasAlt, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardSoft: Color.lerp(cardSoft, other.cardSoft, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      foregroundMuted: Color.lerp(foregroundMuted, other.foregroundMuted, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentStrong: Color.lerp(accentStrong, other.accentStrong, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      onArtwork: Color.lerp(onArtwork, other.onArtwork, t)!,
      onArtworkMuted: Color.lerp(onArtworkMuted, other.onArtworkMuted, t)!,
      paper: Color.lerp(paper, other.paper, t)!,
      paperDeep: Color.lerp(paperDeep, other.paperDeep, t)!,
      paperInk: Color.lerp(paperInk, other.paperInk, t)!,
    );
  }
}

extension FantasyThemeDataX on ThemeData {
  FantasyThemeColors get fantasy =>
      extension<FantasyThemeColors>() ?? FantasyThemeColors.dark;
}

extension FantasyBuildContextX on BuildContext {
  FantasyThemeColors get fantasy => Theme.of(this).fantasy;
}

ThemeData buildFantasyTheme() => _buildFantasyThemeData(
      brightness: Brightness.dark,
      palette: FantasyThemeColors.dark,
    );

ThemeData buildFantasyLightTheme() => _buildFantasyThemeData(
      brightness: Brightness.light,
      palette: FantasyThemeColors.light,
    );

ThemeData _buildFantasyThemeData({
  required Brightness brightness,
  required FantasyThemeColors palette,
}) {
  final isDark = brightness == Brightness.dark;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: palette.accentStrong,
    brightness: brightness,
  ).copyWith(
    primary: palette.accent,
    onPrimary: palette.onAccent,
    secondary: palette.accentStrong,
    onSecondary: palette.onArtwork,
    surface: palette.card,
    onSurface: palette.foreground,
    outline: palette.outline,
    outlineVariant: palette.foregroundMuted,
    primaryContainer: isDark ? FantasyPalette.ember : FantasyPalette.dawnDeep,
    onPrimaryContainer: palette.foreground,
    secondaryContainer: isDark ? FantasyPalette.moss : FantasyPalette.ivorySoft,
    onSecondaryContainer: palette.foreground,
    tertiary: palette.paperDeep,
    onTertiary: palette.paperInk,
    tertiaryContainer: palette.cardSoft,
    onTertiaryContainer: palette.foreground,
    error: const Color(0xFFE67E6A),
    onError: palette.paperInk,
    errorContainer: isDark ? const Color(0xFF5F241D) : const Color(0xFFF6D0C8),
    onErrorContainer:
        isDark ? const Color(0xFFFFD8D0) : const Color(0xFF5F241D),
    surfaceContainerHighest: palette.cardSoft,
    onSurfaceVariant: palette.foregroundMuted,
    surfaceTint: Colors.transparent,
    inverseSurface: palette.paper,
    onInverseSurface: palette.paperInk,
    inversePrimary: palette.accentStrong,
    scrim: Colors.black,
  );

  final baseTextTheme = GoogleFonts.crimsonTextTextTheme(
    ThemeData(brightness: brightness).textTheme,
  ).apply(
    bodyColor: palette.foreground,
    displayColor: palette.foreground,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: palette.canvas,
    extensions: <ThemeExtension<dynamic>>[palette],
    textTheme: baseTextTheme.copyWith(
      displayLarge: GoogleFonts.cinzelDecorative(
        color: palette.foreground,
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
      displayMedium: GoogleFonts.cinzelDecorative(
        color: palette.foreground,
        fontSize: 30,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
      headlineLarge: GoogleFonts.cinzel(
        color: palette.foreground,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.9,
      ),
      headlineMedium: GoogleFonts.cinzel(
        color: palette.foreground,
        fontSize: 23,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
      ),
      titleLarge: GoogleFonts.cinzel(
        color: palette.foreground,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
      ),
      titleMedium: GoogleFonts.cinzel(
        color: isDark ? palette.paperDeep : palette.foreground,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
      ),
      titleSmall: GoogleFonts.cinzel(
        color: palette.accent,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
      bodyLarge: GoogleFonts.crimsonText(
        color: palette.foreground,
        fontSize: 20,
        height: 1.45,
      ),
      bodyMedium: GoogleFonts.crimsonText(
        color: palette.foreground,
        fontSize: 17,
        height: 1.45,
      ),
      bodySmall: GoogleFonts.crimsonText(
        color: palette.foregroundMuted,
        fontSize: 14,
        height: 1.35,
      ),
      labelLarge: GoogleFonts.cinzel(
        color: palette.foreground,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.9,
      ),
      labelMedium: GoogleFonts.cinzel(
        color: palette.accent,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
      labelSmall: GoogleFonts.cinzel(
        color: palette.foregroundMuted,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.9,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: palette.foreground,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.cinzelDecorative(
        color: palette.foreground,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardThemeData(
      color: palette.card.withValues(alpha: isDark ? 0.92 : 0.96),
      margin: EdgeInsets.zero,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: palette.accent.withValues(alpha: isDark ? 0.28 : 0.22),
          width: 1.1,
        ),
      ),
    ),
    dividerColor: palette.outline.withValues(alpha: 0.45),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark
          ? palette.paper.withValues(alpha: 0.06)
          : palette.canvasAlt.withValues(alpha: 0.56),
      hintStyle: GoogleFonts.crimsonText(
        color: palette.foregroundMuted.withValues(alpha: 0.82),
        fontSize: 16,
      ),
      labelStyle: GoogleFonts.cinzel(
        color: isDark ? palette.paperDeep : palette.foregroundMuted,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: palette.outline.withValues(alpha: 0.55),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        borderSide: BorderSide(
          color: palette.accent,
          width: 1.4,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: palette.accent,
      circularTrackColor: palette.cardSoft,
      linearTrackColor: palette.cardSoft,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return palette.paper;
        }
        return palette.foregroundMuted;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return palette.accentStrong;
        }
        return palette.outline.withValues(alpha: 0.6);
      }),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: palette.accentStrong,
        foregroundColor: palette.onArtwork,
        disabledBackgroundColor: palette.cardSoft,
        disabledForegroundColor: palette.foregroundMuted,
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
        foregroundColor: palette.foreground,
        side: BorderSide(
          color: palette.accent.withValues(alpha: 0.6),
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
      backgroundColor: palette.cardSoft,
      contentTextStyle: GoogleFonts.crimsonText(
        color: palette.foreground,
        fontSize: 16,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}
