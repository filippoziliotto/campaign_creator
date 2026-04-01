import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:campaign_creator_flutter/src/services/local_campaign_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalCampaignService', () {
    CampaignGenerateRequest buildRequest({
      String campaignType = 'One-Shot',
      String localeCode = 'it',
      String twist = '',
      String setting = 'Forgotten Realms',
      String settingSummary = '',
      List<String> themePreferences = const [],
      List<String> tonePreferences = const [],
      bool includeNpcs = true,
      bool includeEncounters = true,
    }) {
      return CampaignGenerateRequest(
        setting: setting,
        settingSummary: settingSummary,
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
        localeCode: localeCode,
      );
    }

    test('loads bundled Italian options from assets', () async {
      final service = LocalCampaignService();

      final options = await service.getOptions(localeCode: 'it');

      expect(options.settings, isNotEmpty);
      expect(options.settings, contains('Forgotten Realms'));
      expect(options.campaignTypes, contains('Campagna lunga'));
      expect(options.presets, isNotEmpty);
    });

    test('loads bundled English options from assets', () async {
      final service = LocalCampaignService();

      final options = await service.getOptions(localeCode: 'en');

      expect(options.settings, isNotEmpty);
      expect(options.settings, contains('Forgotten Realms'));
      expect(options.campaignTypes, contains('Long campaign'));
      expect(options.presets, isNotEmpty);
    });

    test('loads bundled Spanish options from assets', () async {
      final service = LocalCampaignService();

      final options = await service.getOptions(localeCode: 'es');

      expect(options.settings, isNotEmpty);
      expect(options.settings, contains('Forgotten Realms'));
      expect(options.campaignTypes, contains('Campaña larga'));
      expect(options.presets, isNotEmpty);
    });

    test('loads bundled French options from assets', () async {
      final service = LocalCampaignService();

      final options = await service.getOptions(localeCode: 'fr');

      expect(options.settings, isNotEmpty);
      expect(options.settings, contains('Forgotten Realms'));
      expect(options.campaignTypes, contains('Longue campagne'));
      expect(options.presets, isNotEmpty);
    });

    test('loads bundled German options from assets', () async {
      final service = LocalCampaignService();

      final options = await service.getOptions(localeCode: 'de');

      expect(options.settings, isNotEmpty);
      expect(options.settings, contains('Forgotten Realms'));
      expect(options.campaignTypes, contains('Lange Kampagne'));
      expect(options.presets, isNotEmpty);
    });

    test('loads bundled Portuguese options from assets', () async {
      final service = LocalCampaignService();

      final options = await service.getOptions(localeCode: 'pt');

      expect(options.settings, isNotEmpty);
      expect(options.settings, contains('Forgotten Realms'));
      expect(options.campaignTypes, contains('Campanha longa'));
      expect(options.presets, isNotEmpty);
    });

    test('loads bundled Polish options from assets', () async {
      final service = LocalCampaignService();

      final options = await service.getOptions(localeCode: 'pl');

      expect(options.settings, isNotEmpty);
      expect(options.settings, contains('Forgotten Realms'));
      expect(options.campaignTypes, contains('Długa kampania'));
      expect(options.themes, contains('Klasyczne fantasy'));
      expect(options.tones, contains('Mroczny'));
      expect(options.styles, contains('Epicki'));
      expect(options.twists, contains('Brak zwrotu akcji'));
      expect(options.presets, isNotEmpty);
    });

    test('loads bundled Polish preset display names', () async {
      final service = LocalCampaignService();

      final options = await service.getOptions(localeCode: 'pl');

      expect(
        options.presetNames['NULLA NELLE TORRI'],
        'Nic w wieżach',
      );
      expect(
        options.presetNames['TOMBA RESPIRANTE'],
        'Oddychający grobowiec',
      );
    });

    test('loads bundled Japanese options and preset display names', () async {
      final service = LocalCampaignService();

      final options = await service.getOptions(localeCode: 'ja');

      expect(options.settings, contains('Forgotten Realms'));
      expect(options.campaignTypes, contains('長編キャンペーン'));
      expect(options.themes, contains('王道ファンタジー'));
      expect(options.tones, contains('ダーク'));
      expect(options.styles, contains('エピック'));
      expect(options.twists, contains('どんでん返しなし'));
      expect(options.presetNames['NULLA NELLE TORRI'], '塔に潜む虚無');
      expect(options.presetNames['TOMBA RESPIRANTE'], '呼吸する墓');
      expect(options.presets, isNotEmpty);
    });

    test(
        'returns the same CampaignOptions instance for repeated calls with the same locale',
        () async {
      final service = LocalCampaignService();

      final first = await service.getOptions(localeCode: 'en');
      final second = await service.getOptions(localeCode: 'en');

      expect(
        identical(first, second),
        isTrue,
        reason:
            'second call should return the cached instance without re-parsing',
      );
    });

    test(
        'bundled assets include long campaign presets in Italian, English, Spanish, French, and German',
        () async {
      final service = LocalCampaignService();

      final itOptions = await service.getOptions(localeCode: 'it');
      final enOptions = await service.getOptions(localeCode: 'en');
      final esOptions = await service.getOptions(localeCode: 'es');
      final frOptions = await service.getOptions(localeCode: 'fr');
      final deOptions = await service.getOptions(localeCode: 'de');

      expect(itOptions.presetsForCampaignType('Campagna lunga'), isNotEmpty);
      expect(enOptions.presetsForCampaignType('Long campaign'), isNotEmpty);
      expect(esOptions.presetsForCampaignType('Campaña larga'), isNotEmpty);
      expect(frOptions.presetsForCampaignType('Longue campagne'), isNotEmpty);
      expect(deOptions.presetsForCampaignType('Lange Kampagne'), isNotEmpty);
    });

    test(
        'bundled settings include the new premium settings in the same order across locales with localized descriptions',
        () async {
      final service = LocalCampaignService();

      final enOptions = await service.getOptions(localeCode: 'en');
      final itOptions = await service.getOptions(localeCode: 'it');

      const expectedFreeSettings = <String>[
        'Forgotten Realms',
        'Eberron',
        'Ravenloft',
        'Exandria',
        'Homebrew continent',
        'Dragonlance',
        'Feywild',
        'Frontier',
        'Greyhawk',
        'Ghosts of Saltmarsh Coast',
      ];
      const expectedPremiumSettings = <String>[
        'Ravnica',
        'Spelljammer',
        'Theros',
        'Dark Sun',
        'Wildemount',
        'Planescape',
        'Underdark',
        'Shadowfell',
        'Radiant Citadel',
        'Avernus',
        'Sigil',
      ];

      expect(
        enOptions.settings,
        <String>[...expectedFreeSettings, ...expectedPremiumSettings],
      );
      expect(
        itOptions.settings,
        isNot(<String>[...expectedFreeSettings, ...expectedPremiumSettings]),
      );
      expect(
        enOptions.premiumSettings,
        expectedPremiumSettings.toSet(),
      );
      expect(
        itOptions.premiumSettings,
        <String>{
          'Ravnica',
          'Spelljammer',
          'Theros',
          'Dark Sun',
          'Wildemount',
          'Planescape',
          'Underdark',
          'Shadowfell',
          'Radiant Citadel',
          'Avernus',
          'Sigil',
        },
      );
      expect(
        enOptions.settingDescriptions['Shadowfell'],
        isNotEmpty,
      );
      expect(
        itOptions.settingDescriptions['Shadowfell'],
        isNotEmpty,
      );
      expect(
        itOptions.settingDescriptions['Shadowfell'],
        isNot(enOptions.settingDescriptions['Shadowfell']),
      );
    });

    test('bundled themes tones and styles include the new localized options',
        () async {
      final service = LocalCampaignService();

      final enOptions = await service.getOptions(localeCode: 'en');
      final itOptions = await service.getOptions(localeCode: 'it');
      final deOptions = await service.getOptions(localeCode: 'de');

      expect(
        enOptions.themes,
        containsAll(<String>[
          'Tournament',
          'Treasure hunt',
          'Post-apocalyptic',
          'Rebellion',
        ]),
      );
      expect(
        enOptions.tones,
        containsAll(<String>['Dreamlike', 'Chaotic', 'Ominous']),
      );
      expect(
        enOptions.styles,
        containsAll(<String>['Open-world', 'Tactical', 'Mythic', 'Mystery']),
      );

      expect(
        itOptions.themes,
        containsAll(<String>[
          'Torneo',
          'Caccia al tesoro',
          'Post-apocalittico',
          'Ribellione',
        ]),
      );
      expect(
        itOptions.tones,
        containsAll(<String>['Onirico', 'Caotico', 'Minaccioso']),
      );
      expect(
        itOptions.styles,
        containsAll(<String>[
          'Open-world',
          'Tattico',
          'Mitico',
          'Mistero',
        ]),
      );

      expect(
        deOptions.themes,
        containsAll(<String>[
          'Turnier',
          'Schatzjagd',
          'Postapokalyptisch',
          'Rebellion',
        ]),
      );
      expect(
        deOptions.tones,
        containsAll(<String>['Traumhaft', 'Chaotisch', 'Unheilvoll']),
      );
      expect(
        deOptions.styles,
        containsAll(<String>[
          'Open-world',
          'Taktisch',
          'Mythisch',
          'Mysterium',
        ]),
      );

      expect(
        enOptions.premiumThemes,
        containsAll(<String>[
          'Urban heist',
          'Planar journey',
          'Nautical adventure',
          'Faction war',
          'Medieval steampunk',
          'Tournament',
          'Post-apocalyptic',
          'Rebellion',
        ]),
      );
      expect(
        enOptions.premiumTones,
        containsAll(<String>[
          'Ironic',
          'Tragic',
          'Noir',
          'Bizarre',
          'Dreamlike',
          'Chaotic',
        ]),
      );
      expect(
        enOptions.premiumStyles,
        containsAll(<String>[
          'Low fantasy',
          'Fairytale',
          'Sandbox',
          'Survival',
          'Open-world',
          'Tactical',
          'Mythic',
        ]),
      );
      expect(
        enOptions.premiumTwists,
        containsAll(<String>[
          'The true threat is a benevolent institution (church, guild, academy)',
          'The world is trapped in a subtle time loop',
          "The PCs are already dead and don't know it",
          'The party is unknowingly serving the villain',
        ]),
      );
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
              localeCode: 'it',
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('constraint augmentation: Italian gothic horror adds gore line',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'One-Shot',
          themePreferences: const ['Horror gotico'],
          includeNpcs: false,
          includeEncounters: false,
        ));

        expect(prompt, contains('gore'));
      });

      test('constraint augmentation: Italian dark tone adds agency line',
          () async {
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
          localeCode: 'en',
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
          localeCode: 'en',
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
            themePreferences: const ['Horror gotico'],
            tonePreferences: const ['Cupo'],
            stylePreferences: const ['Investigativo'],
            partyLevel: 4,
            partySize: 4,
            partyArchetypes: const ['Guerriero', 'Mago'],
            twist: 'I PG sono già morti e non lo sanno',
            narrativeHooks: 'funerale interrotto',
            characterNotes: 'uno dei PG perde memoria',
            constraints: '',
            factions: 'casata decaduta',
            npcFocus: 'vedova inquieta',
            encounterFocus: 'indagine sociale',
            safetyNotes: 'evitare body horror dettagliato',
            includeNpcs: true,
            includeEncounters: true,
            localeCode: 'it',
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
          localeCode: 'it',
          twist: 'Nessun colpo di scena',
        ));

        expect(prompt, isNot(contains('| Twist |')));
        expect(prompt, isNot(contains('Nessun colpo di scena')));
        expect(prompt, contains('punto di svolta principale'));
      });

      test(
          'English prompts hide the twist row and avoid twist wording when none is selected',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'One-Shot',
          localeCode: 'en',
          twist: 'No twist',
        ));

        expect(prompt, isNot(contains('| Twist |')));
        expect(prompt, isNot(contains('No twist requested')));
        expect(prompt, contains('main turning point'));
      });

      test(
          'Spanish prompts hide the twist row and avoid twist wording when none is selected',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'One-Shot',
          localeCode: 'es',
          twist: 'Sin giro',
        ));

        expect(prompt, isNot(contains('| Giro |')));
        expect(prompt, isNot(contains('Sin giro solicitado')));
        expect(prompt, contains('punto de giro principal'));
      });

      test(
          'French prompts hide the twist row and avoid twist wording when none is selected',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'One-Shot',
          localeCode: 'fr',
          twist: 'Sans rebondissement',
        ));

        expect(prompt, isNot(contains('| Rebondissement |')));
        expect(prompt, isNot(contains('Sans rebondissement demandé')));
        expect(prompt, contains('point de bascule principal'));
      });

      test('predefined settings include a localized setting summary row',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          localeCode: 'en',
          setting: 'Forgotten Realms',
          settingSummary:
              'Classic high fantasy across a vast, conflict-rich world.',
        ));

        expect(prompt, contains('| Setting | Forgotten Realms |'));
        expect(
          prompt,
          contains(
            '| Setting summary | Classic high fantasy across a vast, conflict-rich world. |',
          ),
        );
      });

      test('Italian prompts localize the setting summary row label', () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          localeCode: 'it',
          setting: 'Forgotten Realms',
          settingSummary:
              'High fantasy classico in un mondo vasto e ricco di conflitti.',
        ));

        expect(
          prompt,
          contains(
            '| Sintesi ambientazione | High fantasy classico in un mondo vasto e ricco di conflitti. |',
          ),
        );
      });

      test('custom settings do not render a localized setting summary row',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          localeCode: 'it',
          setting: 'Mia Ambientazione Originale',
          settingSummary: '',
        ));

        expect(prompt,
            contains('| Ambientazione | Mia Ambientazione Originale |'));
        expect(prompt, isNot(contains('| Sintesi ambientazione |')));
      });

      test('one-shot template is selected for One-Shot campaign type',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest());

        expect(prompt, contains('CINQUE CONCEPT'));
      });

      test('English generic requests use the English generic template',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'Custom Arc',
          localeCode: 'en',
        ));

        expect(prompt, contains('# Role'));
        expect(prompt, contains('## Output format'));
        expect(prompt, isNot(contains('# Ruolo')));
      });

      test('English One-Shot requests use the English one-shot template',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          localeCode: 'en',
        ));

        expect(prompt, contains('PHASE 1 — FIVE CONCEPTS'));
        expect(prompt, isNot(contains('FASE 1 — CINQUE CONCEPT')));
      });

      test('Italian requests keep using the Italian templates', () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          localeCode: 'it',
        ));

        expect(prompt, contains('FASE 1 — CINQUE CONCEPT'));
        expect(prompt, isNot(contains('PHASE 1 — FIVE CONCEPTS')));
      });

      test('Spanish generic requests use the Spanish generic template',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'Arco personalizado',
          localeCode: 'es',
        ));

        expect(prompt, contains('# Rol'));
        expect(prompt, contains('## Formato de salida'));
        expect(prompt, isNot(contains('## Output format')));
      });

      test('Spanish One-Shot requests use the Spanish one-shot template',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          localeCode: 'es',
        ));

        expect(prompt, contains('FASE 1 — CINCO CONCEPTOS'));
        expect(prompt, isNot(contains('PHASE 1 — FIVE CONCEPTS')));
      });

      test('French generic requests use the French generic template', () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'Arc personnalisé',
          localeCode: 'fr',
        ));

        expect(prompt, contains('# Role'));
        expect(prompt, contains('## Format de sortie'));
        expect(prompt, isNot(contains('## Output format')));
      });

      test('French One-Shot requests use the French one-shot template',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          localeCode: 'fr',
        ));

        expect(prompt, contains('PHASE 1 — CINQ CONCEPTS'));
        expect(prompt, isNot(contains('PHASE 1 — FIVE CONCEPTS')));
      });

      test('German generic requests use the German generic template', () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'Benutzerdefinierter Handlungsbogen',
          localeCode: 'de',
        ));

        expect(prompt, contains('# Rolle'));
        expect(prompt, contains('## Ausgabeformat'));
        expect(prompt, isNot(contains('## Output format')));
      });

      test('German One-Shot requests use the German one-shot template',
          () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          localeCode: 'de',
        ));

        expect(prompt, contains('PHASE 1 — FÜNF KONZEPTE'));
        expect(prompt, isNot(contains('PHASE 1 — FIVE CONCEPTS')));
      });

      test('Spanish horror prompts add the gore guidance line', () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'One-Shot',
          localeCode: 'es',
          themePreferences: const ['Horror gótico'],
          includeNpcs: false,
          includeEncounters: false,
        ));

        expect(prompt, contains('gore'));
      });

      test('French dark tone prompts add the agency guidance line', () async {
        final service = LocalCampaignService();

        final prompt = await service.generatePrompt(buildRequest(
          campaignType: 'One-Shot',
          localeCode: 'fr',
          tonePreferences: const ['Sombre'],
          includeNpcs: false,
          includeEncounters: false,
        ));

        expect(prompt, contains('libre arbitre'));
      });

      test(
          'Spanish localized campaign templates do not leak English instructions',
          () async {
        final service = LocalCampaignService();
        const campaignTypes = <String>[
          'Mini-campaña',
          'Campaña larga',
          'Exploración de mazmorra',
        ];
        const englishMarkers = <String>[
          'You are a senior narrative designer',
          'Requested hooks:',
          'Premise and stakes',
          'Game world',
          'NPCs and event timeline',
          'Three entry hooks',
          'DM note:',
          'Mini-campaign (3-6 sessions)',
          'Long campaign (10-25+ sessions)',
          'Dungeon exploration (multi-session)',
          '**NPCs:**',
          '**Encounters:**',
        ];

        for (final campaignType in campaignTypes) {
          final prompt = await service.generatePrompt(buildRequest(
            campaignType: campaignType,
            localeCode: 'es',
          ));

          for (final marker in englishMarkers) {
            expect(
              prompt,
              isNot(contains(marker)),
              reason:
                  'Spanish prompt for "$campaignType" still contains English marker "$marker".',
            );
          }
        }
      });

      test(
          'French localized campaign templates do not leak English instructions',
          () async {
        final service = LocalCampaignService();
        const campaignTypes = <String>[
          'Mini-campagne',
          'Longue campagne',
          'Exploration de donjon',
        ];
        const englishMarkers = <String>[
          'You are a senior narrative designer',
          'Requested hooks:',
          'Premise and stakes',
          'Game world',
          'NPCs and event timeline',
          'Three entry hooks',
          'DM note:',
          'Mini-campaign (3-6 sessions)',
          'Long campaign (10-25+ sessions)',
          'Dungeon exploration (multi-session)',
          '**NPCs:**',
          '**Encounters:**',
        ];

        for (final campaignType in campaignTypes) {
          final prompt = await service.generatePrompt(buildRequest(
            campaignType: campaignType,
            localeCode: 'fr',
          ));

          for (final marker in englishMarkers) {
            expect(
              prompt,
              isNot(contains(marker)),
              reason:
                  'French prompt for "$campaignType" still contains English marker "$marker".',
            );
          }
        }
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
