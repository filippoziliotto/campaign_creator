// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Créateur de campagnes D&D';

  @override
  String get appNameShort => 'Créateur de campagnes';

  @override
  String get languageItalianShort => 'IT';

  @override
  String get languageEnglishShort => 'EN';

  @override
  String get languageSpanishShort => 'ES';

  @override
  String get languageFrenchShort => 'FR';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonOpen => 'Ouvrir';

  @override
  String get appFreeFormat => 'Choisir le format';

  @override
  String get appSettingPending => 'Cadre à définir';

  @override
  String get appTwistPending => 'Rebondissement à définir';

  @override
  String get appStageEntry => 'Choix';

  @override
  String get appStageForge => 'Forge';

  @override
  String get appStageParchment => 'Parchemin';

  @override
  String get appOpenParchment => 'Ouvrir le parchemin';

  @override
  String get appSealParchment => 'Sceller le parchemin';

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
      'Parchemin forgé et prompt copié dans le presse-papiers.';

  @override
  String get appSnackGenerationFailed =>
      'La génération a échoué. Vérifiez le message affiché à l’écran.';

  @override
  String get appSnackPromptCopied => 'Prompt copié dans le presse-papiers.';

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
      'Générez d’abord un parchemin avant de l’envoyer.';

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
  String get appErrorEyebrow => 'Rituel interrompu';

  @override
  String get appErrorTitle => 'Le grimoire ne répond pas';

  @override
  String get appErrorUnknownLoad =>
      'Erreur inconnue lors du chargement des options.';

  @override
  String get entryCampaignTypesTitle => 'Types de campagne';

  @override
  String get entryResumeTitle => 'Reprendre la session';

  @override
  String get entryResumeSubtitle =>
      'Vous avez déjà un brouillon actif. Revenez immédiatement au bon endroit.';

  @override
  String get entryResumeForge => 'Reprendre la forge';

  @override
  String get entryOpenForge => 'Ouvrir la forge';

  @override
  String get entryHeroWelcomeTitle => 'Choisissez votre campagne';

  @override
  String get entryHeroWelcomeBody =>
      'Forgez le prompt de votre campagne, puis donnez-lui vie avec votre IA de confiance.';

  @override
  String get entryHeroChooseRitual => 'Sélectionnez un format pour commencer.';

  @override
  String get entryResetDraft => 'Nouvelle session';

  @override
  String get entryResetDraftConfirm => 'Brouillon supprimé.';

  @override
  String get entryBadgeDefault => 'Format';

  @override
  String get entryDescriptionDefault =>
      'Format de campagne prêt sur l’appareil.';

  @override
  String get entryBadgeOneShot => 'Rapide';

  @override
  String get entryDescriptionOneShot =>
      'Une mission à fort impact pensée pour une seule séance, avec un payoff immédiat et un rebondissement précis.';

  @override
  String get entryBadgeMiniCampaign => 'Arc court';

  @override
  String get entryDescriptionMiniCampaign =>
      'Une histoire condensée en quelques séances, avec une progression forte, une montée en tension et une finale nette.';

  @override
  String get entryBadgeLongCampaign => 'Grande saga';

  @override
  String get entryDescriptionLongCampaign =>
      'Factions, équilibres mouvants et intrigues persistantes pour une campagne qui grandit dans la durée.';

  @override
  String get entryBadgeDungeon => 'Profondeurs';

  @override
  String get entryDescriptionDungeon =>
      'Une descente structurée entre cartes, risque, attrition et découvertes en couches.';

  @override
  String get forgeSectionWorld => 'Monde';

  @override
  String get forgeSectionParty => 'Groupe';

  @override
  String get forgeSectionNarrative => 'Histoire';

  @override
  String get forgeButtonForging => 'Forge en cours...';

  @override
  String get forgeNextParty => 'Aller au groupe';

  @override
  String get forgeNextNarrative => 'Aller à l’histoire';

  @override
  String get forgeReforgeParchment => 'Reforger le parchemin';

  @override
  String get forgeForgeParchment => 'Forger le parchemin';

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
  String get forgeWorldSectionTitle => 'Construction du monde';

  @override
  String get forgeWorldSectionSubtitle =>
      'Format, cadre et signaux initiaux de la campagne.';

  @override
  String get forgeFoundationLabel => 'Fondation';

  @override
  String get forgeFoundationTitle => 'Configuration de base';

  @override
  String get forgeFoundationSubtitle => 'Cadre et scénario.';

  @override
  String get forgePresetSectionTitle => 'Choisir un préréglage';

  @override
  String get forgePresetSectionSubtitle =>
      'Appliquez un préréglage pour configurer rapidement votre campagne.';

  @override
  String get forgePresetPanelLabel => 'Presets';

  @override
  String get forgePresetPanelTitle => 'Quick presets';

  @override
  String get forgeQuickPresetLabel => 'Quick preset';

  @override
  String get forgeApplyPreset => 'Apply preset';

  @override
  String get forgeApply => 'Apply';

  @override
  String get forgeSettingLabel => 'Cadre';

  @override
  String get forgeCustomSettingLabel => 'Cadre personnalisé';

  @override
  String get forgeCustomSettingHint => 'Ex. royaume en guerre, ville verticale';

  @override
  String get forgeTwistTitle => 'Rebondissement initial';

  @override
  String get forgeTwistLabel => 'Rebondissement';

  @override
  String get forgeCustomTwistLabel => 'Rebondissement personnalisé';

  @override
  String get forgeCustomTwistHint =>
      'Un allié ment, le donjon est vivant, la mission est un piège...';

  @override
  String get forgeCreativeTitle => 'Thèmes, ton et style';

  @override
  String get forgeThemesTitle => 'Thèmes';

  @override
  String get forgeCustomThemesLabel => 'Thèmes personnalisés';

  @override
  String get forgeCustomThemesHint => 'Ex. steampunk, horreur cosmique';

  @override
  String get forgeToneTitle => 'Ton';

  @override
  String get forgeStyleTitle => 'Style';

  @override
  String get forgeToneStyleOverrideLabel => 'Ton et style personnalisés';

  @override
  String get forgeToneStyleOverrideHint => 'Ex. Ton : sombre ; Style : âpre';

  @override
  String get forgePartySectionTitle => 'Groupe et échelle de jeu';

  @override
  String get forgePartySectionSubtitle =>
      'Niveau, taille et rôles principaux du groupe.';

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
  String get forgePartyArchetypesTitle => 'Archétypes du groupe';

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
  String get forgeCharacterNotesLabel => 'Notes de personnage';

  @override
  String get forgeCharacterNotesHint =>
      'Secrets, bonds, fears, important backstory...';

  @override
  String get forgeConstraintsLabel => 'Contraintes';

  @override
  String get forgeConstraintsHint =>
      'Short duration, no planar travel, mandatory final boss...';

  @override
  String get forgeNarrativeSectionTitle => 'Pression narrative';

  @override
  String get forgeNarrativeSectionSubtitle =>
      'Accroches, factions, rencontres et limites de contenu.';

  @override
  String get forgeNarrativePanelTitle => 'Story and forces in play';

  @override
  String get forgeNarrativeHooksLabel => 'Accroches narratives';

  @override
  String get forgeNarrativeHooksHint =>
      'Opening mission, threat, mystery, countdown...';

  @override
  String get forgeFactionsLabel => 'Factions et puissances';

  @override
  String get forgeFactionsHint =>
      'Guilds, cults, noble houses, antagonists, unstable allies...';

  @override
  String get forgeNpcFocusLabel => 'PNJ clés';

  @override
  String get forgeNpcFocusHint => 'Ambiguous mentor, rival, patron, traitor...';

  @override
  String get forgeEncounterFocusLabel => 'Rencontres souhaitées';

  @override
  String get forgeEncounterFocusHint =>
      'Siege, social investigation, chase, final boss...';

  @override
  String get forgeContentConstraintsTitle => 'Contraintes de contenu';

  @override
  String get forgeIncludeNpcsLabel => 'Inclure des PNJ';

  @override
  String get forgeIncludeNpcsSubtitle =>
      'Le prompt inclura des personnages non joueurs pertinents.';

  @override
  String get forgeIncludeEncountersLabel => 'Inclure des rencontres';

  @override
  String get forgeIncludeEncountersSubtitle =>
      'Le prompt proposera des scènes et des combats.';

  @override
  String get forgeSafetyNotesLabel => 'Notes de sécurité';

  @override
  String get forgeSafetyNotesHint =>
      'Sujets à éviter, lignes et voiles, limites de ton...';

  @override
  String get forgeParchmentDirty => 'Configuration modifiée : régénérer.';

  @override
  String get forgeParchmentReady => 'Parchemin à jour.';

  @override
  String get forgeParchmentIncomplete => 'Complétez l’histoire pour générer.';

  @override
  String get statusReady => 'Prêt';

  @override
  String get statusNeedsPolish => 'À peaufiner';

  @override
  String get parchmentReadyTitle => 'Parchemin prêt';

  @override
  String get parchmentReadySubtitleStale =>
      'You changed the forge: the copied prompt is no longer up to date.';

  @override
  String get parchmentReadySubtitleAligned =>
      'The copied prompt is aligned with the current forge state.';

  @override
  String get parchmentQuickActionsTitle => 'Actions rapides';

  @override
  String get parchmentCopyPromptTitle => 'Copier le prompt';

  @override
  String get parchmentCopyPromptSubtitle => 'Send the prompt to the clipboard.';

  @override
  String get parchmentShareTitle => 'Partager';

  @override
  String get parchmentShareSubtitle => 'Opens the sharing menu.';

  @override
  String get parchmentOpenChatGptTitle => 'Ouvrir dans ChatGPT';

  @override
  String get parchmentOpenChatGptSubtitle => 'Opens ChatGPT in a new tab.';

  @override
  String get parchmentDraftUpdatedTitle => 'Draft updated';

  @override
  String get parchmentSaveDraftTitle => 'Enregistrer le brouillon';

  @override
  String get parchmentSaveDraftSubtitle => 'Save the prompt locally for later.';

  @override
  String get parchmentPromptCopied => 'Prompt copié';

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
  String get parchmentSeal => 'SCELLER';

  @override
  String get parchmentSealAndCopy => 'Sceller et copier';

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
  String get settingsTitle => 'Réglages';

  @override
  String get settingsLeaveReview => 'Laisser un avis';

  @override
  String get settingsShareApp => 'Partager l’app';

  @override
  String get settingsShareText =>
      'Découvrez Campaign Forge, le générateur de campagnes D&D : ';

  @override
  String get settingsLanguageLabel => 'Langue';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsThemeLabel => 'Thème';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsInfoLabel => 'Info';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsGoAdFree => 'Publicités';

  @override
  String get settingsGoAdFreePrice => 'Supprimer les pubs';

  @override
  String settingsGoAdFreePriceWithAmount(String price) {
    return 'Supprimer les pubs — $price';
  }

  @override
  String get settingsRestorePurchases => 'Restaurer les achats';

  @override
  String get settingsRestorePurchasesStarted => 'Restauration des achats…';

  @override
  String get settingsRestorePurchasesComplete =>
      'Achats restaurés avec succès.';

  @override
  String get settingsAdFreeActive => 'Publicités supprimées';

  @override
  String get settingsIapUnavailable =>
      'Les achats intégrés ne sont pas disponibles sur cet appareil.';

  @override
  String get settingsIapProductNotFound =>
      'Produit introuvable. Réessayez plus tard.';

  @override
  String get settingsPurchasePending => 'Achat en cours…';

  @override
  String get settingsPurchaseCancelled => 'Achat annulé.';

  @override
  String get settingsPurchaseFailed => 'Échec de l’achat. Veuillez réessayer.';
}
