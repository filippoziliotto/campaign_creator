import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:campaign_creator_flutter/src/theme/fantasy_theme.dart';
import 'package:campaign_creator_flutter/src/ui/pages/shell/campaign_builder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  testWidgets('settings and help buttons are visible and help opens its sheet',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.byKey(const ValueKey<String>('info-settings-button')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('help-guide-button')),
        findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('help-guide-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('help-sheet')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-sheet')), findsNothing);
  });

  testWidgets('help button uses the handbook icon', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    final iconButton = tester.widget<IconButton>(
      find.byKey(const ValueKey<String>('help-guide-button')),
    );

    expect((iconButton.icon as Icon).icon, Icons.menu_book_rounded);
  });

  testWidgets('help sheet shows campaign types and tips sections',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester.tap(find.byKey(const ValueKey<String>('help-guide-button')));
    await tester.pumpAndSettle();

    final helpSheet = find.byKey(const ValueKey<String>('help-sheet'));
    expect(
      find.descendant(of: helpSheet, matching: find.text('Tipi di campagna')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: helpSheet,
        matching: find.text('Consigli e buone pratiche'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('help sheet is dismissed by dragging down from the top handle',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester.tap(find.byKey(const ValueKey<String>('help-guide-button')));
    await tester.pumpAndSettle();

    final helpSheet = find.byKey(const ValueKey<String>('help-sheet'));
    final handle = find.byKey(const ValueKey<String>('help-sheet-drag-handle'));
    expect(helpSheet, findsOneWidget);
    expect(handle, findsOneWidget);

    final dragStart = tester.getRect(handle).center;
    await tester.dragFrom(dragStart, const Offset(0, 220));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('help-sheet')), findsNothing);
  });

  testWidgets('settings and help sheets can open independently',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester.tap(find.byKey(const ValueKey<String>('help-guide-button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey<String>('help-sheet')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-sheet')), findsNothing);

    await tester.tapAt(Offset.zero);
    await tester.pumpAndSettle();

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();
    expect(
        find.byKey(const ValueKey<String>('settings-sheet')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('help-sheet')), findsNothing);
  });

  for (final (
        locale,
        campaignTypesTitle,
        tipsTitle,
        sampleTip,
      ) in <(Locale, String, String, String)>[
    (
      const Locale('it'),
      'Tipi di campagna',
      'Consigli e buone pratiche',
      'Scegli un twist per dare subito tensione alla trama.',
    ),
    (
      const Locale('en'),
      'Campaign types',
      'Tips & best practices',
      'Pick a twist to give the plot immediate tension.',
    ),
    (
      const Locale('es'),
      'Tipos de campaña',
      'Consejos y buenas prácticas',
      'Elige un giro para dar tensión inmediata a la trama.',
    ),
    (
      const Locale('fr'),
      'Types de campagne',
      'Conseils et bonnes pratiques',
      'Choisis un twist pour donner tout de suite de la tension à l’intrigue.',
    ),
    (
      const Locale('de'),
      'Kampagnentypen',
      'Tipps & Best Practices',
      'Wähle einen Twist, um der Handlung sofort Spannung zu geben.',
    ),
  ]) {
    testWidgets(
        'help sheet localizes static guide content for ${locale.languageCode}',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_testApp(currentLocale: locale));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));

      await tester.tap(find.byKey(const ValueKey<String>('help-guide-button')));
      await tester.pumpAndSettle();

      final helpSheet = find.byKey(const ValueKey<String>('help-sheet'));
      expect(
        find.descendant(of: helpSheet, matching: find.text(campaignTypesTitle)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: helpSheet, matching: find.text(tipsTitle)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: helpSheet, matching: find.text(sampleTip)),
        findsOneWidget,
      );
    });
  }

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

  testWidgets('settings share passes a non-empty origin rect to share_plus',
      (tester) async {
    Map<dynamic, dynamic>? capturedArguments;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/share'),
      (call) async {
        if (call.method == 'share') {
          capturedArguments = call.arguments as Map<dynamic, dynamic>;
          return 'dev.fluttercommunity.plus/share/success';
        }
        return null;
      },
    );
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('dev.fluttercommunity.plus/share'),
        null,
      );
    });

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('settings-share-row')));
    await tester.pumpAndSettle();

    expect(capturedArguments, isNotNull);
    expect(capturedArguments!['originWidth'], isNotNull);
    expect(capturedArguments!['originHeight'], isNotNull);
    expect(capturedArguments!['originWidth'] as double, greaterThan(0));
    expect(capturedArguments!['originHeight'] as double, greaterThan(0));
  },
      variant:
          const TargetPlatformVariant(<TargetPlatform>{TargetPlatform.iOS}));

  testWidgets('settings sheet shows ad-free title and small purchase subtitle',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    final row = find.byKey(const ValueKey<String>('settings-go-ad-free-row'));
    expect(row, findsOneWidget);
    expect(
      find.descendant(of: row, matching: find.text('Rimuovi le pubblicità')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: row,
        matching: find.text('Acquisto una tantum · £1.99'),
      ),
      findsOneWidget,
    );

    final subtitle = tester.widget<Text>(
      find.descendant(
        of: row,
        matching: find.text('Acquisto una tantum · £1.99'),
      ),
    );
    final theme = buildFantasyTheme();
    expect(subtitle.style?.color, theme.fantasy.accent);
    expect(
      subtitle.style?.fontSize,
      theme.textTheme.labelSmall?.fontSize,
    );
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
    expect(find.byKey(const ValueKey<String>('settings-theme-control')),
        findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('settings-theme-control')),
        matching: find.byIcon(Icons.nightlight_round),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('settings-theme-control')),
        matching: find.byIcon(Icons.wb_sunny_rounded),
      ),
      findsOneWidget,
    );
  });

  testWidgets('settings sheet shows language segmented control',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    expect(find.text('Lingua'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-language-control')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-language-segment-en')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-language-segment-it')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-language-segment-es')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-language-segment-fr')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-language-segment-de')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-language-mark-en')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-language-mark-it')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-language-mark-es')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-language-mark-fr')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-language-mark-de')),
        findsOneWidget);
  });

  testWidgets('settings sheet language segments do not overflow on mobile',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    final exceptions = <Object>[];
    Object? exception;
    while ((exception = tester.takeException()) != null) {
      exceptions.add(exception!);
    }

    expect(exceptions, isEmpty);
  });

  testWidgets(
      'settings sheet language segments do not overflow with modest text scaling',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester
        .pumpWidget(_testApp(textScaler: const TextScaler.linear(1.15)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    final exceptions = <Object>[];
    Object? exception;
    while ((exception = tester.takeException()) != null) {
      exceptions.add(exception!);
    }

    expect(exceptions, isEmpty);
  });

  testWidgets(
      'opening settings sheet does not emit language segment overflow during animation',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));

    final exceptions = <Object>[];
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 16));
      Object? exception;
      while ((exception = tester.takeException()) != null) {
        exceptions.add(exception!);
      }
    }

    expect(exceptions, isEmpty);
  });

  testWidgets(
      'settings sheet language segments do not overflow on compact phones',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    final exceptions = <Object>[];
    Object? exception;
    while ((exception = tester.takeException()) != null) {
      exceptions.add(exception!);
    }

    expect(exceptions, isEmpty);
  });

  testWidgets(
      'settings sheet language segments do not overflow on compact phones with larger text',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp(textScaler: const TextScaler.linear(1.3)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    final exceptions = <Object>[];
    Object? exception;
    while ((exception = tester.takeException()) != null) {
      exceptions.add(exception!);
    }

    expect(exceptions, isEmpty);
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

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>('settings-theme-control')),
        matching: find.byIcon(Icons.wb_sunny_rounded),
      ),
    );
    await tester.pumpAndSettle();

    expect(selectedTheme, ThemeMode.light);
    expect(
        find.byKey(const ValueKey<String>('settings-sheet')), findsOneWidget);
  });

  testWidgets(
      'settings sheet language control triggers callback and closes sheet',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    Locale? selectedLocale;

    await tester.pumpWidget(
      _testApp(
        currentLocale: const Locale('it'),
        onLocaleChanged: (locale) {
          selectedLocale = locale;
        },
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    await tester.tap(
      find.ancestor(
        of: find.byKey(
          const ValueKey<String>('settings-language-segment-en'),
        ),
        matching: find.byType(TextButton),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(selectedLocale, const Locale('en'));
    expect(find.byKey(const ValueKey<String>('settings-sheet')), findsNothing);
  });

  testWidgets(
      'changing locale resets localized selections and reloads localized options',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const _LocaleReactiveTestApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester.tap(
      find.byKey(const ValueKey<String>('entry-campaign-card-Mini-campagna')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mini-campagna'), findsWidgets);

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    await tester.tap(
      find.ancestor(
        of: find.byKey(
          const ValueKey<String>('settings-language-segment-en'),
        ),
        matching: find.byType(TextButton),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Choose format'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('entry-campaign-card-Mini-campaign')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('entry-campaign-card-Mini-campagna')),
      findsNothing,
    );
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

  testWidgets(
      'settings sheet is dismissed by dragging down from the top handle',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    final settingsSheet = find.byKey(const ValueKey<String>('settings-sheet'));
    final handle =
        find.byKey(const ValueKey<String>('settings-sheet-drag-handle'));
    expect(settingsSheet, findsOneWidget);
    expect(handle, findsOneWidget);

    final dragStart = tester.getRect(handle).center;
    await tester.dragFrom(dragStart, const Offset(0, 220));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('settings-sheet')), findsNothing);
  });

  testWidgets('settings sheet updates its own theme immediately',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const _ThemeReactiveTestApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    final settingsSheet = find.byKey(const ValueKey<String>('settings-sheet'));

    Color sheetColor() {
      final container = tester.widget<Container>(settingsSheet);
      final decoration = container.decoration! as BoxDecoration;
      return decoration.color!;
    }

    expect(sheetColor(), FantasyThemeColors.dark.card);

    await tester.tap(find.byIcon(Icons.wb_sunny_rounded));
    await tester.pumpAndSettle();

    expect(
        find.byKey(const ValueKey<String>('settings-sheet')), findsOneWidget);
    expect(sheetColor(), FantasyThemeColors.light.card);
  });

  testWidgets('settings sheet animates its content with a fade transition',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('settings-sheet')),
        matching: find.byType(FadeTransition),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
      'settings sheet content is immediately visible with reduced motion',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp(disableAnimations: true));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester
        .tap(find.byKey(const ValueKey<String>('info-settings-button')));
    await tester.pump();

    final fadeTransition = tester.widget<FadeTransition>(
      find.descendant(
        of: find.byKey(const ValueKey<String>('settings-sheet')),
        matching: find.byType(FadeTransition),
      ),
    );

    expect(fadeTransition.opacity.value, 1);
  });
}

