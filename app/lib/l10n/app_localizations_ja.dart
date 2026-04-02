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
  String get languageKoreanShort => 'KR';

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
  String get forgeFoundationTitle => '基本設定';

  @override
  String get forgeFoundationSubtitle => '舞台とシナリオ。';

  @override
  String get forgePresetSectionTitle => 'プリセットを選択';

  @override
  String get forgePresetSectionSubtitle => 'プリセットを適用してキャンペーンをすばやく設定します。';

  @override
  String get forgePresetPanelLabel => 'Presets';

  @override
  String get forgePresetPanelTitle => 'Quick presets';

  @override
  String get forgeQuickPresetLabel => 'Quick preset';

  @override
  String get forgeNoPresetSelected => 'No preset';

  @override
  String get forgeApplyPreset => 'プリセットで鍛造';

  @override
  String get forgeApply => 'プリセットで鍛造';

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
  String get forgeCreativeTitle => 'テーマ・トーン・スタイル';

  @override
  String get forgeCreativeHelpTooltip => 'Creative direction help';

  @override
  String get forgeCreativeHelpBody =>
      'Choose the themes, tone, and narrative style of your campaign.';

  @override
  String get forgeThemesTitle => 'テーマ';

  @override
  String get forgeCustomThemesLabel => 'Custom themes';

  @override
  String get forgeCustomThemesHint => 'E.g. Steampunk, cosmic horror';

  @override
  String get forgeToneTitle => 'トーン';

  @override
  String get forgeStyleTitle => 'スタイル';

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
  String get settingsTitle => '設定';

  @override
  String get settingsLeaveReview => 'レビューを書く';

  @override
  String get settingsShareApp => 'アプリを共有';

  @override
  String get settingsPrivacyOptions => 'プライバシー設定';

  @override
  String get settingsShareText => 'D&Dキャンペーン生成アプリ「Campaign Forge」をチェック: ';

  @override
  String get settingsLanguageLabel => '言語';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsThemeLabel => 'テーマ';

  @override
  String get settingsThemeDark => 'ダーク';

  @override
  String get settingsThemeLight => 'ライト';

  @override
  String get settingsInfoLabel => '情報';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String get settingsGoAdFree => '広告';

  @override
  String get settingsGoAdFreePrice => 'プレミアムを解除';

  @override
  String get settingsGoAdFreeSubtitle => '一度限りの購入 · £1.99';

  @override
  String settingsGoAdFreeSubtitleWithAmount(String price) {
    return '一度限りの購入 · $price';
  }

  @override
  String settingsGoAdFreePriceWithAmount(String price) {
    return 'プレミアムを解除 — $price';
  }

  @override
  String get settingsRestorePurchases => '購入を復元';

  @override
  String get settingsRestorePurchasesStarted => '購入を復元中…';

  @override
  String get settingsRestorePurchasesComplete => '購入が正常に復元されました。';

  @override
  String get settingsAdFreeActive => '広告削除済み';

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
  String get premiumUnlockTitle => 'プレミアム機能';

  @override
  String get premiumUnlockBodyWithAd =>
      '広告を見ると、すべてのプレミアム機能を5分間アンロックできます。恒久的に使うにはプレミアムを解除してください。';

  @override
  String get premiumUnlockBodyNoAd => 'この機能を恒久的に使うにはプレミアムを解除してください。';

  @override
  String get premiumUnlockWatchAd => '広告を見る（5分）';

  @override
  String get helpTitle => 'ガイド';

  @override
  String get helpCampaignTypesTitle => 'キャンペーンタイプ';

  @override
  String get helpCampaignTypeOneShotTitle => 'One-Shot';

  @override
  String get helpCampaignTypeOneShotBody =>
      '1セッションで完結する冒険で、強い導入、明確な目標、素早い見返りを備えています。即効性と引き締まった展開が欲しいときに最適です。';

  @override
  String get helpCampaignTypeMiniCampaignTitle => 'ミニキャンペーン';

  @override
  String get helpCampaignTypeMiniCampaignBody =>
      '数回のセッションで展開する短い物語で、エスカレーションと鋭い結末の余地があります。ワンショットほど圧縮されていない、コンパクトな体験に向いています。';

  @override
  String get helpCampaignTypeLongCampaignTitle => '長編キャンペーン';

  @override
  String get helpCampaignTypeLongCampaignBody =>
      '時間をかけて発展する勢力、サブプロット、結果を含む長期構成です。継続性、成長、プレイヤーの選択に反応する世界が欲しい場合に理想的です。';

  @override
  String get helpCampaignTypeDungeonTitle => 'ダンジョン探索';

  @override
  String get helpCampaignTypeDungeonBody =>
      '地図、発見、消耗、危険な場所に隠された秘密に焦点を当てたキャンペーンです。緊張感、探索、強い場所性を求めるときに最適です。';

  @override
  String get helpTipsTitle => 'ヒントとベストプラクティス';

  @override
  String get helpTipWorld => '設定とテーマから始めましょう。それが全体の一貫性を保つ制約になります。';

  @override
  String get helpTipTheme => '似たアイデアを詰め込みすぎず、強いテーマを1つか2つ選びましょう。';

  @override
  String get helpTipTwist => 'ひねりを選んで、物語に即座に緊張感を与えましょう。';

  @override
  String get helpTipContrast => '対照的なトーンを組み合わせると、より予測しにくいプロンプトになります。';

  @override
  String get helpTipPreset => '素早く着想を得たいときや、強い出発点が欲しいときはプリセットを使いましょう。';

  @override
  String get helpTipCustom => '必要な項目が既存の選択肢にない場合にだけカスタム項目を追加しましょう。';

  @override
  String get helpTipParty => '偏りのないプロンプトにするため、レベル、人数、アーキタイプを揃えましょう。';
}
