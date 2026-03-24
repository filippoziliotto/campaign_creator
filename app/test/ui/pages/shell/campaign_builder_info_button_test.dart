import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:campaign_creator_flutter/src/theme/fantasy_theme.dart';
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
    expect(find.byKey(const ValueKey<String>('settings-language-mark-en')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-language-mark-it')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-language-mark-es')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('settings-language-mark-fr')),
        findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('settings-language-mark-en')),
        matching: find.text('GB'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('settings-language-mark-it')),
        matching: find.text('IT'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('settings-language-mark-es')),
        matching: find.text('ES'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('settings-language-mark-fr')),
        matching: find.text('FR'),
      ),
      findsOneWidget,
    );
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
    await tester.pumpAndSettle();

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
}) =>
    MaterialApp(
      locale: currentLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context)
            .copyWith(disableAnimations: disableAnimations);
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
