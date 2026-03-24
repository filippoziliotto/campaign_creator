import 'package:campaign_creator_flutter/src/theme/fantasy_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('dark and light fantasy themes expose distinct semantic palettes', () {
    final darkTheme = buildFantasyTheme();
    final lightTheme = buildFantasyLightTheme();

    final darkTokens = darkTheme.extension<FantasyThemeColors>();
    final lightTokens = lightTheme.extension<FantasyThemeColors>();

    expect(darkTheme.brightness, Brightness.dark);
    expect(lightTheme.brightness, Brightness.light);
    expect(darkTokens, isNotNull);
    expect(lightTokens, isNotNull);
    expect(
        lightTheme.colorScheme.surface, isNot(darkTheme.colorScheme.surface));
    expect(lightTokens!.card, isNot(darkTokens!.card));
    expect(lightTokens.foreground, isNot(darkTokens.foreground));
  });
}
