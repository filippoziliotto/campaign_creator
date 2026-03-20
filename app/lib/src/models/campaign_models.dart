class CampaignOptions {
  CampaignOptions({
    required this.settings,
    required this.campaignTypes,
    required this.themes,
    required this.tones,
    required this.styles,
    required this.partyArchetypes,
    required this.twists,
    required this.presets,
    required this.settingDescriptions,
    required this.presetDescriptions,
    required this.presetNames,
  });

  final List<String> settings;
  final List<String> campaignTypes;
  final List<String> themes;
  final List<String> tones;
  final List<String> styles;
  final List<String> partyArchetypes;
  final List<String> twists;
  final Map<String, Map<String, dynamic>> presets;
  final Map<String, String> settingDescriptions;
  final Map<String, String> presetDescriptions;
  final Map<String, String> presetNames;

  factory CampaignOptions.fromJson(Map<String, dynamic> json) {
    final rawPresets =
        (json['presets'] as Map<String, dynamic>? ?? <String, dynamic>{});

    return CampaignOptions(
      settings: _stringList(json['settings']),
      campaignTypes: _stringList(json['campaign_types']),
      themes: _stringList(json['themes']),
      tones: _stringList(json['tones']),
      styles: _stringList(json['styles']),
      partyArchetypes: _stringList(json['party_archetypes']),
      twists: _stringList(json['twists']),
      presets: rawPresets.map(
        (key, value) =>
            MapEntry(key, Map<String, dynamic>.from(value as Map<dynamic, dynamic>)),
      ),
      settingDescriptions: _stringMap(json['setting_descriptions']),
      presetDescriptions: _stringMap(json['preset_descriptions']),
      presetNames: _stringMap(json['preset_names']),
    );
  }

  List<String> presetsForCampaignType(String campaignType) {
    final normalizedCampaignType = campaignType.trim().toLowerCase();

    final filtered = presets.entries.where((entry) {
      final normalizedPresetType =
          (entry.value['campaign_type'] ?? '').toString().trim().toLowerCase();
      return normalizedPresetType == normalizedCampaignType;
    }).map((entry) => entry.key).toList();

    filtered.sort();
    return filtered;
  }

  Map<String, dynamic>? presetByName(String name) => presets[name];
}

class CampaignGenerateRequest {
  CampaignGenerateRequest({
    required this.setting,
    required this.campaignType,
    required this.themePreferences,
    required this.tonePreferences,
    required this.stylePreferences,
    required this.partyLevel,
    required this.partySize,
    required this.partyArchetypes,
    required this.twist,
    required this.narrativeHooks,
    required this.characterNotes,
    required this.constraints,
    required this.factions,
    required this.npcFocus,
    required this.encounterFocus,
    required this.safetyNotes,
    required this.includeNpcs,
    required this.includeEncounters,
    this.language = 'Italiano',
  });

  final String setting;
  final String campaignType;
  final List<String> themePreferences;
  final List<String> tonePreferences;
  final List<String> stylePreferences;
  final int partyLevel;
  final int partySize;
  final List<String> partyArchetypes;
  final String twist;
  final String narrativeHooks;
  final String characterNotes;
  final String constraints;
  final String factions;
  final String npcFocus;
  final String encounterFocus;
  final String safetyNotes;
  final bool includeNpcs;
  final bool includeEncounters;
  final String language;

  Map<String, dynamic> toJson() {
    return {
      'setting': setting,
      'campaign_type': campaignType,
      'theme_preferences': themePreferences,
      'tone_preferences': tonePreferences,
      'style_preferences': stylePreferences,
      'party_level': partyLevel,
      'party_size': partySize,
      'party_archetypes': partyArchetypes,
      'twist': twist,
      'narrative_hooks': narrativeHooks,
      'character_notes': characterNotes,
      'constraints': constraints,
      'factions': factions,
      'npc_focus': npcFocus,
      'encounter_focus': encounterFocus,
      'safety_notes': safetyNotes,
      'include_npcs': includeNpcs,
      'include_encounters': includeEncounters,
      'language': language,
    };
  }
}

List<String> _stringList(dynamic raw) {
  if (raw is! List<dynamic>) {
    return <String>[];
  }
  return raw.map((item) => item.toString()).toList();
}

Map<String, String> _stringMap(dynamic raw) {
  if (raw is! Map<dynamic, dynamic>) {
    return <String, String>{};
  }
  return raw.map((key, value) => MapEntry(key.toString(), value.toString()));
}
