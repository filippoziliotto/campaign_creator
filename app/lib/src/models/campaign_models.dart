import 'package:yaml/yaml.dart';

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
        (key, value) => MapEntry(
            key, Map<String, dynamic>.from(value as Map<dynamic, dynamic>)),
      ),
      settingDescriptions: _stringMap(json['setting_descriptions']),
      presetDescriptions: _stringMap(json['preset_descriptions']),
      presetNames: _stringMap(json['preset_names']),
    );
  }

  factory CampaignOptions.fromYaml(YamlMap yaml) {
    List<String> yamlList(dynamic v) =>
        v is YamlList ? v.map((e) => e.toString()).toList() : <String>[];

    Map<String, String> yamlStringMap(dynamic v) {
      if (v is! YamlMap) return {};
      return v.map((k, val) => MapEntry(k.toString(), val.toString()));
    }

    final rawPresets = yaml['presets'];
    final presets = <String, Map<String, dynamic>>{};
    if (rawPresets is YamlMap) {
      for (final entry in rawPresets.entries) {
        if (entry.value is YamlMap) {
          presets[entry.key.toString()] =
              (entry.value as YamlMap).map((k, v) => MapEntry(k.toString(), v));
        }
      }
    }

    return CampaignOptions(
      settings: yamlList(yaml['settings']),
      campaignTypes: yamlList(yaml['campaign_types']),
      themes: yamlList(yaml['themes']),
      tones: yamlList(yaml['tones']),
      styles: yamlList(yaml['styles']),
      partyArchetypes: yamlList(yaml['party_archetypes']),
      twists: yamlList(yaml['twists']),
      presets: presets,
      settingDescriptions: yamlStringMap(yaml['setting_descriptions']),
      presetDescriptions: yamlStringMap(yaml['preset_descriptions']),
      presetNames: yamlStringMap(yaml['preset_names']),
    );
  }

  List<String> presetsForCampaignType(String campaignType) {
    final normalizedCampaignType = campaignType.trim().toLowerCase();

    final filtered = presets.entries
        .where((entry) {
          final normalizedPresetType = (entry.value['campaign_type'] ?? '')
              .toString()
              .trim()
              .toLowerCase();
          return normalizedPresetType == normalizedCampaignType;
        })
        .map((entry) => entry.key)
        .toList();

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
    this.localeCode = 'it',
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
  final String localeCode;
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
