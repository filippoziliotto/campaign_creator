import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/ui/pages/shell/campaign_builder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus/share_plus.dart';
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

  testWidgets('share forwards a non-empty origin rect to the share delegate', (
    tester,
  ) async {
    ShareParams? captured;

    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
          sharePrompt: (params) async {
            captured = params;
            return const ShareResult('', ShareResultStatus.success);
          },
        ),
      ),
    );

    await _pumpUi(tester);
    await _openSavedParchment(tester);

    await tester.tap(find.text('Condividi'));
    await _pumpUi(tester);

    expect(captured, isNotNull);
    expect(captured!.sharePositionOrigin, isNotNull);
    expect(captured!.sharePositionOrigin!.width, greaterThan(0));
    expect(captured!.sharePositionOrigin!.height, greaterThan(0));
  },
      variant:
          const TargetPlatformVariant(<TargetPlatform>{TargetPlatform.iOS}));

  testWidgets('share shows a snackbar when sharing is unavailable on device', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
          sharePrompt: (_) async => ShareResult.unavailable,
        ),
      ),
    );

    await _pumpUi(tester);
    await _openSavedParchment(tester);

    await tester.tap(find.text('Condividi'));
    await _pumpUi(tester);

    expect(
      find.text('La condivisione non è disponibile su questo dispositivo.'),
      findsOneWidget,
    );
  },
      variant:
          const TargetPlatformVariant(<TargetPlatform>{TargetPlatform.iOS}));

  testWidgets('share stays silent when the share sheet is dismissed', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
          sharePrompt: (_) async =>
              const ShareResult('', ShareResultStatus.dismissed),
        ),
      ),
    );

    await _pumpUi(tester);
    await _openSavedParchment(tester);

    await tester.tap(find.text('Condividi'));
    await _pumpUi(tester);

    expect(
      find.text('La condivisione non è disponibile su questo dispositivo.'),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  },
      variant:
          const TargetPlatformVariant(<TargetPlatform>{TargetPlatform.iOS}));

  testWidgets('share keeps the existing no-parchment snackbar', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(minimalOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
          sharePrompt: (_) async => ShareResult.unavailable,
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

    await _flingSection(
      tester,
      find.byKey(const ValueKey<String>('forge-section-party')),
      const Offset(-500, 0),
    );
    await _pumpUi(tester);

    await _flingSection(
      tester,
      find.byKey(const ValueKey<String>('forge-section-narrative')),
      const Offset(-500, 0),
    );
    await _pumpUi(tester);

    await tester.tap(find.text('Condividi'));
    await _pumpUi(tester);

    expect(
      find.text("Non c'è ancora una pergamena da condividere."),
      findsOneWidget,
    );
  },
      variant:
          const TargetPlatformVariant(<TargetPlatform>{TargetPlatform.iOS}));
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

Future<void> _openSavedParchment(WidgetTester tester) async {
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
