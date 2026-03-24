import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/fantasy_theme.dart';

enum CampaignBackdropVariant {
  emberRush,
  wayfinderAtlas,
  sagaAtlas,
  torchVault,
}

class CampaignAtmosphereData {
  const CampaignAtmosphereData({
    required this.id,
    required this.label,
    required this.primary,
    required this.secondary,
    required this.highlight,
    required this.cardTint,
    required this.linework,
    required this.glow,
    required this.backdropVariant,
    required this.routeTransitionType,
    required this.sectionTransitionType,
    required this.routeTransitionDuration,
    required this.reverseRouteTransitionDuration,
    required this.sectionTransitionDuration,
    required this.revealDuration,
    required this.revealDistance,
    required this.cardHoverLift,
    required this.cardHoverTilt,
    required this.chipFlashDuration,
    required this.ctaPulseDuration,
    required this.parchmentUnfoldDuration,
    required this.parchmentUnfoldCurve,
  });

  final String id;
  final String label;
  final Color primary;
  final Color secondary;
  final Color highlight;
  final Color cardTint;
  final Color linework;
  final Color glow;
  final CampaignBackdropVariant backdropVariant;
  final SharedAxisTransitionType routeTransitionType;
  final SharedAxisTransitionType sectionTransitionType;
  final Duration routeTransitionDuration;
  final Duration reverseRouteTransitionDuration;
  final Duration sectionTransitionDuration;
  final Duration revealDuration;
  final double revealDistance;
  final double cardHoverLift;
  final double cardHoverTilt;
  final Duration chipFlashDuration;
  final Duration ctaPulseDuration;
  final Duration parchmentUnfoldDuration;
  final Curve parchmentUnfoldCurve;
}

ThemeData buildCampaignAtmosphereTheme(
  ThemeData baseTheme,
  CampaignAtmosphereData atmosphere,
) {
  final palette = baseTheme.fantasy;
  final isDark = baseTheme.brightness == Brightness.dark;
  final colorScheme = baseTheme.colorScheme.copyWith(
    primary: atmosphere.primary,
    secondary: atmosphere.secondary,
    outline: atmosphere.linework,
    outlineVariant: Color.lerp(
      atmosphere.linework,
      palette.foregroundMuted,
      0.45,
    ),
    primaryContainer: Color.lerp(
      palette.cardSoft,
      atmosphere.cardTint,
      0.68,
    ),
    secondaryContainer: Color.lerp(
      palette.card,
      atmosphere.glow,
      0.34,
    ),
    tertiary: atmosphere.highlight,
    tertiaryContainer: Color.lerp(
      palette.cardSoft,
      atmosphere.highlight,
      0.16,
    ),
    surfaceContainerHighest: Color.lerp(
      palette.cardSoft,
      atmosphere.cardTint,
      0.44,
    ),
    onSurfaceVariant: Color.lerp(
      palette.foregroundMuted,
      atmosphere.highlight,
      0.24,
    ),
    surfaceTint: Colors.transparent,
  );

  return baseTheme.copyWith(
    colorScheme: colorScheme,
    cardTheme: CardThemeData(
      color: Color.lerp(
        palette.card,
        atmosphere.cardTint,
        0.14,
      )?.withValues(alpha: 0.95),
      margin: EdgeInsets.zero,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: atmosphere.primary.withValues(alpha: 0.26),
          width: 1.1,
        ),
      ),
    ),
    dividerColor: atmosphere.linework.withValues(alpha: 0.42),
    inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
      fillColor: Color.lerp(
        isDark ? palette.paper : palette.cardSoft,
        atmosphere.cardTint,
        isDark ? 0.16 : 0.08,
      )?.withValues(alpha: 0.12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: atmosphere.linework.withValues(alpha: 0.62),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: atmosphere.primary,
          width: 1.4,
        ),
      ),
      labelStyle: GoogleFonts.cinzel(
        color: Color.lerp(
          isDark ? palette.paperDeep : palette.foregroundMuted,
          atmosphere.highlight,
          0.28,
        ),
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
      hintStyle: GoogleFonts.crimsonText(
        color: Color.lerp(
          palette.foregroundMuted,
          atmosphere.highlight,
          0.16,
        )?.withValues(alpha: 0.84),
        fontSize: 16,
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: atmosphere.primary,
      circularTrackColor: colorScheme.surfaceContainerHighest,
      linearTrackColor: colorScheme.surfaceContainerHighest,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return atmosphere.highlight;
        }
        return palette.foregroundMuted;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return atmosphere.primary;
        }
        return atmosphere.linework.withValues(alpha: 0.62);
      }),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: atmosphere.primary,
        foregroundColor: palette.onArtwork,
        disabledBackgroundColor: colorScheme.surfaceContainerHighest,
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
        foregroundColor: isDark ? palette.onArtwork : palette.foreground,
        side: BorderSide(
          color: atmosphere.primary.withValues(alpha: 0.62),
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
    snackBarTheme: baseTheme.snackBarTheme.copyWith(
      backgroundColor: Color.lerp(
        palette.cardSoft,
        atmosphere.cardTint,
        0.22,
      ),
    ),
  );
}
