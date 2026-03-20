import 'dart:convert';

import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/services/backend_api.dart';
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

  testWidgets(
      'world section shows presets in a dedicated panel below the top row',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          api: _buildTestApi(),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await tester.tap(find.text('Apri la forgia'));
    await _pumpUi(tester);

    expect(find.text('Impostazioni base'), findsOneWidget);
    expect(find.text('Ambientazione e scenario.'), findsOneWidget);
    expect(find.text('Preset rapidi'), findsOneWidget);
    expect(find.text('Preset rapido'), findsOneWidget);

    final twistY = tester.getTopLeft(find.text('Twist iniziale')).dy;
    final presetsY = tester.getTopLeft(find.text('Preset rapidi')).dy;

    expect(presetsY, greaterThan(twistY));
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));

  testWidgets('applying a preset still unlocks the world advance action',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          api: _buildTestApi(),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await tester.tap(find.text('Apri la forgia'));
    await _pumpUi(tester);

    final advanceButton = find.widgetWithText(FilledButton, 'Vai al Party');
    expect(tester.widget<FilledButton>(advanceButton).onPressed, isNull);

    final presetDropdown = find.byWidgetPredicate(
      (widget) =>
          widget is DropdownButtonFormField<String> &&
          widget.decoration.labelText == 'Preset rapido',
    );

    await tester.tap(presetDropdown);
    await _pumpUi(tester);
    await tester.tap(find.text('Cronache del Porto').last);
    await _pumpUi(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Applica'));
    await _pumpUi(tester);

    expect(tester.widget<FilledButton>(advanceButton).onPressed, isNotNull);
    expect(find.text('Metropoli magica e pulp noir.'), findsOneWidget);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));
}

BackendApi _buildTestApi() {
  return BackendApi(
    baseUrl: 'http://localhost:8000',
    client: MockClient((request) async {
      if (request.url.path == '/options') {
        return http.Response(
          jsonEncode({
            'settings': ['Forgotten Realms', 'Eberron'],
            'campaign_types': ['One-Shot'],
            'themes': ['Intrigo'],
            'tones': ['Epico'],
            'styles': ['Lineare'],
            'party_archetypes': ['Tank'],
            'twists': ['Tradimento', 'Portale'],
            'presets': {
              'Cronache del Porto': {
                'campaign_type': 'one-shot',
                'setting': 'Eberron',
                'twist': 'Tradimento',
                'theme': 'Intrigo',
                'tone': 'Epico',
                'style': 'Lineare',
                'party_level': 5,
                'party_size': 4,
              },
            },
            'setting_descriptions': {
              'Forgotten Realms': 'Classico high fantasy.',
              'Eberron': 'Metropoli magica e pulp noir.',
            },
            'preset_descriptions': {
              'Cronache del Porto': 'Intrighi nei moli e faide tra casate.',
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }

      throw UnimplementedError('Unexpected request: ${request.url}');
    }),
  );
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
