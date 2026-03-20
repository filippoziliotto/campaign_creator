import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n_extension.dart';
import '../../../models/campaign_models.dart';
import '../../../services/campaign_service.dart';
import '../../../services/local_campaign_service.dart';
import '../../../theme/fantasy_theme.dart';
import '../design/campaign_builder_atmosphere.dart';
import '../design/campaign_builder_motion.dart';
import '../design/campaign_builder_primitives.dart';
import '../parchment/campaign_builder_parchment.dart';
import '../routes/entry_page.dart';
import '../routes/forge_page.dart';
import '../routes/parchment_page.dart';

part 'campaign_builder_entry_shell.dart';
part 'campaign_builder_forge_shell.dart';
part 'campaign_builder_parchment_shell.dart';

enum _AppStage { entry, forge, parchment }

enum _ForgeSection { world, party, narrative }

typedef SharePromptCallback = Future<ShareResult> Function(ShareParams params);

class _CampaignTypeMeta {
  const _CampaignTypeMeta({
    required this.icon,
    required this.colors,
    required this.artAsset,
    required this.atmosphere,
  });

  final IconData icon;
  final List<Color> colors;
  final String artAsset;
  final CampaignAtmosphereData atmosphere;
}

const CampaignAtmosphereData _oneShotAtmosphere = CampaignAtmosphereData(
  id: 'one-shot',
  label: 'Urgenza cremisi',
  primary: Color(0xFFC2482D),
  secondary: Color(0xFFF0A35B),
  highlight: Color(0xFFF5E6C9),
  cardTint: Color(0xFF4C1E17),
  linework: Color(0xFF8A3A28),
  glow: Color(0xFFE46B3C),
  backdropVariant: CampaignBackdropVariant.emberRush,
  routeTransitionType: SharedAxisTransitionType.horizontal,
  sectionTransitionType: SharedAxisTransitionType.horizontal,
  routeTransitionDuration: Duration(milliseconds: 420),
  reverseRouteTransitionDuration: Duration(milliseconds: 320),
  sectionTransitionDuration: Duration(milliseconds: 260),
  revealDuration: Duration(milliseconds: 520),
  revealDistance: 30,
  cardHoverLift: 14,
  cardHoverTilt: 0.095,
  chipFlashDuration: Duration(milliseconds: 300),
  ctaPulseDuration: Duration(milliseconds: 1300),
  parchmentUnfoldDuration: Duration(milliseconds: 620),
  parchmentUnfoldCurve: Curves.easeOutCubic,
);

const CampaignAtmosphereData _miniCampaignAtmosphere = CampaignAtmosphereData(
  id: 'mini-campaign',
  label: 'Strada dorata',
  primary: Color(0xFFB07A34),
  secondary: Color(0xFFD9A95A),
  highlight: Color(0xFFF1E0BF),
  cardTint: Color(0xFF3D2414),
  linework: Color(0xFF7A5630),
  glow: Color(0xFFCE8C43),
  backdropVariant: CampaignBackdropVariant.wayfinderAtlas,
  routeTransitionType: SharedAxisTransitionType.horizontal,
  sectionTransitionType: SharedAxisTransitionType.scaled,
  routeTransitionDuration: Duration(milliseconds: 500),
  reverseRouteTransitionDuration: Duration(milliseconds: 380),
  sectionTransitionDuration: Duration(milliseconds: 340),
  revealDuration: Duration(milliseconds: 620),
  revealDistance: 26,
  cardHoverLift: 11,
  cardHoverTilt: 0.075,
  chipFlashDuration: Duration(milliseconds: 360),
  ctaPulseDuration: Duration(milliseconds: 1600),
  parchmentUnfoldDuration: Duration(milliseconds: 680),
  parchmentUnfoldCurve: Curves.easeInOutCubic,
);

const CampaignAtmosphereData _longCampaignAtmosphere = CampaignAtmosphereData(
  id: 'long-campaign',
  label: 'Atlante verde',
  primary: Color(0xFF5E8A69),
  secondary: Color(0xFF85A98C),
  highlight: Color(0xFFD8E5D7),
  cardTint: Color(0xFF183128),
  linework: Color(0xFF4F6A57),
  glow: Color(0xFF6A9A77),
  backdropVariant: CampaignBackdropVariant.sagaAtlas,
  routeTransitionType: SharedAxisTransitionType.scaled,
  sectionTransitionType: SharedAxisTransitionType.scaled,
  routeTransitionDuration: Duration(milliseconds: 640),
  reverseRouteTransitionDuration: Duration(milliseconds: 480),
  sectionTransitionDuration: Duration(milliseconds: 520),
  revealDuration: Duration(milliseconds: 820),
  revealDistance: 20,
  cardHoverLift: 8,
  cardHoverTilt: 0.055,
  chipFlashDuration: Duration(milliseconds: 440),
  ctaPulseDuration: Duration(milliseconds: 2200),
  parchmentUnfoldDuration: Duration(milliseconds: 780),
  parchmentUnfoldCurve: Curves.easeInOutCubicEmphasized,
);

const CampaignAtmosphereData _dungeonAtmosphere = CampaignAtmosphereData(
  id: 'dungeon',
  label: 'Volta di torce',
  primary: Color(0xFFB9813C),
  secondary: Color(0xFF6B5C86),
  highlight: Color(0xFFF0DFC1),
  cardTint: Color(0xFF1C1822),
  linework: Color(0xFF544A63),
  glow: Color(0xFFDA9B4A),
  backdropVariant: CampaignBackdropVariant.torchVault,
  routeTransitionType: SharedAxisTransitionType.scaled,
  sectionTransitionType: SharedAxisTransitionType.scaled,
  routeTransitionDuration: Duration(milliseconds: 560),
  reverseRouteTransitionDuration: Duration(milliseconds: 420),
  sectionTransitionDuration: Duration(milliseconds: 460),
  revealDuration: Duration(milliseconds: 760),
  revealDistance: 24,
  cardHoverLift: 10,
  cardHoverTilt: 0.072,
  chipFlashDuration: Duration(milliseconds: 390),
  ctaPulseDuration: Duration(milliseconds: 1850),
  parchmentUnfoldDuration: Duration(milliseconds: 720),
  parchmentUnfoldCurve: Curves.easeOutCubic,
);

