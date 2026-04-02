import 'dart:async';

import 'package:campaign_creator_flutter/src/app.dart';
import 'package:campaign_creator_flutter/src/l10n_extension.dart';
import 'package:campaign_creator_flutter/src/monetization/app_consent_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets(
      'CampaignCreatorApp follows a supported device locale on first launch', (
    tester,
  ) async {
    tester.binding.platformDispatcher.localesTestValue = const <Locale>[
      Locale('it'),
    ];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(
      CampaignCreatorApp(
        homeBuilder: (_, onLocaleChanged, themeMode, onThemeModeChanged) =>
            _AppProbe(
          onLocaleChanged: onLocaleChanged,
          themeMode: themeMode,
          onThemeModeChanged: onThemeModeChanged,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Creatore Campagne D&D'), findsOneWidget);
    expect(find.text('locale:it'), findsOneWidget);
    expect(find.text('theme:dark'), findsOneWidget);
    expect(find.text('IT | EN | ES | FR | DE | PT | PL | JP | KR'),
        findsOneWidget);
    expect(find.text('free-format:Scegli formato'), findsOneWidget);
    expect(find.text('seal:Forgia pergamena'), findsOneWidget);
    expect(
        find.text('entry-description:Formato campagna pronto sul dispositivo.'),
        findsOneWidget);
  });

  testWidgets(
      'CampaignCreatorApp falls back to English for unsupported device locale',
      (
    tester,
  ) async {
    tester.binding.platformDispatcher.localesTestValue = const <Locale>[
      Locale('ru'),
    ];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(
      CampaignCreatorApp(
        homeBuilder: (_, onLocaleChanged, themeMode, onThemeModeChanged) =>
            _AppProbe(
          onLocaleChanged: onLocaleChanged,
          themeMode: themeMode,
          onThemeModeChanged: onThemeModeChanged,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('D&D Campaign Creator'), findsOneWidget);
    expect(find.text('locale:en'), findsOneWidget);
    expect(find.text('theme:dark'), findsOneWidget);
    expect(find.text('free-format:Choose format'), findsOneWidget);
    expect(find.text('seal:Seal parchment'), findsOneWidget);
    expect(find.text('entry-description:Campaign format ready on device.'),
        findsOneWidget);
  });

  testWidgets(
      'CampaignCreatorApp follows supported Spanish, French, German, Portuguese, Polish, Japanese, and Korean device locales on first launch',
      (tester) async {
    Future<void> pumpForLocale(Locale locale) async {
      tester.binding.platformDispatcher.localesTestValue = <Locale>[locale];
      addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        CampaignCreatorApp(
          key: ValueKey<String>('app-${locale.languageCode}'),
          homeBuilder: (_, onLocaleChanged, themeMode, onThemeModeChanged) =>
              _AppProbe(
            onLocaleChanged: onLocaleChanged,
            themeMode: themeMode,
            onThemeModeChanged: onThemeModeChanged,
          ),
        ),
      );

      await tester.pumpAndSettle();
    }

    await pumpForLocale(const Locale('es'));
    expect(find.text('locale:es'), findsOneWidget);
    expect(find.text('Creador de Campañas D&D'), findsOneWidget);
    expect(find.text('free-format:Elige formato'), findsOneWidget);
    expect(find.text('seal:Sellar pergamino'), findsOneWidget);
    expect(find.text('entry-description:Formato de campaña listo en el dispositivo.'),
        findsOneWidget);
    expect(find.text('IT | EN | ES | FR | DE | PT | PL | JP | KR'),
        findsOneWidget);

    await pumpForLocale(const Locale('fr'));
    expect(find.text('locale:fr'), findsOneWidget);
    expect(find.text('Créateur de campagnes D&D'), findsOneWidget);
    expect(find.text('free-format:Choisir le format'), findsOneWidget);
    expect(find.text('seal:Sceller le parchemin'), findsOneWidget);
    expect(find.text('entry-description:Format de campagne prêt sur l’appareil.'),
        findsOneWidget);
    expect(find.text('IT | EN | ES | FR | DE | PT | PL | JP | KR'),
        findsOneWidget);

    await pumpForLocale(const Locale('de'));
    expect(find.text('locale:de'), findsOneWidget);
    expect(find.text('D&D Kampagnenersteller'), findsOneWidget);
    expect(find.text('free-format:Format wählen'), findsOneWidget);
    expect(find.text('seal:Pergament versiegeln'), findsOneWidget);
    expect(
      find.text('entry-description:Kampagnenformat direkt auf dem Gerät bereit.'),
      findsOneWidget,
    );
    expect(find.text('IT | EN | ES | FR | DE | PT | PL | JP | KR'),
        findsOneWidget);

    await pumpForLocale(const Locale('pt'));
    expect(find.text('locale:pt'), findsOneWidget);
    expect(find.text('Criador de Campanhas D&D'), findsOneWidget);
    expect(find.text('free-format:Escolher formato'), findsOneWidget);
    expect(find.text('seal:Selar pergaminho'), findsOneWidget);
    expect(find.text('entry-description:Formato de campanha pronto no dispositivo.'),
        findsOneWidget);
    expect(find.text('IT | EN | ES | FR | DE | PT | PL | JP | KR'),
        findsOneWidget);

    await pumpForLocale(const Locale('pl'));
    expect(find.text('locale:pl'), findsOneWidget);
    expect(find.text('Kreator Kampanii D&D'), findsOneWidget);
    expect(find.text('free-format:Wybierz format'), findsOneWidget);
    expect(find.text('seal:Zapieczętuj pergamin'), findsOneWidget);
    expect(find.text('entry-description:Format kampanii gotowy na urządzeniu.'),
        findsOneWidget);
    expect(find.text('IT | EN | ES | FR | DE | PT | PL | JP | KR'),
        findsOneWidget);

    await pumpForLocale(const Locale('ja'));
    expect(find.text('locale:ja'), findsOneWidget);
    expect(find.text('D&Dキャンペーンクリエイター'), findsOneWidget);
    expect(find.text('free-format:形式を選択'), findsOneWidget);
    expect(find.text('seal:羊皮紙を封印'), findsOneWidget);
    expect(find.text('entry-description:キャンペーン形式は端末上で準備完了です。'),
        findsOneWidget);
    expect(find.text('IT | EN | ES | FR | DE | PT | PL | JP | KR'),
        findsOneWidget);

    await pumpForLocale(const Locale('ko'));
    expect(find.text('locale:ko'), findsOneWidget);
    expect(find.text('D&D 캠페인 크리에이터'), findsOneWidget);
    expect(find.text('free-format:형식 선택'), findsOneWidget);
    expect(find.text('seal:양피지 봉인'), findsOneWidget);
    expect(find.text('entry-description:캠페인 형식이 기기에 준비되었습니다.'),
        findsOneWidget);
    expect(find.text('IT | EN | ES | FR | DE | PT | PL | JP | KR'),
        findsOneWidget);
  });

  testWidgets('CampaignCreatorApp switches locale at runtime without restart', (
    tester,
  ) async {
    await tester.pumpWidget(
      CampaignCreatorApp(
        homeBuilder: (_, onLocaleChanged, themeMode, onThemeModeChanged) =>
            _AppProbe(
          onLocaleChanged: onLocaleChanged,
          themeMode: themeMode,
          onThemeModeChanged: onThemeModeChanged,
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('switch-en')));
    await tester.pumpAndSettle();

    expect(find.text('D&D Campaign Creator'), findsOneWidget);
    expect(find.text('locale:en'), findsOneWidget);
    expect(find.text('theme:dark'), findsOneWidget);
    expect(find.text('free-format:Choose format'), findsOneWidget);
    expect(find.text('seal:Seal parchment'), findsOneWidget);
    expect(find.text('entry-description:Campaign format ready on device.'),
        findsOneWidget);

    await tester.tap(find.byKey(const Key('switch-es')));
    await tester.pumpAndSettle();

    expect(find.text('Creador de Campañas D&D'), findsOneWidget);
    expect(find.text('locale:es'), findsOneWidget);
    expect(find.text('free-format:Elige formato'), findsOneWidget);

    await tester.tap(find.byKey(const Key('switch-fr')));
    await tester.pumpAndSettle();

    expect(find.text('Créateur de campagnes D&D'), findsOneWidget);
    expect(find.text('locale:fr'), findsOneWidget);
    expect(find.text('free-format:Choisir le format'), findsOneWidget);

    await tester.tap(find.byKey(const Key('switch-de')));
    await tester.pumpAndSettle();

    expect(find.text('D&D Kampagnenersteller'), findsOneWidget);
    expect(find.text('locale:de'), findsOneWidget);
    expect(find.text('free-format:Format wählen'), findsOneWidget);

    await tester.tap(find.byKey(const Key('switch-pt')));
    await tester.pumpAndSettle();

    expect(find.text('Criador de Campanhas D&D'), findsOneWidget);
    expect(find.text('locale:pt'), findsOneWidget);
    expect(find.text('free-format:Escolher formato'), findsOneWidget);

    await tester.tap(find.byKey(const Key('switch-pl')));
    await tester.pumpAndSettle();

    expect(find.text('Kreator Kampanii D&D'), findsOneWidget);
    expect(find.text('locale:pl'), findsOneWidget);
    expect(find.text('free-format:Wybierz format'), findsOneWidget);

    await tester.tap(find.byKey(const Key('switch-ja')));
    await tester.pumpAndSettle();

    expect(find.text('D&Dキャンペーンクリエイター'), findsOneWidget);
    expect(find.text('locale:ja'), findsOneWidget);
    expect(find.text('free-format:形式を選択'), findsOneWidget);

    await tester.tap(find.byKey(const Key('switch-ko')));
    await tester.pumpAndSettle();

    expect(find.text('D&D 캠페인 크리에이터'), findsOneWidget);
    expect(find.text('locale:ko'), findsOneWidget);
    expect(find.text('free-format:형식 선택'), findsOneWidget);
  });

  testWidgets('CampaignCreatorApp restores the saved locale on startup', (
    tester,
  ) async {
    tester.binding.platformDispatcher.localesTestValue = const <Locale>[
      Locale('it'),
    ];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    SharedPreferences.setMockInitialValues(<String, Object>{
      'app.locale_code': 'en',
    });

    await tester.pumpWidget(
      CampaignCreatorApp(
        homeBuilder: (_, onLocaleChanged, themeMode, onThemeModeChanged) =>
            _AppProbe(
          onLocaleChanged: onLocaleChanged,
          themeMode: themeMode,
          onThemeModeChanged: onThemeModeChanged,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('D&D Campaign Creator'), findsOneWidget);
    expect(find.text('locale:en'), findsOneWidget);
    expect(find.text('theme:dark'), findsOneWidget);
    expect(find.text('free-format:Choose format'), findsOneWidget);
    expect(find.text('seal:Seal parchment'), findsOneWidget);
    expect(find.text('entry-description:Campaign format ready on device.'),
        findsOneWidget);
  });

  testWidgets('CampaignCreatorApp defaults to dark theme on first launch', (
    tester,
  ) async {
    await tester.pumpWidget(
      CampaignCreatorApp(
        homeBuilder: (_, onLocaleChanged, themeMode, onThemeModeChanged) =>
            _AppProbe(
          onLocaleChanged: onLocaleChanged,
          themeMode: themeMode,
          onThemeModeChanged: onThemeModeChanged,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('theme:dark'), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });

  testWidgets('CampaignCreatorApp restores the saved theme on startup', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'app.theme_mode': 'light',
    });

    await tester.pumpWidget(
      CampaignCreatorApp(
        homeBuilder: (_, onLocaleChanged, themeMode, onThemeModeChanged) =>
            _AppProbe(
          onLocaleChanged: onLocaleChanged,
          themeMode: themeMode,
          onThemeModeChanged: onThemeModeChanged,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('theme:light'), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
  });

  testWidgets('CampaignCreatorApp switches theme at runtime without restart', (
    tester,
  ) async {
    await tester.pumpWidget(
      CampaignCreatorApp(
        homeBuilder: (_, onLocaleChanged, themeMode, onThemeModeChanged) =>
            _AppProbe(
          onLocaleChanged: onLocaleChanged,
          themeMode: themeMode,
          onThemeModeChanged: onThemeModeChanged,
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('switch-light')));
    await tester.tap(find.byKey(const Key('switch-light')));
    await tester.pumpAndSettle();

    expect(find.text('theme:light'), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
  });

  testWidgets('CampaignCreatorApp renders immediately while consent bootstraps',
      (tester) async {
    final consentManager = _PendingAppConsentManager();

    await tester.pumpWidget(
      CampaignCreatorApp(
        consentManager: consentManager,
        bootstrapConsent: true,
        homeBuilder: (_, onLocaleChanged, themeMode, onThemeModeChanged) =>
            _AppProbe(
          onLocaleChanged: onLocaleChanged,
          themeMode: themeMode,
          onThemeModeChanged: onThemeModeChanged,
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('theme:dark'), findsOneWidget);
  });
}

class _AppProbe extends StatelessWidget {
  const _AppProbe({
    required this.onLocaleChanged,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ValueChanged<Locale> onLocaleChanged;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.l10n.appTitle),
              Text('locale:$localeCode'),
              Text('theme:${themeMode.name}'),
              Text('free-format:${context.l10n.appFreeFormat}'),
              Text('seal:${context.l10n.appSealParchment}'),
              Text('entry-description:${context.l10n.entryDescriptionDefault}'),
              Text(
                '${context.l10n.languageItalianShort} | ${context.l10n.languageEnglishShort} | ${context.l10n.languageSpanishShort} | ${context.l10n.languageFrenchShort} | ${context.l10n.languageGermanShort} | ${context.l10n.languagePortugueseShort} | ${context.l10n.languagePolishShort} | ${context.l10n.languageJapaneseShort} | ${context.l10n.languageKoreanShort}',
              ),
              const SizedBox(height: 12),
              TextButton(
                key: const Key('switch-it'),
                onPressed: () => onLocaleChanged(const Locale('it')),
                child: const Text('IT'),
              ),
              TextButton(
                key: const Key('switch-en'),
                onPressed: () => onLocaleChanged(const Locale('en')),
                child: const Text('EN'),
              ),
              TextButton(
                key: const Key('switch-es'),
                onPressed: () => onLocaleChanged(const Locale('es')),
                child: const Text('ES'),
              ),
              TextButton(
                key: const Key('switch-fr'),
                onPressed: () => onLocaleChanged(const Locale('fr')),
                child: const Text('FR'),
              ),
              TextButton(
                key: const Key('switch-de'),
                onPressed: () => onLocaleChanged(const Locale('de')),
                child: const Text('DE'),
              ),
              TextButton(
                key: const Key('switch-pt'),
                onPressed: () => onLocaleChanged(const Locale('pt')),
                child: const Text('PT'),
              ),
              TextButton(
                key: const Key('switch-pl'),
                onPressed: () => onLocaleChanged(const Locale('pl')),
                child: const Text('PL'),
              ),
              TextButton(
                key: const Key('switch-ja'),
                onPressed: () => onLocaleChanged(const Locale('ja')),
                child: const Text('JP'),
              ),
              TextButton(
                key: const Key('switch-ko'),
                onPressed: () => onLocaleChanged(const Locale('ko')),
                child: const Text('KR'),
              ),
              TextButton(
                key: const Key('switch-dark'),
                onPressed: () => onThemeModeChanged(ThemeMode.dark),
                child: const Text('Dark'),
              ),
              TextButton(
                key: const Key('switch-light'),
                onPressed: () => onThemeModeChanged(ThemeMode.light),
                child: const Text('Light'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PendingAppConsentManager implements AppConsentManager {
  @override
  Future<bool> canRequestAds() async => false;

  @override
  Future<void> gatherConsent() => Completer<void>().future;

  @override
  Future<void> initializeAdsIfAllowed() async {}

  @override
  Future<bool> isPrivacyOptionsRequired() async => false;

  @override
  Future<void> showPrivacyOptionsForm() async {}
}
