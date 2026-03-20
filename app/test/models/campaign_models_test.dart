import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('CampaignOptions parsing', () {
    test('parses YAML payloads and filters presets by campaign type', () {
      final options = CampaignOptions.fromYaml(
        loadYaml('''
settings:
  - Forgotten Realms
  - Eberron
campaign_types:
  - One-Shot
  - Campagna lunga
themes:
  - Intrigo
  - Esplorazione
tones:
  - Epico
  - Cupo
styles:
  - Sandbox
  - Lineare
party_archetypes:
  - Tank
  - Supporto
twists:
  - Tradimento
  - Portale
presets:
  Ritorno al Faro:
    campaign_type: one-shot
  Ascesa delle Casate:
    campaign_type: Campagna Lunga
  Cronache del Porto:
    campaign_type: ONE-SHOT
setting_descriptions:
  Forgotten Realms: Classico high fantasy.
preset_descriptions:
  Ritorno al Faro: Indagine costiera.
''') as YamlMap,
      );

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

    test('falls back to empty collections for malformed YAML fields', () {
      final options = CampaignOptions.fromYaml(
        loadYaml('''
settings: invalid
campaign_types:
themes: 3
tones: {}
styles: false
party_archetypes: tank
twists:
  bad: shape
presets:
setting_descriptions:
  - bad
preset_descriptions: bad
''') as YamlMap,
      );

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
}
