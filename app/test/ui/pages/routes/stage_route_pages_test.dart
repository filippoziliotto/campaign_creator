import 'package:campaign_creator_flutter/src/ui/pages/routes/entry_page.dart';
import 'package:campaign_creator_flutter/src/ui/pages/routes/forge_page.dart';
import 'package:campaign_creator_flutter/src/ui/pages/routes/parchment_page.dart';
import 'package:campaign_creator_flutter/src/ui/pages/design/campaign_builder_atmosphere.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'EntryRoutePage can render without hero content',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EntryRoutePage(
              campaignModeGrid: Text('grid'),
            ),
          ),
        ),
      );

      expect(find.text('grid'), findsOneWidget);
      expect(find.byType(EntryRoutePage), findsOneWidget);
    },
  );

  testWidgets(
    'ForgeRoutePage can render without hero content',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ForgeRoutePage(
              sectionRibbon: Text('ribbon'),
              activeSection: Text('active'),
              controlPanel: Text('controls'),
            ),
          ),
        ),
      );

      expect(find.text('ribbon'), findsOneWidget);
      expect(find.text('active'), findsOneWidget);
      expect(find.text('controls'), findsOneWidget);
    },
  );

  testWidgets(
    'ParchmentRoutePage can render without sheet content',
    (tester) async {
      const atmosphere = CampaignAtmosphereData(
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

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ParchmentRoutePage(
              atmosphere: atmosphere,
              sidebar: Text('sidebar'),
            ),
          ),
        ),
      );

      expect(find.text('sidebar'), findsOneWidget);
    },
  );
}
