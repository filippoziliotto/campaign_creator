import 'dart:async';

import 'package:campaign_creator_flutter/l10n/app_localizations.dart';
import 'package:campaign_creator_flutter/src/audio/forge_sound_player.dart';
import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:campaign_creator_flutter/src/monetization/interstitial_ad_service.dart';
import 'package:campaign_creator_flutter/src/monetization/premium_access.dart';
import 'package:campaign_creator_flutter/src/monetization/purchase_service.dart';
import 'package:campaign_creator_flutter/src/monetization/rewarded_ad_service.dart';
import 'package:campaign_creator_flutter/src/services/campaign_service.dart';
import 'package:campaign_creator_flutter/src/ui/pages/design/campaign_builder_motion.dart';
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
        subtitle:
            'Agganci, fazioni e vincoli extra per personalizzare la pergamena.',
      );
      await pumpForLocale(
        locale: const Locale('en'),
        sectionLabel: 'Story',
        optionalLabel: 'Optional',
        subtitle:
            'Extra hooks, factions, and constraints to customize the parchment.',
      );
      await pumpForLocale(
        locale: const Locale('es'),
        sectionLabel: 'Historia',
        optionalLabel: 'Opcional',
        subtitle:
            'Ganchos, facciones y restricciones extra para personalizar el pergamino.',
      );
      await pumpForLocale(
        locale: const Locale('fr'),
        sectionLabel: 'Histoire',
        optionalLabel: 'Optionnel',
        subtitle:
            'Accroches, factions et contraintes supplémentaires pour personnaliser le parchemin.',
      );
    },
  );

  testWidgets(
    'forge hints localize and inject example text on focus',
    (tester) async {
      await _setLargeSurface(tester);

      await tester.pumpWidget(
        _TestApp(
          locale: const Locale('en'),
          child: _buildPage(locale: const Locale('en')),
        ),
      );
      await _pumpUi(tester);
      await _openNarrativeSection(
        tester,
        sectionLabel: 'Story',
      );

      final englishFieldFinder = _textFieldForLabel('Key NPCs');
      final englishField = tester.widget<TextField>(englishFieldFinder);
      expect(englishField.controller!.text, isEmpty);
      expect(
        englishField.decoration?.hintText,
        'Ambiguous mentor, rival, patron, traitor...',
      );
      expect(
        englishField.decoration?.floatingLabelBehavior,
        FloatingLabelBehavior.always,
      );
      expect(
        find.text('Ambiguous mentor, rival, patron, traitor...'),
        findsOneWidget,
      );

      await tester.tap(englishFieldFinder);
      await tester.pump();

      expect(
        _textFieldControllerText(tester, 'Key NPCs'),
        'Ambiguous mentor, rival, patron, traitor...',
      );
      expect(tester.widget<TextField>(englishFieldFinder).style?.fontStyle,
          FontStyle.italic);

      await tester.pumpWidget(
        _TestApp(
          locale: const Locale('it'),
          child: _buildPage(locale: const Locale('it')),
        ),
      );
      await _pumpUi(tester);
      await _openNarrativeSection(tester);

      final italianFieldFinder = _textFieldForLabel('NPC chiave');
      final italianField = tester.widget<TextField>(italianFieldFinder);
      expect(
        italianField.controller!.text,
        'Mentore ambiguo, rivale, patrono, traditore...',
      );
      expect(
        italianField.decoration?.hintText,
        'Mentore ambiguo, rivale, patrono, traditore...',
      );
    },
  );

  testWidgets(
    'user-authored forge text survives language changes',
    (tester) async {
      await _setLargeSurface(tester);

      await tester.pumpWidget(
        _TestApp(
          locale: const Locale('en'),
          child: _buildPage(locale: const Locale('en')),
        ),
      );
      await _pumpUi(tester);
      await _openNarrativeSection(
        tester,
        sectionLabel: 'Story',
      );

      await tester.enterText(
        _textFieldForLabel('Key NPCs'),
        'Village elder with a hidden pact',
      );
      await _pumpUi(tester);

      await tester.pumpWidget(
        _TestApp(
          locale: const Locale('it'),
          child: _buildPage(locale: const Locale('it')),
        ),
      );
      await _pumpUi(tester);
      await _openNarrativeSection(tester);

      expect(
        _textFieldControllerText(tester, 'NPC chiave'),
        'Village elder with a hidden pact',
      );
    },
  );

  testWidgets(
    'empty forge text stays out of the generated prompt until overwritten',
    (tester) async {
      await _setLargeSurface(tester);
      final service = _CapturingCampaignService();

      await tester.pumpWidget(
        _TestApp(
          locale: const Locale('en'),
          child: _buildPage(
            locale: const Locale('en'),
            initialPreferences: const <String, Object>{
              'app.review_prompted': true,
            },
            service: service,
          ),
        ),
      );
      await _pumpUi(tester);
      await _openNarrativeSection(
        tester,
        sectionLabel: 'Story',
      );

      final fieldFinder = _textFieldForLabel('Key NPCs');
      await tester.tap(fieldFinder);
      await tester.pump();

      expect(
        _textFieldControllerText(tester, 'Key NPCs'),
        'Ambiguous mentor, rival, patron, traitor...',
      );

      await _tapForgePrimaryAction(tester);

      expect(service.lastRequest, isNotNull);
      expect(service.lastRequest!.npcFocus, isEmpty);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();

      final overwrittenService = _CapturingCampaignService();
      await tester.pumpWidget(
        _TestApp(
          locale: const Locale('en'),
          child: _buildPage(
            locale: const Locale('en'),
            initialPreferences: const <String, Object>{
              'app.review_prompted': true,
            },
            service: overwrittenService,
          ),
        ),
      );
      await _pumpUi(tester);
      await _openNarrativeSection(
        tester,
        sectionLabel: 'Story',
      );

      await tester.enterText(
        _textFieldForLabel('Key NPCs'),
        'Harbormaster hiding a cult debt',
      );
      await _pumpUi(tester);

      await _tapForgePrimaryAction(tester);

      expect(overwrittenService.lastRequest, isNotNull);
      expect(
        overwrittenService.lastRequest!.npcFocus,
        'Harbormaster hiding a cult debt',
      );
    },
  );

  testWidgets(
    'forge fields show hints before focus and example text after focus',
    (tester) async {
      await _setLargeSurface(tester);

      await tester.pumpWidget(
        _TestApp(
          locale: const Locale('en'),
          child: _buildPage(locale: const Locale('en')),
        ),
      );
      await _pumpUi(tester);
      await _openNarrativeSection(
        tester,
        sectionLabel: 'Story',
      );

      final fieldFinder = _textFieldForLabel('Key NPCs');
      final field = tester.widget<TextField>(fieldFinder);

      expect(field.controller!.text, isEmpty);
      expect(field.decoration?.hintText, isNotNull);

      await tester.tap(fieldFinder);
      await tester.pump();

      expect(
        _textFieldControllerText(tester, 'Key NPCs'),
        'Ambiguous mentor, rival, patron, traitor...',
      );
    },
  );

  testWidgets(
    'tapping a forge field injects and selects the starter text',
    (tester) async {
      await _setLargeSurface(tester);

      await tester.pumpWidget(
        _TestApp(
          locale: const Locale('en'),
          child: _buildPage(locale: const Locale('en')),
        ),
      );
      await _pumpUi(tester);
      await _openNarrativeSection(
        tester,
        sectionLabel: 'Story',
      );

      final fieldFinder = _textFieldForLabel('Key NPCs');
      expect(_textFieldControllerText(tester, 'Key NPCs'), isEmpty);

      await tester.tap(fieldFinder);
      await tester.pump();

      expect(
        _textFieldControllerText(tester, 'Key NPCs'),
        'Ambiguous mentor, rival, patron, traitor...',
      );
      final field = tester.widget<TextField>(fieldFinder);
      expect(field.controller!.selection.baseOffset, 0);
      expect(
        field.controller!.selection.extentOffset,
        field.controller!.text.length,
      );
    },
  );

  testWidgets(
    'typing over the starter text replaces it instead of appending',
    (tester) async {
      await _setLargeSurface(tester);

      await tester.pumpWidget(
        _TestApp(
          locale: const Locale('en'),
          child: _buildPage(locale: const Locale('en')),
        ),
      );
      await _pumpUi(tester);
      await _openNarrativeSection(
        tester,
        sectionLabel: 'Story',
      );

      final fieldFinder = _textFieldForLabel('Key NPCs');
      await tester.tap(fieldFinder);
      await tester.pump();

      final starterText = _textFieldControllerText(tester, 'Key NPCs');
      tester.testTextInput.updateEditingValue(
        TextEditingValue(
          text: '${starterText}Guild fixer',
          selection: TextSelection.collapsed(
            offset: starterText.length + 'Guild fixer'.length,
          ),
        ),
      );
      await tester.pump();

      expect(_textFieldControllerText(tester, 'Key NPCs'), 'Guild fixer');
    },
  );

  testWidgets(
    'starter text remains when focus moves away',
    (tester) async {
      await _setLargeSurface(tester);

      await tester.pumpWidget(
        _TestApp(
          locale: const Locale('en'),
          child: _buildPage(locale: const Locale('en')),
        ),
      );
      await _pumpUi(tester);
      await _openNarrativeSection(
        tester,
        sectionLabel: 'Story',
      );

      final keyNpcsField = _textFieldForLabel('Key NPCs');
      final safetyNotesField = _textFieldForLabel('Safety notes');

      await tester.tap(keyNpcsField);
      await tester.pump();

      expect(
        _textFieldControllerText(tester, 'Key NPCs'),
        'Ambiguous mentor, rival, patron, traitor...',
      );

      await tester.tap(safetyNotesField);
      await tester.pump();

      expect(
        _textFieldControllerText(tester, 'Key NPCs'),
        'Ambiguous mentor, rival, patron, traitor...',
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
    'theme tone and style chip handlers trigger a light haptic on select and deselect',
    (tester) async {
      await _setLargeSurface(tester);

      final haptics = await _recordHapticFeedback(() async {
        await tester.pumpWidget(_TestApp(child: _buildPage()));
        await _pumpUi(tester);
        await _openWorldSection(tester);
        _clearRecordedHaptics();

        for (final label in <String>['Intrigo', 'Epico', 'Lineare']) {
          final chip = find.byKey(ValueKey<String>('forge-option-chip-$label'));
          await tester.ensureVisible(chip);
          tester.widget<AnimatedRuneFilterChip>(chip).onSelected(true);
          await _pumpUi(tester);
        }

        for (final label in <String>['Intrigo', 'Epico', 'Lineare']) {
          final chip = find.byKey(ValueKey<String>('forge-option-chip-$label'));
          await tester.ensureVisible(chip);
          tester.widget<AnimatedRuneFilterChip>(chip).onSelected(false);
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

  testWidgets('tapping the custom add chip triggers a light haptic impact', (
    tester,
  ) async {
    await _setLargeSurface(tester);

    final haptics = await _recordHapticFeedback(() async {
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
      _clearRecordedHaptics();

      final customButton = find.ancestor(
        of: find.text('Custom').first,
        matching: find.byType(InkWell),
      );
      await tester.ensureVisible(customButton.first);
      await tester.tap(customButton.first, warnIfMissed: false);
      await _pumpUi(tester);
    });

    expect(haptics, <String>['HapticFeedbackType.lightImpact']);
  });

  testWidgets('tapping a custom chip triggers a light haptic impact', (
    tester,
  ) async {
    await _setLargeSurface(tester);

    final haptics = await _recordHapticFeedback(() async {
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

      _clearRecordedHaptics();
      await tester.tap(find.text('Noir'));
      await _pumpUi(tester);
    });

    expect(haptics, <String>['HapticFeedbackType.lightImpact']);
  });

  testWidgets('party scale uses one-line segmented controls for level and size',
      (
    tester,
  ) async {
    await _setLargeSurface(tester);

    await tester.pumpWidget(_TestApp(
      locale: const Locale('en'),
      child: _buildPage(locale: const Locale('en')),
    ));
    await _pumpUi(tester);
    await _openPartySection(tester);

    expect(find.byType(Slider), findsNothing);
    expect(find.byKey(const ValueKey<String>('party-level-control')),
        findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('party-level-control')),
        matching: find.byKey(const ValueKey<String>('party-level-pill-1')),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('party-level-control')),
        matching: find.byKey(const ValueKey<String>('party-level-pill-20')),
      ),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey<String>('party-size-control')),
        findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('party-size-control')),
        matching: find.byKey(const ValueKey<String>('party-size-pill-1')),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('party-size-control')),
        matching: find.byKey(const ValueKey<String>('party-size-pill-8')),
      ),
      findsOneWidget,
    );
  });

  testWidgets('tapping a free level pill updates the party level label', (
    tester,
  ) async {
    await _setLargeSurface(tester);

    await tester.pumpWidget(_TestApp(
      locale: const Locale('en'),
      child: _buildPage(locale: const Locale('en')),
    ));
    await _pumpUi(tester);
    await _openPartySection(tester);

    await tester.tap(find.byKey(const ValueKey<String>('party-level-pill-5')));
    await _pumpUi(tester);

    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey<String>('party-level-label')))
          .data,
      'Party level: 5',
    );
  });

  testWidgets(
      'tapping a locked level pill opens unlock flow and does not select 6', (
    tester,
  ) async {
    await _setLargeSurface(tester);

    await tester.pumpWidget(_TestApp(
      locale: const Locale('en'),
      child: _buildPage(locale: const Locale('en')),
    ));
    await _pumpUi(tester);
    await _openPartySection(tester);
    final l10n = _l10n(tester);

    await tester.tap(find.byKey(const ValueKey<String>('party-level-pill-6')));
    await _pumpUi(tester);

    expect(find.text(l10n.settingsGoAdFreePrice), findsWidgets);
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey<String>('party-level-label')))
          .data,
      isNot('Party level: 6'),
    );
  });

  testWidgets('tapping a free party size pill updates the party size label', (
    tester,
  ) async {
    await _setLargeSurface(tester);

    await tester.pumpWidget(_TestApp(
      locale: const Locale('en'),
      child: _buildPage(locale: const Locale('en')),
    ));
    await _pumpUi(tester);
    await _openPartySection(tester);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>('party-size-control')),
        matching: find.byKey(const ValueKey<String>('party-size-pill-3')),
      ),
    );
    await _pumpUi(tester);

    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey<String>('party-size-label')))
          .data,
      'Number of characters: 3',
    );
  });

  testWidgets(
      'tapping a locked party size pill opens unlock flow and does not select 5',
      (
    tester,
  ) async {
    await _setLargeSurface(tester);

    await tester.pumpWidget(_TestApp(
      locale: const Locale('en'),
      child: _buildPage(locale: const Locale('en')),
    ));
    await _pumpUi(tester);
    await _openPartySection(tester);
    final l10n = _l10n(tester);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>('party-size-control')),
        matching: find.byKey(const ValueKey<String>('party-size-pill-5')),
      ),
    );
    await _pumpUi(tester);

    expect(find.text(l10n.settingsGoAdFreePrice), findsWidgets);
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey<String>('party-size-label')))
          .data,
      isNot('Number of characters: 5'),
    );
  });

  testWidgets(
      'locked premium flow hides watch ad until rewarded ad is ready',
      (tester) async {
    await _setLargeSurface(tester);
    final rewardedAdService = _FakeRewardedAdService()
      ..shouldBeReady = false
      ..readyOnPreloadAttempt = 2
      ..showResult = true;

    await tester.pumpWidget(
      _TestApp(
        locale: const Locale('en'),
        child: _buildPage(
          locale: const Locale('en'),
          rewardedAdService: rewardedAdService,
        ),
      ),
    );
    await _pumpUi(tester);
    await _openPartySection(tester);
    final l10n = _l10n(tester);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>('party-size-control')),
        matching: find.byKey(const ValueKey<String>('party-size-pill-5')),
      ),
    );
    await _pumpUi(tester);

    expect(
      find.widgetWithText(FilledButton, l10n.premiumUnlockWatchAd),
      findsNothing,
    );
    expect(rewardedAdService.showCallCount, 0);
  });

  testWidgets('watch ad stays hidden when rewarded ad is unavailable', (
    tester,
  ) async {
    await _setLargeSurface(tester);
    final rewardedAdService = _FakeRewardedAdService()
      ..shouldBeReady = false
      ..showResult = false;

    await tester.pumpWidget(
      _TestApp(
        locale: const Locale('en'),
        child: _buildPage(
          locale: const Locale('en'),
          rewardedAdService: rewardedAdService,
        ),
      ),
    );
    await _pumpUi(tester);
    await _openPartySection(tester);
    final l10n = _l10n(tester);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>('party-size-control')),
        matching: find.byKey(const ValueKey<String>('party-size-pill-5')),
      ),
    );
    await _pumpUi(tester);

    expect(
      find.widgetWithText(FilledButton, l10n.premiumUnlockWatchAd),
      findsNothing,
    );
    expect(rewardedAdService.showCallCount, 0);
  });

  testWidgets(
      'premium party pills keep their premium color after rewarded unlock',
      (tester) async {
    await _setLargeSurface(tester);
    final rewardedAdService = _FakeRewardedAdService()
      ..shouldBeReady = true
      ..showResult = true;

    await tester.pumpWidget(
      _TestApp(
        locale: const Locale('en'),
        child: _buildPage(
          locale: const Locale('en'),
          rewardedAdService: rewardedAdService,
        ),
      ),
    );
    await _pumpUi(tester);
    await _openPartySection(tester);

    final l10n = _l10n(tester);
    final premiumLevelFinder =
        find.byKey(const ValueKey<String>('party-level-pill-6'));

    final colorBeforeUnlock =
        tester.widget<Text>(premiumLevelFinder).style?.color;
    expect(colorBeforeUnlock, isNotNull);

    await tester.tap(premiumLevelFinder);
    await _pumpUi(tester);
    await tester
        .tap(find.widgetWithText(FilledButton, l10n.premiumUnlockWatchAd));
    await _pumpUi(tester);

    expect(rewardedAdService.showCallCount, 1);

    final colorAfterUnlock =
        tester.widget<Text>(premiumLevelFinder).style?.color;
    expect(colorAfterUnlock, colorBeforeUnlock);
  });

  testWidgets('restores rewarded premium unlock from persisted preferences', (
    tester,
  ) async {
    await _setLargeSurface(tester);

    await tester.pumpWidget(
      _TestApp(
        locale: const Locale('en'),
        child: _buildPage(
          locale: const Locale('en'),
          initialPreferences: <String, Object>{
            'app.premium_temporary_unlock_timestamp':
                DateTime.now().millisecondsSinceEpoch,
          },
        ),
      ),
    );
    await _pumpUi(tester);
    await _openPartySection(tester);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>('party-size-control')),
        matching: find.byKey(const ValueKey<String>('party-size-pill-5')),
      ),
    );
    await _pumpUi(tester);

    expect(find.byType(PremiumUnlockPrompt), findsNothing);
  });

  testWidgets('reducing party size trims selected archetypes', (tester) async {
    await _setLargeSurface(tester);

    await tester.pumpWidget(
      _TestApp(
        child: _buildPage(
          service: FakeCampaignService(_partyScaleOptions()),
        ),
      ),
    );
    await _pumpUi(tester);
    await _openPartySection(tester);

    for (final label in <String>['Tank', 'Healer', 'Scout', 'Mage']) {
      await tester
          .tap(find.byKey(ValueKey<String>('forge-option-chip-$label')));
      await _pumpUi(tester);
    }

    expect(
      tester
          .widgetList<AnimatedRuneFilterChip>(
              find.byType(AnimatedRuneFilterChip))
          .where((widget) => widget.selected)
          .length,
      4,
    );

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>('party-size-control')),
        matching: find.byKey(const ValueKey<String>('party-size-pill-2')),
      ),
    );
    await _pumpUi(tester);

    expect(
      tester
          .widgetList<AnimatedRuneFilterChip>(
              find.byType(AnimatedRuneFilterChip))
          .where((widget) => widget.selected)
          .length,
      2,
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

  testWidgets('narrative forge action uses compact label on narrow screens', (
    tester,
  ) async {
    await _setSmallSurface(tester);

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

    expect(find.text('Forgia Pergamena'), findsOneWidget);
    expect(find.text('Forgia la Pergamena'), findsNothing);
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

  testWidgets('failed generation does not request the forge sound',
      (tester) async {
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
      find.text(
          'Generazione fallita. Controlla il messaggio mostrato nella schermata.'),
      findsOneWidget,
    );
  });

  testWidgets('seal action requests the forge sound once more', (tester) async {
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

    final playCountAfterForge = soundPlayer.playCount;

    await tester.ensureVisible(find.text('SIGILLA'));
    await tester.tap(find.text('SIGILLA'));
    await _pumpUi(tester);

    expect(soundPlayer.playCount, playCountAfterForge + 1);
  });

  testWidgets('snack bar messages are center aligned', (tester) async {
    await _setLargeSurface(tester);

    await tester.pumpWidget(
      _TestApp(
        child: _buildPage(
          initialPreferences: const <String, Object>{
            'app.review_prompted': true,
          },
          service: _FailingCampaignService(),
        ),
      ),
    );
    await _pumpUi(tester);
    await _openNarrativeSection(tester);

    await _tapForgePrimaryAction(tester);

    final message = find.text(
      'Generazione fallita. Controlla il messaggio mostrato nella schermata.',
    );
    final messageText = tester.widget<Text>(message);

    expect(messageText.textAlign, TextAlign.center);
  });

  testWidgets('short confirmation snack bars use a compact floating width', (
    tester,
  ) async {
    await _setLargeSurface(tester);

    await tester.pumpWidget(
      _TestApp(
        child: _buildPage(
          initialPreferences: const <String, Object>{
            'campaign_builder.saved_prompt': 'Prompt salvato',
            'campaign_builder.saved_campaign_type': 'One-Shot',
            'campaign_builder.saved_setting': 'Forgotten Realms',
          },
        ),
      ),
    );
    await _pumpUi(tester);

    final newSessionButton = find.text('Nuova sessione');
    await tester.ensureVisible(newSessionButton);
    await tester.tap(newSessionButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar).last);

    expect(find.text('Bozza eliminata.'), findsOneWidget);
    expect(snackBar.behavior, SnackBarBehavior.floating);
    expect(snackBar.width, 320);
  });

  testWidgets('long snack bar messages keep the default full-width layout', (
    tester,
  ) async {
    await _setLargeSurface(tester);

    await tester.pumpWidget(
      _TestApp(
        child: _buildPage(
          initialPreferences: const <String, Object>{
            'app.review_prompted': true,
          },
          service: _FailingCampaignService(),
        ),
      ),
    );
    await _pumpUi(tester);
    await _openNarrativeSection(tester);

    await _tapForgePrimaryAction(tester);

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar).last);

    expect(
      find.text(
        'Generazione fallita. Controlla il messaggio mostrato nella schermata.',
      ),
      findsOneWidget,
    );
    expect(snackBar.behavior, isNot(SnackBarBehavior.floating));
    expect(snackBar.width, isNull);
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

  testWidgets('ad-free users do not preload ads on startup', (tester) async {
    await _setLargeSurface(tester);
    final interstitialAdService = _FakeInterstitialAdService();
    final rewardedAdService = _FakeRewardedAdService();

    await tester.pumpWidget(
      _TestApp(
        child: _buildPage(
          initialPreferences: const <String, Object>{
            'app.ad_free_purchased': true,
          },
          interstitialAdService: interstitialAdService,
          rewardedAdService: rewardedAdService,
        ),
      ),
    );
    await _pumpUi(tester);

    expect(interstitialAdService.preloadCallCount, 0);
    expect(rewardedAdService.preloadCallCount, 0);
  });

  testWidgets('purchasing ad-free disables loaded ads in the same session', (
    tester,
  ) async {
    await _setLargeSurface(tester);
    final interstitialAdService = _FakeInterstitialAdService();
    final rewardedAdService = _FakeRewardedAdService();
    final purchaseService = _FakePurchaseService();

    await tester.pumpWidget(
      _TestApp(
        child: _buildPage(
          interstitialAdService: interstitialAdService,
          rewardedAdService: rewardedAdService,
          purchaseService: purchaseService,
        ),
      ),
    );
    await _pumpUi(tester);

    expect(interstitialAdService.disposeCallCount, 0);
    expect(rewardedAdService.disposeCallCount, 0);

    purchaseService.emitUpdates(
      const <NormalizedPurchaseUpdate>[
        NormalizedPurchaseUpdate(
          status: PurchaseUpdateStatus.purchased,
          productId: 'ad_free_upgrade',
        ),
      ],
    );
    await _pumpUi(tester);

    expect(interstitialAdService.disposeCallCount, greaterThanOrEqualTo(1));
    expect(rewardedAdService.disposeCallCount, greaterThanOrEqualTo(1));
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
  InterstitialAdService? interstitialAdService,
  RewardedAdService? rewardedAdService,
  PurchaseService? purchaseService,
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
    interstitialAdService: interstitialAdService,
    rewardedAdService: rewardedAdService,
    purchaseService: purchaseService,
  );
}

Future<void> _openNarrativeSection(
  WidgetTester tester, {
  String sectionLabel = 'Trama',
}) async {
  await _openWorldSection(tester);
  final sectionFinder = find.text(sectionLabel);
  await tester.ensureVisible(sectionFinder);
  await tester.tap(sectionFinder, warnIfMissed: false);
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
  final l10n = _l10n(tester);
  final primaryLabels = <String>[
    l10n.forgeNextParty,
    l10n.forgeNextNarrative,
    l10n.forgeForgeParchment,
    l10n.forgeReforgeParchment,
    l10n.forgeForgeParchmentCompact,
    l10n.forgeReforgeParchmentCompact,
  ];
  final matchingLabels = primaryLabels
      .where((candidate) => find.text(candidate).evaluate().isNotEmpty)
      .toList(growable: false);
  if (matchingLabels.isNotEmpty) {
    final finder = find.text(matchingLabels.first);
    expect(finder, findsOneWidget);
    await tester.ensureVisible(finder);
    await tester.tap(finder, warnIfMissed: false);
    await _pumpUi(tester);
    return;
  }

  final primaryButtonFinder = find.byType(ForgePrimaryActionButton);
  expect(primaryButtonFinder, findsWidgets);
  final primaryButton = tester.widget<ForgePrimaryActionButton>(
    primaryButtonFinder.first,
  );
  expect(primaryButton.onPressed, isNotNull);
  primaryButton.onPressed!.call();
  await _pumpUi(tester);
}

Future<void> _setLargeSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(1200, 1600));
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

