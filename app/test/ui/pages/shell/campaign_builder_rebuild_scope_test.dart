import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
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
