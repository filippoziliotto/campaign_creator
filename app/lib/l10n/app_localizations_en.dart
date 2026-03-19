// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'D&D Campaign Creator';

  @override
  String get appNameShort => 'Campaign Creator';

  @override
  String get languageItalianShort => 'IT';

  @override
  String get languageEnglishShort => 'EN';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonOpen => 'Open';

  @override
  String get appFreeFormat => 'Free format';

  @override
  String get appSettingPending => 'Setting to define';

  @override
  String get appTwistPending => 'Twist to define';

  @override
  String get appStageEntry => 'Choice';

  @override
  String get appStageForge => 'Forge';

  @override
  String get appStageParchment => 'Parchment';

  @override
  String get appOpenParchment => 'Open parchment';

  @override
  String get appSealParchment => 'Seal parchment';

  @override
  String appSummaryLevel(int level) {
    return 'Lvl $level';
  }

  @override
  String appSummaryPartySize(int size) {
    return '$size PCs';
  }

  @override
  String appSummaryPreset(String name) {
    return 'Preset: $name';
  }

  @override
  String appLoadOptionsError(String error) {
    return 'Unable to load options: $error';
  }

  @override
  String appGenerationFailedError(String error) {
    return 'Generation failed: $error';
  }

  @override
  String appInvalidArchetypeSelection(int count, int size) {
    return 'You selected $count archetypes, but the party is set to $size PCs.';
  }

  @override
  String get appSnackForgedAndCopied =>
      'Parchment forged and prompt copied to the clipboard.';

  @override
  String get appSnackGenerationFailed =>
      'Generation failed. Check the message shown on screen.';

  @override
  String get appSnackPromptCopied => 'Prompt copied to the clipboard.';

  @override
  String get appSnackNoParchmentToShare =>
      'There is no parchment to share yet.';

  @override
  String appSnackShareUnavailable(String error) {
    return 'Sharing unavailable: $error';
  }

  @override
  String get appSnackGenerateFirst =>
      'Generate a parchment first before sending it.';

  @override
  String get appSnackChatGptOpened =>
      'ChatGPT opened. The prompt is already in the clipboard.';

  @override
  String get appSnackChatGptCopiedOnly =>
      'Unable to open ChatGPT, but the prompt was copied.';

  @override
  String get appSnackNoParchmentToSave => 'There is no parchment to save.';

  @override
  String get appSnackDraftSaved => 'Parchment draft saved locally.';

  @override
  String get appSnackDraftMemoryOnly =>
      'Draft saved in memory only. Fully restart the app to enable local persistence.';

  @override
  String get appSnackSealedSavedAndCopied =>
      'Parchment sealed: draft saved and prompt copied.';

  @override
  String get appSnackSealedCopiedOnlyMemory =>
      'Parchment sealed: prompt copied. Fully restart the app to enable local saving.';

  @override
  String get appSnackLocalSaveUnavailable =>
      'Local saving is unavailable in this session. Close and relaunch the app to register the plugin.';

  @override
  String get appDraftMemoryOnly =>
      'Draft kept in memory only. Fully restart the app to reactivate local saving.';

  @override
  String appDraftAligned(String dateTime) {
    return 'Local draft aligned on $dateTime.';
  }

  @override
  String appDraftLastSaved(String dateTime) {
    return 'Last draft saved on $dateTime.';
  }

  @override
  String get appErrorEyebrow => 'Ritual interrupted';

  @override
  String get appErrorTitle => 'The grimoire is not responding';

  @override
  String get appErrorUnknownLoad => 'Unknown error while loading options.';

  @override
  String get entryCampaignTypesTitle => 'Campaign types';

  @override
  String get entryResumeTitle => 'Resume session';

  @override
  String get entryResumeSubtitle =>
      'You already have an active draft. Jump back to the right point.';

  @override
  String get entryResumeForge => 'Resume forge';

  @override
  String get entryOpenForge => 'Open forge';

  @override
  String get entryOpenParchment => 'Open parchment';

  @override
  String get entryBadgeDefault => 'Format';

  @override
  String get entryDescriptionDefault =>
      'Campaign format available from the backend.';

  @override
  String get entryBadgeOneShot => 'Fast blade';

  @override
  String get entryDescriptionOneShot =>
      'A high-impact mission designed for a single sitting, with immediate payoff and a precise twist.';

  @override
  String get entryBadgeMiniCampaign => 'Short arc';

  @override
  String get entryDescriptionMiniCampaign =>
      'A story condensed into a few sessions, with strong progression, escalation, and a sharp finale.';

  @override
  String get entryBadgeLongCampaign => 'Wide saga';

  @override
  String get entryDescriptionLongCampaign =>
      'Factions, shifting balances, and persistent subplots for a campaign that grows over time.';

  @override
  String get entryBadgeDungeon => 'Depths';

  @override
  String get entryDescriptionDungeon =>
      'A structured descent through maps, risk, attrition, and layered discoveries.';

  @override
  String get forgeSectionWorld => 'World';

  @override
  String get forgeSectionParty => 'Party';

  @override
  String get forgeSectionNarrative => 'Story';

  @override
  String get forgeButtonForging => 'Forging...';

  @override
  String get forgeNextParty => 'Go to Party';

  @override
  String get forgeNextNarrative => 'Go to Story';

  @override
  String get forgeReforgeParchment => 'Reforge Parchment';

  @override
  String get forgeForgeParchment => 'Forge Parchment';

  @override
  String get forgeAdvanceBlockedWorld =>
      'Define at least tone, style, or themes before moving to the party.';

  @override
  String get forgeAdvanceBlockedParty =>
      'Check party level, size, and archetypes before continuing.';

  @override
  String get forgeAdvanceBlockedNarrative =>
      'Add at least one narrative detail before forging the parchment.';

  @override
  String get forgeReadinessWorldReady => 'You can move on to the party.';

  @override
  String get forgeReadinessWorldPending =>
      'Choose format, setting, and key signals.';

  @override
  String get forgeReadinessPartyReady => 'You can open the story.';

  @override
  String get forgeReadinessPartyPending =>
      'Define level, size, and group roles.';

  @override
  String get forgeReadinessNarrativeReady => 'You can forge the parchment.';

  @override
  String get forgeReadinessNarrativePending =>
      'Add at least one narrative hook.';

  @override
  String get forgeWorldSectionTitle => 'World and creative signature';

  @override
  String get forgeWorldSectionSubtitle =>
      'Format, setting, and the opening signals of the campaign.';

  @override
  String get forgeFoundationLabel => 'Foundation';

  @override
  String get forgeFoundationTitle => 'Base setup';

  @override
  String get forgeFoundationSubtitle => 'Format, quick preset, and setting.';

  @override
  String get forgeQuickPresetLabel => 'Quick preset';

  @override
  String get forgeApplyPreset => 'Apply preset';

  @override
  String get forgeApply => 'Apply';

  @override
  String get forgeSettingLabel => 'Setting';

  @override
  String get forgeCustomSettingLabel => 'Custom setting detail';

  @override
  String get forgeCustomSettingHint =>
      'Kingdom at war, suspended frontier, vertical city, infernal archipelago...';

  @override
  String get forgeTwistTitle => 'Opening twist';

  @override
  String get forgeTwistLabel => 'Twist';

  @override
  String get forgeCustomTwistLabel => 'Custom twist';

  @override
  String get forgeCustomTwistHint =>
      'An ally lies, the dungeon is alive, the mission is a trap...';

  @override
  String get forgeCreativeTitle => 'Themes, tone and style';

  @override
  String get forgeThemesTitle => 'Themes';

  @override
  String get forgeCustomThemesLabel => 'Custom themes';

  @override
  String get forgeCustomThemesHint =>
      'Political intrigue, redemption, survival, cosmic horror...';

  @override
  String get forgeToneTitle => 'Tone';

  @override
  String get forgeStyleTitle => 'Style';

  @override
  String get forgeToneStyleOverrideLabel => 'Tone and style override';

  @override
  String get forgeToneStyleOverrideHint =>
      'E.g. tone: dark, epic\nstyle: sandbox, mystery';

  @override
  String get forgePartySectionTitle => 'Party and game scale';

  @override
  String get forgePartySectionSubtitle => 'Level, size, and main group roles.';

  @override
  String get forgeScaleLabel => 'Scale';

  @override
  String get forgeScaleTitle => 'Level and size';

  @override
  String forgePartyLevel(int level) {
    return 'Party level: $level';
  }

  @override
  String forgePartySize(int size) {
    return 'Number of characters: $size';
  }

  @override
  String get forgePartyArchetypesTitle => 'Party archetypes';

  @override
  String forgePartyArchetypesSubtitle(int size) {
    return 'Select up to $size archetypes.';
  }

  @override
  String get forgePartyArchetypesMaxReached =>
      'You reached the maximum archetypes selectable for the current party.';

  @override
  String get forgePartyInfoTitle => 'Useful information';

  @override
  String get forgeCharacterNotesLabel => 'Character notes';

  @override
  String get forgeCharacterNotesHint =>
      'Secrets, bonds, fears, important backstory...';

  @override
  String get forgeConstraintsLabel => 'Constraints';

  @override
  String get forgeConstraintsHint =>
      'Short duration, no planar travel, mandatory final boss...';

  @override
  String get forgeNarrativeSectionTitle => 'Narrative pressure';

  @override
  String get forgeNarrativeSectionSubtitle =>
      'Hooks, factions, encounters, and content limits.';

  @override
  String get forgeNarrativePanelTitle => 'Story and forces in play';

  @override
  String get forgeNarrativeHooksLabel => 'Narrative hooks';

  @override
  String get forgeNarrativeHooksHint =>
      'Opening mission, threat, mystery, countdown...';

  @override
  String get forgeFactionsLabel => 'Factions and powers';

  @override
  String get forgeFactionsHint =>
      'Guilds, cults, noble houses, antagonists, unstable allies...';

  @override
  String get forgeNpcFocusLabel => 'Key NPCs';

  @override
  String get forgeNpcFocusHint => 'Ambiguous mentor, rival, patron, traitor...';

  @override
  String get forgeEncounterFocusLabel => 'Desired encounters';

  @override
  String get forgeEncounterFocusHint =>
      'Siege, social investigation, chase, final boss...';

  @override
  String get forgeContentConstraintsTitle => 'Content constraints';

  @override
  String get forgeIncludeNpcsLabel => 'Include NPCs';

  @override
  String get forgeIncludeNpcsSubtitle =>
      'The prompt will include relevant non-player characters.';

  @override
  String get forgeIncludeEncountersLabel => 'Include encounters';

  @override
  String get forgeIncludeEncountersSubtitle =>
      'The prompt will suggest scenes and combats.';

  @override
  String get forgeSafetyNotesLabel => 'Safety notes';

  @override
  String get forgeSafetyNotesHint =>
      'Topics to avoid, lines and veils, tone limits...';

  @override
  String get forgeParchmentDirty => 'Configuration changed: regenerate.';

  @override
  String get forgeParchmentReady => 'Parchment up to date.';

  @override
  String get forgeParchmentIncomplete => 'Complete the story to generate.';

  @override
  String get statusReady => 'Ready';

  @override
  String get statusNeedsPolish => 'Needs polish';

  @override
  String get parchmentReadyTitle => 'Parchment ready';

  @override
  String get parchmentReadySubtitleStale =>
      'You changed the forge: the copied prompt is no longer up to date.';

  @override
  String get parchmentReadySubtitleAligned =>
      'The copied prompt is aligned with the current forge state.';

  @override
  String get parchmentQuickActionsTitle => 'Quick actions';

  @override
  String get parchmentCopyPromptTitle => 'Copy prompt';

  @override
  String get parchmentCopyPromptSubtitle => 'Send the prompt to the clipboard.';

  @override
  String get parchmentShareTitle => 'Share';

  @override
  String get parchmentShareSubtitle => 'Opens the sharing menu.';

  @override
  String get parchmentOpenChatGptTitle => 'Open in ChatGPT';

  @override
  String get parchmentOpenChatGptSubtitle => 'Opens ChatGPT in a new tab.';

  @override
  String get parchmentDraftUpdatedTitle => 'Draft updated';

  @override
  String get parchmentSaveDraftTitle => 'Save draft';

  @override
  String get parchmentSaveDraftSubtitle => 'Save the prompt locally for later.';

  @override
  String get parchmentPromptCopied => 'Prompt copied';

  @override
  String get parchmentCopiedStaleBanner =>
      'You changed the forge after the last generation. Regenerate to refresh the copied prompt.';

  @override
  String get parchmentCopiedSuccessBody =>
      'The parchment was forged successfully. Use the rituals on the right to share it, save it, or open it in ChatGPT.';

  @override
  String get atmosphereOneShot => 'Crimson urgency';

  @override
  String get atmosphereMiniCampaign => 'Golden road';

  @override
  String get atmosphereLongCampaign => 'Green atlas';

  @override
  String get atmosphereDungeon => 'Torch vault';

  @override
  String get parchmentSeal => 'SEAL';

  @override
  String get parchmentSealAndCopy => 'Seal and copy';
}