Future<void> _setSmallSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(360, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

Finder _textFieldForLabel(String label) {
  return find.ancestor(
    of: find.text(label),
    matching: find.byType(TextField),
  );
}

String _textFieldControllerText(WidgetTester tester, String label) {
  final field = tester.widget<TextField>(_textFieldForLabel(label));
  return field.controller!.text;
}

AppLocalizations _l10n(WidgetTester tester) {
  return AppLocalizations.of(tester.element(find.byType(CampaignBuilderPage)));
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
  int themeSwitchPlayCount = 0;
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
  Future<void> playThemeSwitchSound() async {
    themeSwitchPlayCount += 1;
  }

  @override
  void dispose() {
    disposed = true;
  }
}

class _FakeRewardedAdService implements RewardedAdService {
  int preloadCallCount = 0;
  int showCallCount = 0;
  int disposeCallCount = 0;
  bool shouldBeReady = true;
  int? readyOnPreloadAttempt;
  bool showResult = true;

  @override
  bool get isSupported => true;

  @override
  bool get isReady => shouldBeReady;

  @override
  Future<void> preload() async {
    preloadCallCount += 1;
    if (readyOnPreloadAttempt == preloadCallCount) {
      shouldBeReady = true;
    }
  }

  @override
  Future<bool> show() async {
    showCallCount += 1;
    return showResult;
  }

  @override
  void dispose() {
    disposeCallCount += 1;
  }
}

class _FakeInterstitialAdService implements InterstitialAdService {
  int preloadCallCount = 0;
  int showCallCount = 0;
  int disposeCallCount = 0;
  bool shouldBeReady = true;

  @override
  bool get isReady => shouldBeReady;

  @override
  Future<void> preload() async {
    preloadCallCount += 1;
  }

  @override
  Future<bool> show() async {
    showCallCount += 1;
    return true;
  }

  @override
  void dispose() {
    disposeCallCount += 1;
  }
}

class _FakePurchaseService implements PurchaseService {
  final StreamController<List<NormalizedPurchaseUpdate>> _controller =
      StreamController<List<NormalizedPurchaseUpdate>>.broadcast();

  @override
  Stream<List<NormalizedPurchaseUpdate>> get purchaseStream =>
      _controller.stream;

  void emitUpdates(List<NormalizedPurchaseUpdate> updates) {
    _controller.add(updates);
  }

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<PurchaseStartResult> buyAdFree() async => PurchaseStartResult.started;

  @override
  Future<String?> queryAdFreePrice() async => '€1.99';

  @override
  Future<void> restorePurchases() async {}

  @override
  Future<void> completePurchase(Object rawPurchase) async {}
}

class _FailingCampaignService extends FakeCampaignService {
  _FailingCampaignService() : super(minimalOptions());

  @override
  Future<String> generatePrompt(CampaignGenerateRequest req) async {
    throw Exception('boom');
  }
}

class _CapturingCampaignService extends FakeCampaignService {
  _CapturingCampaignService() : super(minimalOptions());

  CampaignGenerateRequest? lastRequest;

  @override
  Future<String> generatePrompt(CampaignGenerateRequest req) async {
    lastRequest = req;
    return super.generatePrompt(req);
  }
}

CampaignOptions _partyScaleOptions() {
  return CampaignOptions(
    settings: const ['Forgotten Realms'],
    campaignTypes: const ['One-Shot'],
    themes: const ['Intrigo'],
    tones: const ['Epico'],
    styles: const ['Lineare'],
    partyArchetypes: const ['Tank', 'Healer', 'Scout', 'Mage', 'Bard'],
    twists: const ['Tradimento'],
    presets: const {},
    settingDescriptions: const {'Forgotten Realms': 'Classico high fantasy.'},
    presetDescriptions: const {},
    presetNames: const {},
  );
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
