import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/ui/pages/shell/campaign_builder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_campaign_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('selecting a campaign type triggers a light haptic impact', (
    tester,
  ) async {
    await _setLargeSurface(tester);

    final haptics = await _recordHapticFeedback(() async {
      await tester.pumpWidget(_TestApp(child: _buildPage()));
      await _pumpUi(tester);

      await tester.tap(
        find.byKey(const ValueKey<String>('entry-campaign-card-One-Shot')),
      );
      await _pumpUi(tester);
    });

    expect(haptics, <String>['HapticFeedbackType.lightImpact']);
  });

  testWidgets('successful generation triggers only a medium haptic impact', (
    tester,
  ) async {
    await _setLargeSurface(tester);

    final haptics = await _recordHapticFeedback(() async {
      await tester.pumpWidget(
        _TestApp(
          child: _buildPage(
            initialPreferences: const <String, Object>{
              'app.review_prompted': true,
            },
          ),
        ),
      );
      await _pumpUi(tester);
      await _openNarrativeSection(tester);
      _clearRecordedHaptics();

      await _tapForgePrimaryAction(tester);
    });

    expect(haptics, <String>['HapticFeedbackType.mediumImpact']);
  });

  testWidgets('copy action triggers a light haptic impact', (tester) async {
    await _setLargeSurface(tester);

    final haptics = await _recordHapticFeedback(() async {
      await tester.pumpWidget(
        _TestApp(
          child: _buildPage(
            initialPreferences: const <String, Object>{
              'app.review_prompted': true,
            },
          ),
        ),
      );
      await _pumpUi(tester);
      await _openNarrativeSection(tester);
      await _tapForgePrimaryAction(tester);

      _clearRecordedHaptics();
      await tester.ensureVisible(
        find.byKey(const ValueKey('parchment-action-copy')),
      );
      await tester.tap(find.byKey(const ValueKey('parchment-action-copy')));
      await _pumpUi(tester);
    });

    expect(haptics, <String>['HapticFeedbackType.lightImpact']);
  });

  testWidgets('seal action triggers only a medium haptic impact', (
    tester,
  ) async {
    await _setLargeSurface(tester);

    final haptics = await _recordHapticFeedback(() async {
      await tester.pumpWidget(
        _TestApp(
          child: _buildPage(
            initialPreferences: const <String, Object>{
              'app.review_prompted': true,
            },
          ),
        ),
      );
      await _pumpUi(tester);
      await _openNarrativeSection(tester);
      await _tapForgePrimaryAction(tester);

      _clearRecordedHaptics();
      await tester.ensureVisible(find.text('SIGILLA'));
      await tester.tap(find.text('SIGILLA'));
      await _pumpUi(tester);
    });

    expect(haptics, <String>['HapticFeedbackType.mediumImpact']);
  });

  test('review prompt appears once after the fifth successful generation',
      () async {
    SharedPreferences.setMockInitialValues(const <String, Object>{
      'app.onboarding_completed': true,
    });
    final reviewPrompter = _FakeAppReviewPrompter();
    final preferences = await SharedPreferences.getInstance();
    final coordinator = ReviewPromptCoordinator(
      reviewPrompter: reviewPrompter,
      promptDelay: Duration.zero,
    );

    for (var i = 0; i < 5; i++) {
      await coordinator.recordSuccessfulGeneration(
        preferences: preferences,
        isMounted: () => true,
      );
    }

    expect(preferences.getInt('app.generation_count'), 5);
    expect(preferences.getBool('app.review_prompted'), isTrue);
    expect(reviewPrompter.requestReviewCallCount, 1);

    await coordinator.recordSuccessfulGeneration(
      preferences: preferences,
      isMounted: () => true,
    );

    expect(preferences.getInt('app.generation_count'), 5);
    expect(reviewPrompter.requestReviewCallCount, 1);
  });
}

final List<String> _recordedHaptics = <String>[];

Future<List<String>> _recordHapticFeedback(
  Future<void> Function() action,
) async {
  _recordedHaptics.clear();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(SystemChannels.platform, (call) async {
    if (call.method == 'HapticFeedback.vibrate') {
      _recordedHaptics.add(call.arguments as String);
    }
    return null;
  });

  try {
    await action();
    return List<String>.from(_recordedHaptics);
  } finally {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
    _recordedHaptics.clear();
  }
}

void _clearRecordedHaptics() {
  _recordedHaptics.clear();
}

Widget _buildPage({
  Map<String, Object>? initialPreferences,
  AppReviewPrompter? reviewPrompter,
}) {
  if (initialPreferences != null) {
    SharedPreferences.setMockInitialValues(initialPreferences);
  }

  return CampaignBuilderPage(
    service: FakeCampaignService(minimalOptions()),
    currentLocale: const Locale('it'),
    onLocaleChanged: (_) {},
    reviewPrompter: reviewPrompter,
  );
}

Future<void> _openNarrativeSection(WidgetTester tester) async {
  await tester.tap(
    find.byKey(const ValueKey<String>('entry-campaign-card-One-Shot')),
  );
  await _pumpUi(tester);
  await tester.tap(find.text('Trama'));
  await _pumpUi(tester);

  expect(
    find.byKey(const ValueKey<String>('forge-section-narrative')),
    findsOneWidget,
  );
}

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 800));
}

Future<void> _tapForgePrimaryAction(WidgetTester tester) async {
  final finder = find.text('Forgia la Pergamena').evaluate().isNotEmpty
      ? find.text('Forgia la Pergamena')
      : find.text('Riforgia la Pergamena');
  expect(finder, findsOneWidget);
  await tester.ensureVisible(finder);
  await tester.tap(finder, warnIfMissed: false);
  await _pumpUi(tester);
}

Future<void> _setLargeSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(1200, 1600));
  addTearDown(() => tester.binding.setSurfaceSize(null));
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
        final mediaQuery = MediaQuery.of(
          context,
        ).copyWith(disableAnimations: true);
        return MediaQuery(data: mediaQuery, child: child!);
      },
      home: child,
    );
  }
}

class _FakeAppReviewPrompter implements AppReviewPrompter {
  int requestReviewCallCount = 0;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<void> requestReview() async {
    requestReviewCallCount += 1;
  }
}
