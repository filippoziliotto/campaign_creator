import 'package:campaign_creator_flutter/src/theme/fantasy_theme.dart';
import 'package:campaign_creator_flutter/src/ui/app_launch_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('onboarding is shown above app content on startup', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestHarness(
        child: AppLaunchOnboardingGate(
          child: const Scaffold(body: Text('home-probe')),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Choose Campaign'), findsOneWidget);
    expect(find.text('Choose your campaign'), findsNothing);
    expect(find.text('Campaign Forge'), findsNothing);
    expect(find.text('First-launch walkthrough'), findsNothing);
    expect(find.text('1 / 3'), findsOneWidget);
    expect(find.text('home-probe'), findsOneWidget);
    expect(find.text('One-Shot'), findsOneWidget);
    expect(find.text('Mini-campaign'), findsOneWidget);
    expect(find.text('Long campaign'), findsOneWidget);
    expect(find.text('Dungeon crawl'), findsOneWidget);

    final counterTopLeft = tester.getTopLeft(find.text('1 / 3'));
    final titleTopLeft = tester.getTopLeft(find.text('Choose Campaign'));
    final cardTopLeft = tester.getTopLeft(find.text('One-Shot'));
    expect(titleTopLeft.dy - counterTopLeft.dy, lessThan(34));
    expect(titleTopLeft.dy, lessThan(cardTopLeft.dy));

    final semantics = tester.ensureSemantics();
    expect(
      tester.getSemantics(find.bySemanticsLabel('One-Shot preview card')),
      isSemantics(
        label: 'One-Shot preview card',
        hasSelectedState: true,
        isSelected: true,
      ),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('Mini-campaign preview card')),
      isSemantics(
        label: 'Mini-campaign preview card',
        hasSelectedState: true,
        isSelected: false,
      ),
    );
    semantics.dispose();

    final panelRect = tester.getRect(
      find.byKey(const ValueKey<String>('app-onboarding-panel')),
    );
    final rootRect = tester.getRect(find.byType(Stack).first);

    expect(panelRect.width, lessThan(rootRect.width));
    expect(panelRect.height, lessThan(rootRect.height));
    expect(panelRect.width, greaterThan(rootRect.width * 0.55));
    expect(panelRect.height, greaterThan(rootRect.height * 0.55));
  });

  testWidgets('footer shows only primary action and supports forward flow', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestHarness(
        child: AppLaunchOnboardingGate(
          child: const Scaffold(body: Text('home-probe')),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Choose Campaign'), findsOneWidget);
    expect(find.text('Back'), findsNothing);
    expect(find.text('Skip'), findsNothing);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Define Key Details'), findsOneWidget);
  });

  testWidgets('slide 2 stacks copy panel above the choices panel', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestHarness(
        child: AppLaunchOnboardingGate(
          child: const Scaffold(body: Text('home-probe')),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Define Key Details'), findsOneWidget);
    expect(find.text('2 / 3'), findsOneWidget);
    expect(find.text('Forgotten Realms'), findsOneWidget);

    final titleTopLeft = tester.getTopLeft(
      find.text('Define Key Details'),
    );
    final titleBottomLeft = tester.getBottomLeft(
      find.text('Define Key Details'),
    );
    final settingChipTopLeft = tester.getTopLeft(find.text('Setting').first);

    expect((titleTopLeft.dx - settingChipTopLeft.dx).abs(), lessThan(120));
    expect(titleBottomLeft.dy, lessThan(settingChipTopLeft.dy));
  });

  testWidgets('swiping left goes to the next slide and right goes back', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestHarness(
        child: AppLaunchOnboardingGate(
          child: const Scaffold(body: Text('home-probe')),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Choose Campaign'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-420, 0));
    await tester.pumpAndSettle();

    expect(find.text('Define Key Details'), findsOneWidget);
    expect(find.text('2 / 3'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(420, 0));
    await tester.pumpAndSettle();

    expect(find.text('Choose Campaign'), findsOneWidget);
    expect(find.text('1 / 3'), findsOneWidget);
  });

  testWidgets('final slide shows the copy-to-ChatGPT handoff and dismisses', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestHarness(
        child: AppLaunchOnboardingGate(
          child: const Scaffold(body: Text('home-probe')),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Forge the prompt'), findsOneWidget);
    expect(find.text('3 / 3'), findsOneWidget);
    expect(find.text('Copy Prompt'), findsNothing);
    expect(find.text('Open in ChatGPT'), findsOneWidget);
    expect(find.text('Share'), findsNothing);

    await tester.tap(find.text('Start Forging'));
    await tester.pumpAndSettle();

    expect(find.text('Forge the prompt'), findsNothing);
    expect(find.text('home-probe'), findsOneWidget);
  });

  testWidgets('showOnLaunch false leaves onboarding hidden', (tester) async {
    await tester.pumpWidget(
      _TestHarness(
        child: AppLaunchOnboardingGate(
          showOnLaunch: false,
          child: const Scaffold(body: Text('home-probe')),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Choose Campaign'), findsNothing);
    expect(find.text('home-probe'), findsOneWidget);
  });

  testWidgets('reopening the gate shows onboarding again in test mode', (
    tester,
  ) async {
    Future<void> pumpGate({Key? key}) async {
      await tester.pumpWidget(
        _TestHarness(
          child: AppLaunchOnboardingGate(
            key: key,
            child: const Scaffold(body: Text('home-probe')),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await pumpGate(key: const ValueKey<String>('gate-a'));

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start Forging'));
    await tester.pumpAndSettle();

    expect(find.text('Choose your campaign'), findsNothing);

    await pumpGate(key: const ValueKey<String>('gate-b'));

    expect(find.text('Choose Campaign'), findsOneWidget);
  });
}

class _TestHarness extends StatelessWidget {
  const _TestHarness({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildFantasyTheme(),
      home: child,
    );
  }
}
