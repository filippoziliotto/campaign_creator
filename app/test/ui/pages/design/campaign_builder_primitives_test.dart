import 'package:animations/animations.dart';
import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/theme/fantasy_theme.dart';
import 'package:campaign_creator_flutter/src/ui/pages/design/campaign_builder_atmosphere.dart';
import 'package:campaign_creator_flutter/src/ui/pages/design/campaign_builder_primitives.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

const CampaignAtmosphereData _testAtmosphere = CampaignAtmosphereData(
  id: 'test',
  label: 'Test',
  primary: Color(0xFFC2482D),
  secondary: Color(0xFFF0A35B),
  highlight: Color(0xFFF5E6C9),
  cardTint: Color(0xFF4C1E17),
  linework: Color(0xFF8A3A28),
  glow: Color(0xFFE46B3C),
  backdropVariant: CampaignBackdropVariant.emberRush,
  routeTransitionType: SharedAxisTransitionType.horizontal,
  sectionTransitionType: SharedAxisTransitionType.horizontal,
  routeTransitionDuration: Duration(milliseconds: 420),
  reverseRouteTransitionDuration: Duration(milliseconds: 320),
  sectionTransitionDuration: Duration(milliseconds: 260),
  revealDuration: Duration(milliseconds: 520),
  revealDistance: 30,
  cardHoverLift: 14,
  cardHoverTilt: 0.095,
  chipFlashDuration: Duration(milliseconds: 300),
  ctaPulseDuration: Duration(milliseconds: 1300),
  parchmentUnfoldDuration: Duration(milliseconds: 620),
  parchmentUnfoldCurve: Curves.easeOutCubic,
);