const _CampaignTypeMeta _defaultCampaignMeta = _CampaignTypeMeta(
  icon: Icons.bolt_rounded,
  colors: <Color>[FantasyPalette.ember, FantasyPalette.cardSoft],
  artAsset: 'assets/entry_cards/one_shot.jpg',
  atmosphere: _miniCampaignAtmosphere,
);

const Map<String, _CampaignTypeMeta> _campaignTypeMeta =
    <String, _CampaignTypeMeta>{
  'One-Shot': _CampaignTypeMeta(
    icon: Icons.bolt_rounded,
    colors: <Color>[Color(0xFFB03A2E), Color(0xFF6D2018)],
    artAsset: 'assets/entry_cards/one_shot.jpg',
    atmosphere: _oneShotAtmosphere,
  ),
  'Mini-campagna': _CampaignTypeMeta(
    icon: Icons.hiking_rounded,
    colors: <Color>[Color(0xFF9A6A2F), Color(0xFF5A3318)],
    artAsset: 'assets/entry_cards/campagna_corta.jpg',
    atmosphere: _miniCampaignAtmosphere,
  ),
  'Mini-campaign': _CampaignTypeMeta(
    icon: Icons.hiking_rounded,
    colors: <Color>[Color(0xFF9A6A2F), Color(0xFF5A3318)],
    artAsset: 'assets/entry_cards/campagna_corta.jpg',
    atmosphere: _miniCampaignAtmosphere,
  ),
  'Campagna lunga': _CampaignTypeMeta(
    icon: Icons.auto_stories_rounded,
    colors: <Color>[Color(0xFF47644A), Color(0xFF1E2E22)],
    artAsset: 'assets/entry_cards/campagna_lunga.jpg',
    atmosphere: _longCampaignAtmosphere,
  ),
  'Long campaign': _CampaignTypeMeta(
    icon: Icons.auto_stories_rounded,
    colors: <Color>[Color(0xFF47644A), Color(0xFF1E2E22)],
    artAsset: 'assets/entry_cards/campagna_lunga.jpg',
    atmosphere: _longCampaignAtmosphere,
  ),
  'Esplorazione dungeon': _CampaignTypeMeta(
    icon: Icons.layers_rounded,
    colors: <Color>[Color(0xFF5E4C80), Color(0xFF292036)],
    artAsset: 'assets/entry_cards/dungeon.jpg',
    atmosphere: _dungeonAtmosphere,
  ),
  'Dungeon crawl': _CampaignTypeMeta(
    icon: Icons.layers_rounded,
    colors: <Color>[Color(0xFF5E4C80), Color(0xFF292036)],
    artAsset: 'assets/entry_cards/dungeon.jpg',
    atmosphere: _dungeonAtmosphere,
  ),
};

class CampaignBuilderPage extends StatefulWidget {
  const CampaignBuilderPage({
    super.key,
    this.service,
    this.sharePrompt,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  final CampaignService? service;
  final SharePromptCallback? sharePrompt;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<CampaignBuilderPage> createState() => _CampaignBuilderPageState();
}

class _CampaignBuilderPageState extends State<CampaignBuilderPage> {
  static const String _draftPromptKey = 'campaign_builder.saved_prompt';
  static const String _draftSavedAtKey =
      'campaign_builder.saved_prompt_saved_at';
  static const String _draftCampaignTypeKey =
      'campaign_builder.saved_campaign_type';
  static const String _draftSettingKey = 'campaign_builder.saved_setting';

  late final CampaignService _service;
  late final SharePromptCallback _sharePromptCallback;
  late final List<TextEditingController> _textControllers;
  final ScrollController _entryScrollController = ScrollController();
  final ScrollController _forgeScrollController = ScrollController();
  final ScrollController _parchmentScrollController = ScrollController();

  CampaignOptions? _options;

  String? _selectedSetting;
  String? _selectedCampaignType;
  String? _selectedTwist;
  String? _selectedPreset;
  String? _appliedPreset;

  int _partyLevel = 3;
  int _partySize = 4;

  final Set<String> _selectedThemes = <String>{};
  final Set<String> _selectedTones = <String>{};
  final Set<String> _selectedStyles = <String>{};
  final Set<String> _selectedArchetypes = <String>{};

  bool _includeNpcs = true;
  bool _includeEncounters = true;

  bool _isLoadingOptions = true;
  bool _isGenerating = false;
  bool _hasUnsavedChanges = false;
  bool _draftPersistenceAvailable = true;

  _AppStage _appStage = _AppStage.entry;
  _ForgeSection _forgeSection = _ForgeSection.world;
  bool _forgeTransitionReverse = false;

  String? _errorMessage;
  String? _generatedPrompt;
  String? _savedDraftPrompt;
  int? _savedDraftSavedAt;

  final TextEditingController _customSettingController =
      TextEditingController();
  final TextEditingController _customThemeController = TextEditingController();
  final TextEditingController _customToneStyleController =
      TextEditingController();
  final TextEditingController _customTwistController = TextEditingController();
  final TextEditingController _narrativeHooksController =
      TextEditingController();
  final TextEditingController _characterNotesController =
      TextEditingController();
  final TextEditingController _constraintsController = TextEditingController();
  final TextEditingController _factionsController = TextEditingController();
  final TextEditingController _npcFocusController = TextEditingController();
  final TextEditingController _encounterFocusController =
      TextEditingController();
  final TextEditingController _safetyNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? LocalCampaignService();
    _sharePromptCallback = widget.sharePrompt ?? SharePlus.instance.share;
    _textControllers = <TextEditingController>[
      _customSettingController,
      _customThemeController,
      _customToneStyleController,
      _customTwistController,
      _narrativeHooksController,
      _characterNotesController,
      _constraintsController,
      _factionsController,
      _npcFocusController,
      _encounterFocusController,
      _safetyNotesController,
    ];
    for (final controller in _textControllers) {
      controller.addListener(_handleDraftInputChanged);
    }
    _loadSavedDraftState();
    _loadOptions();
  }

  @override
  void dispose() {
    for (final controller in _textControllers) {
      controller.removeListener(_handleDraftInputChanged);
      controller.dispose();
    }
    _entryScrollController.dispose();
    _forgeScrollController.dispose();
    _parchmentScrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CampaignBuilderPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentLocale.languageCode !=
        widget.currentLocale.languageCode) {
      setState(_clearLocaleSelections);
      _loadOptions();
    }
  }