Widget _testApp({
  Locale currentLocale = const Locale('it'),
  ValueChanged<Locale>? onLocaleChanged,
  ThemeMode currentThemeMode = ThemeMode.dark,
  ValueChanged<ThemeMode>? onThemeModeChanged,
  bool disableAnimations = false,
  TextScaler textScaler = TextScaler.noScaling,
}) =>
    MaterialApp(
      locale: currentLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context).copyWith(
          disableAnimations: disableAnimations,
          textScaler: textScaler,
        );
        return MediaQuery(data: mediaQuery, child: child!);
      },
      home: CampaignBuilderPage(
        service: FakeCampaignService(minimalOptions()),
        currentLocale: currentLocale,
        onLocaleChanged: onLocaleChanged ?? (_) {},
        currentThemeMode: currentThemeMode,
        onThemeModeChanged: onThemeModeChanged,
      ),
    );

class _ThemeReactiveTestApp extends StatefulWidget {
  const _ThemeReactiveTestApp();

  @override
  State<_ThemeReactiveTestApp> createState() => _ThemeReactiveTestAppState();
}

class _ThemeReactiveTestAppState extends State<_ThemeReactiveTestApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildFantasyLightTheme(),
      darkTheme: buildFantasyTheme(),
      themeMode: _themeMode,
      locale: const Locale('it'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: CampaignBuilderPage(
        service: FakeCampaignService(minimalOptions()),
        currentLocale: const Locale('it'),
        onLocaleChanged: (_) {},
        currentThemeMode: _themeMode,
        onThemeModeChanged: (themeMode) {
          setState(() {
            _themeMode = themeMode;
          });
        },
      ),
    );
  }
}

