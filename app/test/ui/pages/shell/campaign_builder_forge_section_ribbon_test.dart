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
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android, TargetPlatform.iOS}));
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
