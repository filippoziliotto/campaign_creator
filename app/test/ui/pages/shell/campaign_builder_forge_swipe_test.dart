import 'package:animations/animations.dart';
import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:campaign_creator_flutter/src/ui/pages/routes/entry_page.dart';
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

  testWidgets('forge swipe advances from narrative into parchment', (
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

    expect(find.byType(ParchmentRoutePage), findsOneWidget);

    await _flingSection(
      tester,
      find.byType(ParchmentRoutePage),
      const Offset(500, 0),
    );
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-section-narrative')),
      findsOneWidget,
    );
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('forge swipe opens parchment from narrative without a prompt', (
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

    expect(find.byType(ParchmentRoutePage), findsOneWidget);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('swiping right from the first forge section returns to entry', (
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

    expect(find.byType(EntryRoutePage), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('forge-section-world')),
      findsNothing,
    );
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('long campaign uses horizontal shared-axis transitions in forge',
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

  testWidgets('dragging the party slider does not change forge section', (
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

    final slider = find.byType(Slider).first;
    await tester.drag(slider, const Offset(160, 0));
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-section-party')),
      findsOneWidget,
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
