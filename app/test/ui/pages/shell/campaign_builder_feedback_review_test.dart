import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/audio/forge_sound_player.dart';
import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:campaign_creator_flutter/src/services/campaign_service.dart';
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

  testWidgets(
    'narrative section shows optional eyebrow and localized subtitle',
    (tester) async {
      await _setLargeSurface(tester);

      Future<void> pumpForLocale({
        required Locale locale,
        required String sectionLabel,
        required String optionalLabel,
        required String subtitle,
      }) async {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();

        await tester.pumpWidget(
          _TestApp(
            locale: locale,
            child: _buildPage(locale: locale),
          ),
        );
        await _pumpUi(tester);
        await _openNarrativeSection(
          tester,
          sectionLabel: sectionLabel,
        );

        expect(find.text(optionalLabel), findsOneWidget);
        expect(find.text(subtitle), findsOneWidget);
      }

      await pumpForLocale(
        locale: const Locale('it'),
        sectionLabel: 'Trama',
        optionalLabel: 'Opzionale',
        subtitle: 'Agganci, fazioni e vincoli extra per personalizzare la pergamena.',
      );
      await pumpForLocale(
        locale: const Locale('en'),
        sectionLabel: 'Story',
        optionalLabel: 'Optional',
        subtitle: 'Extra hooks, factions, and constraints to customize the parchment.',
      );
      await pumpForLocale(
        locale: const Locale('es'),
        sectionLabel: 'Historia',
        optionalLabel: 'Opcional',
        subtitle: 'Ganchos, facciones y restricciones extra para personalizar el pergamino.',
      );
      await pumpForLocale(
        locale: const Locale('fr'),
        sectionLabel: 'Histoire',
        optionalLabel: 'Optionnel',
        subtitle: 'Accroches, factions et contraintes supplémentaires pour personnaliser le parchemin.',
      );
    },
  );

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

  testWidgets(
    'theme tone and style chips trigger a light haptic on select and deselect',
    (tester) async {
      await _setLargeSurface(tester);

      final haptics = await _recordHapticFeedback(() async {
        await tester.pumpWidget(_TestApp(child: _buildPage()));
        await _pumpUi(tester);
        await _openWorldSection(tester);
        _clearRecordedHaptics();

        for (final label in <String>['Intrigo', 'Epico', 'Lineare']) {
          final chip =
              find.byKey(ValueKey<String>('forge-option-chip-$label'));
          await tester.ensureVisible(chip);
          await tester.tap(chip, warnIfMissed: false);
          await _pumpUi(tester);
        }

        for (final label in <String>['Intrigo', 'Epico', 'Lineare']) {
          final chip =
              find.byKey(ValueKey<String>('forge-option-chip-$label'));
          await tester.ensureVisible(chip);
          await tester.tap(chip, warnIfMissed: false);
          await _pumpUi(tester);
        }
      });

      expect(
        haptics,
        <String>[
          'HapticFeedbackType.lightImpact',
          'HapticFeedbackType.lightImpact',
          'HapticFeedbackType.lightImpact',
          'HapticFeedbackType.lightImpact',
          'HapticFeedbackType.lightImpact',
          'HapticFeedbackType.lightImpact',
        ],
      );
    },
  );

  testWidgets('custom chips use the same text size as standard chips', (
    tester,
  ) async {
    await _setLargeSurface(tester);

    await tester.pumpWidget(
      _TestApp(
        child: _buildPage(
          initialPreferences: <String, Object>{
            'app.ad_free_purchased': true,
          },
        ),
      ),
    );
    await _pumpUi(tester);
    await _openWorldSection(tester);

    final customButton = find.ancestor(
      of: find.text('Custom').first,
      matching: find.byType(InkWell),
    );
    await tester.ensureVisible(customButton.first);
    await tester.tap(customButton.first, warnIfMissed: false);
    await _pumpUi(tester);

    await tester.enterText(find.byType(TextField), 'Noir');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await _pumpUi(tester);

    final customText = tester.widget<Text>(find.text('Noir'));
    expect(customText.style?.fontSize, 12);
  });

  testWidgets('party scale shows no premium threshold markers', (
    tester,
  ) async {
    await _setLargeSurface(tester);

    await tester.pumpWidget(_TestApp(
      locale: const Locale('en'),
      child: _buildPage(locale: const Locale('en')),
    ));
    await _pumpUi(tester);
    await _openPartySection(tester);

    expect(find.byKey(const ValueKey<String>('party-level-premium-threshold')),
        findsNothing);
    expect(find.byKey(const ValueKey<String>('party-size-premium-threshold')),
        findsNothing);
    expect(find.text('Levels 4+ are premium'), findsNothing);
    expect(find.text('5+ characters are premium'), findsNothing);
    expect(find.text('4+'), findsNothing);
    expect(find.text('5+'), findsNothing);
  });

  testWidgets('dragging party level into premium opens unlock flow', (
    tester,
  ) async {
    await _setLargeSurface(tester);

    await tester.pumpWidget(_TestApp(
      locale: const Locale('en'),
      child: _buildPage(locale: const Locale('en')),
    ));
    await _pumpUi(tester);
    await _openPartySection(tester);

    expect(find.byKey(const ValueKey<String>('party-level-label')),
        findsOneWidget);

    await tester.drag(
      find.byKey(const ValueKey<String>('party-level-slider')),
      const Offset(2000, 0),
    );
    await _pumpUi(tester);

    expect(find.text('Unlock Premium'), findsWidgets);
    expect(
      tester.widget<Text>(find.byKey(const ValueKey<String>('party-level-label')))
          .data,
      isNot('Party level: 6'),
    );
  });

  testWidgets('narrative section still forges parchment with empty fields', (
    tester,
  ) async {
    await _setLargeSurface(tester);

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

    expect(find.byKey(const ValueKey('parchment-action-copy')), findsOneWidget);
  });

  testWidgets('successful generation requests the forge sound once', (
    tester,
  ) async {
    await _setLargeSurface(tester);
    final soundPlayer = _FakeForgeSoundPlayer();

    await tester.pumpWidget(
      _TestApp(
        child: _buildPage(
          initialPreferences: const <String, Object>{
            'app.review_prompted': true,
          },
          forgeSoundPlayer: soundPlayer,
        ),
      ),
    );
    await _pumpUi(tester);
    await _openNarrativeSection(tester);

    await _tapForgePrimaryAction(tester);

    expect(soundPlayer.playCount, 1);
  });

  testWidgets('failed generation does not request the forge sound', (tester) async {
    await _setLargeSurface(tester);
    final soundPlayer = _FakeForgeSoundPlayer();

    await tester.pumpWidget(
      _TestApp(
        child: _buildPage(
          initialPreferences: const <String, Object>{
            'app.review_prompted': true,
          },
          service: _FailingCampaignService(),
          forgeSoundPlayer: soundPlayer,
        ),
      ),
    );
    await _pumpUi(tester);
    await _openNarrativeSection(tester);

    await _tapForgePrimaryAction(tester);

    expect(soundPlayer.playCount, 0);
    expect(
      find.text('Generazione fallita. Controlla il messaggio mostrato nella schermata.'),
      findsOneWidget,
    );
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

  test('review prompt exposes a requested outcome at the threshold', () async {
    SharedPreferences.setMockInitialValues(const <String, Object>{
      'app.onboarding_completed': true,
      'app.generation_count': 4,
    });
    final reviewPrompter = _FakeAppReviewPrompter();
    final preferences = await SharedPreferences.getInstance();
    final coordinator = ReviewPromptCoordinator(
      reviewPrompter: reviewPrompter,
      promptDelay: Duration.zero,
    );

    final outcome = await coordinator.recordSuccessfulGeneration(
      preferences: preferences,
      isMounted: () => true,
    );

    expect(outcome, ReviewPromptOutcome.thresholdReachedRequested);
    expect(reviewPrompter.requestReviewCallCount, 1);
    expect(
      reviewPromptDebugMessage(outcome, enableDebugMessages: true),
      contains('Debug: review threshold reached'),
    );
  });

  test('review prompt debug message is null below the threshold', () {
    expect(
      reviewPromptDebugMessage(
        ReviewPromptOutcome.belowThreshold,
        enableDebugMessages: true,
      ),
      isNull,
    );
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
  CampaignService? service,
  ForgeSoundPlayer? forgeSoundPlayer,
  Locale locale = const Locale('it'),
}) {
  if (initialPreferences != null) {
    SharedPreferences.setMockInitialValues(initialPreferences);
  }

  return CampaignBuilderPage(
    service: service ?? FakeCampaignService(minimalOptions()),
    currentLocale: locale,
    onLocaleChanged: (_) {},
    reviewPrompter: reviewPrompter,
    forgeSoundPlayer: forgeSoundPlayer,
  );
}

Future<void> _openNarrativeSection(
  WidgetTester tester, {
  String sectionLabel = 'Trama',
}) async {
  await _openWorldSection(tester);
  await tester.tap(find.text(sectionLabel));
  await _pumpUi(tester);

  expect(
    find.byKey(const ValueKey<String>('forge-section-narrative')),
    findsOneWidget,
  );
}

Future<void> _openPartySection(WidgetTester tester) async {
  await _openWorldSection(tester);
  final partyTab = find.text('Party').evaluate().isNotEmpty
      ? find.text('Party')
      : find.text('Gruppe');
  await tester.tap(partyTab);
  await _pumpUi(tester);

  expect(
    find.byKey(const ValueKey<String>('forge-section-party')),
    findsOneWidget,
  );
}

Future<void> _openWorldSection(WidgetTester tester) async {
  await tester.tap(
    find.byKey(const ValueKey<String>('entry-campaign-card-One-Shot')),
  );
  await _pumpUi(tester);
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
  const _TestApp({
    required this.child,
    this.locale = const Locale('it'),
  });

  final Widget child;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
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

class _FakeForgeSoundPlayer implements ForgeSoundPlayer {
  int playCount = 0;
  int newSessionPlayCount = 0;
  bool disposed = false;

  @override
  Future<void> playForgeSound() async {
    playCount += 1;
  }

  @override
  Future<void> playNewSessionSound() async {
    newSessionPlayCount += 1;
  }

  @override
  void dispose() {
    disposed = true;
  }
}

class _FailingCampaignService extends FakeCampaignService {
  _FailingCampaignService() : super(minimalOptions());

  @override
  Future<String> generatePrompt(CampaignGenerateRequest req) async {
    throw Exception('boom');
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
