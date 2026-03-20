import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/ui/pages/design/campaign_builder_primitives.dart';
import 'package:campaign_creator_flutter/src/ui/pages/shell/campaign_builder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_campaign_service.dart';

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
          service: FakeCampaignService(presetsOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

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
          service: FakeCampaignService(presetsOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

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

  testWidgets('world forge panels use descending visual emphasis',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        child: CampaignBuilderPage(
          service: FakeCampaignService(presetsOptions()),
          currentLocale: const Locale('it'),
          onLocaleChanged: (_) {},
        ),
      ),
    );

    await _pumpUi(tester);
    await _openForgeFromEntry(tester);

    final worldFrame =
        find.widgetWithText(SectionFrame, 'Costruzione del Mondo');
    final presetFrame = find.widgetWithText(SectionFrame, 'Scegli un preset');
    final foundationPanel =
        find.widgetWithText(ControlRoomPanel, 'Impostazioni base');
    final creativePanel =
        find.widgetWithText(ControlRoomPanel, 'Temi, tono e stile');
    final twistPanel = find.widgetWithText(ControlRoomPanel, 'Twist iniziale');

    expect(
      tester.widget<SectionFrame>(worldFrame).emphasis,
      PanelEmphasis.primary,
    );
    expect(
      tester.widget<SectionFrame>(presetFrame).emphasis,
      PanelEmphasis.secondary,
    );
    expect(
      tester.widget<ControlRoomPanel>(foundationPanel).emphasis,
      PanelEmphasis.primary,
    );
    expect(
      tester.widget<ControlRoomPanel>(creativePanel).emphasis,
      PanelEmphasis.secondary,
    );
    expect(
      tester.widget<ControlRoomPanel>(twistPanel).emphasis,
      PanelEmphasis.tertiary,
    );

    expect(_backgroundAlpha(tester, worldFrame),
        greaterThan(_backgroundAlpha(tester, presetFrame)));
    expect(_backgroundAlpha(tester, foundationPanel),
        greaterThan(_backgroundAlpha(tester, creativePanel)));
    expect(_backgroundAlpha(tester, creativePanel),
        greaterThan(_backgroundAlpha(tester, twistPanel)));
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

Future<void> _openForgeFromEntry(WidgetTester tester) async {
  final oneShotCard = find.byKey(
    const ValueKey<String>('entry-campaign-card-One-Shot'),
  );
  await tester.ensureVisible(oneShotCard);
  await tester.tap(oneShotCard);
  await _pumpUi(tester);
}

int _backgroundAlpha(WidgetTester tester, Finder finder) {
  final container = tester.widget<Container>(
    find
        .descendant(
          of: finder,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Container && widget.decoration is BoxDecoration,
          ),
        )
        .first,
  );
  final decoration = container.decoration! as BoxDecoration;
  return (decoration.color!.a * 255.0).round().clamp(0, 255);
}
