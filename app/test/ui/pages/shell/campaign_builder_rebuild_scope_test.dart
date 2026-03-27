import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:campaign_creator_flutter/src/ui/pages/design/campaign_builder_primitives.dart';
import 'package:campaign_creator_flutter/src/ui/pages/design/campaign_builder_motion.dart';
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
    'selecting a forge chip does not recreate the persistent top bar widget',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _TestApp(
          child: CampaignBuilderPage(
            service: FakeCampaignService(minimalOptions()),
            currentLocale: const Locale('en'),
            onLocaleChanged: (_) {},
          ),
        ),
      );
      await _pumpUi(tester);
      await _enterForge(tester);

      final topBarBefore = tester.widget<Container>(
        find.byKey(const ValueKey<String>('persistent-top-bar')),
      );

      final intrigueChip = find.byKey(
        const ValueKey<String>('forge-option-chip-Intrigo'),
      );
      await tester.ensureVisible(intrigueChip);
      tester.widget<AnimatedRuneFilterChip>(intrigueChip).onSelected(true);
      await _pumpUi(tester);

      final topBarAfter = tester.widget<Container>(
        find.byKey(const ValueKey<String>('persistent-top-bar')),
      );

      expect(
        identical(topBarBefore, topBarAfter),
        isTrue,
      );
    },
  );

  testWidgets(
    'typing in a forge text field does not recreate the persistent top bar widget',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _TestApp(
          child: CampaignBuilderPage(
            service: FakeCampaignService(minimalOptions()),
            currentLocale: const Locale('en'),
            onLocaleChanged: (_) {},
          ),
        ),
      );
      await _pumpUi(tester);
      await _enterForge(tester);

      await tester.tap(find.text('Story'));
      await _pumpUi(tester);

      final topBarBefore = tester.widget<Container>(
        find.byKey(const ValueKey<String>('persistent-top-bar')),
      );

      await tester.enterText(find.byType(TextField).first, 'Faction war');
      await _pumpUi(tester);

      final topBarAfter = tester.widget<Container>(
        find.byKey(const ValueKey<String>('persistent-top-bar')),
      );

      expect(
        identical(topBarBefore, topBarAfter),
        isTrue,
      );
    },
  );

  testWidgets(
    'selecting another world theme after the draft is already dirty does not recreate ribbon or action strip',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _TestApp(
          child: CampaignBuilderPage(
            service: FakeCampaignService(_rebuildScopeOptions()),
            currentLocale: const Locale('en'),
            onLocaleChanged: (_) {},
          ),
        ),
      );
      await _pumpUi(tester);
      await _enterForge(tester);

      final intrigueChip = find.byKey(
        const ValueKey<String>('forge-option-chip-Intrigue'),
      );
      final mysteryChip = find.byKey(
        const ValueKey<String>('forge-option-chip-Mystery'),
      );

      await tester.ensureVisible(intrigueChip);
      tester.widget<AnimatedRuneFilterChip>(intrigueChip).onSelected(true);
      await _pumpUi(tester);

      final ribbonBefore = tester.widget(
        find.byKey(const ValueKey<String>('forge-section-ribbon')),
      );
      final actionStripBefore = tester.widget<ForgeActionStrip>(
        find.byType(ForgeActionStrip),
      );

      await tester.ensureVisible(mysteryChip);
      tester.widget<AnimatedRuneFilterChip>(mysteryChip).onSelected(true);
      await _pumpUi(tester);

      final ribbonAfter = tester.widget(
        find.byKey(const ValueKey<String>('forge-section-ribbon')),
      );
      final actionStripAfter = tester.widget<ForgeActionStrip>(
        find.byType(ForgeActionStrip),
      );

      expect(identical(ribbonBefore, ribbonAfter), isTrue);
      expect(identical(actionStripBefore, actionStripAfter), isTrue);
    },
    variant: const TargetPlatformVariant(
      <TargetPlatform>{TargetPlatform.macOS},
    ),
  );

  testWidgets(
    'switching forge section recreates ribbon and action strip',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _TestApp(
          child: CampaignBuilderPage(
            service: FakeCampaignService(_rebuildScopeOptions()),
            currentLocale: const Locale('en'),
            onLocaleChanged: (_) {},
          ),
        ),
      );
      await _pumpUi(tester);
      await _enterForge(tester);

      final ribbonBefore = tester.widget(
        find.byKey(const ValueKey<String>('forge-section-ribbon')),
      );
      final actionStripBefore = tester.widget<ForgeActionStrip>(
        find.byType(ForgeActionStrip),
      );

      await tester.tap(find.text('Party'));
      await _pumpUi(tester);

      final ribbonAfter = tester.widget(
        find.byKey(const ValueKey<String>('forge-section-ribbon')),
      );
      final actionStripAfter = tester.widget<ForgeActionStrip>(
        find.byType(ForgeActionStrip),
      );

      expect(identical(ribbonBefore, ribbonAfter), isFalse);
      expect(identical(actionStripBefore, actionStripAfter), isFalse);
    },
    variant: const TargetPlatformVariant(
      <TargetPlatform>{TargetPlatform.macOS},
    ),
  );
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }
}

Future<void> _enterForge(WidgetTester tester) async {
  final oneShotCard = find.byKey(
    const ValueKey<String>('entry-campaign-card-One-Shot'),
  );
  await tester.ensureVisible(oneShotCard);
  await tester.tap(oneShotCard);
  await _pumpUi(tester);
}

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 800));
}

CampaignOptions _rebuildScopeOptions() {
  return CampaignOptions(
    settings: const ['Forgotten Realms'],
    campaignTypes: const ['One-Shot'],
    themes: const ['Intrigue', 'Mystery'],
    tones: const ['Epic'],
    styles: const ['Linear'],
    partyArchetypes: const ['Tank'],
    twists: const ['Betrayal'],
    presets: const {},
    settingDescriptions: const {'Forgotten Realms': 'Classic high fantasy.'},
    presetDescriptions: const {},
    presetNames: const {},
  );
}
