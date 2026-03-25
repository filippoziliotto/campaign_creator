import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:campaign_creator_flutter/src/ui/pages/shell/campaign_builder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_campaign_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('entry renders hero above grid and resume panel below it', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'campaign_builder.saved_prompt': 'Prompt salvato',
      'campaign_builder.saved_campaign_type': 'One-Shot',
      'campaign_builder.saved_setting': 'Forgotten Realms',
    });

    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(_entryOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final hero = find.byKey(const ValueKey<String>('entry-hero'));
    final firstCard = find.byKey(
      const ValueKey<String>('entry-campaign-card-One-Shot'),
    );
    final resumeTitle = find.text('Riprendi la sessione');

    expect(hero, findsOneWidget);
    expect(firstCard, findsOneWidget);
    expect(resumeTitle, findsOneWidget);

    final heroRect = tester.getRect(hero);
    final cardRect = tester.getRect(firstCard);
    final resumeRect = tester.getRect(resumeTitle);

    expect(heroRect.bottom, lessThan(cardRect.top));
    expect(cardRect.bottom, lessThan(resumeRect.top));
  });

  testWidgets('entry hero stays static after selecting a campaign type', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(_entryOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final hero = find.byKey(const ValueKey<String>('entry-hero'));

    expect(hero, findsOneWidget);
    expect(
      find.descendant(
        of: hero,
        matching: find.text(
          'Forgia il prompt della tua campagna, poi portalo in vita con la tua AI di fiducia.',
        ),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: hero, matching: find.text('Scegli la tua campagna')),
      findsOneWidget,
    );

    final oneShotCard = find.byKey(
      const ValueKey<String>('entry-campaign-card-One-Shot'),
    );
    await tester.ensureVisible(oneShotCard);
    await tester.tap(oneShotCard);
    await _pumpUi(tester);

    expect(
      find.descendant(
        of: hero,
        matching: find.text('Scegli la tua campagna'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: hero,
        matching: find.text(
          'Forgia il prompt della tua campagna, poi portalo in vita con la tua AI di fiducia.',
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('new session resets forge selections back to defaults', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'campaign_builder.saved_prompt': 'Prompt salvato',
      'campaign_builder.saved_campaign_type': 'One-Shot',
      'campaign_builder.saved_setting': 'Eberron',
    });

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(_entryResetOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final newSessionButton = find.text('Nuova sessione');
    await tester.ensureVisible(newSessionButton);
    await tester.tap(newSessionButton);
    await _pumpUi(tester);

    final oneShotCard = find.byKey(
      const ValueKey<String>('entry-campaign-card-One-Shot'),
    );
    await tester.ensureVisible(oneShotCard);
    await tester.tap(oneShotCard);
    await _pumpUi(tester);

    final settingField =
        find.byKey(const ValueKey<String>('setting-selector-field'));

    expect(settingField, findsOneWidget);

    expect(
      find.descendant(
        of: settingField,
        matching: find.text('Forgotten Realms'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: settingField, matching: find.text('Eberron')),
      findsNothing,
    );
  });

  testWidgets('entry top bar stays stable on narrow mobile widths', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(_entryOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('top-bar-language-switch')),
      findsNothing,
    );
    expect(find.text('Scelta'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('entry hero uses linked oo title treatment in English only', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        locale: const Locale('en'),
        child: CampaignBuilderPage(
          service: FakeCampaignService(_entryOptions()),
          currentLocale: const Locale('en'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    expect(find.byKey(const ValueKey<String>('entry-hero-linked-oo')),
        findsOneWidget);
    expect(find.bySemanticsLabel('Choose your Campaign'), findsOneWidget);
  });

  testWidgets('entry cards use Spanish localized badges for campaign types', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        locale: const Locale('es'),
        child: CampaignBuilderPage(
          service: FakeCampaignService(_entryOptionsEs()),
          currentLocale: const Locale('es'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    expect(find.text('Arco breve'), findsOneWidget);
    expect(find.text('Saga amplia'), findsOneWidget);
    expect(find.text('Profundidades'), findsOneWidget);
    expect(find.text('Formato'), findsNothing);
  });

  testWidgets('entry cards use French localized badges for campaign types', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        locale: const Locale('fr'),
        child: CampaignBuilderPage(
          service: FakeCampaignService(_entryOptionsFr()),
          currentLocale: const Locale('fr'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    expect(find.text('Arc court'), findsOneWidget);
    expect(find.text('Grande saga'), findsOneWidget);
    expect(find.text('Profondeurs'), findsOneWidget);
    expect(find.text('Format'), findsNothing);
  });
}

CampaignOptions _entryOptions() {
  return CampaignOptions(
    settings: const ['Forgotten Realms'],
    campaignTypes: const [
      'One-Shot',
      'Mini-campaign',
      'Long campaign',
      'Dungeon crawl',
    ],
    themes: const ['Intrigo'],
    tones: const ['Epico'],
    styles: const ['Lineare'],
    partyArchetypes: const ['Tank'],
    twists: const ['Tradimento'],
    presets: const {},
    settingDescriptions: const {'Forgotten Realms': 'Classico high fantasy.'},
    presetDescriptions: const {},
    presetNames: const {},
  );
}

CampaignOptions _entryResetOptions() {
  return CampaignOptions(
    settings: const ['Forgotten Realms', 'Eberron'],
    campaignTypes: const [
      'One-Shot',
      'Mini-campaign',
      'Long campaign',
      'Dungeon crawl',
    ],
    themes: const ['Intrigo'],
    tones: const ['Epico'],
    styles: const ['Lineare'],
    partyArchetypes: const ['Tank'],
    twists: const ['Nessun colpo di scena', 'Tradimento'],
    presets: const {},
    settingDescriptions: const {
      'Forgotten Realms': 'Classico high fantasy.',
      'Eberron': 'Metropoli magica e pulp noir.',
    },
    presetDescriptions: const {},
    presetNames: const {},
  );
}

CampaignOptions _entryOptionsEs() {
  return CampaignOptions(
    settings: const ['Forgotten Realms'],
    campaignTypes: const [
      'One-Shot',
      'Mini-campaña',
      'Campaña larga',
      'Exploración de mazmorra',
    ],
    themes: const ['Intriga'],
    tones: const ['Épico'],
    styles: const ['Lineal'],
    partyArchetypes: const ['Tanque'],
    twists: const ['Traición'],
    presets: const {},
    settingDescriptions: const {'Forgotten Realms': 'Alta fantasía clásica.'},
    presetDescriptions: const {},
    presetNames: const {},
  );
}

CampaignOptions _entryOptionsFr() {
  return CampaignOptions(
    settings: const ['Forgotten Realms'],
    campaignTypes: const [
      'One-Shot',
      'Mini-campagne',
      'Longue campagne',
      'Exploration de donjon',
    ],
    themes: const ['Intrigue'],
    tones: const ['Épique'],
    styles: const ['Linéaire'],
    partyArchetypes: const ['Tank'],
    twists: const ['Trahison'],
    presets: const {},
    settingDescriptions: const {'Forgotten Realms': 'High fantasy classique.'},
    presetDescriptions: const {},
    presetNames: const {},
  );
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child, this.locale = const Locale('it')});

  final Widget child;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        final data = MediaQuery.of(context).copyWith(disableAnimations: true);
        return MediaQuery(data: data, child: child!);
      },
      home: child,
    );
  }
}

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 800));
}
