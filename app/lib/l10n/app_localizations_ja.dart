// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'D&Dキャンペーンクリエイター';

  @override
  String get appNameShort => 'キャンペーンクリエイター';

  @override
  String get languageItalianShort => 'IT';

  @override
  String get languageEnglishShort => 'EN';

  @override
  String get languageSpanishShort => 'ES';

  @override
  String get languageFrenchShort => 'FR';

  @override
  String get languageGermanShort => 'DE';

  @override
  String get languagePortugueseShort => 'PT';

  @override
  String get languagePolishShort => 'PL';

  @override
  String get languageJapaneseShort => 'JP';

  @override
  String get commonRetry => '再試行';

  @override
  String get commonOpen => '開く';

  @override
  String get commonOptional => '任意';

  @override
  String get appFreeFormat => '形式を選択';

  @override
  String get appSettingPending => '舞台を設定';

  @override
  String get appTwistPending => 'ひねりを設定';

  @override
  String get appStageEntry => '選択';

  @override
  String get appStageForge => '鍛造';

  @override
  String get appStageParchment => '羊皮紙';

  @override
  String get appOpenParchment => '羊皮紙を開く';

  @override
  String get appSealParchment => '羊皮紙を封印';

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
  String get appSnackShareUnavailableOnDevice =>
      'Sharing is not available on this device.';

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
  String get appSnackPremiumUnlockedTemporary =>
      'Premium unlocked for 5 minutes';

  @override
  String get appSnackRewardedAdUnavailable =>
      'Ad not available right now. Try again in a moment.';

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
  String get entryCampaignTypesTitle => 'キャンペーンタイプ';

  @override
  String get entryResumeTitle => 'セッションを再開';

  @override
  String get entryResumeSubtitle => '進行中の下書きがあります。続きから再開できます。';

  @override
  String get entryResumeForge => '鍛造を再開';

  @override
  String get entryOpenForge => '鍛造を開く';

  @override
  String get entryHeroWelcomeTitle => 'キャンペーンを選ぼう';

  @override
  String get entryHeroWelcomeBody => 'キャンペーン用のプロンプトを鍛え、信頼できるAIで命を吹き込みましょう。';

  @override
  String get entryHeroChooseRitual => '形式を選んで始めましょう。';

  @override
  String get onboardingHowItWorks => 'How it works';

  @override
  String get onboardingChooseCampaignTitle => 'Choose Campaign';

  @override
  String get onboardingChooseCampaignBody =>
      'Pick the campaign format first so the rest of the setup has the right shape.';

  @override
  String get onboardingDefineDetailsTitle => 'Define Key Details';

  @override
  String get onboardingDefineDetailsBody =>
      'Set the world, themes, tone, style, party, and twist before forging the prompt.';

  @override
  String get onboardingForgePromptTitle => 'Forge the prompt';

  @override
  String get onboardingForgePromptBody =>
      'Generate the final prompt, preview it and paste it on ChatGPT.';

  @override
  String get onboardingGeneratedPromptTitle => 'Generated prompt';

  @override
  String get onboardingPastePromptSubtitle =>
      'Paste the generated prompt there.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingStartForging => 'Start Forging';

  @override
  String get onboardingCopyStep => 'Copy';

  @override
  String get onboardingSettingExample => 'Border kingdom';

  @override
  String get onboardingThemesExample => 'Political tension';

  @override
  String get onboardingToneExample => 'Dark & noir';

  @override
  String get onboardingStyleExample => 'Grounded fantasy';

  @override
  String get entryResetDraft => '新しいセッション';

  @override
  String get entryResetDraftConfirm => '下書きを削除しました。';

  @override
  String get entryBadgeDefault => '形式';

  @override
  String get entryDescriptionDefault => 'キャンペーン形式は端末上で準備完了です。';

  @override
  String get entryBadgeOneShot => '短期決戦';

  @override
  String get entryDescriptionOneShot => '一度の卓で完結する、高密度で即効性のあるミッション。';

  @override
  String get entryBadgeMiniCampaign => '短い章';

  @override
  String get entryDescriptionMiniCampaign => '数回のセッションに凝縮され、強い進行と明確な結末を持つ物語。';

  @override
  String get entryBadgeLongCampaign => '大いなる叙事';

  @override
  String get entryDescriptionLongCampaign =>
      '勢力、揺れる均衡、持続する副筋が時間とともに育つ長編キャンペーン。';

  @override
  String get entryBadgeDungeon => '深層';

  @override
  String get entryDescriptionDungeon => '地図、危険、消耗、層状の発見を伴う構造化された下降行。';

  @override
  String get forgeSectionWorld => '世界';

  @override
  String get forgeSectionParty => 'パーティ';

  @override
  String get forgeSectionNarrative => '物語';

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
  String get forgeReforgeParchmentCompact => 'Reforge Parchment';

  @override
  String get forgeForgeParchmentCompact => 'Forge Parchment';

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
  String get forgeWorldSectionTitle => 'World building';

  @override
  String get forgeWorldSectionSubtitle =>
      'Format, setting, and the opening signals of the campaign.';

  @override
  String get forgeFoundationLabel => 'Foundation';

  @override
  String get forgeFoundationTitle => 'Base setup';

  @override
  String get forgeFoundationSubtitle => 'Setting and scenario.';

  @override
  String get forgePresetSectionTitle => 'Choose a preset';

  @override
  String get forgePresetSectionSubtitle =>
      'Apply a preset to quickly configure your campaign.';

  @override
  String get forgePresetPanelLabel => 'Presets';

  @override
  String get forgePresetPanelTitle => 'Quick presets';

  @override
  String get forgeQuickPresetLabel => 'Quick preset';

  @override
  String get forgeNoPresetSelected => 'No preset';

  @override
  String get forgeApplyPreset => 'Forge with preset';

  @override
  String get forgeApply => 'Forge with preset';

  @override
  String get forgeSettingLabel => 'Setting';

  @override
  String get forgeCustomSettingLabel => 'Custom setting';

  @override
  String get forgeCustomSettingHint => 'E.g. Kingdom at war, vertical city';

  @override
  String get forgeTwistTitle => 'Opening twist';

  @override
  String get forgeTwistHelpTooltip => 'Opening twist help';

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
  String get forgeCreativeHelpTooltip => 'Creative direction help';

  @override
  String get forgeCreativeHelpBody =>
      'Choose the themes, tone, and narrative style of your campaign.';

  @override
  String get forgeThemesTitle => 'Themes';

  @override
  String get forgeCustomThemesLabel => 'Custom themes';

  @override
  String get forgeCustomThemesHint => 'E.g. Steampunk, cosmic horror';

  @override
  String get forgeToneTitle => 'Tone';

  @override
  String get forgeStyleTitle => 'Style';

  @override
  String get forgeToneStyleOverrideLabel => 'Custom tones & style';

  @override
  String get forgeToneStyleOverrideHint => 'E.g. Tone: dark; Style: gritty';

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
  String get forgePartyLevelPremiumHint => 'Levels 4+ are premium';

  @override
  String get forgePartySizePremiumHint => '5+ characters are premium';

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
      'Extra hooks, factions, and constraints to customize the parchment.';

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
  String get parchmentPreviewPromptTooltip => 'Prompt preview';

  @override
  String get parchmentGoHomeTooltip => 'Back to home';

  @override
  String get parchmentPreviewSheetTitle => 'Prompt preview';

  @override
  String get parchmentPreviewSheetSubtitle =>
      'Review the full prompt before copying or pasting it.';

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

  @override
  String get infoDialogLine1 =>
      'This app is a prompt generator inspired by fantasy role-playing games.';

  @override
  String get infoDialogLine2 =>
      'It is not affiliated with Dungeons & Dragons or any AI language tool.';

  @override
  String get infoDialogLine3 =>
      'You can use the prompts with AI tools to create your own stories.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLeaveReview => 'Leave a review';

  @override
  String get settingsShareApp => 'Share the app';

  @override
  String get settingsPrivacyOptions => 'Privacy Settings';

  @override
  String get settingsShareText =>
      'Discover Campaign Forge, the D&D campaign generator: ';

  @override
  String get settingsLanguageLabel => 'Language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsThemeLabel => 'Theme';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsInfoLabel => 'Info';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsGoAdFree => 'Ads';

  @override
  String get settingsGoAdFreePrice => 'Unlock Premium';

  @override
  String get settingsGoAdFreeSubtitle => 'One-time purchase · £1.99';

  @override
  String settingsGoAdFreeSubtitleWithAmount(String price) {
    return 'One-time purchase · $price';
  }

  @override
  String settingsGoAdFreePriceWithAmount(String price) {
    return 'Unlock Premium — $price';
  }

  @override
  String get settingsRestorePurchases => 'Restore purchases';

  @override
  String get settingsRestorePurchasesStarted => 'Restoring purchases…';

  @override
  String get settingsRestorePurchasesComplete =>
      'Purchases restored successfully.';

  @override
  String get settingsAdFreeActive => 'Ads removed';

  @override
  String get settingsIapUnavailable =>
      'In-app purchases unavailable on this device.';

  @override
  String get settingsIapProductNotFound =>
      'Product not found. Try again later.';

  @override
  String get settingsPurchasePending => 'Purchase processing…';

  @override
  String get settingsPurchaseCancelled => 'Purchase cancelled.';

  @override
  String get settingsPurchaseFailed => 'Purchase failed. Please try again.';

  @override
  String get premiumUnlockTitle => 'Premium feature';

  @override
  String get premiumUnlockBodyWithAd =>
      'Watch an ad to unlock all premium features for 5 minutes, or unlock Premium to access everything permanently.';

  @override
  String get premiumUnlockBodyNoAd =>
      'Unlock Premium to access this feature permanently.';

  @override
  String get premiumUnlockWatchAd => 'Watch ad (5 min)';

  @override
  String get helpTitle => 'Guide';

  @override
  String get helpCampaignTypesTitle => 'Campaign types';

  @override
  String get helpCampaignTypeOneShotTitle => 'One-Shot';

  @override
  String get helpCampaignTypeOneShotBody =>
      'A complete adventure built for a single session, with a strong opening, a clear goal, and a fast payoff. Choose it when you want immediate momentum and a tight arc.';

  @override
  String get helpCampaignTypeMiniCampaignTitle => 'Mini-Campaign';

  @override
  String get helpCampaignTypeMiniCampaignBody =>
      'A short arc that unfolds across a few sessions, leaving room for escalation and a sharper finale. Best when you want something compact but less compressed than a one-shot.';

  @override
  String get helpCampaignTypeLongCampaignTitle => 'Long Campaign';

  @override
  String get helpCampaignTypeLongCampaignBody =>
      'An extended structure with factions, subplots, and consequences that develop over time. Ideal if you want continuity, progression, and a world that reacts to player choices.';

  @override
  String get helpCampaignTypeDungeonTitle => 'Dungeon Exploration';

  @override
  String get helpCampaignTypeDungeonBody =>
      'A campaign focused on maps, discovery, attrition, and secrets hidden in dangerous places. Perfect when you want pressure, exploration, and a strong sense of place.';

  @override
  String get helpTipsTitle => 'Tips & best practices';

  @override
  String get helpTipWorld =>
      'Start from setting and theme: they are the constraints that keep everything coherent.';

  @override
  String get helpTipTheme =>
      'Use 1 or 2 strong themes instead of piling on too many similar ideas.';

  @override
  String get helpTipTwist => 'Pick a twist to give the plot immediate tension.';

  @override
  String get helpTipContrast =>
      'Try combining contrasting tones to get less predictable prompts.';

  @override
  String get helpTipPreset =>
      'Use presets when you want quick inspiration or a strong starting point.';

  @override
  String get helpTipCustom =>
      'Add custom entries only when the exact option you need does not already exist.';

  @override
  String get helpTipParty =>
      'Keep level, party size, and archetypes aligned to avoid uneven prompts.';
}
