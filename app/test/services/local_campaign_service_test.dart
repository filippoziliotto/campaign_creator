import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:campaign_creator_flutter/src/services/local_campaign_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalCampaignService', () {
    test('loads bundled Italian options from assets', () async {
      final service = LocalCampaignService();

      final options = await service.getOptions(lang: 'it');

      expect(options.settings, isNotEmpty);
      expect(options.settings, contains('Forgotten Realms'));
      expect(options.campaignTypes, contains('Campagna lunga'));
      expect(options.presets, isNotEmpty);
    });

    test('loads bundled English options from assets', () async {
      final service = LocalCampaignService();

      final options = await service.getOptions(lang: 'en');

      expect(options.settings, isNotEmpty);
      expect(options.settings, contains('Forgotten Realms'));
      expect(options.campaignTypes, contains('Long campaign'));
      expect(options.presets, isNotEmpty);
    });

    group('generatePrompt', () {
      test('validation: throws when archetypes exceed party size', () async {
        final service = LocalCampaignService();

        expect(
          service.generatePrompt(
            CampaignGenerateRequest(
              setting: 'Forgotten Realms',
              campaignType: 'One-Shot',
              themePreferences: const [],
              tonePreferences: const [],
              stylePreferences: const [],
              partyLevel: 3,
              partySize: 2,
              partyArchetypes: const ['Tank', 'Healer', 'DPS'],
              twist: '',
              narrativeHooks: '',
              characterNotes: '',
              constraints: '',
              factions: '',
              npcFocus: '',
              encounterFocus: '',
              safetyNotes: '',
              includeNpcs: true,
              includeEncounters: true,
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('constraint augmentation: gothic horror adds gore line', () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(
          CampaignGenerateRequest(
            setting: 'Ravenloft',
            campaignType: 'One-Shot',
            themePreferences: const ['Horror Gotico'],
            tonePreferences: const [],
            stylePreferences: const [],
            partyLevel: 5,
            partySize: 4,
            partyArchetypes: const [],
            twist: '',
            narrativeHooks: '',
            characterNotes: '',
            constraints: '',
            factions: '',
            npcFocus: '',
            encounterFocus: '',
            safetyNotes: '',
            includeNpcs: false,
            includeEncounters: false,
          ),
        );

        expect(prompt, contains('gore'));
      });

      test('constraint augmentation: dark tone adds agency line', () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(
          CampaignGenerateRequest(
            setting: 'Forgotten Realms',
            campaignType: 'One-Shot',
            themePreferences: const [],
            tonePreferences: const ['Cupo'],
            stylePreferences: const [],
            partyLevel: 5,
            partySize: 4,
            partyArchetypes: const [],
            twist: '',
            narrativeHooks: '',
            characterNotes: '',
            constraints: '',
            factions: '',
            npcFocus: '',
            encounterFocus: '',
            safetyNotes: '',
            includeNpcs: false,
            includeEncounters: false,
          ),
        );

        expect(prompt, contains('agenzia'));
      });

      test('empty optional fields use fallback text', () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(
          CampaignGenerateRequest(
            setting: 'Forgotten Realms',
            campaignType: 'One-Shot',
            themePreferences: const [],
            tonePreferences: const [],
            stylePreferences: const [],
            partyLevel: 1,
            partySize: 4,
            partyArchetypes: const [],
            twist: '',
            narrativeHooks: '',
            characterNotes: '',
            constraints: '',
            factions: '',
            npcFocus: '',
            encounterFocus: '',
            safetyNotes: '',
            includeNpcs: true,
            includeEncounters: true,
          ),
        );

        // Empty narrative hooks → fallback text
        expect(prompt, contains('ganci iniziali'));
      });

      test('one-shot template is selected for One-Shot campaign type',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(
          CampaignGenerateRequest(
            setting: 'Forgotten Realms',
            campaignType: 'One-Shot',
            themePreferences: const [],
            tonePreferences: const [],
            stylePreferences: const [],
            partyLevel: 5,
            partySize: 4,
            partyArchetypes: const [],
            twist: '',
            narrativeHooks: '',
            characterNotes: '',
            constraints: '',
            factions: '',
            npcFocus: '',
            encounterFocus: '',
            safetyNotes: '',
            includeNpcs: true,
            includeEncounters: true,
          ),
        );

        // One-shot template contains this section header
        expect(prompt, contains('CINQUE CONCEPT'));
      });

      test(
          'post-processing: no trailing whitespace, no 3+ consecutive newlines',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(
          CampaignGenerateRequest(
            setting: 'Forgotten Realms',
            campaignType: 'One-Shot',
            themePreferences: const [],
            tonePreferences: const [],
            stylePreferences: const [],
            partyLevel: 5,
            partySize: 4,
            partyArchetypes: const [],
            twist: '',
            narrativeHooks: '',
            characterNotes: '',
            constraints: '',
            factions: '',
            npcFocus: '',
            encounterFocus: '',
            safetyNotes: '',
            includeNpcs: false,
            includeEncounters: false,
          ),
        );

        for (final line in prompt.split('\n')) {
          expect(line, equals(line.trimRight()),
              reason: 'Line has trailing whitespace: "$line"');
        }
        expect(prompt, isNot(contains('\n\n\n')));
      });
    });
  });
}
