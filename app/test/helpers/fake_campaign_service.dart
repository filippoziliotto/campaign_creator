import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:campaign_creator_flutter/src/services/campaign_service.dart';

class FakeCampaignService implements CampaignService {
  FakeCampaignService(this._options);

  final CampaignOptions _options;

  @override
  Future<CampaignOptions> getOptions({String localeCode = 'it'}) async =>
      _options;

  @override
  Future<String> generatePrompt(CampaignGenerateRequest req) async =>
      'Fake prompt for ${req.campaignType}';
}

/// Minimal options sufficient for most widget tests.
CampaignOptions minimalOptions() {
  return CampaignOptions(
    settings: const ['Forgotten Realms'],
    campaignTypes: const ['One-Shot'],
    themes: const ['Intrigo'],
    tones: const ['Epico'],
    styles: const ['Lineare'],
    partyArchetypes: const ['Tank'],
    twists: const ['Tradimento'],
    presets: const {},
    settingDescriptions: const {'Forgotten Realms': 'Classico high fantasy.'},
    presetDescriptions: const {},
    presetNames: const {},
  );
}

/// Options with a full preset used by world presets panel tests.
CampaignOptions presetsOptions() {
  return CampaignOptions(
    settings: const ['Forgotten Realms', 'Eberron'],
    campaignTypes: const ['One-Shot'],
    themes: const ['Intrigo'],
    tones: const ['Epico'],
    styles: const ['Lineare'],
    partyArchetypes: const ['Tank'],
    twists: const ['Nessun colpo di scena', 'Tradimento', 'Portale'],
    presets: const {
      'Cronache del Porto': {
        'campaign_type': 'one-shot',
        'setting': 'Eberron',
        'twist': 'Tradimento',
        'theme': 'Intrigo',
        'tone': 'Epico',
        'style': 'Lineare',
        'party_level': 5,
        'party_size': 4,
      },
    },
    settingDescriptions: const {
      'Forgotten Realms': 'Classico high fantasy.',
      'Eberron': 'Metropoli magica e pulp noir.',
    },
    presetDescriptions: const {
      'Cronache del Porto': 'Intrighi nei moli e faide tra casate.',
    },
    presetNames: const {
      'Cronache del Porto': 'Cronache del Porto',
    },
  );
}

CampaignOptions longCampaignPresetsOptions() {
  return CampaignOptions(
    settings: const ['Ravenloft', 'Forgotten Realms'],
    campaignTypes: const ['Campagna lunga'],
    themes: const ['Intrigo'],
    tones: const ['Tragico'],
    styles: const ['Investigativo'],
    partyArchetypes: const ['Tank'],
    twists: const ['Nessun colpo di scena', 'Tradimento', 'Portale'],
    presets: const {
      'Echi del Trono': {
        'campaign_type': 'Campagna lunga',
        'setting': 'Ravenloft',
        'twist': 'Tradimento',
        'theme': 'Intrigo',
        'tone': 'Tragico',
        'style': 'Investigativo',
        'party_level': 6,
        'party_size': 4,
      },
    },
    settingDescriptions: const {
      'Ravenloft': "L'impero crolla dall'interno.",
      'Forgotten Realms': 'Classico high fantasy.',
    },
    presetDescriptions: const {
      'Echi del Trono': 'Una dinastia spezzata alimenta una guerra di ombre.',
    },
    presetNames: const {
      'Echi del Trono': 'Echi del Trono',
    },
  );
}
