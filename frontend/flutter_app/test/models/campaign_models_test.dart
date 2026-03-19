import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CampaignOptions.fromJson', () {
    test('parses backend payloads and filters presets by campaign type', () {
      final options = CampaignOptions.fromJson({
        'settings': ['Forgotten Realms', 'Eberron'],
        'campaign_types': ['One-Shot', 'Campagna lunga'],
        'themes': ['Intrigo', 'Esplorazione'],
        'tones': ['Epico', 'Cupo'],
        'styles': ['Sandbox', 'Lineare'],
        'party_archetypes': ['Tank', 'Supporto'],
        'twists': ['Tradimento', 'Portale'],
        'presets': {
          'Ritorno al Faro': {
            'campaign_type': 'one-shot',
          },
          'Ascesa delle Casate': {
            'campaign_type': 'Campagna Lunga',
          },
          'Cronache del Porto': {
            'campaign_type': 'ONE-SHOT',
          },
        },
        'setting_descriptions': {
          'Forgotten Realms': 'Classico high fantasy.',
        },
        'preset_descriptions': {
          'Ritorno al Faro': 'Indagine costiera.',
        },
      });

      expect(options.settings, ['Forgotten Realms', 'Eberron']);
      expect(options.campaignTypes, ['One-Shot', 'Campagna lunga']);
      expect(
        options.presetsForCampaignType('one-shot'),
        ['Cronache del Porto', 'Ritorno al Faro'],
      );
      expect(
        options.presetByName('Ascesa delle Casate'),
        {'campaign_type': 'Campagna Lunga'},
      );
      expect(
        options.settingDescriptions['Forgotten Realms'],
        'Classico high fantasy.',
      );
    });

    test('falls back to empty collections for malformed payload fields', () {
      final options = CampaignOptions.fromJson({
        'settings': 'invalid',
        'campaign_types': null,
        'themes': 3,
        'tones': {},
        'styles': false,
        'party_archetypes': 'tank',
        'twists': {'bad': 'shape'},
        'presets': null,
        'setting_descriptions': ['bad'],
        'preset_descriptions': 'bad',
      });

      expect(options.settings, isEmpty);
      expect(options.campaignTypes, isEmpty);
      expect(options.themes, isEmpty);
      expect(options.tones, isEmpty);
      expect(options.styles, isEmpty);
      expect(options.partyArchetypes, isEmpty);
      expect(options.twists, isEmpty);
      expect(options.presets, isEmpty);
      expect(options.settingDescriptions, isEmpty);
      expect(options.presetDescriptions, isEmpty);
    });
  });

  group('CampaignGenerateRequest.toJson', () {
    test('serializes the request with backend field names', () {
      final request = CampaignGenerateRequest(
        setting: 'Eberron',
        campaignType: 'One-Shot',
        themePreferences: ['Noir'],
        tonePreferences: ['Teso'],
        stylePreferences: ['Lineare'],
        partyLevel: 5,
        partySize: 4,
        partyArchetypes: ['Tank', 'Skill monkey'],
        twist: 'Un alleato mente',
        narrativeHooks: 'Recuperare un artefatto perduto.',
        characterNotes: 'Il chierico teme la magia draconica.',
        constraints: 'Una sola sessione.',
        factions: 'Casata Cannith',
        npcFocus: 'Rivale ambiguo',
        encounterFocus: 'Inseguimento sul treno',
        safetyNotes: 'No body horror',
        includeNpcs: true,
        includeEncounters: false,
      );

      expect(request.toJson(), {
        'setting': 'Eberron',
        'campaign_type': 'One-Shot',
        'theme_preferences': ['Noir'],
        'tone_preferences': ['Teso'],
        'style_preferences': ['Lineare'],
        'party_level': 5,
        'party_size': 4,
        'party_archetypes': ['Tank', 'Skill monkey'],
        'twist': 'Un alleato mente',
        'narrative_hooks': 'Recuperare un artefatto perduto.',
        'character_notes': 'Il chierico teme la magia draconica.',
        'constraints': 'Una sola sessione.',
        'factions': 'Casata Cannith',
        'npc_focus': 'Rivale ambiguo',
        'encounter_focus': 'Inseguimento sul treno',
        'safety_notes': 'No body horror',
        'include_npcs': true,
        'include_encounters': false,
        'language': 'Italiano',
      });
    });
  });
}
