import 'dart:convert';

import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/services/backend_api.dart';
import 'package:campaign_creator_flutter/src/ui/pages/routes/entry_page.dart';
import 'package:campaign_creator_flutter/src/ui/pages/routes/parchment_page.dart';
import 'package:campaign_creator_flutter/src/ui/pages/shell/campaign_builder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    });

    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final api = BackendApi(
      baseUrl: 'http://localhost:8000',
      client: MockClient((request) async {
        if (request.url.path == '/options') {
          return http.Response(
            jsonEncode({
              'settings': ['Forgotten Realms'],
              'campaign_types': ['One-Shot'],
              'themes': ['Intrigo'],
              'tones': ['Epico'],
              'styles': ['Lineare'],
              'party_archetypes': ['Tank'],
              'twists': ['Tradimento'],
              'presets': {},
              'setting_descriptions': {
                'Forgotten Realms': 'Classico high fantasy.',
              },
              'preset_descriptions': {},
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        throw UnimplementedError('Unexpected request: ${request.url}');
      }),
    );

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          api: api,
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    await tester.tap(find.text('Riprendi la forgia'));
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

    final api = BackendApi(
      baseUrl: 'http://localhost:8000',
      client: MockClient((request) async {
        if (request.url.path == '/options') {
          return http.Response(
            jsonEncode({
              'settings': ['Forgotten Realms'],
              'campaign_types': ['One-Shot'],
              'themes': ['Intrigo'],
              'tones': ['Epico'],
              'styles': ['Lineare'],
              'party_archetypes': ['Tank'],
              'twists': ['Tradimento'],
              'presets': {},
              'setting_descriptions': {
                'Forgotten Realms': 'Classico high fantasy.',
              },
              'preset_descriptions': {},
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        throw UnimplementedError('Unexpected request: ${request.url}');
      }),
    );

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          api: api,
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    await tester.tap(find.text('One-Shot').last);
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

    final api = BackendApi(
      baseUrl: 'http://localhost:8000',
      client: MockClient((request) async {
        if (request.url.path == '/options') {
          return http.Response(
            jsonEncode({
              'settings': ['Forgotten Realms'],
              'campaign_types': ['One-Shot'],
              'themes': ['Intrigo'],
              'tones': ['Epico'],
              'styles': ['Lineare'],
              'party_archetypes': ['Tank'],
              'twists': ['Tradimento'],
              'presets': {},
              'setting_descriptions': {
                'Forgotten Realms': 'Classico high fantasy.',
              },
              'preset_descriptions': {},
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        throw UnimplementedError('Unexpected request: ${request.url}');
      }),
    );

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          api: api,
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    await tester.tap(find.text('One-Shot').last);
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

  testWidgets('dragging the party slider does not change forge section', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final api = BackendApi(
      baseUrl: 'http://localhost:8000',
      client: MockClient((request) async {
        if (request.url.path == '/options') {
          return http.Response(
            jsonEncode({
              'settings': ['Forgotten Realms'],
              'campaign_types': ['One-Shot'],
              'themes': ['Intrigo'],
              'tones': ['Epico'],
              'styles': ['Lineare'],
              'party_archetypes': ['Tank'],
              'twists': ['Tradimento'],
              'presets': {},
              'setting_descriptions': {
                'Forgotten Realms': 'Classico high fantasy.',
              },
              'preset_descriptions': {},
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        throw UnimplementedError('Unexpected request: ${request.url}');
      }),
    );

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          api: api,
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    await tester.tap(find.text('One-Shot').last);
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

    final api = BackendApi(
      baseUrl: 'http://localhost:8000',
      client: MockClient((request) async {
        if (request.url.path == '/options') {
          return http.Response(
            jsonEncode({
              'settings': ['Forgotten Realms'],
              'campaign_types': ['One-Shot'],
              'themes': ['Intrigo'],
              'tones': ['Epico'],
              'styles': ['Lineare'],
              'party_archetypes': ['Tank'],
              'twists': ['Tradimento'],
              'presets': {},
              'setting_descriptions': {
                'Forgotten Realms': 'Classico high fantasy.',
              },
              'preset_descriptions': {},
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        throw UnimplementedError('Unexpected request: ${request.url}');
      }),
    );

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          api: api,
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);

    await tester.tap(find.text('Riprendi la forgia'));
    await _pumpUi(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Apri pergamena'));
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
