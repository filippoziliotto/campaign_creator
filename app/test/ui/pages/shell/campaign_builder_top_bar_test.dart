import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/ui/pages/shell/campaign_builder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_campaign_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'campaign_builder.saved_prompt': 'Prompt salvato',
      'campaign_builder.saved_campaign_type': 'One-Shot',
      'campaign_builder.saved_setting': 'Forgotten Realms',
    });
  });

  testWidgets(
      'parchment top bar keeps a vertical language toggle without top bar actions',
      (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
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

    final languageSwitch = find.byKey(
      const ValueKey<String>('top-bar-language-switch'),
    );
    final topBar = find.byKey(const ValueKey<String>('persistent-top-bar'));
    final topBarForgeAction = find.descendant(
      of: topBar,
      matching: find.widgetWithText(ButtonStyleButton, 'Forgia'),
    );
    final topBarOpenAction = find.descendant(
      of: topBar,
      matching: find.widgetWithText(ButtonStyleButton, 'Apri'),
    );

    expect(topBar, findsOneWidget);
    expect(languageSwitch, findsOneWidget);
    expect(topBarForgeAction, findsNothing);
    expect(topBarOpenAction, findsNothing);

    final switchRect = tester.getRect(languageSwitch);
    final enCenter = tester.getCenter(find.descendant(
      of: languageSwitch,
      matching: find.text('EN'),
    ));
    final itCenter = tester.getCenter(find.descendant(
      of: languageSwitch,
      matching: find.text('IT'),
    ));

    expect(switchRect.height, greaterThan(switchRect.width));
    expect(switchRect.width, lessThan(54));
    expect(enCenter.dx, closeTo(switchRect.center.dx, 2));
    expect(itCenter.dx, closeTo(switchRect.center.dx, 2));
    expect(tester.takeException(), isNull);
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
      home: child,
    );
  }
}

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 800));
}
