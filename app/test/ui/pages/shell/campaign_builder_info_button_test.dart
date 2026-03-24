import 'package:campaign_creator_flutter/src/ui/pages/shell/campaign_builder_page.dart';
import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_campaign_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('info button is visible and opens disclaimer dialog', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('it'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    // Button must be visible
    final infoBtn = find.byKey(const ValueKey<String>('info-settings-button'));
    expect(infoBtn, findsOneWidget);

    // Tap opens dialog
    await tester.tap(infoBtn);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('info-dialog')), findsOneWidget);

    // Dialog contains disclaimer text
    expect(
      find.textContaining('generatore di prompt'),
      findsOneWidget,
    );
  });

  testWidgets('info dialog can be dismissed', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('it'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester.tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('info-dialog-close')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('info-dialog')), findsNothing);
  });
}
