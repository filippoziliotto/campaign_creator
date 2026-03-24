import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:campaign_creator_flutter/src/services/local_campaign_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalCampaignService', () {
    CampaignGenerateRequest buildRequest({
      String campaignType = 'One-Shot',
      String language = 'Italiano',
      String twist = '',
      List<String> themePreferences = const [],
      List<String> tonePreferences = const [],
      bool includeNpcs = true,
      bool includeEncounters = true,
    }) {
      return CampaignGenerateRequest(
        setting: 'Forgotten Realms',
        campaignType: campaignType,
        themePreferences: themePreferences,
        tonePreferences: tonePreferences,
        stylePreferences: const [],
        partyLevel: 5,
        partySize: 4,
        partyArchetypes: const [],
        twist: twist,
        narrativeHooks: '',
        characterNotes: '',
        constraints: '',
        factions: '',
        npcFocus: '',
        encounterFocus: '',
        safetyNotes: '',
        includeNpcs: includeNpcs,
        includeEncounters: includeEncounters,
        language: language,
      );
    }

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

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'One-Shot',
          themePreferences: const ['Horror Gotico'],
          includeNpcs: false,
          includeEncounters: false,
        ));

        expect(prompt, contains('gore'));
      });

      test('constraint augmentation: dark tone adds agency line', () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'One-Shot',
          tonePreferences: const ['Cupo'],
          includeNpcs: false,
          includeEncounters: false,
        ));

        expect(prompt, contains('agenzia'));
      });

      test(
          'empty optional fields are moved into a dedicated missing-input guidance section',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'Mini-campaign',
          language: 'English',
        ));

        expect(prompt, contains('## IF INPUTS ARE MISSING'));
        expect(prompt, contains('If narrative hooks are missing'));
        expect(prompt,
            isNot(contains('**Requested hooks:** If the field is empty')));
        expect(
            prompt,
            isNot(
                contains('**Character notes:** No character notes provided')));
        expect(prompt, isNot(contains('**Factions:** Not specified')));
      });

      test('empty party archetypes are shown as not specified by the user',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'Mini-campaign',
          language: 'English',
        ));

        expect(prompt,
            contains('| Party composition | Not specified by the user. |'));
        expect(
          prompt,
          isNot(contains(
            'Not specified: propose a coherent composition of classes and roles for the PCs.',
          )),
        );
      });

      test(
          'multiple optional user inputs render as separate lines instead of concatenated markdown',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(
          CampaignGenerateRequest(
            setting: 'Ravenloft',
            campaignType: 'One-Shot',
            themePreferences: const ['Horror Gotico'],
            tonePreferences: const ['Cupo'],
            stylePreferences: const ['Investigativo'],
            partyLevel: 4,
            partySize: 4,
            partyArchetypes: const ['Guerriero', 'Mago'],
            twist: "I PG sono già morti e non lo sanno",
            narrativeHooks: 'funerale interrotto',
            characterNotes: 'uno dei PG perde memoria',
            constraints: '',
            factions: 'casata decaduta',
            npcFocus: 'vedova inquieta',
            encounterFocus: 'indagine sociale',
            safetyNotes: 'evitare body horror dettagliato',
            includeNpcs: true,
            includeEncounters: true,
            language: 'Italiano',
          ),
        );

        expect(prompt, contains('- Ganci richiesti: funerale interrotto'));
        expect(prompt, contains('- Note personaggi: uno dei PG perde memoria'));
        expect(
            prompt, isNot(contains('funerale interrotto**Note personaggi:**')));
      });

      test(
          'Italian prompts hide the twist row and avoid twist wording when none is selected',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'One-Shot',
          language: 'Italiano',
          twist: 'Nessun colpo di scena',
        ));

        expect(prompt, isNot(contains('| Twist |')));
        expect(prompt, isNot(contains('`Nessun colpo di scena`')));
        expect(prompt, isNot(contains('Nessun twist selezionato')));
        expect(prompt, isNot(contains('twist')));
        expect(prompt, contains('punto di svolta principale'));
      });

      test(
          'English prompts hide the twist row and avoid twist wording when none is selected',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'One-Shot',
          language: 'English',
          twist: 'No twist',
        ));

        expect(prompt, isNot(contains('| Twist |')));
        expect(prompt, isNot(contains('No twist requested')));
        expect(prompt, isNot(contains('No twist is selected')));
        expect(prompt, isNot(contains('twist')));
        expect(prompt, contains('main turning point'));
      });

      test('one-shot template is selected for One-Shot campaign type',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest());

        // One-shot template contains this section header
        expect(prompt, contains('CINQUE CONCEPT'));
      });

      test('English generic requests use the English generic template',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'Custom Arc',
          language: 'English',
        ));

        expect(prompt, contains('# Role'));
        expect(prompt, contains('## Output format'));
        expect(prompt, isNot(contains('# Ruolo')));
      });

      test('English One-Shot requests use the English one-shot template',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          language: 'English',
        ));

        expect(prompt, contains('PHASE 1 — FIVE CONCEPTS'));
        expect(prompt, isNot(contains('FASE 1 — CINQUE CONCEPT')));
      });

      test('Italian requests keep using the Italian templates', () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          language: 'Italiano',
        ));

        expect(prompt, contains('FASE 1 — CINQUE CONCEPT'));
        expect(prompt, isNot(contains('PHASE 1 — FIVE CONCEPTS')));
      });

      test(
          'post-processing: no trailing whitespace, no 3+ consecutive newlines',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          includeNpcs: false,
          includeEncounters: false,
        ));

        for (final line in prompt.split('\n')) {
          expect(line, equals(line.trimRight()),
              reason: 'Line has trailing whitespace: "$line"');
        }
        expect(prompt, isNot(contains('\n\n\n')));
      });
    });
  });
}