  void _clearLocaleSelections() {
    _selectedCampaignType = null;
    _selectedTwist = null;
    _selectedPreset = null;
    _appliedPreset = null;
    _selectedThemes.clear();
    _selectedTones.clear();
    _selectedStyles.clear();
    _selectedArchetypes.clear();
  }

  void _handleDraftInputChanged() {
    if (!mounted) {
      return;
    }
    setState(() {
      _hasUnsavedChanges = true;
    });
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _markDirty([VoidCallback? update]) {
    setState(() {
      update?.call();
      _hasUnsavedChanges = true;
    });
  }

  void _applyShellState(VoidCallback update) {
    setState(update);
  }

  Future<void> _loadOptions() async {
    setState(() {
      _isLoadingOptions = true;
      _errorMessage = null;
    });

    try {
      final options =
          await _service.getOptions(lang: widget.currentLocale.languageCode);
      if (!mounted) {
        return;
      }

      setState(() {
        _options = options;
        _selectedSetting = options.settings.contains(_selectedSetting)
            ? _selectedSetting
            : (options.settings.isNotEmpty ? options.settings.first : null);
        _selectedCampaignType =
            options.campaignTypes.contains(_selectedCampaignType)
                ? _selectedCampaignType
                : null;
        _selectedTwist =
            options.twists.isNotEmpty ? options.twists.first : null;
        _selectedPreset = null;
        _appliedPreset = null;
        _generatedPrompt = _savedDraftPrompt;
        _hasUnsavedChanges = false;
        _forgeTransitionReverse = false;
        _appStage = _AppStage.entry;
        _forgeSection = _ForgeSection.world;
      });
    } catch (exc) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = context.l10n.appLoadOptionsError(exc.toString());
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingOptions = false;
        });
      }
    }
  }

  List<String> _parseCustomList(String rawText) {
    final normalized = rawText.replaceAll('\n', ',').replaceAll(';', ',');
    return normalized
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  ({List<String> tones, List<String> styles}) _parseToneStyleOverride(
    String rawText,
    List<String> toneOptions,
    List<String> styleOptions,
  ) {
    final text = rawText.trim();
    if (text.isEmpty) {
      return (tones: <String>[], styles: <String>[]);
    }

    final toneLookup = <String, String>{
      for (final item in toneOptions) item.toLowerCase(): item,
    };
    final styleLookup = <String, String>{
      for (final item in styleOptions) item.toLowerCase(): item,
    };

    final toneValues = <String>[];
    final styleValues = <String>[];

    void appendUnique(List<String> target, String value) {
      if (value.isNotEmpty && !target.contains(value)) {
        target.add(value);
      }
    }

    var explicitMode = false;

    for (final rawLine in text.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty || !line.contains(':')) {
        continue;
      }

      final parts = line.split(':');
      if (parts.length < 2) {
        continue;
      }
      final prefix = parts.first.trim().toLowerCase();
      final content = parts.sublist(1).join(':');
      final parsedValues = _parseCustomList(content);

      if (prefix == 'tono' ||
          prefix == 'toni' ||
          prefix == 'tone' ||
          prefix == 'tones') {
        explicitMode = true;
        for (final value in parsedValues) {
          appendUnique(toneValues, toneLookup[value.toLowerCase()] ?? value);
        }
      } else if (prefix == 'stile' ||
          prefix == 'stili' ||
          prefix == 'style' ||
          prefix == 'styles') {
        explicitMode = true;
        for (final value in parsedValues) {
          appendUnique(styleValues, styleLookup[value.toLowerCase()] ?? value);
        }
      }
    }

    if (explicitMode) {
      return (tones: toneValues, styles: styleValues);
    }

    for (final value in _parseCustomList(text)) {
      final normalizedValue = value.toLowerCase();
      final toneMatch = toneLookup[normalizedValue];
      final styleMatch = styleLookup[normalizedValue];
      if (toneMatch != null) {
        appendUnique(toneValues, toneMatch);
      }
      if (styleMatch != null) {
        appendUnique(styleValues, styleMatch);
      }
    }

    return (tones: toneValues, styles: styleValues);
  }

  List<String> _availablePresetsForCampaignType(CampaignOptions options) {
    if (_selectedCampaignType == null) {
      return <String>[];
    }
    return options.presetsForCampaignType(_selectedCampaignType!);
  }

  void _applyPreset() {
    final options = _options;
    final presetName = _selectedPreset;
    if (options == null || presetName == null) {
      return;
    }

    final preset = options.presetByName(presetName);
    if (preset == null) {
      return;
    }

    _markDirty(() {
      final campaignType = preset['campaign_type']?.toString();
      final setting = preset['setting']?.toString();
      final twist = preset['twist']?.toString();

      if (campaignType != null && campaignType.trim().isNotEmpty) {
        _selectedCampaignType = campaignType;
      }
      if (setting != null && setting.trim().isNotEmpty) {
        _selectedSetting = setting;
      }
      if (twist != null && twist.trim().isNotEmpty) {
        _selectedTwist = twist;
      }

      final level = int.tryParse(preset['party_level']?.toString() ?? '');
      final size = int.tryParse(preset['party_size']?.toString() ?? '');
      if (level != null && level >= 1 && level <= 20) {
        _partyLevel = level;
      }
      if (size != null && size >= 1 && size <= 8) {
        _partySize = size;
      }

      final theme = preset['theme']?.toString();
      final tone = preset['tone']?.toString();
      final style = preset['style']?.toString();

      _selectedThemes
        ..clear()
        ..addAll(theme == null || theme.isEmpty ? <String>[] : <String>[theme]);
      _selectedTones
        ..clear()
        ..addAll(tone == null || tone.isEmpty ? <String>[] : <String>[tone]);
      _selectedStyles
        ..clear()
        ..addAll(style == null || style.isEmpty ? <String>[] : <String>[style]);

      _errorMessage = null;
      _appliedPreset = presetName;
    });
  }

  CampaignGenerateRequest _buildGenerateRequest(CampaignOptions options) {
    final customSetting = _customSettingController.text.trim();
    final customTheme = _parseCustomList(_customThemeController.text.trim());
    final customTwist = _customTwistController.text.trim();

    final toneStyleOverride = _parseToneStyleOverride(
      _customToneStyleController.text,
      options.tones,
      options.styles,
    );

    final themePreferences = customTheme.isNotEmpty
        ? customTheme
        : _selectedThemes.toList(growable: false);

    final tonePreferences = toneStyleOverride.tones.isNotEmpty
        ? toneStyleOverride.tones
        : _selectedTones.toList(growable: false);

    final stylePreferences = toneStyleOverride.styles.isNotEmpty
        ? toneStyleOverride.styles
        : _selectedStyles.toList(growable: false);

    return CampaignGenerateRequest(
      setting:
          customSetting.isNotEmpty ? customSetting : (_selectedSetting ?? ''),
      campaignType: _selectedCampaignType ?? '',
      themePreferences: themePreferences,
      tonePreferences: tonePreferences,
      stylePreferences: stylePreferences,
      partyLevel: _partyLevel,
      partySize: _partySize,
      partyArchetypes: _selectedArchetypes.toList(growable: false),
      twist: customTwist.isNotEmpty ? customTwist : (_selectedTwist ?? ''),
      narrativeHooks: _narrativeHooksController.text.trim(),
      characterNotes: _characterNotesController.text.trim(),
      constraints: _constraintsController.text.trim(),
      factions: _factionsController.text.trim(),
      npcFocus: _npcFocusController.text.trim(),
      encounterFocus: _encounterFocusController.text.trim(),
      safetyNotes: _safetyNotesController.text.trim(),
      includeNpcs: _includeNpcs,
      includeEncounters: _includeEncounters,
      language:
          widget.currentLocale.languageCode == 'en' ? 'English' : 'Italiano',
    );
  }

  Future<void> _generatePrompt() async {
    final options = _options;
    if (options == null) {
      return;
    }

    if (_selectedArchetypes.length > _partySize) {
      final message = context.l10n.appInvalidArchetypeSelection(
        _selectedArchetypes.length,
        _partySize,
      );
      setState(() {
        _errorMessage = message;
      });
      _showSnackBar(message);
      return;
    }

    setState(() {
      _isGenerating = true;
      _errorMessage = null;
    });

    try {
      final request = _buildGenerateRequest(options);
      final prompt = await _service.generatePrompt(request);

      if (!mounted) {
        return;
      }
      setState(() {
        _generatedPrompt = prompt;
        _hasUnsavedChanges = false;
        _setAppStage(_AppStage.parchment);
      });
      await _copyPrompt(showFeedback: false);
      if (!mounted) {
        return;
      }
      _showSnackBar(context.l10n.appSnackForgedAndCopied);
    } catch (exc) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = context.l10n.appGenerationFailedError(exc.toString());
      });
      _showSnackBar(context.l10n.appSnackGenerationFailed);
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  Future<void> _copyPrompt({bool showFeedback = true}) async {
    final prompt = _generatedPrompt;
    if (prompt == null || prompt.trim().isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: prompt));
    if (!mounted || !showFeedback) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.appSnackPromptCopied)),
    );
  }

  Future<void> _sharePrompt({Rect? shareOrigin}) async {
    final prompt = _generatedPrompt;
    if (prompt == null || prompt.trim().isEmpty) {
      _showSnackBar(context.l10n.appSnackNoParchmentToShare);
      return;
    }

    try {
      final result = await _sharePromptCallback(
        ShareParams(
          text: prompt,
          title: context.l10n.parchmentReadyTitle,
          subject: context.l10n.appTitle,
          sharePositionOrigin: shareOrigin,
        ),
      );
      if (!mounted) {
        return;
      }
      if (result.status == ShareResultStatus.unavailable) {
        _showSnackBar(context.l10n.appSnackShareUnavailableOnDevice);
      }
    } catch (exc) {
      if (!mounted) {
        return;
      }
      _showSnackBar(context.l10n.appSnackShareUnavailable(exc.toString()));
    }
  }

  Future<void> _openPromptInChatGpt() async {
    final prompt = _generatedPrompt;
    if (prompt == null || prompt.trim().isEmpty) {
      _showSnackBar(context.l10n.appSnackGenerateFirst);
      return;
    }

    final uri = Uri.parse('https://chatgpt.com/');
    var launched = false;

    try {
      launched = await launchUrl(uri, webOnlyWindowName: '_blank');
    } catch (_) {
      launched = false;
    }

    await Clipboard.setData(ClipboardData(text: prompt));
    if (!mounted) {
      return;
    }
    if (launched) {
      _showSnackBar(context.l10n.appSnackChatGptOpened);
      return;
    }

    _showSnackBar(context.l10n.appSnackChatGptCopiedOnly);
  }

  Future<void> _loadSavedDraftState() async {
    final preferences = await _resolvePreferences();
    if (preferences == null) {
      return;
    }

    final savedPrompt = preferences.getString(_draftPromptKey);
    final savedAt = preferences.getInt(_draftSavedAtKey);
    final savedCampaignType = preferences.getString(_draftCampaignTypeKey);
    final savedSetting = preferences.getString(_draftSettingKey);

    if (!mounted) {
      return;
    }

    setState(() {
      _savedDraftPrompt = savedPrompt;
      _savedDraftSavedAt = savedAt;
      _generatedPrompt = savedPrompt;
      if (savedCampaignType != null && savedCampaignType.trim().isNotEmpty) {
        _selectedCampaignType = savedCampaignType;
      }
      if (savedSetting != null && savedSetting.trim().isNotEmpty) {
        _selectedSetting = savedSetting;
      }
    });
  }

  Future<bool> _savePromptDraft({bool showFeedback = true}) async {
    final prompt = _generatedPrompt;
    if (prompt == null || prompt.trim().isEmpty) {
      _showSnackBar(context.l10n.appSnackNoParchmentToSave);
      return false;
    }

    final savedAt = DateTime.now().millisecondsSinceEpoch;
    final preferences =
        await _resolvePreferences(notifyOnFailure: showFeedback);
    var persisted = false;

    if (preferences != null) {
      await preferences.setString(_draftPromptKey, prompt);
      await preferences.setInt(_draftSavedAtKey, savedAt);

      final campaignType = _selectedCampaignType?.trim();
      if (campaignType != null && campaignType.isNotEmpty) {
        await preferences.setString(_draftCampaignTypeKey, campaignType);
      }

      final setting = _currentSettingLabel().trim();
      if (setting.isNotEmpty) {
        await preferences.setString(_draftSettingKey, setting);
      }
      persisted = true;
    }

    if (!mounted) {
      return persisted;
    }

    setState(() {
      _savedDraftPrompt = prompt;
      _savedDraftSavedAt = savedAt;
    });
    if (showFeedback) {
      _showSnackBar(
        persisted
            ? context.l10n.appSnackDraftSaved
            : context.l10n.appSnackDraftMemoryOnly,
      );
    }
    return persisted;
  }

  Future<void> _resetDraft() async {
    final preferences = await _resolvePreferences();
    if (preferences != null) {
      await preferences.remove(_draftPromptKey);
      await preferences.remove(_draftSavedAtKey);
      await preferences.remove(_draftCampaignTypeKey);
      await preferences.remove(_draftSettingKey);
    }
    if (!mounted) return;
    setState(() {
      _generatedPrompt = null;
      _savedDraftPrompt = null;
      _savedDraftSavedAt = null;
      _hasUnsavedChanges = false;
      _selectedCampaignType = null;
    });
    _showSnackBar(context.l10n.entryResetDraftConfirm);
  }

  Future<void> _sealCurrentParchment() async {
    final persisted = await _savePromptDraft(showFeedback: false);
    await _copyPrompt(showFeedback: false);
    if (!mounted) {
      return;
    }
    _showSnackBar(
      persisted
          ? context.l10n.appSnackSealedSavedAndCopied
          : context.l10n.appSnackSealedCopiedOnlyMemory,
    );
  }

  Future<SharedPreferences?> _resolvePreferences({
    bool notifyOnFailure = false,
  }) async {
    if (!_draftPersistenceAvailable) {
      if (notifyOnFailure) {
        _showSnackBar(context.l10n.appSnackLocalSaveUnavailable);
      }
      return null;
    }

    try {
      return await SharedPreferences.getInstance();
    } on MissingPluginException {
      _markPreferencesUnavailable(notifyUser: notifyOnFailure);
      return null;
    } on PlatformException {
      _markPreferencesUnavailable(notifyUser: notifyOnFailure);
      return null;
    }
  }

  void _markPreferencesUnavailable({required bool notifyUser}) {
    if (_draftPersistenceAvailable && mounted) {
      setState(() {
        _draftPersistenceAvailable = false;
      });
    } else {
      _draftPersistenceAvailable = false;
    }

    if (notifyUser && mounted) {
      _showSnackBar(context.l10n.appSnackLocalSaveUnavailable);
    }
  }

  int _forgeSectionIndex(_ForgeSection section) =>
      _ForgeSection.values.indexOf(section);

  void _scrollToTop(ScrollController controller) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.hasClients && controller.offset > 0) {
        controller.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _setAppStage(_AppStage stage) {
    _appStage = stage;
    final controller = switch (stage) {
      _AppStage.entry => _entryScrollController,
      _AppStage.forge => _forgeScrollController,
      _AppStage.parchment => _parchmentScrollController,
    };
    _scrollToTop(controller);
  }

  void _setForgeSection(_ForgeSection section) {
    if (_forgeSection == section) {
      return;
    }
    _forgeTransitionReverse =
        _forgeSectionIndex(section) < _forgeSectionIndex(_forgeSection);
    _forgeSection = section;
    _scrollToTop(_forgeScrollController);
  }

  void _selectCampaignType(String campaignType) {
    final hasChanged = campaignType != _selectedCampaignType;
    setState(() {
      _selectedCampaignType = campaignType;
      _selectedPreset = null;
      _appliedPreset = null;
      _setAppStage(_AppStage.forge);
      _setForgeSection(_ForgeSection.world);
      if (hasChanged) {
        _hasUnsavedChanges = true;
      }
    });
  }

  void _goToStage(_AppStage stage) {
    if (!_isStageUnlocked(stage)) {
      return;
    }
    setState(() {
      _setAppStage(stage);
      if (stage == _AppStage.forge &&
          _forgeSection == _ForgeSection.narrative) {
        _setForgeSection(_ForgeSection.world);
      }
    });
  }

  void _goToForge([_ForgeSection section = _ForgeSection.world]) {
    if (!_isStageUnlocked(_AppStage.forge)) {
      return;
    }
    setState(() {
      _setAppStage(_AppStage.forge);
      _setForgeSection(section);
    });
  }

  bool _isStageUnlocked(_AppStage stage) {
    switch (stage) {
      case _AppStage.entry:
        return true;
      case _AppStage.forge:
        return (_selectedCampaignType ?? '').trim().isNotEmpty;
      case _AppStage.parchment:
        return _canOpenParchmentStage();
    }
  }

  bool _canOpenParchmentStage() {
    if ((_generatedPrompt ?? '').trim().isNotEmpty) {
      return true;
    }

    if (_appStage == _AppStage.parchment) {
      return true;
    }

    return _appStage == _AppStage.forge &&
        _forgeSection == _ForgeSection.narrative;
  }

  void _advanceForge() {
    if (!_isForgePrimaryActionEnabled()) {
      final message = switch (_forgeSection) {
        _ForgeSection.world => context.l10n.forgeAdvanceBlockedWorld,
        _ForgeSection.party => context.l10n.forgeAdvanceBlockedParty,
        _ForgeSection.narrative => context.l10n.forgeAdvanceBlockedNarrative,
      };
      setState(() {
        _errorMessage = message;
      });
      _showSnackBar(message);
      return;
    }

    switch (_forgeSection) {
      case _ForgeSection.world:
        setState(() {
          _setForgeSection(_ForgeSection.party);
        });
        return;
      case _ForgeSection.party:
        setState(() {
          _setForgeSection(_ForgeSection.narrative);
        });
        return;
      case _ForgeSection.narrative:
        _generatePrompt();
        return;
    }
  }

  void _retreatForge() {
    switch (_forgeSection) {
      case _ForgeSection.world:
        _goToStage(_AppStage.entry);
        return;
      case _ForgeSection.party:
        setState(() {
          _setForgeSection(_ForgeSection.world);
        });
        return;
      case _ForgeSection.narrative:
        setState(() {
          _setForgeSection(_ForgeSection.party);
        });
        return;
    }
  }

  String _currentSettingLabel() {
    final customSetting = _customSettingController.text.trim();
    if (customSetting.isNotEmpty) {
      return customSetting;
    }
    return _selectedSetting ?? context.l10n.appSettingPending;
  }

  String _currentTwistLabel() {
    final customTwist = _customTwistController.text.trim();
    if (customTwist.isNotEmpty) {
      return customTwist;
    }
    return _selectedTwist ?? context.l10n.appTwistPending;
  }

  List<String> _summaryTokens({int? limit}) {
    final tokens = <String>[
      _selectedCampaignType ?? context.l10n.appFreeFormat,
      _currentSettingLabel(),
      context.l10n.appSummaryLevel(_partyLevel),
      context.l10n.appSummaryPartySize(_partySize),
    ];

    if (_selectedThemes.isNotEmpty) {
      tokens.add(_selectedThemes.take(2).join(' + '));
    }
    if (_selectedTones.isNotEmpty) {
      tokens.add(_selectedTones.take(2).join(' + '));
    }
    if (_selectedPreset != null) {
      final displayName =
          _options?.presetNames[_selectedPreset!] ?? _selectedPreset!;
      tokens.add(context.l10n.appSummaryPreset(displayName));
    }

    if (limit == null || tokens.length <= limit) {
      return tokens;
    }
    return tokens.take(limit).toList(growable: false);
  }

  _CampaignTypeMeta _currentCampaignMeta([CampaignOptions? options]) {
    final selectedType = _selectedCampaignType;
    if (selectedType != null) {
      final selectedMeta = _campaignTypeMeta[selectedType];
      if (selectedMeta != null) {
        return selectedMeta;
      }
    }

    final availableOptions = options ?? _options;
    if (availableOptions != null && availableOptions.campaignTypes.isNotEmpty) {
      final fallbackType = availableOptions.campaignTypes.first;
      final fallbackMeta = _campaignTypeMeta[fallbackType];
      if (fallbackMeta != null) {
        return fallbackMeta;
      }
    }

    return _defaultCampaignMeta;
  }

  String _localizedCampaignBadge(String? campaignType) {
    switch (campaignType) {
      case 'One-Shot':
        return context.l10n.entryBadgeOneShot;
      case 'Mini-campagna':
      case 'Mini-campaign':
        return context.l10n.entryBadgeMiniCampaign;
      case 'Campagna lunga':
      case 'Long campaign':
        return context.l10n.entryBadgeLongCampaign;
      case 'Esplorazione dungeon':
      case 'Dungeon crawl':
        return context.l10n.entryBadgeDungeon;
      default:
        return context.l10n.entryBadgeDefault;
    }
  }

  String _localizedCampaignDescription(String? campaignType) {
    switch (campaignType) {
      case 'One-Shot':
        return context.l10n.entryDescriptionOneShot;
      case 'Mini-campagna':
      case 'Mini-campaign':
        return context.l10n.entryDescriptionMiniCampaign;
      case 'Campagna lunga':
      case 'Long campaign':
        return context.l10n.entryDescriptionLongCampaign;
      case 'Esplorazione dungeon':
      case 'Dungeon crawl':
        return context.l10n.entryDescriptionDungeon;
      default:
        return context.l10n.entryDescriptionDefault;
    }
  }

  CampaignAtmosphereData _currentAtmosphere([CampaignOptions? options]) {
    return _currentCampaignMeta(options).atmosphere;
  }

  ThemeData _resolvedAtmosphereTheme([CampaignOptions? options]) {
    return buildCampaignAtmosphereTheme(
      Theme.of(context),
      _currentAtmosphere(options),
    );
  }

  Widget _revealed({
    required double delay,
    required Widget child,
    CampaignAtmosphereData? atmosphere,
  }) {
    final resolvedAtmosphere = atmosphere ?? _currentAtmosphere();
    return AnimatedReveal(
      delay: delay,
      duration: resolvedAtmosphere.revealDuration,
      distance: resolvedAtmosphere.revealDistance,
      child: child,
    );
  }

  bool _isCurrentDraftSaved() {
    final prompt = _generatedPrompt;
    if (prompt == null || prompt.trim().isEmpty) {
      return false;
    }
    return !_hasUnsavedChanges && prompt == _savedDraftPrompt;
  }

  String? _savedDraftLabel() {
    if (!_draftPersistenceAvailable) {
      return context.l10n.appDraftMemoryOnly;
    }

    final savedAt = _savedDraftSavedAt;
    if (savedAt == null) {
      return null;
    }

    final timestamp = DateTime.fromMillisecondsSinceEpoch(savedAt).toLocal();
    final formattedDateTime = DateFormat.yMd(
      widget.currentLocale.toLanguageTag(),
    ).add_Hm().format(timestamp);

    if (_isCurrentDraftSaved()) {
      return context.l10n.appDraftAligned(formattedDateTime);
    }

    return context.l10n.appDraftLastSaved(formattedDateTime);
  }

  String _appStageLabel(_AppStage stage) {
    switch (stage) {
      case _AppStage.entry:
        return context.l10n.appStageEntry;
      case _AppStage.forge:
        return context.l10n.appStageForge;
      case _AppStage.parchment:
        return context.l10n.appStageParchment;
    }
  }

  String _forgeSectionLabel(_ForgeSection section) {
    switch (section) {
      case _ForgeSection.world:
        return context.l10n.forgeSectionWorld;
      case _ForgeSection.party:
        return context.l10n.forgeSectionParty;
      case _ForgeSection.narrative:
        return context.l10n.forgeSectionNarrative;
    }
  }

  String _nextForgeActionLabel() {
    switch (_forgeSection) {
      case _ForgeSection.world:
        return context.l10n.forgeNextParty;
      case _ForgeSection.party:
        return context.l10n.forgeNextNarrative;
      case _ForgeSection.narrative:
        return _hasUnsavedChanges && _generatedPrompt != null
            ? context.l10n.forgeReforgeParchment
            : context.l10n.forgeForgeParchment;
    }
  }

  bool _hasWorldSignals() {
    return _selectedThemes.isNotEmpty ||
        _selectedTones.isNotEmpty ||
        _selectedStyles.isNotEmpty ||
        _customThemeController.text.trim().isNotEmpty ||
        _customToneStyleController.text.trim().isNotEmpty ||
        _customTwistController.text.trim().isNotEmpty;
  }

  bool _canAdvanceWorldSection() {
    return (_selectedCampaignType ?? '').trim().isNotEmpty &&
        _currentSettingLabel().trim().isNotEmpty &&
        _hasWorldSignals();
  }

  bool _canAdvancePartySection() {
    return _partyLevel >= 1 &&
        _partyLevel <= 20 &&
        _partySize >= 1 &&
        _partySize <= 8 &&
        _selectedArchetypes.length <= _partySize;
  }

  bool _canForgeNarrativeSection() => true;

  bool _isForgePrimaryActionEnabled() {
    switch (_forgeSection) {
      case _ForgeSection.world:
        return _canAdvanceWorldSection();
      case _ForgeSection.party:
        return _canAdvancePartySection();
      case _ForgeSection.narrative:
        return _canForgeNarrativeSection();
    }
  }

  void _trimArchetypesToPartySize() {
    if (_selectedArchetypes.length <= _partySize) {
      return;
    }
    final trimmed = _selectedArchetypes.take(_partySize).toSet();
    _selectedArchetypes
      ..clear()
      ..addAll(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    final options = _options;
    final atmosphere = _currentAtmosphere(options);
    final atmosphereTheme =
        buildCampaignAtmosphereTheme(Theme.of(context), atmosphere);

    return Theme(
      data: atmosphereTheme,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: FantasyBackdrop(
                atmosphere: atmosphere,
                stageVignette: _appStage == _AppStage.entry,
              ),
            ),
            if (_isLoadingOptions)
              const Center(child: CircularProgressIndicator())
            else if (options == null)
              _buildErrorState()
            else
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                      child: _buildPersistentTopBar(),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: Navigator(
                        pages: _buildStagePages(options),
                        onDidRemovePage: _handleStagePageRemoved,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Page<void>> _buildStagePages(CampaignOptions options) {
    final atmosphere = _currentAtmosphere(options);
    final pages = <Page<void>>[
      CampaignStagePage(
        key: const ValueKey<String>('entry-route'),
        name: '/entry',
        atmosphere: atmosphere,
        child: _buildEntryStage(options),
      ),
    ];

    if (_appStage == _AppStage.forge || _appStage == _AppStage.parchment) {
      pages.add(
        CampaignStagePage(
          key: const ValueKey<String>('forge-route'),
          name: '/forge',
          atmosphere: atmosphere,
          child: _buildForgeStage(options),
        ),
      );
    }

    if (_appStage == _AppStage.parchment) {
      pages.add(
        CampaignStagePage(
          key: const ValueKey<String>('parchment-route'),
          name: '/parchment',
          atmosphere: atmosphere,
          child: _buildParchmentStage(options),
        ),
      );
    }

    return pages;
  }

  void _handleStagePageRemoved(Page<Object?> page) {
    setState(() {
      switch (page.name) {
        case '/parchment':
          _setAppStage(_AppStage.forge);
          break;
        case '/forge':
          _setAppStage(_AppStage.entry);
          break;
        default:
          break;
      }
    });
  }

  Widget _buildPersistentTopBar() {
    final atmosphere = _currentAtmosphere();
    final theme = _resolvedAtmosphereTheme();
    final isEntryStage = _appStage == _AppStage.entry;
    final campaignTypeLabel =
        _selectedCampaignType ?? context.l10n.appFreeFormat;
    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: atmosphere.primary.withValues(
              alpha: isEntryStage ? 0.07 : 0.12,
            ),
            border: Border.all(
              color: atmosphere.primary.withValues(
                alpha: isEntryStage ? 0.12 : 0.2,
              ),
            ),
          ),
          child: Icon(
            _currentCampaignMeta().icon,
            color: atmosphere.highlight,
            size: 17,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    context.l10n.appNameShort,
                    style: theme.textTheme.titleSmall,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: atmosphere.primary.withValues(
                        alpha: isEntryStage ? 0.05 : 0.08,
                      ),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: atmosphere.primary.withValues(
                          alpha: isEntryStage ? 0.09 : 0.16,
                        ),
                      ),
                    ),
                    child: Text(
                      campaignTypeLabel,
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    final stageSummary = LayoutBuilder(
      builder: (context, constraints) {
        final alignEnd = constraints.maxWidth >= 980;
        return Column(
          crossAxisAlignment:
              alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            _buildAppStageRibbon(),
          ],
        );
      },
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: atmosphere.primary.withValues(
            alpha: isEntryStage ? 0.12 : 0.18,
          ),
        ),
        color: Color.lerp(FantasyPalette.card, atmosphere.cardTint, 0.2)!
            .withValues(alpha: isEntryStage ? 0.86 : 0.92),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: atmosphere.glow.withValues(
              alpha: isEntryStage ? 0.04 : 0.08,
            ),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 980;
          final padding = compact ? 12.0 : 20.0;
          final languageSwitch = _buildLanguageSwitch();
          final action = _buildTopBarAction(compact: compact);

          if (compact) {
            return Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header,
                  const SizedBox(height: 6),
                  stageSummary,
                  const SizedBox(height: 6),
                  _buildTopBarUtilities(
                    languageSwitch: languageSwitch,
                    action: action,
                    alignment: WrapAlignment.start,
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: header),
                const SizedBox(width: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildTopBarUtilities(
                        languageSwitch: languageSwitch,
                        action: action,
                        alignment: WrapAlignment.end,
                      ),
                      const SizedBox(height: 6),
                      stageSummary,
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBarUtilities({
    required Widget languageSwitch,
    required Widget? action,
    required WrapAlignment alignment,
  }) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: alignment,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        languageSwitch,
        if (action != null) action,
      ],
    );
  }

  ButtonStyle _topBarActionStyle() {
    return FilledButton.styleFrom(
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  ButtonStyle _compactTopBarActionStyle() {
    return TextButton.styleFrom(
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget? _buildTopBarAction({required bool compact}) {
    switch (_appStage) {
      case _AppStage.entry:
        return null;
      case _AppStage.forge:
        if (_generatedPrompt == null) {
          return null;
        }
        if (compact) {
          return TextButton(
            style: _compactTopBarActionStyle(),
            onPressed: () => _goToStage(_AppStage.parchment),
            child: Text(context.l10n.commonOpen),
          );
        }
        return FilledButton.icon(
          style: _topBarActionStyle(),
          onPressed: () => _goToStage(_AppStage.parchment),
          icon: const Icon(Icons.description_rounded),
          label: Text(context.l10n.appOpenParchment),
        );
      case _AppStage.parchment:
        if (compact) {
          return TextButton(
            style: _compactTopBarActionStyle(),
            onPressed: _sealCurrentParchment,
            child: Text(context.l10n.appStageForge),
          );
        }
        return FilledButton.icon(
          style: _topBarActionStyle(),
          onPressed: _sealCurrentParchment,
          icon: const Icon(Icons.approval_rounded),
          label: Text(context.l10n.appSealParchment),
        );
    }
  }

  Widget _buildLanguageSwitch() {
    final selectedCode = widget.currentLocale.languageCode;
    final theme = _resolvedAtmosphereTheme();
    final colorScheme = theme.colorScheme;

    Widget buildSegment({
      required String code,
      required String label,
    }) {
      final selected = code == selectedCode;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: selected ? null : () => widget.onLocaleChanged(Locale(code)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: selected
                  ? colorScheme.primary.withValues(alpha: 0.18)
                  : Colors.transparent,
            ),
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: selected
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      key: const ValueKey<String>('top-bar-language-switch'),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.28),
        ),
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildSegment(
            code: 'en',
            label: context.l10n.languageEnglishShort,
          ),
          buildSegment(
            code: 'it',
            label: context.l10n.languageItalianShort,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    final colorScheme = _resolvedAtmosphereTheme().colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.error.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppStageRibbon() {
    final pills = _AppStage.values.map((stage) {
      final active = _appStage == stage;
      final enabled = _isStageUnlocked(stage);
      final completed = stage == _AppStage.entry
          ? _selectedCampaignType != null
          : stage == _AppStage.forge
              ? _generatedPrompt != null
              : _generatedPrompt != null && !_hasUnsavedChanges;

      return StagePill(
        index: _AppStage.values.indexOf(stage) + 1,
        label: _appStageLabel(stage),
        active: active,
        enabled: enabled,
        completed: completed,
        onTap: enabled ? () => _goToStage(stage) : null,
      );
    }).toList();

    return StagePillRibbon(
      children: pills,
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: SectionFrame(
            eyebrow: context.l10n.appErrorEyebrow,
            title: context.l10n.appErrorTitle,
            subtitle: _errorMessage ?? context.l10n.appErrorUnknownLoad,
            icon: Icons.error_outline_rounded,
            child: FilledButton(
              onPressed: _loadOptions,
              child: Text(context.l10n.commonRetry),
            ),
          ),
        ),
      ),
    );
  }
}
