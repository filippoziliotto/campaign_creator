import 'package:campaign_creator_flutter/src/app.dart';
import 'package:campaign_creator_flutter/src/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('CampaignCreatorApp follows a supported device locale on first launch', (
    tester,
  ) async {
    tester.binding.platformDispatcher.localesTestValue = const <Locale>[
      Locale('it'),
    ];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(
      CampaignCreatorApp(
        homeBuilder: (_, onLocaleChanged) => _LocaleProbe(
          onLocaleChanged: onLocaleChanged,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Creatore Campagne D&D'), findsOneWidget);
    expect(find.text('locale:it'), findsOneWidget);
    expect(find.text('IT | EN'), findsOneWidget);
    expect(find.text('free-format:Scegli formato'), findsOneWidget);
    expect(find.text('seal:Forgia pergamena'), findsOneWidget);
  });

  testWidgets('CampaignCreatorApp falls back to English for unsupported device locale', (
    tester,
  ) async {
    tester.binding.platformDispatcher.localesTestValue = const <Locale>[
      Locale('fr'),
    ];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(
      CampaignCreatorApp(
        homeBuilder: (_, onLocaleChanged) => _LocaleProbe(
          onLocaleChanged: onLocaleChanged,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('D&D Campaign Creator'), findsOneWidget);
    expect(find.text('locale:en'), findsOneWidget);
    expect(find.text('free-format:Choose format'), findsOneWidget);
    expect(find.text('seal:Seal parchment'), findsOneWidget);
  });

  testWidgets('CampaignCreatorApp switches locale at runtime without restart', (
    tester,
  ) async {
    await tester.pumpWidget(
      CampaignCreatorApp(
        homeBuilder: (_, onLocaleChanged) => _LocaleProbe(
          onLocaleChanged: onLocaleChanged,
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('switch-en')));
    await tester.pumpAndSettle();

    expect(find.text('D&D Campaign Creator'), findsOneWidget);
    expect(find.text('locale:en'), findsOneWidget);
    expect(find.text('free-format:Choose format'), findsOneWidget);
    expect(find.text('seal:Seal parchment'), findsOneWidget);
  });

  testWidgets('CampaignCreatorApp restores the saved locale on startup', (
    tester,
  ) async {
    tester.binding.platformDispatcher.localesTestValue = const <Locale>[
      Locale('it'),
    ];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    SharedPreferences.setMockInitialValues(<String, Object>{
      'app.locale_code': 'en',
    });

    await tester.pumpWidget(
      CampaignCreatorApp(
        homeBuilder: (_, onLocaleChanged) => _LocaleProbe(
          onLocaleChanged: onLocaleChanged,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('D&D Campaign Creator'), findsOneWidget);
    expect(find.text('locale:en'), findsOneWidget);
    expect(find.text('free-format:Choose format'), findsOneWidget);
    expect(find.text('seal:Seal parchment'), findsOneWidget);
  });
}

class _LocaleProbe extends StatelessWidget {
  const _LocaleProbe({
    required this.onLocaleChanged,
  });

  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.appTitle),
            Text('locale:$localeCode'),
            Text('free-format:${context.l10n.appFreeFormat}'),
            Text('seal:${context.l10n.appSealParchment}'),
            Text(
              '${context.l10n.languageItalianShort} | ${context.l10n.languageEnglishShort}',
            ),
            const SizedBox(height: 12),
            TextButton(
              key: const Key('switch-it'),
              onPressed: () => onLocaleChanged(const Locale('it')),
              child: const Text('IT'),
            ),
            TextButton(
              key: const Key('switch-en'),
              onPressed: () => onLocaleChanged(const Locale('en')),
              child: const Text('EN'),
            ),
          ],
        ),
      ),
    );
  }
}
