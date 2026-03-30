import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
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

    final l10n = AppLocalizations.of(
      tester.element(find.byType(AppLaunchOnboardingGate)),
    );

    expect(find.text(l10n.onboardingChooseCampaignTitle), findsOneWidget);
    expect(find.text(l10n.onboardingChooseCampaignBody), findsOneWidget);
    expect(find.text('Campaign Forge'), findsNothing);
    expect(find.text('First-launch walkthrough'), findsNothing);
    expect(find.text('1 / 3'), findsOneWidget);
    expect(find.text('home-probe'), findsOneWidget);
    expect(find.text(l10n.helpCampaignTypeOneShotTitle), findsOneWidget);
    expect(find.text(l10n.helpCampaignTypeMiniCampaignTitle), findsOneWidget);
    expect(find.text(l10n.helpCampaignTypeLongCampaignTitle), findsOneWidget);
    expect(find.text(l10n.helpCampaignTypeDungeonTitle), findsOneWidget);

    final counterTopLeft = tester.getTopLeft(find.text('1 / 3'));
    final titleTopLeft =
        tester.getTopLeft(find.text(l10n.onboardingChooseCampaignTitle));
    final cardTopLeft = tester.getTopLeft(find.text(l10n.helpCampaignTypeOneShotTitle));
    expect(titleTopLeft.dy - counterTopLeft.dy, lessThan(34));
    expect(titleTopLeft.dy, lessThan(cardTopLeft.dy));

    final semantics = tester.ensureSemantics();
    expect(
      tester.getSemantics(
        find.bySemanticsLabel('${l10n.helpCampaignTypeOneShotTitle} preview card'),
      ),
      isSemantics(
        label: '${l10n.helpCampaignTypeOneShotTitle} preview card',
        hasSelectedState: true,
        isSelected: true,
      ),
    );
    expect(
      tester.getSemantics(
        find.bySemanticsLabel('${l10n.helpCampaignTypeMiniCampaignTitle} preview card'),
      ),
      isSemantics(
        label: '${l10n.helpCampaignTypeMiniCampaignTitle} preview card',
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

    final l10n = AppLocalizations.of(
      tester.element(find.byType(AppLaunchOnboardingGate)),
    );

    expect(find.text(l10n.onboardingChooseCampaignTitle), findsOneWidget);
    expect(find.text(l10n.onboardingBack), findsNothing);
    expect(find.text(l10n.onboardingSkip), findsNothing);

    await tester.tap(find.text(l10n.onboardingNext));
    await tester.pumpAndSettle();

    expect(find.text(l10n.onboardingDefineDetailsTitle), findsOneWidget);
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

    final l10n = AppLocalizations.of(
      tester.element(find.byType(AppLaunchOnboardingGate)),
    );

    await tester.tap(find.text(l10n.onboardingNext));
    await tester.pumpAndSettle();

    expect(find.text(l10n.onboardingDefineDetailsTitle), findsOneWidget);
    expect(find.text('2 / 3'), findsOneWidget);
    expect(find.text(l10n.onboardingSettingExample), findsOneWidget);

    final titleTopLeft = tester.getTopLeft(
      find.text(l10n.onboardingDefineDetailsTitle),
    );
    final titleBottomLeft = tester.getBottomLeft(
      find.text(l10n.onboardingDefineDetailsTitle),
    );
    final settingChipTopLeft = tester.getTopLeft(find.text(l10n.forgeSettingLabel).first);

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

    final l10n = AppLocalizations.of(
      tester.element(find.byType(AppLaunchOnboardingGate)),
    );

    expect(find.text(l10n.onboardingChooseCampaignTitle), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-420, 0));
    await tester.pumpAndSettle();

    expect(find.text(l10n.onboardingDefineDetailsTitle), findsOneWidget);
    expect(find.text('2 / 3'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(420, 0));
    await tester.pumpAndSettle();

    expect(find.text(l10n.onboardingChooseCampaignTitle), findsOneWidget);
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

    final l10n = AppLocalizations.of(
      tester.element(find.byType(AppLaunchOnboardingGate)),
    );

    await tester.tap(find.text(l10n.onboardingNext));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.onboardingNext));
    await tester.pumpAndSettle();

    expect(find.text(l10n.onboardingForgePromptTitle), findsOneWidget);
    expect(find.text('3 / 3'), findsOneWidget);
    expect(find.text(l10n.onboardingCopyStep), findsOneWidget);
    expect(find.text(l10n.parchmentOpenChatGptTitle), findsOneWidget);
    expect(find.text(l10n.parchmentShareTitle), findsNothing);

    await tester.tap(find.text(l10n.onboardingStartForging));
    await tester.pumpAndSettle();

    expect(find.text(l10n.onboardingForgePromptTitle), findsNothing);
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

    final l10n = AppLocalizations.of(
      tester.element(find.byType(AppLaunchOnboardingGate)),
    );

    expect(find.text(l10n.onboardingChooseCampaignTitle), findsNothing);
    expect(find.text('home-probe'), findsOneWidget);
  });

  testWidgets('showOnLaunch can turn on after first build without crashing', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestHarness(
        child: AppLaunchOnboardingGate(
          showOnLaunch: false,
          child: const Scaffold(body: Text('home-probe')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      _TestHarness(
        child: AppLaunchOnboardingGate(
          showOnLaunch: true,
          child: const Scaffold(body: Text('home-probe')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = AppLocalizations.of(
      tester.element(find.byType(AppLaunchOnboardingGate)),
    );

    expect(find.text(l10n.onboardingChooseCampaignTitle), findsOneWidget);
    expect(find.text('1 / 3'), findsOneWidget);
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

    final l10n = AppLocalizations.of(
      tester.element(find.byType(AppLaunchOnboardingGate)),
    );

    await tester.tap(find.text(l10n.onboardingNext));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.onboardingNext));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.onboardingStartForging));
    await tester.pumpAndSettle();

    expect(find.text(l10n.onboardingChooseCampaignTitle), findsNothing);

    await pumpGate(key: const ValueKey<String>('gate-b'));

    expect(find.text(l10n.onboardingChooseCampaignTitle), findsOneWidget);
  });

  testWidgets('onboarding copy localizes in every supported locale', (
    tester,
  ) async {
    for (final locale in AppLocalizations.supportedLocales) {
      await tester.pumpWidget(
        _TestHarness(
          locale: locale,
          child: AppLaunchOnboardingGate(
            child: const Scaffold(body: Text('home-probe')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final gateContext = tester.element(find.byType(AppLaunchOnboardingGate));
      final l10n = AppLocalizations.of(gateContext);

      expect(find.text(l10n.onboardingHowItWorks), findsOneWidget);
      expect(find.text(l10n.onboardingChooseCampaignTitle), findsOneWidget);
      expect(find.text(l10n.onboardingNext), findsOneWidget);

      await tester.tap(find.text(l10n.onboardingNext));
      await tester.pumpAndSettle();

      expect(find.text(l10n.onboardingDefineDetailsTitle), findsOneWidget);

      await tester.tap(find.text(l10n.onboardingNext));
      await tester.pumpAndSettle();

      expect(find.text(l10n.onboardingForgePromptTitle), findsOneWidget);
      expect(find.text(l10n.onboardingGeneratedPromptTitle), findsOneWidget);
      expect(find.text(l10n.parchmentOpenChatGptTitle), findsOneWidget);
      expect(find.text(l10n.onboardingStartForging), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    }
  });
}

class _TestHarness extends StatelessWidget {
  const _TestHarness({
    required this.child,
    this.locale = const Locale('en'),
  });

  final Widget child;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildFantasyTheme(),
      home: child,
    );
  }
}