void main() {
  testWidgets(
    'CampaignModeCard fits within its compact height without overflow',
    (tester) async {
      await tester.pumpWidget(
        _localizedTestApp(
          child: Center(
            child: SizedBox(
              width: 399.2,
              child: CampaignModeCard(
                atmosphere: _testAtmosphere,
                title: 'Campagna lunga',
                badge: 'Saga ampia',
                description:
                    'Fazioni, cambi di equilibrio e sottotrame persistenti per una campagna da far crescere nel tempo.',
                emblemAsset: 'assets/entry_cards/long_campaign_emblem.svg',
                fallbackIcon: Icons.account_tree_rounded,
                colors: const <Color>[
                  Color(0xFF47644A),
                  Color(0xFF1E2E22),
                ],
                artAsset: 'assets/entry_cards/campagna_lunga.jpg',
                selected: false,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Campagna lunga'), findsOneWidget);
      expect(find.text('Apri la forgia'), findsNothing);
    },
  );

  testWidgets(
    'CampaignModeCard emphasizes CTA only when selected',
    (tester) async {
      await tester.pumpWidget(
        _localizedTestApp(
          child: Center(
            child: SizedBox(
              width: 399.2,
              child: CampaignModeCard(
                atmosphere: _testAtmosphere,
                title: 'One-Shot',
                badge: 'Singola',
                description: 'Una missione ad alto impatto.',
                emblemAsset: 'assets/entry_cards/one_shot_emblem.svg',
                fallbackIcon: Icons.bolt_rounded,
                colors: const <Color>[
                  Color(0xFFB03A2E),
                  Color(0xFF6D2018),
                ],
                artAsset: 'assets/entry_cards/one_shot.jpg',
                selected: true,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Apri la forgia'), findsOneWidget);
    },
  );

  testWidgets(
    'CampaignModeCard allows entry descriptions to wrap on compact layouts',
    (tester) async {
      const description =
          'Una missione ad alto impatto con fronti, pressioni e svolte che devono respirare anche su schermi compatti.';

      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _localizedTestApp(
          child: Center(
            child: SizedBox(
              width: 358,
              child: CampaignModeCard(
                atmosphere: _testAtmosphere,
                title: 'One-Shot',
                badge: 'Singola',
                description: description,
                emblemAsset: 'assets/entry_cards/one_shot_emblem.svg',
                fallbackIcon: Icons.bolt_rounded,
                colors: const <Color>[
                  Color(0xFFB03A2E),
                  Color(0xFF6D2018),
                ],
                artAsset: 'assets/entry_cards/one_shot.jpg',
                selected: false,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(
        tester.widget<Text>(find.text(description)).maxLines,
        3,
      );
    },
  );

  testWidgets(
    'CampaignModeCard renders a heraldic SVG emblem without overflow',
    (tester) async {
      await tester.pumpWidget(
        _localizedTestApp(
          child: Center(
            child: SizedBox(
              width: 399.2,
              child: CampaignModeCard(
                atmosphere: _testAtmosphere,
                title: 'Mini-campagna',
                badge: 'Arco breve',
                description: 'Viaggio, bussola e tappe ravvicinate.',
                emblemAsset: 'assets/entry_cards/mini_campaign_emblem.svg',
                fallbackIcon: Icons.hiking_rounded,
                colors: const <Color>[
                  Color(0xFF9A6A2F),
                  Color(0xFF5A3318),
                ],
                artAsset: 'assets/entry_cards/campagna_corta.jpg',
                selected: false,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('campaign-mode-card-fallback-icon')),
        findsNothing,
      );
    },
  );

  testWidgets(
    'CampaignModeCard falls back to the icon when emblem asset is missing',
    (tester) async {
      await tester.pumpWidget(
        _localizedTestApp(
          child: Center(
            child: SizedBox(
              width: 399.2,
              child: CampaignModeCard(
                atmosphere: _testAtmosphere,
                title: 'Dungeon crawl',
                badge: 'Profondita',
                description: 'Torce, discese e sale infestate.',
                emblemAsset: 'assets/entry_cards/missing_emblem.svg',
                fallbackIcon: Icons.layers_rounded,
                colors: const <Color>[
                  Color(0xFF5E4C80),
                  Color(0xFF292036),
                ],
                artAsset: 'assets/entry_cards/dungeon.jpg',
                selected: true,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('campaign-mode-card-fallback-icon')),
        findsOneWidget,
      );
      expect(find.byType(SvgPicture), findsOneWidget);
    },
  );

  testWidgets(
    'StagePill uses contrasting index text color when completed',
    (tester) async {
      await tester.pumpWidget(
        _localizedTestApp(
          child: const StagePill(
            index: 3,
            label: 'Pergamena',
            active: false,
            enabled: true,
            completed: true,
            onTap: null,
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('3'));
      expect(text.style?.color, isNot(Colors.black));
    },
  );

  testWidgets(
    'StagePill sequence stays on one row when enough horizontal space exists',
    (tester) async {
      await tester.pumpWidget(
        _localizedTestApp(
          child: Center(
            child: SizedBox(
              width: 320,
              child: StagePillRibbon(
                children: const [
                  StagePill(
                    index: 1,
                    label: 'Scelta',
                    active: true,
                    enabled: true,
                    completed: true,
                    onTap: null,
                  ),
                  StagePill(
                    index: 2,
                    label: 'Forgia',
                    active: false,
                    enabled: true,
                    completed: false,
                    onTap: null,
                  ),
                  StagePill(
                    index: 3,
                    label: 'Pergamena',
                    active: false,
                    enabled: true,
                    completed: false,
                    onTap: null,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      final sceltaY = tester.getCenter(find.text('Scelta')).dy;
      final forgiaY = tester.getCenter(find.text('Forgia')).dy;
      final pergamenaY = tester.getCenter(find.text('Pergamena')).dy;

      expect(forgiaY, sceltaY);
      expect(pergamenaY, sceltaY);
    },
  );

  testWidgets(
    'ForgeActionStrip does not render the previous button',
    (tester) async {
      await tester.pumpWidget(
        _localizedTestApp(
          child: ForgeActionStrip(
            atmosphere: _testAtmosphere,
            readinessHint: 'Pronto a forgiare.',
            isPrimaryEnabled: true,
            isGenerating: false,
            primaryLabel: 'Avanza',
            primaryIcon: Icons.arrow_forward_rounded,
            onRetreat: () {},
            onAdvance: () {},
            parchmentReady: false,
            hasUnsavedChanges: false,
            onOpenParchment: () {},
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Precedente'), findsNothing);
      expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
      expect(find.text('Avanza'), findsOneWidget);
    },
  );

  testWidgets(
    'SectionFrame defaults to compact framing without decorative divider',
    (tester) async {
      await tester.pumpWidget(
        _localizedTestApp(
          child: const SectionFrame(
            title: 'Titolo sezione',
            child: Text('Contenuto'),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Titolo sezione'), findsOneWidget);
      expect(find.text('Contenuto'), findsOneWidget);
      expect(find.byType(RuneDivider), findsNothing);
    },
  );

  testWidgets(
    'SectionFrame defaults to primary emphasis and ControlRoomPanel defaults to secondary emphasis',
    (tester) async {
      await tester.pumpWidget(
        _localizedTestApp(
          child: Column(
            children: const [
              SectionFrame(
                title: 'Sezione primaria',
                child: Text('Contenuto sezione'),
              ),
              ControlRoomPanel(
                title: 'Pannello secondario',
                child: Text('Contenuto pannello'),
              ),
            ],
          ),
        ),
      );

      await tester.pump();

      expect(
        tester.widget<SectionFrame>(find.byType(SectionFrame)),
        isA<SectionFrame>().having(
          (widget) => widget.emphasis,
          'emphasis',
          PanelEmphasis.primary,
        ),
      );
      expect(
        tester.widget<ControlRoomPanel>(find.byType(ControlRoomPanel)),
        isA<ControlRoomPanel>().having(
          (widget) => widget.emphasis,
          'emphasis',
          PanelEmphasis.secondary,
        ),
      );
    },
  );

  testWidgets(
    'ControlRoomPanel emphasis reduces visual weight from primary to tertiary',
    (tester) async {
      await tester.pumpWidget(
        _localizedTestApp(
          child: Column(
            children: const [
              ControlRoomPanel(
                title: 'Primario',
                emphasis: PanelEmphasis.primary,
                child: Text('A'),
              ),
              ControlRoomPanel(
                title: 'Secondario',
                emphasis: PanelEmphasis.secondary,
                child: Text('B'),
              ),
              ControlRoomPanel(
                title: 'Terziario',
                emphasis: PanelEmphasis.tertiary,
                child: Text('C'),
              ),
            ],
          ),
        ),
      );

      await tester.pump();

      final primary = _panelBackgroundAlpha(
        tester,
        find.widgetWithText(ControlRoomPanel, 'Primario'),
      );
      final secondary = _panelBackgroundAlpha(
        tester,
        find.widgetWithText(ControlRoomPanel, 'Secondario'),
      );
      final tertiary = _panelBackgroundAlpha(
        tester,
        find.widgetWithText(ControlRoomPanel, 'Terziario'),
      );

      expect(primary, greaterThan(secondary));
      expect(secondary, greaterThan(tertiary));
    },
  );
}

Widget _localizedTestApp({required Widget child}) {
  return MaterialApp(
    locale: const Locale('it'),
    theme: buildFantasyTheme(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

int _panelBackgroundAlpha(WidgetTester tester, Finder finder) {
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
