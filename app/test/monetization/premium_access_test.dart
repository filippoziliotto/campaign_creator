import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/monetization/premium_access.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final (locale, title, watchAdLabel, unlockLabel) in <(
    Locale,
    String,
    String,
    String,
  )>[
    (
      const Locale('en'),
      'Premium feature',
      'Watch ad (5 min)',
      'Unlock Premium',
    ),
    (
      const Locale('it'),
      'Funzionalità premium',
      'Guarda un annuncio (5 min)',
      'Sblocca Premium',
    ),
    (
      const Locale('es'),
      'Función premium',
      'Ver anuncio (5 min)',
      'Desbloquear Premium',
    ),
    (
      const Locale('fr'),
      'Fonction premium',
      'Regarder une pub (5 min)',
      'Débloquer Premium',
    ),
    (
      const Locale('de'),
      'Premium-Funktion',
      'Werbung ansehen (5 Min.)',
      'Premium Freischalten',
    ),
    (
      const Locale('pt'),
      'Funcionalidade premium',
      'Ver anúncio (5 min)',
      'Desbloquear Premium',
    ),
  ]) {
    testWidgets(
      'premium unlock prompt localizes copy for ${locale.languageCode}',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: PremiumUnlockPrompt(
                highlightColor: const Color(0xFFFFD54F),
                onWatchAd: () {},
                onGoAdFree: () {},
              ),
            ),
          ),
        );

        await tester.pump();

        expect(find.text(title), findsOneWidget);
        expect(find.text(watchAdLabel), findsOneWidget);
        expect(find.text(unlockLabel), findsOneWidget);
      },
    );
  }
}
