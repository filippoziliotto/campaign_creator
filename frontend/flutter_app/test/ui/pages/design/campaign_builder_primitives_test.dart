import 'package:animations/animations.dart';
import 'package:campaign_creator_flutter/src/theme/fantasy_theme.dart';
import 'package:campaign_creator_flutter/src/ui/pages/design/campaign_builder_atmosphere.dart';
import 'package:campaign_creator_flutter/src/ui/pages/design/campaign_builder_primitives.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
        MaterialApp(
          theme: buildFantasyTheme(),
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 399.2,
                child: CampaignModeCard(
                  atmosphere: _testAtmosphere,
                  title: 'Campagna lunga',
                  badge: 'Saga ampia',
                  description:
                      'Fazioni, cambi di equilibrio e sottotrame persistenti per una campagna da far crescere nel tempo.',
                  icon: Icons.account_tree_rounded,
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
        MaterialApp(
          theme: buildFantasyTheme(),
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 399.2,
                child: CampaignModeCard(
                  atmosphere: _testAtmosphere,
                  title: 'One-Shot',
                  badge: 'Lama rapida',
                  description: 'Una missione ad alto impatto.',
                  icon: Icons.bolt_rounded,
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
        ),
      );

      await tester.pump();

      expect(find.text('Apri la forgia'), findsOneWidget);
    },
  );

  testWidgets(
    'StagePill uses contrasting index text color when completed',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildFantasyTheme(),
          home: const Scaffold(
            body: StagePill(
              index: 3,
              label: 'Pergamena',
              active: false,
              enabled: true,
              completed: true,
              onTap: null,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('3'));
      expect(text.style?.color, isNot(Colors.black));
    },
  );

  testWidgets(
    'ForgeActionStrip does not render the previous button',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildFantasyTheme(),
          home: Scaffold(
            body: ForgeActionStrip(
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
        MaterialApp(
          theme: buildFantasyTheme(),
          home: const Scaffold(
            body: SectionFrame(
              title: 'Titolo sezione',
              child: Text('Contenuto'),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Titolo sezione'), findsOneWidget);
      expect(find.text('Contenuto'), findsOneWidget);
      expect(find.byType(RuneDivider), findsNothing);
    },
  );
}
