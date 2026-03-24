import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/ui/pages/shell/campaign_builder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_campaign_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    PackageInfo.setMockInitialValues(
      appName: 'Campaign Forge',
      packageName: 'com.fzlabs.campaignforge',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  testWidgets('settings button is visible and opens settings sheet',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    final btn = find.byKey(const ValueKey<String>('info-settings-button'));
    expect(btn, findsOneWidget);

    await tester.tap(btn);
    await tester.pumpAndSettle();

    expect(
        find.byKey(const ValueKey<String>('settings-sheet')), findsOneWidget);
    expect(find.textContaining('generatore di prompt'), findsOneWidget);
  });

  testWidgets('settings sheet contains review and share rows', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('settings-review-row')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-share-row')),
        findsOneWidget);
  });

  testWidgets('settings sheet shows version text', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('settings-version-text')),
        findsOneWidget);
  });

  testWidgets('settings sheet shows theme segmented control', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    expect(find.text('Tema'), findsOneWidget);
    expect(find.text('Scuro'), findsOneWidget);
    expect(find.text('Chiaro'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-theme-control')),
        findsOneWidget);
  });

  testWidgets('settings sheet theme control triggers callback and stays open',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    ThemeMode? selectedTheme;

    await tester.pumpWidget(
      _testApp(
        currentThemeMode: ThemeMode.dark,
        onThemeModeChanged: (mode) {
          selectedTheme = mode;
        },
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Chiaro'));
    await tester.pumpAndSettle();

    expect(selectedTheme, ThemeMode.light);
    expect(
        find.byKey(const ValueKey<String>('settings-sheet')), findsOneWidget);
  });

  testWidgets('settings sheet is dismissed by tapping outside', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    expect(
        find.byKey(const ValueKey<String>('settings-sheet')), findsOneWidget);

    await tester.tapAt(Offset.zero);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('settings-sheet')), findsNothing);
  });
}

Widget _testApp({
  ThemeMode currentThemeMode = ThemeMode.dark,
  ValueChanged<ThemeMode>? onThemeModeChanged,
}) =>
    MaterialApp(
      locale: const Locale('it'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: CampaignBuilderPage(
        service: FakeCampaignService(minimalOptions()),
        currentLocale: const Locale('it'),
        onLocaleChanged: (_) {},
        currentThemeMode: currentThemeMode,
        onThemeModeChanged: onThemeModeChanged,
      ),
    );