class _LocaleReactiveTestApp extends StatefulWidget {
  const _LocaleReactiveTestApp();

  @override
  State<_LocaleReactiveTestApp> createState() => _LocaleReactiveTestAppState();
}

class _LocaleReactiveTestAppState extends State<_LocaleReactiveTestApp> {
  Locale _locale = const Locale('it');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        final data = MediaQuery.of(context).copyWith(disableAnimations: true);
        return MediaQuery(data: data, child: child!);
      },
      home: CampaignBuilderPage(
        service: _LocaleAwareFakeCampaignService(),
        currentLocale: _locale,
        onLocaleChanged: (locale) {
          setState(() {
            _locale = locale;
          });
        },
      ),
    );
  }
}

class _LocaleAwareFakeCampaignService extends FakeCampaignService {
  _LocaleAwareFakeCampaignService() : super(_localeAwareOptions('it'));

  @override
  Future<CampaignOptions> getOptions({String localeCode = 'it'}) async {
    return _localeAwareOptions(localeCode);
  }
}

CampaignOptions _localeAwareOptions(String localeCode) {
  switch (localeCode) {
    case 'en':
      return CampaignOptions(
        settings: const ['Forgotten Realms'],
        campaignTypes: const ['One-Shot', 'Mini-campaign'],
        themes: const ['Intrigue'],
        tones: const ['Epic'],
        styles: const ['Linear'],
        partyArchetypes: const ['Tank'],
        twists: const ['Betrayal'],
        presets: const {},
        settingDescriptions: const {
          'Forgotten Realms': 'Classic high fantasy.',
        },
        presetDescriptions: const {},
        presetNames: const {},
      );
    default:
      return CampaignOptions(
        settings: const ['Forgotten Realms'],
        campaignTypes: const ['One-Shot', 'Mini-campagna'],
        themes: const ['Intrigo'],
        tones: const ['Epico'],
        styles: const ['Lineare'],
        partyArchetypes: const ['Tank'],
        twists: const ['Tradimento'],
        presets: const {},
        settingDescriptions: const {
          'Forgotten Realms': 'Classico high fantasy.',
        },
        presetDescriptions: const {},
        presetNames: const {},
      );
  }
}
