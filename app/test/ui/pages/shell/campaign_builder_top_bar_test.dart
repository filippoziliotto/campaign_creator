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
      'parchment top bar keeps language toggle and action on one row in Italian',
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

    await tester.tap(find.text('Riprendi la forgia'));
    await _pumpUi(tester);

    await tester.tap(
      find
          .ancestor(
            of: find.text('Apri'),
            matching:
                find.byWidgetPredicate((widget) => widget is ButtonStyleButton),
          )
          .first,
    );
    await _pumpUi(tester);

    final languageSwitch = find.byKey(
      const ValueKey<String>('top-bar-language-switch'),
    );
    final actionLabel = find.text('Forgia').last;
    final action = find.ancestor(
      of: actionLabel,
      matching: find.byWidgetPredicate((widget) => widget is ButtonStyleButton),
    );

    expect(languageSwitch, findsOneWidget);
    expect(actionLabel, findsOneWidget);
    expect(action, findsOneWidget);

    final switchRect = tester.getRect(languageSwitch);
    final actionRect = tester.getRect(action);

    expect(actionRect.top, lessThan(switchRect.bottom));
    expect(switchRect.top, lessThan(actionRect.bottom));
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
