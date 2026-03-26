import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/audio/forge_sound_player.dart';
import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:campaign_creator_flutter/src/ui/pages/design/campaign_builder_primitives.dart';
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

  testWidgets('German entry cards use distinct artwork and atmosphere per campaign type', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        locale: const Locale('de'),
        child: CampaignBuilderPage(
          service: FakeCampaignService(_entryOptionsDe()),
          currentLocale: const Locale('de'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final oneShotCard = tester.widget<CampaignModeCard>(
      find.byKey(const ValueKey<String>('entry-campaign-card-One-Shot')),
    );
    final miniCampaignCard = tester.widget<CampaignModeCard>(
      find.byKey(const ValueKey<String>('entry-campaign-card-Mini-Kampagne')),
    );
    final longCampaignCard = tester.widget<CampaignModeCard>(
      find.byKey(const ValueKey<String>('entry-campaign-card-Lange Kampagne')),
    );
    final dungeonCard = tester.widget<CampaignModeCard>(
      find.byKey(
        const ValueKey<String>('entry-campaign-card-Dungeon-Erkundung'),
      ),
    );

    expect(oneShotCard.artAsset, 'assets/entry_cards/one_shot.jpg');
    expect(oneShotCard.atmosphere.id, 'one-shot');

    expect(miniCampaignCard.artAsset, 'assets/entry_cards/campagna_corta.jpg');
    expect(miniCampaignCard.atmosphere.id, 'mini-campaign');

    expect(longCampaignCard.artAsset, 'assets/entry_cards/campagna_lunga.jpg');
    expect(longCampaignCard.atmosphere.id, 'long-campaign');

    expect(dungeonCard.artAsset, 'assets/entry_cards/dungeon.jpg');
    expect(dungeonCard.atmosphere.id, 'dungeon');
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
        matching: find.text('FORGOTTEN REALMS'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: settingField, matching: find.text('EBERRON')),
      findsNothing,
    );
  });

  testWidgets('new session requests its sound immediately on tap', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'campaign_builder.saved_prompt': 'Prompt salvato',
      'campaign_builder.saved_campaign_type': 'One-Shot',
      'campaign_builder.saved_setting': 'Forgotten Realms',
    });
    final soundPlayer = _FakeForgeSoundPlayer();

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(_entryOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
          forgeSoundPlayer: soundPlayer,
        ),
      ),
    );

    await _pumpUi(tester);

    final newSessionButton = find.text('Nuova sessione');
    await tester.ensureVisible(newSessionButton);
    await tester.tap(newSessionButton);
    await tester.pump();

    expect(soundPlayer.newSessionPlayCount, 1);
    expect(soundPlayer.forgePlayCount, 0);

    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
  });

  testWidgets('resume forge requests the forge sound immediately on tap', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'campaign_builder.saved_prompt': 'Prompt salvato',
      'campaign_builder.saved_campaign_type': 'One-Shot',
      'campaign_builder.saved_setting': 'Forgotten Realms',
    });
    final soundPlayer = _FakeForgeSoundPlayer();

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(_entryOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
          forgeSoundPlayer: soundPlayer,
        ),
      ),
    );

    await _pumpUi(tester);

    final resumeButton = find.text('Riprendi la forgia');
    await tester.ensureVisible(resumeButton);
    await tester.tap(resumeButton);
    await tester.pump();

    expect(soundPlayer.forgePlayCount, 1);
    expect(soundPlayer.newSessionPlayCount, 0);
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

  testWidgets('entry cards use Spanish localized descriptions for campaign types', (
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

    expect(
      find.text(
        'Una historia condensada en pocas sesiones, con progresión fuerte, escalada y un final nítido.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Facciones, equilibrios cambiantes y subtramas persistentes para una campaña que crece con el tiempo.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Un descenso estructurado entre mapas, riesgo, desgaste y descubrimientos por capas.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('entry cards use French localized descriptions for campaign types', (
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

    expect(
      find.text(
        'Une histoire condensée en quelques séances, avec une progression forte, une montée en tension et une finale nette.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Factions, équilibres mouvants et intrigues persistantes pour une campagne qui grandit dans la durée.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Une descente structurée entre cartes, risque, attrition et découvertes en couches.',
      ),
      findsOneWidget,
    );
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

CampaignOptions _entryOptionsDe() {
  return CampaignOptions(
    settings: const ['Forgotten Realms'],
    campaignTypes: const [
      'One-Shot',
      'Mini-Kampagne',
      'Lange Kampagne',
      'Dungeon-Erkundung',
    ],
    themes: const ['Intrige'],
    tones: const ['Düster'],
    styles: const ['Cinematisch'],
    partyArchetypes: const ['Tank'],
    twists: const ['Verrat'],
    presets: const {},
    settingDescriptions: const {'Forgotten Realms': 'Klassische High Fantasy.'},
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

class _FakeForgeSoundPlayer implements ForgeSoundPlayer {
  int forgePlayCount = 0;
  int newSessionPlayCount = 0;

  @override
  void dispose() {}

  @override
  Future<void> playForgeSound() async {
    forgePlayCount += 1;
  }

  @override
  Future<void> playNewSessionSound() async {
    newSessionPlayCount += 1;
  }
}

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 800));
}
