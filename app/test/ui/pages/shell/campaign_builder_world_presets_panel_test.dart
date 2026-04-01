import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:campaign_creator_flutter/src/monetization/rewarded_ad_service.dart';
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

  testWidgets('creative panel help button toggles the helper bubble',
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

    expect(
      find.byKey(const ValueKey('forge-creative-help-bubble')),
      findsNothing,
    );

    await tester.tap(find.byKey(const ValueKey('forge-creative-help-button')));
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey('forge-creative-help-bubble')),
      findsOneWidget,
    );
    expect(
      find.text('Scegli temi, tono e stile narrativo della campagna.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('forge-creative-help-button')));
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey('forge-creative-help-bubble')),
      findsNothing,
    );
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

  testWidgets(
      'preset selector uses localized preset names in uppercase for English',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        locale: const Locale('en'),
        child: CampaignBuilderPage(
          service: FakeCampaignService(englishPresetsOptions()),
          currentLocale: const Locale('en'),
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
    expect(find.text('HARBOR CHRONICLES'), findsWidgets);
    expect(find.text('CRONACHE DEL PORTO'), findsNothing);

    await tester.tap(find.widgetWithText(FilledButton, 'Select'));
    await _pumpUi(tester);

    expect(
      find.descendant(
        of: presetField,
        matching: find.text('HARBOR CHRONICLES'),
      ),
      findsOneWidget,
    );
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('setting selector treats Ravnica as a premium option',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final rewardedAdService = FakeRewardedAdService()..shouldBeReady = true;

    await tester.pumpWidget(
      _TestApp(
        locale: const Locale('en'),
        child: CampaignBuilderPage(
          service: FakeCampaignService(premiumSettingsOptions()),
          rewardedAdService: rewardedAdService,
          currentLocale: const Locale('en'),
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

    await tester.drag(find.byType(ListWheelScrollView), const Offset(0, -150));
    await _pumpUi(tester);

    final l10n = _l10n(tester);

    await tester.tap(
      find.widgetWithText(FilledButton, l10n.settingsGoAdFreePrice),
    );
    await _pumpUi(tester);

    expect(find.text(l10n.premiumUnlockTitle), findsOneWidget);
    expect(find.text(l10n.premiumUnlockWatchAd), findsOneWidget);
    expect(find.text(l10n.settingsGoAdFreePrice), findsWidgets);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('setting selector allows selecting a free option from metadata',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        locale: const Locale('en'),
        child: CampaignBuilderPage(
          service: FakeCampaignService(premiumSettingsOptions()),
          currentLocale: const Locale('en'),
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
    await tester.drag(find.byType(ListWheelScrollView), const Offset(0, -70));
    await _pumpUi(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Select'));
    await _pumpUi(tester);

    expect(
      find.descendant(of: settingField, matching: find.text('GREYHAWK')),
      findsOneWidget,
    );
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('premium preset inherits lock from premium ingredients',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final rewardedAdService = FakeRewardedAdService()..shouldBeReady = true;

    await tester.pumpWidget(
      _TestApp(
        locale: const Locale('en'),
        child: CampaignBuilderPage(
          service: FakeCampaignService(premiumPresetsOptions()),
          rewardedAdService: rewardedAdService,
          currentLocale: const Locale('en'),
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
    await tester.drag(find.byType(ListWheelScrollView), const Offset(0, -70));
    await _pumpUi(tester);
    expect(find.text('VOID THRONES'), findsWidgets);

    final l10n = _l10n(tester);

    await tester.tap(
      find.widgetWithText(FilledButton, l10n.settingsGoAdFreePrice),
    );
    await _pumpUi(tester);

    expect(find.text(l10n.premiumUnlockWatchAd), findsOneWidget);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets(
      'watching rewarded ad unlocks premium temporarily and shows confirmation',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final rewardedAdService = FakeRewardedAdService()
      ..shouldBeReady = true
      ..showResult = true;

    await tester.pumpWidget(
      _TestApp(
        locale: const Locale('en'),
        child: CampaignBuilderPage(
          service: FakeCampaignService(premiumPresetsOptions()),
          rewardedAdService: rewardedAdService,
          currentLocale: const Locale('en'),
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
    await tester.drag(find.byType(ListWheelScrollView), const Offset(0, -70));
    await _pumpUi(tester);

    final l10n = _l10n(tester);

    await tester.tap(
      find.widgetWithText(FilledButton, l10n.settingsGoAdFreePrice),
    );
    await _pumpUi(tester);
    await tester
        .tap(find.widgetWithText(FilledButton, l10n.premiumUnlockWatchAd));
    await _pumpUi(tester);

    expect(rewardedAdService.showCallCount, 1);
    expect(find.text('Premium unlocked for 5 minutes'), findsOneWidget);

    await tester.tap(presetField);
    await _pumpUi(tester);
    await tester.drag(find.byType(ListWheelScrollView), const Offset(0, -70));
    await _pumpUi(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Select'));
    await _pumpUi(tester);

    expect(find.text('VOID THRONES'), findsWidgets);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('failed rewarded ad does not unlock premium access',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final rewardedAdService = FakeRewardedAdService()
      ..shouldBeReady = true
      ..showResult = false;

    await tester.pumpWidget(
      _TestApp(
        locale: const Locale('en'),
        child: CampaignBuilderPage(
          service: FakeCampaignService(premiumPresetsOptions()),
          rewardedAdService: rewardedAdService,
          currentLocale: const Locale('en'),
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
    await tester.drag(find.byType(ListWheelScrollView), const Offset(0, -70));
    await _pumpUi(tester);

    final l10n = _l10n(tester);

    await tester.tap(
      find.widgetWithText(FilledButton, l10n.settingsGoAdFreePrice),
    );
    await _pumpUi(tester);
    await tester
        .tap(find.widgetWithText(FilledButton, l10n.premiumUnlockWatchAd));
    await _pumpUi(tester);

    expect(rewardedAdService.showCallCount, 1);
    expect(find.text('Premium unlocked for 5 minutes'), findsNothing);

    await tester.tap(presetField);
    await _pumpUi(tester);
    await tester.drag(find.byType(ListWheelScrollView), const Offset(0, -70));
    await _pumpUi(tester);

    await tester.tap(
      find.widgetWithText(FilledButton, l10n.settingsGoAdFreePrice),
    );
    await _pumpUi(tester);
    expect(find.text(l10n.premiumUnlockWatchAd), findsOneWidget);
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

AppLocalizations _l10n(WidgetTester tester) {
  return AppLocalizations.of(tester.element(find.byType(CampaignBuilderPage)));
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

CampaignOptions englishPresetsOptions() {
  return CampaignOptions(
    settings: const ['Forgotten Realms', 'Eberron'],
    campaignTypes: const ['One-Shot'],
    themes: const ['Intrigue'],
    tones: const ['Epic'],
    styles: const ['Linear'],
    partyArchetypes: const ['Tank'],
    twists: const ['No twist', 'Betrayal', 'Portal'],
    presets: const {
      'Cronache del Porto': {
        'campaign_type': 'One-Shot',
        'setting': 'Eberron',
        'twist': 'Betrayal',
        'theme': 'Intrigue',
        'tone': 'Epic',
        'style': 'Linear',
        'party_level': 5,
        'party_size': 4,
      },
    },
    settingDescriptions: const {
      'Forgotten Realms': 'Classic high fantasy.',
      'Eberron': 'Magical metropolis and pulp noir.',
    },
    presetDescriptions: const {
      'Cronache del Porto': 'Dockside intrigue and feuds between houses.',
    },
    presetNames: const {
      'Cronache del Porto': 'Harbor Chronicles',
    },
  );
}

CampaignOptions premiumSettingsOptions() {
  return CampaignOptions(
    settings: const [
      'Forgotten Realms',
      'Greyhawk',
      'Ravnica',
    ],
    campaignTypes: const ['One-Shot'],
    themes: const ['Intrigue'],
    tones: const ['Dark'],
    styles: const ['Cinematic'],
    partyArchetypes: const ['Tank'],
    twists: const ['No twist', 'Betrayal'],
    presets: const {},
    settingDescriptions: const {
      'Forgotten Realms': 'Classic high fantasy.',
      'Ravnica': 'Guild city of political conflict.',
      'Greyhawk': 'Classic old-school fantasy.',
    },
    presetDescriptions: const {},
    presetNames: const {},
    premiumSettings: const {'Ravnica'},
  );
}

CampaignOptions premiumPresetsOptions() {
  return CampaignOptions(
    settings: const ['Forgotten Realms', 'Ravnica'],
    campaignTypes: const ['One-Shot'],
    themes: const ['Classic fantasy', 'Urban heist'],
    tones: const ['Mysterious', 'Noir'],
    styles: const ['Investigative', 'Cinematic'],
    partyArchetypes: const ['Tank'],
    twists: const ['No twist', 'The party is unknowingly serving the villain'],
    presets: const {
      'Harbor Lights': {
        'campaign_type': 'One-Shot',
        'setting': 'Forgotten Realms',
        'theme': 'Classic fantasy',
        'tone': 'Mysterious',
        'style': 'Investigative',
        'party_level': 4,
        'party_size': 4,
        'twist': 'No twist',
      },
      'Void Thrones': {
        'campaign_type': 'One-Shot',
        'setting': 'Ravnica',
        'theme': 'Urban heist',
        'tone': 'Noir',
        'style': 'Cinematic',
        'party_level': 5,
        'party_size': 4,
        'twist': 'The party is unknowingly serving the villain',
      },
    },
    settingDescriptions: const {
      'Forgotten Realms': 'Classic high fantasy.',
      'Ravnica': 'Guild city of political conflict.',
    },
    presetDescriptions: const {
      'Harbor Lights': 'Free preset.',
      'Void Thrones': 'Premium preset.',
    },
    presetNames: const {
      'Harbor Lights': 'HARBOR LIGHTS',
      'Void Thrones': 'VOID THRONES',
    },
    premiumSettings: const {'Ravnica'},
    premiumThemes: const {'Urban heist'},
    premiumTones: const {'Noir'},
    premiumStyles: const {'Cinematic'},
    premiumTwists: const {'The party is unknowingly serving the villain'},
  );
}

class FakeRewardedAdService implements RewardedAdService {
  int preloadCallCount = 0;
  int showCallCount = 0;
  bool shouldBeReady = true;
  bool showResult = true;

  @override
  bool get isSupported => true;

  @override
  bool get isReady => shouldBeReady;

  @override
  Future<void> preload() async => preloadCallCount++;

  @override
  Future<bool> show() async {
    showCallCount++;
    return showResult;
  }

  @override
  void dispose() {}
}
