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
    theme: Intrigo
  Ascesa delle Casate:
    campaign_type: Campagna Lunga
  Cronache del Porto:
    campaign_type: ONE-SHOT
setting_descriptions:
  Forgotten Realms: Classico high fantasy.
preset_descriptions:
  Ritorno al Faro: Indagine costiera.
premium_option_ids:
  settings:
    - Eberron
  themes:
    - Intrigo
  tones:
    - Cupo
  styles:
    - Sandbox
  twists:
    - Portale
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
      expect(options.isPremiumSetting('Eberron'), isTrue);
      expect(options.isPremiumTheme('Intrigo'), isTrue);
      expect(options.isPremiumTone('Cupo'), isTrue);
      expect(options.isPremiumStyle('Sandbox'), isTrue);
      expect(options.isPremiumTwist('Portale'), isTrue);
      expect(options.isPremiumPreset('Ritorno al Faro'), isTrue);
      expect(options.isPremiumPreset('Ascesa delle Casate'), isFalse);
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
premium_option_ids:
  settings: invalid
  themes: false
  tones:
    bad: shape
  styles: 3
  twists:
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
      expect(options.premiumSettings, isEmpty);
      expect(options.premiumThemes, isEmpty);
      expect(options.premiumTones, isEmpty);
      expect(options.premiumStyles, isEmpty);
      expect(options.premiumTwists, isEmpty);
    });

    test('orders presets by free first and premium second within campaign type',
        () {
      final options = CampaignOptions.fromYaml(
        loadYaml('''
settings:
  - Forgotten Realms
  - Ravnica
campaign_types:
  - One-Shot
themes:
  - Classic fantasy
  - Urban heist
tones:
  - Mysterious
  - Noir
styles:
  - Investigative
  - Cinematic
party_archetypes:
  - Tank
twists:
  - No twist
  - The party is unknowingly serving the villain
presets:
  Ashen Crown:
    campaign_type: One-Shot
    setting: Ravnica
    theme: Urban heist
    tone: Noir
    style: Cinematic
    twist: The party is unknowingly serving the villain
  Zephyr Harbor:
    campaign_type: One-Shot
    setting: Forgotten Realms
    theme: Classic fantasy
    tone: Mysterious
    style: Investigative
    twist: No twist
premium_option_ids:
  settings:
    - Ravnica
  themes:
    - Urban heist
  tones:
    - Noir
  styles:
    - Cinematic
  twists:
    - The party is unknowingly serving the villain
''') as YamlMap,
      );

      expect(
        options.presetsForCampaignType('One-Shot'),
        ['Zephyr Harbor', 'Ashen Crown'],
      );
    });
  });
}
