import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
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
      'forge section ribbon keeps segment icons visible on narrow screens', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: Locale('it'),
          onLocaleChanged: _noopLocaleChanged,
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    final ribbon = find.byKey(const ValueKey<String>('forge-section-ribbon'));
    expect(ribbon, findsOneWidget);

    expect(find.descendant(of: ribbon, matching: find.text('Mondo')),
        findsOneWidget);
    expect(find.descendant(of: ribbon, matching: find.text('Party')),
        findsOneWidget);
    expect(find.descendant(of: ribbon, matching: find.text('Trama')),
        findsOneWidget);

    expect(
        find.descendant(of: ribbon, matching: find.text('🌍')), findsOneWidget);
    expect(
        find.descendant(of: ribbon, matching: find.text('⚔️')), findsOneWidget);
    expect(
        find.descendant(of: ribbon, matching: find.text('📜')), findsOneWidget);

    await tester.tap(find.descendant(of: ribbon, matching: find.text('Party')));
    await _pumpUi(tester);

    expect(
      find.descendant(of: ribbon, matching: find.text('✅')),
      findsOneWidget,
    );
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets(
      'forge section ribbon falls back to material icons on iOS to avoid missing emoji glyphs',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: _noopLocaleChanged,
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    final ribbon = find.byKey(const ValueKey<String>('forge-section-ribbon'));
    expect(ribbon, findsOneWidget);

    expect(
      find.descendant(of: ribbon, matching: find.byIcon(Icons.public_rounded)),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: ribbon,
        matching: find.byIcon(Icons.groups_2_rounded),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: ribbon,
        matching: find.byIcon(Icons.auto_stories_rounded),
      ),
      findsOneWidget,
    );

    expect(
        find.descendant(of: ribbon, matching: find.text('🌍')), findsNothing);
    expect(
        find.descendant(of: ribbon, matching: find.text('⚔️')), findsNothing);
    expect(
        find.descendant(of: ribbon, matching: find.text('📜')), findsNothing);

    await tester.tap(find.descendant(of: ribbon, matching: find.text('Party')));
    await _pumpUi(tester);

    expect(
      find.descendant(of: ribbon, matching: find.byIcon(Icons.check_rounded)),
      findsOneWidget,
    );
  },
      variant:
          const TargetPlatformVariant(<TargetPlatform>{TargetPlatform.iOS}));

  testWidgets('forge swipe helper renders under the ribbon on narrow screens',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: _noopLocaleChanged,
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    final ribbon = find.byKey(const ValueKey<String>('forge-section-ribbon'));
    final helper = find.byKey(const ValueKey<String>('forge-swipe-helper'));

    expect(helper, findsOneWidget);
    expect(
      find.descendant(
        of: helper,
        matching: find.byKey(const ValueKey<String>('forge-swipe-mark-world')),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: helper,
        matching: find.byKey(const ValueKey<String>('forge-swipe-mark-party')),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: helper,
        matching:
            find.byKey(const ValueKey<String>('forge-swipe-mark-narrative')),
      ),
      findsOneWidget,
    );

    expect(tester.getTopLeft(helper).dy,
        greaterThan(tester.getBottomLeft(ribbon).dy));
  });

  testWidgets('forge swipe helper uses a tighter row gap on narrow screens',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: _noopLocaleChanged,
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    final ribbon = find.byKey(const ValueKey<String>('forge-section-ribbon'));
    final helper = find.byKey(const ValueKey<String>('forge-swipe-helper'));
    final gap = tester.getTopLeft(helper).dy - tester.getBottomLeft(ribbon).dy;

    expect(gap, lessThanOrEqualTo(6));
  });

  testWidgets(
      'forge swipe helper updates active mark when ribbon selection changes',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: _noopLocaleChanged,
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-swipe-mark-world-active')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('forge-swipe-mark-party-active')),
      findsNothing,
    );

    final ribbon = find.byKey(const ValueKey<String>('forge-section-ribbon'));
    await tester.tap(find.descendant(of: ribbon, matching: find.text('Party')));
    await _pumpUi(tester);

    expect(
      find.byKey(const ValueKey<String>('forge-swipe-mark-world-active')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey<String>('forge-swipe-mark-party-active')),
      findsOneWidget,
    );
  });

  testWidgets('forge swipe helper remains visible on wide layouts',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: _noopLocaleChanged,
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    expect(find.byKey(const ValueKey<String>('forge-swipe-helper')),
        findsOneWidget);
  });

  testWidgets(
      'forge swipe helper uses a thin active dash and compact inactive marks',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: _noopLocaleChanged,
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    final activeMark = find.byKey(
      const ValueKey<String>('forge-swipe-mark-world-active'),
    );
    final inactiveMark = find.byKey(
      const ValueKey<String>('forge-swipe-mark-party-inactive'),
    );

    expect(tester.getSize(activeMark), const Size(22, 2.5));
    expect(tester.getSize(inactiveMark), const Size(7, 2.5));
  });
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

Future<void> _openForgeFromEntry(WidgetTester tester) async {
  final oneShotCard = find.byKey(
    const ValueKey<String>('entry-campaign-card-One-Shot'),
  );
  await tester.ensureVisible(oneShotCard);
  await tester.tap(oneShotCard);
  await _pumpUi(tester);
}

void _noopLocaleChanged(Locale locale) {}
