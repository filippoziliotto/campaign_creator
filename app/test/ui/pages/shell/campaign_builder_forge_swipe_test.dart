import 'package:animations/animations.dart';
import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:campaign_creator_flutter/src/ui/pages/design/campaign_builder_motion.dart';
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

  testWidgets('swiping left from narrative keeps the forge on narrative', (
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
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final resumeButton = find.text('Riprendi la forgia');
    await tester.ensureVisible(resumeButton);
    await tester.tap(resumeButton);
    await _pumpUi(tester);

    await tester.tap(find.text('Trama'));
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-section-narrative')),
      findsOneWidget,
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('forge-section-narrative')),
    );

    await _flingSection(
      tester,
      find.byKey(const ValueKey<String>('forge-section-narrative')),
      const Offset(-500, 0),
    );
    await _pumpUi(tester);

    expect(find.byType(ParchmentRoutePage), findsNothing);

    expect(
      find.byKey(const ValueKey<String>('forge-section-narrative')),
      findsOneWidget,
    );
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets(
      'swiping beyond narrative without a prompt keeps the forge focused',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final oneShotCard = find.byKey(
      const ValueKey<String>('entry-campaign-card-One-Shot'),
    );
    await tester.ensureVisible(oneShotCard);
    await tester.tap(oneShotCard);
    await _pumpUi(tester);

    await _flingSection(
      tester,
      find.byKey(const ValueKey<String>('forge-section-world')),
      const Offset(-500, 0),
    );
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-section-party')),
      findsOneWidget,
    );

    await _flingSection(
      tester,
      find.byKey(const ValueKey<String>('forge-section-party')),
      const Offset(-500, 0),
    );
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-section-narrative')),
      findsOneWidget,
    );

    await _flingSection(
      tester,
      find.byKey(const ValueKey<String>('forge-section-narrative')),
      const Offset(-500, 0),
    );
    await _pumpUi(tester);

    expect(find.byType(ParchmentRoutePage), findsNothing);
    expect(
      find.byKey(const ValueKey<String>('forge-section-narrative')),
      findsOneWidget,
    );
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('partial horizontal drag reveals the adjacent forge section', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final oneShotCard = find.byKey(
      const ValueKey<String>('entry-campaign-card-One-Shot'),
    );
    await tester.ensureVisible(oneShotCard);
    await tester.tap(oneShotCard);
    await _pumpUi(tester);

    final worldSection = find.byKey(
      const ValueKey<String>('forge-section-world'),
    );
    final worldRect = tester.getRect(worldSection);
    final gesture = await tester.startGesture(
      Offset(worldRect.left + 48, worldRect.top + 48),
    );
    await gesture.moveBy(const Offset(-45, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(-45, 0));
    await tester.pump();

    expect(find.byKey(const ValueKey<String>('forge-section-world')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('forge-section-party')),
        findsOneWidget);

    await gesture.up();
    await _pumpUi(tester);

    expect(find.byKey(const ValueKey<String>('forge-section-world')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('forge-section-party')),
        findsNothing);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('swiping updates the forge swipe helper active mark',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final oneShotCard = find.byKey(
      const ValueKey<String>('entry-campaign-card-One-Shot'),
    );
    await tester.ensureVisible(oneShotCard);
    await tester.tap(oneShotCard);
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-swipe-mark-world-active')),
      findsOneWidget,
    );

    await _flingSection(
      tester,
      find.byKey(const ValueKey<String>('forge-section-world')),
      const Offset(-500, 0),
    );
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-swipe-mark-party-active')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('forge-swipe-mark-world-active')),
      findsNothing,
    );
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('touch forge uses only a bare pinned primary button', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final oneShotCard = find.byKey(
      const ValueKey<String>('entry-campaign-card-One-Shot'),
    );
    await tester.ensureVisible(oneShotCard);
    await tester.tap(oneShotCard);
    await _pumpUi(tester);

    expect(find.byType(ForgePrimaryActionButton), findsOneWidget);
    expect(find.byType(ForgeActionStrip), findsNothing);

    final buttonRect = tester.getRect(
      find.byKey(const ValueKey<String>('forge-pinned-primary-button')),
    );
    final buttonWrapper = tester.widget<SizedBox>(
      find.byKey(const ValueKey<String>('forge-pinned-primary-button')),
    );
    final settingsRect = tester.getRect(
      find.byKey(const ValueKey<String>('info-settings-button')),
    );
    final helpRect = tester.getRect(
      find.byKey(const ValueKey<String>('help-guide-button')),
    );
    final leftGap = buttonRect.left - settingsRect.right;
    final rightGap = helpRect.left - buttonRect.right;
    const minimumOverlayGap = 12.0;

    expect(buttonWrapper.width, greaterThan(0));
    expect(buttonRect.height, lessThan(52));
    expect(leftGap, greaterThanOrEqualTo(minimumOverlayGap));
    expect(rightGap, greaterThanOrEqualTo(minimumOverlayGap));
    expect((leftGap - rightGap).abs(), lessThan(1.0));
    expect(buttonRect.center.dy, greaterThan(932 * 0.75));
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('slow drag past threshold commits the next forge section', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final oneShotCard = find.byKey(
      const ValueKey<String>('entry-campaign-card-One-Shot'),
    );
    await tester.ensureVisible(oneShotCard);
    await tester.tap(oneShotCard);
    await _pumpUi(tester);

    final worldSection = find.byKey(
      const ValueKey<String>('forge-section-world'),
    );
    final worldRect = tester.getRect(worldSection);
    final gesture = await tester.startGesture(
      Offset(worldRect.left + 48, worldRect.top + 48),
    );
    await gesture.moveBy(const Offset(-60, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(-60, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(-60, 0));
    await tester.pump();
    await gesture.up();
    await _pumpUi(tester);

    expect(find.byKey(const ValueKey<String>('forge-section-world')),
        findsNothing);
    expect(find.byKey(const ValueKey<String>('forge-section-party')),
        findsOneWidget);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets(
      'mostly vertical drags in forge do not reveal the adjacent section on android',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final oneShotCard = find.byKey(
      const ValueKey<String>('entry-campaign-card-One-Shot'),
    );
    await tester.ensureVisible(oneShotCard);
    await tester.tap(oneShotCard);
    await _pumpUi(tester);

    final worldSection = find.byKey(
      const ValueKey<String>('forge-section-world'),
    );
    final worldRect = tester.getRect(worldSection);
    final gesture = await tester.startGesture(
      Offset(worldRect.left + 48, worldRect.top + 48),
    );
    await gesture.moveBy(const Offset(-42, 96));
    await tester.pump();
    await gesture.moveBy(const Offset(-42, 96));
    await tester.pump();
    await gesture.up();
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-section-world')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('forge-section-party')),
      findsNothing,
    );
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets(
      'swiping right from the first forge section keeps the forge active',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final oneShotCard = find.byKey(
      const ValueKey<String>('entry-campaign-card-One-Shot'),
    );
    await tester.ensureVisible(oneShotCard);
    await tester.tap(oneShotCard);
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-section-world')),
      findsOneWidget,
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('forge-section-world')),
    );

    await _flingSection(
      tester,
      find.byKey(const ValueKey<String>('forge-section-world')),
      const Offset(500, 0),
    );
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-section-world')),
      findsOneWidget,
    );
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('selecting a campaign type uses shared-axis route transitions',
      (tester) async {
    final options = CampaignOptions(
      settings: const ['Forgotten Realms'],
      campaignTypes: const ['Long campaign'],
      themes: const ['Intrigue'],
      tones: const ['Heroic'],
      styles: const ['Epic'],
      partyArchetypes: const ['Fighter'],
      twists: const ['No twist'],
      presets: const {},
      settingDescriptions: const {'Forgotten Realms': 'Classic high fantasy.'},
      presetDescriptions: const {},
      presetNames: const {},
    );

    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(options),
          currentLocale: const Locale('en'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final longCampaignCard = find.byKey(
      const ValueKey<String>('entry-campaign-card-Long campaign'),
    );
    await tester.ensureVisible(longCampaignCard);
    await tester.tap(longCampaignCard);
    await tester.pump();

    final transitions = tester
        .widgetList<SharedAxisTransition>(find.byType(SharedAxisTransition));

    expect(transitions, isNotEmpty);
    expect(
      transitions.map((transition) => transition.transitionType).toSet(),
      equals(<SharedAxisTransitionType>{SharedAxisTransitionType.horizontal}),
    );
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('touch forge section changes use the interactive pager',
      (tester) async {
    final options = CampaignOptions(
      settings: const ['Forgotten Realms'],
      campaignTypes: const ['Long campaign'],
      themes: const ['Intrigue'],
      tones: const ['Heroic'],
      styles: const ['Epic'],
      partyArchetypes: const ['Fighter'],
      twists: const ['No twist'],
      presets: const {},
      settingDescriptions: const {'Forgotten Realms': 'Classic high fantasy.'},
      presetDescriptions: const {},
      presetNames: const {},
    );

    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(options),
          currentLocale: const Locale('en'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final longCampaignCard = find.byKey(
      const ValueKey<String>('entry-campaign-card-Long campaign'),
    );
    await tester.ensureVisible(longCampaignCard);
    await tester.tap(longCampaignCard);
    await _pumpUi(tester);

    expect(find.byType(InteractiveHorizontalSectionPager), findsOneWidget);

    await tester.tap(find.text('Party'));
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-section-party')),
      findsOneWidget,
    );
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('touch forge pager uses a shorter settle duration than desktop',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final oneShotCard = find.byKey(
      const ValueKey<String>('entry-campaign-card-One-Shot'),
    );
    await tester.ensureVisible(oneShotCard);
    await tester.tap(oneShotCard);
    await _pumpUi(tester);

    final pager = tester.widget<InteractiveHorizontalSectionPager>(
      find.byType(InteractiveHorizontalSectionPager),
    );

    expect(pager.duration, lessThan(const Duration(milliseconds: 240)));
  },
      variant: const TargetPlatformVariant(<TargetPlatform>{
        TargetPlatform.android,
      }));

  testWidgets('changing party metrics does not change forge section', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final oneShotCard = find.byKey(
      const ValueKey<String>('entry-campaign-card-One-Shot'),
    );
    await tester.ensureVisible(oneShotCard);
    await tester.tap(oneShotCard);
    await _pumpUi(tester);

    await _flingSection(
      tester,
      find.byKey(const ValueKey<String>('forge-section-world')),
      const Offset(-500, 0),
    );
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-section-party')),
      findsOneWidget,
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('forge-section-party')),
    );

    final levelPill = find.byKey(const ValueKey<String>('party-level-pill-2'));
    await tester.ensureVisible(levelPill);
    await tester.tap(levelPill);
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-section-party')),
      findsOneWidget,
    );
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets(
      'dragging inside the party level scroller does not reveal adjacent forge sections',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await _openPartySection(tester);

    final levelControl = find.byKey(
      const ValueKey<String>('party-level-control'),
    );
    await tester.ensureVisible(levelControl);

    final rect = tester.getRect(levelControl);
    final gesture = await tester.startGesture(
      Offset(rect.right - 24, rect.center.dy),
    );
    await gesture.moveBy(const Offset(-72, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(-72, 0));
    await tester.pump();

    expect(
      find.byKey(const ValueKey<String>('forge-section-world')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey<String>('forge-section-narrative')),
      findsNothing,
    );

    await gesture.up();
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-section-party')),
      findsOneWidget,
    );
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets(
      'flinging inside the party level scroller does not change the forge section',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await _openPartySection(tester);

    final levelControl = find.byKey(
      const ValueKey<String>('party-level-control'),
    );
    await tester.ensureVisible(levelControl);

    final rect = tester.getRect(levelControl);
    await tester.flingFrom(
      Offset(rect.right - 24, rect.center.dy),
      const Offset(-420, 0),
      1600,
    );
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-section-party')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('forge-section-narrative')),
      findsNothing,
    );
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('swiping right from parchment returns to narrative', (
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
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    final resumeButton = find.text('Riprendi la forgia');
    await tester.ensureVisible(resumeButton);
    await tester.tap(resumeButton);
    await _pumpUi(tester);

    final parchmentStage = find.text('Pergamena');
    await tester.ensureVisible(parchmentStage);
    await tester.tap(parchmentStage);
    await _pumpUi(tester);

    expect(find.byType(ParchmentRoutePage), findsOneWidget);
    await tester.ensureVisible(find.byType(ParchmentRoutePage));

    await tester.fling(
      find.byType(ParchmentRoutePage),
      const Offset(500, 0),
      1000,
    );
    await _pumpUi(tester);

    expect(find.byType(ParchmentRoutePage), findsNothing);
    expect(
      find.byKey(const ValueKey<String>('forge-section-narrative')),
      findsOneWidget,
    );
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
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 800));
}

Future<void> _flingSection(
  WidgetTester tester,
  Finder finder,
  Offset offset,
) async {
  final rect = tester.getRect(finder);
  final start = Offset(rect.left + 48, rect.top + 48);
  await tester.flingFrom(start, offset, 1000);
}

Future<void> _openPartySection(WidgetTester tester) async {
  final oneShotCard = find.byKey(
    const ValueKey<String>('entry-campaign-card-One-Shot'),
  );
  await tester.ensureVisible(oneShotCard);
  await tester.tap(oneShotCard);
  await _pumpUi(tester);

  await tester.tap(find.text('Party'));
  await _pumpUi(tester);
}
