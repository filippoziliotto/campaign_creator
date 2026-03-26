import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:campaign_creator_flutter/src/ui/pages/design/campaign_builder_primitives.dart';
import 'package:campaign_creator_flutter/src/ui/pages/routes/parchment_page.dart';
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

  testWidgets(
      'world section shows presets in a dedicated panel below the top row',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(presetsOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    expect(find.text('Impostazioni base'), findsOneWidget);
    expect(find.text('Ambientazione e scenario.'), findsOneWidget);
    expect(find.text('Preset rapidi'), findsOneWidget);
    expect(find.text('Preset rapido'), findsOneWidget);

    final twistY = tester.getTopLeft(find.text('Twist iniziale')).dy;
    final presetsY = tester.getTopLeft(find.text('Preset rapidi')).dy;

    expect(presetsY, greaterThan(twistY));
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('applying a preset forges directly to parchment', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(presetsOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    final presetField =
        find.byKey(const ValueKey<String>('preset-selector-field'));

    await tester.ensureVisible(presetField);
    await tester.tap(presetField);
    await tester.pumpAndSettle();
    expect(find.byType(ListWheelScrollView), findsWidgets);
    await tester.tap(find.widgetWithText(FilledButton, 'Select'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.widgetWithText(FilledButton, 'Forgia con preset'));
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.byKey(const ValueKey('parchment-action-copy')), findsOneWidget);
    expect(find.byType(ParchmentRoutePage), findsOneWidget);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('preset selector starts empty and forge button is disabled',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(presetsOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    final presetField =
        find.byKey(const ValueKey<String>('preset-selector-field'));
    final forgeButton = find.widgetWithText(FilledButton, 'Forgia con preset');

    expect(
      find.descendant(
        of: presetField,
        matching: find.text('Nessun preset'),
      ),
      findsOneWidget,
    );
    final inputDecorator = tester.widget<InputDecorator>(
      find.descendant(
        of: presetField,
        matching: find.byType(InputDecorator),
      ),
    );
    expect(inputDecorator.isEmpty, isFalse);
    expect(tester.widget<FilledButton>(forgeButton).onPressed, isNull);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets(
      'applying a long campaign preset also forges directly to parchment',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(longCampaignPresetsOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(
      tester,
      const ValueKey<String>('entry-campaign-card-Campagna lunga'),
    );

    final presetField =
        find.byKey(const ValueKey<String>('preset-selector-field'));

    await tester.ensureVisible(presetField);
    await tester.tap(presetField);
    await tester.pumpAndSettle();
    expect(find.byType(ListWheelScrollView), findsWidgets);
    await tester.tap(find.widgetWithText(FilledButton, 'Select'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.widgetWithText(FilledButton, 'Forgia con preset'));
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.byKey(const ValueKey('parchment-action-copy')), findsOneWidget);
    expect(find.byType(ParchmentRoutePage), findsOneWidget);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('world forge panels use descending visual emphasis',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(presetsOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    final worldFrame =
        find.widgetWithText(SectionFrame, 'Costruzione del Mondo');
    final presetFrame = find.widgetWithText(SectionFrame, 'Scegli un preset');
    final foundationPanel =
        find.widgetWithText(ControlRoomPanel, 'Impostazioni base');
    final creativePanel =
        find.widgetWithText(ControlRoomPanel, 'Temi, tono e stile');
    final twistPanel = find.widgetWithText(ControlRoomPanel, 'Twist iniziale');

    expect(
      tester.widget<SectionFrame>(worldFrame).emphasis,
      PanelEmphasis.primary,
    );
    expect(
      tester.widget<SectionFrame>(presetFrame).emphasis,
      PanelEmphasis.secondary,
    );
    expect(
      tester.widget<ControlRoomPanel>(foundationPanel).emphasis,
      PanelEmphasis.primary,
    );
    expect(
      tester.widget<ControlRoomPanel>(creativePanel).emphasis,
      PanelEmphasis.secondary,
    );
    expect(
      tester.widget<ControlRoomPanel>(twistPanel).emphasis,
      PanelEmphasis.tertiary,
    );

    expect(_backgroundAlpha(tester, worldFrame),
        greaterThan(_backgroundAlpha(tester, presetFrame)));
    expect(_backgroundAlpha(tester, foundationPanel),
        greaterThan(_backgroundAlpha(tester, creativePanel)));
    expect(_backgroundAlpha(tester, creativePanel),
        greaterThan(_backgroundAlpha(tester, twistPanel)));
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('twist selector uses a bottom sheet for long readable options',
      (tester) async {
    const longTwist =
        'Il mentore del gruppo guida in segreto la missione verso il sacrificio di un alleato.';

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(longTwistOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    final twistField =
        find.byKey(const ValueKey<String>('twist-selector-field'));

    await tester.ensureVisible(twistField);
    await tester.tap(twistField);
    await _pumpUi(tester);

    expect(find.byType(ListWheelScrollView), findsWidgets);
    expect(find.text(longTwist), findsWidgets);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('setting selector uses a bottom sheet for readable options',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(neutralTwistSettingOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    final settingField =
        find.byKey(const ValueKey<String>('setting-selector-field'));

    await tester.ensureVisible(settingField);
    await tester.tap(settingField);
    await _pumpUi(tester);
    expect(find.byType(ListWheelScrollView), findsWidgets);
    expect(find.text('EBERRON'), findsWidgets);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('preset selector uses a wheel bottom sheet with localized labels',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(presetsOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    final presetField =
        find.byKey(const ValueKey<String>('preset-selector-field'));

    await tester.ensureVisible(presetField);
    await tester.tap(presetField);
    await _pumpUi(tester);
    expect(find.byType(ListWheelScrollView), findsWidgets);
    expect(find.text('CRONACHE DEL PORTO'), findsWidgets);

    await tester.tap(find.widgetWithText(FilledButton, 'Select'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.widgetWithText(FilledButton, 'Forgia con preset'));
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.byKey(const ValueKey('parchment-action-copy')), findsOneWidget);
    expect(find.byType(ParchmentRoutePage), findsOneWidget);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('default no-twist selection does not unlock world advance action',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(neutralTwistOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    final advanceButton = find.widgetWithText(FilledButton, 'Vai al Party');
    expect(tester.widget<FilledButton>(advanceButton).onPressed, isNull);
    expect(find.text('Nessun colpo di scena'), findsWidgets);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('selecting a real twist unlocks world advance action',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(neutralTwistOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    final advanceButton = find.widgetWithText(FilledButton, 'Vai al Party');
    final twistField =
        find.byKey(const ValueKey<String>('twist-selector-field'));

    expect(tester.widget<FilledButton>(advanceButton).onPressed, isNull);

    await tester.ensureVisible(twistField);
    await tester.tap(twistField);
    await _pumpUi(tester);
    await tester.drag(find.byType(ListWheelScrollView), const Offset(0, -80));
    await _pumpUi(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Select'));
    await _pumpUi(tester);

    expect(tester.widget<FilledButton>(advanceButton).onPressed, isNotNull);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets(
      'selecting a non-default setting unlocks world advance with no twist',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(neutralTwistSettingOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    final advanceButton = find.widgetWithText(FilledButton, 'Vai al Party');
    final settingField =
        find.byKey(const ValueKey<String>('setting-selector-field'));

    expect(tester.widget<FilledButton>(advanceButton).onPressed, isNull);
    expect(find.text('Nessun colpo di scena'), findsWidgets);

    await tester.ensureVisible(settingField);
    await tester.tap(settingField);
    await _pumpUi(tester);
    expect(find.byType(ListWheelScrollView), findsWidgets);
    expect(find.text('EBERRON'), findsWidgets);

    await tester.drag(find.byType(ListWheelScrollView), const Offset(0, -70));
    await _pumpUi(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Select'));
    await _pumpUi(tester);

    expect(tester.widget<FilledButton>(advanceButton).onPressed, isNotNull);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('it'),
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
  await tester.pumpAndSettle();
}

Future<void> _openForgeFromEntry(
  WidgetTester tester, [
  ValueKey<String> cardKey =
      const ValueKey<String>('entry-campaign-card-One-Shot'),
]) async {
  final card = find.byKey(cardKey);
  await tester.ensureVisible(card);
  await tester.tap(card);
  await _pumpUi(tester);
}

int _backgroundAlpha(WidgetTester tester, Finder finder) {
  final container = tester.widget<Container>(
    find
        .descendant(
          of: finder,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Container && widget.decoration is BoxDecoration,
          ),
        )
        .first,
  );
  final decoration = container.decoration! as BoxDecoration;
  return (decoration.color!.a * 255.0).round().clamp(0, 255);
}

CampaignOptions longTwistOptions() {
  return CampaignOptions(
    settings: const ['Forgotten Realms'],
    campaignTypes: const ['One-Shot'],
    themes: const ['Intrigo'],
    tones: const ['Epico'],
    styles: const ['Lineare'],
    partyArchetypes: const ['Tank'],
    twists: const [
      'Il mentore del gruppo guida in segreto la missione verso il sacrificio di un alleato.',
      'La reliquia recuperata sta lentamente riscrivendo la memoria della citta e degli eroi.',
    ],
    presets: const {},
    settingDescriptions: const {'Forgotten Realms': 'Classico high fantasy.'},
    presetDescriptions: const {},
    presetNames: const {},
  );
}

CampaignOptions neutralTwistOptions() {
  return CampaignOptions(
    settings: const ['Forgotten Realms'],
    campaignTypes: const ['One-Shot'],
    themes: const ['Intrigo'],
    tones: const ['Epico'],
    styles: const ['Lineare'],
    partyArchetypes: const ['Tank'],
    twists: const [
      'Nessun colpo di scena',
      'Tradimento',
      'Rivelazione',
      'Doppio gioco',
      'Maledizione',
      'Portale instabile',
      'Assedio finale',
    ],
    presets: const {},
    settingDescriptions: const {'Forgotten Realms': 'Classico high fantasy.'},
    presetDescriptions: const {},
    presetNames: const {},
  );
}

CampaignOptions neutralTwistSettingOptions() {
  return CampaignOptions(
    settings: const [
      'Forgotten Realms',
      'Eberron',
      'Ravenloft',
      'Dragonlance',
    ],
    campaignTypes: const ['One-Shot'],
    themes: const ['Intrigo'],
    tones: const ['Epico'],
    styles: const ['Lineare'],
    partyArchetypes: const ['Tank'],
    twists: const [
      'Nessun colpo di scena',
      'Tradimento',
    ],
    presets: const {},
    settingDescriptions: const {
      'Forgotten Realms': 'Classico high fantasy.',
      'Eberron': 'Metropoli magica e pulp noir.',
    },
    presetDescriptions: const {},
    presetNames: const {},
  );
}
