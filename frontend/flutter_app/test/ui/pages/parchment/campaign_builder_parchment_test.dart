import 'package:animations/animations.dart';
import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/ui/pages/parchment/campaign_builder_parchment.dart';
import 'package:campaign_creator_flutter/src/ui/pages/design/campaign_builder_atmosphere.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parsePromptChapters', () {
    test('splits prompt into chapters using markdown headings', () {
      const prompt = '''
# Premessa
La compagnia arriva a Vallaki.

## Minaccia
Strahd osserva da lontano.
''';

      final chapters = parsePromptChapters(prompt);

      expect(chapters, hasLength(2));
      expect(chapters[0].index, 1);
      expect(chapters[0].title, 'Premessa');
      expect(chapters[0].body, 'La compagnia arriva a Vallaki.');
      expect(chapters[1].title, 'Minaccia');
      expect(chapters[1].body, 'Strahd osserva da lontano.');
    });

    test('uses fallback chapter titles for prose-only prompts', () {
      const prompt = '''
Il party viene assoldato da un mercante disperato.

Le strade della citta si chiudono al tramonto.
''';

      final chapters = parsePromptChapters(prompt);

      expect(chapters, hasLength(2));
      expect(chapters[0].title, 'Invocazione');
      expect(chapters[0].body, contains('mercante disperato'));
      expect(chapters[1].title, 'Premessa');
      expect(chapters[1].body, contains('tramonto'));
    });

    test('normalizes colon headings and trims previews', () {
      final prompt = '''
Obiettivo:
${List.filled(40, 'testo').join(' ')}
''';

      final chapters = parsePromptChapters(prompt);

      expect(chapters, hasLength(1));
      expect(chapters.single.title, 'Obiettivo');
      expect(chapters.single.preview.length, lessThanOrEqualTo(144));
      expect(chapters.single.preview, endsWith('...'));
    });

    test('returns no chapters for blank input', () {
      expect(parsePromptChapters(' \n\t '), isEmpty);
    });

    test('preserves icon data for rendered chapters', () {
      const prompt = '''
# Atto I
Ingresso nel dungeon.
''';

      final chapters = parsePromptChapters(prompt);

      expect(chapters.single.icon, Icons.auto_awesome_rounded);
    });
  });

  group('ForgedParchmentSuccessSheet', () {
    testWidgets('shows success state without rendering prompt content', (
      tester,
    ) async {
      await tester.pumpWidget(
        _localizedParchmentApp(
          child: ForgedParchmentSuccessSheet(
            atmosphere: const CampaignAtmosphereData(
              id: 'test',
              label: 'Test',
              primary: Color(0xFFC2482D),
              secondary: Color(0xFFF0A35B),
              highlight: Color(0xFFF5E6C9),
              cardTint: Color(0xFF4C1E17),
              linework: Color(0xFF8A3A28),
              glow: Color(0xFFE46B3C),
              backdropVariant: CampaignBackdropVariant.emberRush,
              routeTransitionType: SharedAxisTransitionType.horizontal,
              sectionTransitionType: SharedAxisTransitionType.horizontal,
              routeTransitionDuration: Duration(milliseconds: 420),
              reverseRouteTransitionDuration: Duration(milliseconds: 320),
              sectionTransitionDuration: Duration(milliseconds: 260),
              revealDuration: Duration(milliseconds: 520),
              revealDistance: 30,
              cardHoverLift: 14,
              cardHoverTilt: 0.095,
              chipFlashDuration: Duration(milliseconds: 300),
              ctaPulseDuration: Duration(milliseconds: 1300),
              parchmentUnfoldDuration: Duration(milliseconds: 620),
              parchmentUnfoldCurve: Curves.easeOutCubic,
            ),
            isStale: false,
            onSealTap: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Prompt copiato'), findsWidgets);
      expect(find.text('Capitoli in evidenza'), findsNothing);
      expect(find.text('Pergamena del Cronista'), findsNothing);
    });

    testWidgets('renders inside a scroll view without flex constraint errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        _localizedParchmentApp(
          child: SingleChildScrollView(
            child: ForgedParchmentSuccessSheet(
              atmosphere: const CampaignAtmosphereData(
                id: 'test',
                label: 'Test',
                primary: Color(0xFFC2482D),
                secondary: Color(0xFFF0A35B),
                highlight: Color(0xFFF5E6C9),
                cardTint: Color(0xFF4C1E17),
                linework: Color(0xFF8A3A28),
                glow: Color(0xFFE46B3C),
                backdropVariant: CampaignBackdropVariant.emberRush,
                routeTransitionType: SharedAxisTransitionType.horizontal,
                sectionTransitionType: SharedAxisTransitionType.horizontal,
                routeTransitionDuration: Duration(milliseconds: 420),
                reverseRouteTransitionDuration: Duration(milliseconds: 320),
                sectionTransitionDuration: Duration(milliseconds: 260),
                revealDuration: Duration(milliseconds: 520),
                revealDistance: 30,
                cardHoverLift: 14,
                cardHoverTilt: 0.095,
                chipFlashDuration: Duration(milliseconds: 300),
                ctaPulseDuration: Duration(milliseconds: 1300),
                parchmentUnfoldDuration: Duration(milliseconds: 620),
                parchmentUnfoldCurve: Curves.easeOutCubic,
              ),
              isStale: true,
              onSealTap: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Prompt copiato'), findsWidgets);
    });
  });
}

Widget _localizedParchmentApp({required Widget child}) {
  return MaterialApp(
    locale: const Locale('it'),
    localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}
