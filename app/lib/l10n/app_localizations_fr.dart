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
  String get languageGermanShort => 'DE';

  @override
  String get languagePortugueseShort => 'PT';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonOpen => 'Ouvrir';

  @override
  String get commonOptional => 'Optionnel';

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
      'Il n\'y a pas encore de parchemin à partager.';

  @override
  String get appSnackShareUnavailableOnDevice =>
      'Le partage n\'est pas disponible sur cet appareil.';

  @override
  String appSnackShareUnavailable(String error) {
    return 'Partage indisponible : $error';
  }

  @override
  String get appSnackGenerateFirst =>
      'Générez d’abord un parchemin avant de l’envoyer.';

  @override
  String get appSnackChatGptOpened =>
      'ChatGPT a été ouvert. Le prompt est déjà dans le presse-papiers.';

  @override
  String get appSnackChatGptCopiedOnly =>
      'Impossible d\'ouvrir ChatGPT, mais le prompt a été copié.';

  @override
  String get appSnackPremiumUnlockedTemporary =>
      'Premium débloqué pendant 5 minutes';

  @override
  String get appSnackRewardedAdUnavailable =>
      'La publicité n\'est pas disponible pour le moment. Réessayez dans un instant.';

  @override
  String get appSnackNoParchmentToSave => 'There is no parchment to save.';

  @override
  String get appSnackDraftSaved =>
      'Brouillon du parchemin enregistré localement.';

  @override
  String get appSnackDraftMemoryOnly =>
      'Brouillon enregistré uniquement en mémoire. Redémarrez complètement l\'application pour activer la persistance locale.';

  @override
  String get appSnackSealedSavedAndCopied =>
      'Parchemin scellé : brouillon enregistré et prompt copié.';

  @override
  String get appSnackSealedCopiedOnlyMemory =>
      'Parchemin scellé : prompt copié. Redémarrez complètement l\'application pour activer l\'enregistrement local.';

  @override
  String get appSnackLocalSaveUnavailable =>
      'Local saving is unavailable in this session. Close and relaunch the app to register the plugin.';

  @override
  String get appDraftMemoryOnly =>
      'Brouillon conservé uniquement en mémoire. Redémarrez complètement l\'application pour réactiver l\'enregistrement local.';

  @override
  String appDraftAligned(String dateTime) {
    return 'Brouillon local synchronisé le $dateTime.';
  }

  @override
  String appDraftLastSaved(String dateTime) {
    return 'Dernier brouillon enregistré le $dateTime.';
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
  String get onboardingHowItWorks => 'Comment ça marche';

  @override
  String get onboardingChooseCampaignTitle => 'Choisissez votre campagne';

  @override
  String get onboardingChooseCampaignBody =>
      'Choisissez d\'abord le format de campagne pour que le reste de la configuration ait la bonne forme.';

  @override
  String get onboardingDefineDetailsTitle => 'Définissez les détails clés';

  @override
  String get onboardingDefineDetailsBody =>
      'Définissez le monde, les thèmes, le ton, le style, le groupe et le rebondissement avant de forger le prompt.';

  @override
  String get onboardingForgePromptTitle => 'Forgez le prompt';

  @override
  String get onboardingForgePromptBody =>
      'Générez le prompt final, ouvrez-le dans ChatGPT.';

  @override
  String get onboardingGeneratedPromptTitle => 'Prompt généré';

  @override
  String get onboardingPastePromptSubtitle => 'Colle-y le prompt généré.';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingBack => 'Retour';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingStartForging => 'Commencer la forge';

  @override
  String get onboardingCopyStep => 'Copier';

  @override
  String get onboardingSettingExample => 'Royaume frontalier';

  @override
  String get onboardingThemesExample => 'Tension politique';

  @override
  String get onboardingToneExample => 'Sombre et noir';

  @override
  String get onboardingStyleExample => 'Fantasy ancrée';

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
  String get forgeReforgeParchmentCompact => 'Reforger le parchemin';

  @override
  String get forgeForgeParchmentCompact => 'Forger le parchemin';

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
  String get forgeNoPresetSelected => 'Aucun preset';

  @override
  String get forgeApplyPreset => 'Forger avec le preset';

  @override
  String get forgeApply => 'Forger avec le preset';

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
  String get forgePartyLevelPremiumHint => 'Les niveaux 4+ sont premium';

  @override
  String get forgePartySizePremiumHint => '5+ personnages sont premium';

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
      'Accroches, factions et contraintes supplémentaires pour personnaliser le parchemin.';

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
      'Vous avez modifié la forge : le prompt copié n\'est plus à jour.';

  @override
  String get parchmentReadySubtitleAligned =>
      'Le prompt copié est aligné avec l\'état actuel de la forge.';

  @override
  String get parchmentQuickActionsTitle => 'Actions rapides';

  @override
  String get parchmentCopyPromptTitle => 'Copier le prompt';

  @override
  String get parchmentPreviewPromptTooltip => 'Aperçu du prompt';

  @override
  String get parchmentPreviewSheetTitle => 'Aperçu du prompt';

  @override
  String get parchmentPreviewSheetSubtitle =>
      'Consultez le prompt complet avant de le copier ou de le coller.';

  @override
  String get parchmentCopyPromptSubtitle =>
      'Envoie le prompt dans le presse-papiers.';

  @override
  String get parchmentShareTitle => 'Partager';

  @override
  String get parchmentShareSubtitle => 'Ouvre le menu de partage.';

  @override
  String get parchmentOpenChatGptTitle => 'Ouvrir dans ChatGPT';

  @override
  String get parchmentOpenChatGptSubtitle =>
      'Ouvre ChatGPT dans un nouvel onglet.';

  @override
  String get parchmentDraftUpdatedTitle => 'Brouillon mis à jour';

  @override
  String get parchmentSaveDraftTitle => 'Enregistrer le brouillon';

  @override
  String get parchmentSaveDraftSubtitle =>
      'Enregistre le prompt localement pour plus tard.';

  @override
  String get parchmentPromptCopied => 'Prompt copié';

  @override
  String get parchmentCopiedStaleBanner =>
      'Vous avez modifié la forge après la dernière génération. Régénérez pour actualiser le prompt copié.';

  @override
  String get parchmentCopiedSuccessBody =>
      'Le parchemin a été forgé avec succès. Utilisez les rituels à droite pour le partager, l\'enregistrer ou l\'ouvrir dans ChatGPT.';

  @override
  String get atmosphereOneShot => 'Urgence cramoisie';

  @override
  String get atmosphereMiniCampaign => 'Route dorée';

  @override
  String get atmosphereLongCampaign => 'Atlas vert';

  @override
  String get atmosphereDungeon => 'Voûte aux torches';

  @override
  String get parchmentSeal => 'SCELLER';

  @override
  String get parchmentSealAndCopy => 'Sceller et copier';

  @override
  String get infoDialogLine1 =>
      'Cette application est un générateur de prompts inspiré des jeux de rôle fantasy.';

  @override
  String get infoDialogLine2 =>
      'Elle n\'est affiliée ni à Dungeons & Dragons ni à un outil d\'IA.';

  @override
  String get infoDialogLine3 =>
      'Vous pouvez utiliser les prompts avec des outils d\'IA pour créer vos propres histoires.';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsLeaveReview => 'Laisser un avis';

  @override
  String get settingsShareApp => 'Partager l’app';

  @override
  String get settingsPrivacyOptions =>
      'Paramètres de confidentialité et de cookies';

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
  String get settingsGoAdFreePrice => 'Débloquer Premium';

  @override
  String get settingsGoAdFreeSubtitle => 'Achat unique · £1.99';

  @override
  String settingsGoAdFreeSubtitleWithAmount(String price) {
    return 'Achat unique · $price';
  }

  @override
  String settingsGoAdFreePriceWithAmount(String price) {
    return 'Débloquer Premium — $price';
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

  @override
  String get premiumUnlockTitle => 'Fonction premium';

  @override
  String get premiumUnlockBodyWithAd =>
      'Regardez une publicité pour débloquer toutes les fonctionnalités premium pendant 5 minutes, ou débloquez Premium pour tout débloquer définitivement.';

  @override
  String get premiumUnlockBodyNoAd =>
      'Débloquez Premium pour accéder définitivement à cette fonctionnalité.';

  @override
  String get premiumUnlockWatchAd => 'Regarder une pub (5 min)';

  @override
  String get helpTitle => 'Guide';

  @override
  String get helpCampaignTypesTitle => 'Types de campagne';

  @override
  String get helpCampaignTypeOneShotTitle => 'One-Shot';

  @override
  String get helpCampaignTypeOneShotBody =>
      'Une aventure complète pensée pour une seule session, avec une ouverture forte, un objectif clair et une conclusion rapide. Choisis-la si tu veux un rythme immédiat et un arc serré.';

  @override
  String get helpCampaignTypeMiniCampaignTitle => 'Mini-campagne';

  @override
  String get helpCampaignTypeMiniCampaignBody =>
      'Un arc court qui se déploie sur quelques sessions, avec assez d’espace pour monter en intensité et conclure plus nettement. Idéal si tu veux quelque chose de compact mais moins condensé qu’un one-shot.';

  @override
  String get helpCampaignTypeLongCampaignTitle => 'Campagne longue';

  @override
  String get helpCampaignTypeLongCampaignBody =>
      'Une structure étendue avec des factions, des sous-intrigues et des conséquences qui évoluent dans le temps. Parfaite si tu veux de la continuité, de la progression et un monde qui réagit aux choix du groupe.';

  @override
  String get helpCampaignTypeDungeonTitle => 'Exploration de donjon';

  @override
  String get helpCampaignTypeDungeonBody =>
      'Une campagne centrée sur les cartes, la découverte, l’attrition et les secrets enfouis dans des lieux dangereux. Très adaptée si tu cherches de la pression, de l’exploration et un fort sens du lieu.';

  @override
  String get helpTipsTitle => 'Conseils et bonnes pratiques';

  @override
  String get helpTipWorld =>
      'Pars du cadre et du thème : ce sont les contraintes qui donnent de la cohérence au reste.';

  @override
  String get helpTipTheme =>
      'Utilise 1 ou 2 thèmes forts plutôt que d’empiler trop d’idées similaires.';

  @override
  String get helpTipTwist =>
      'Choisis un twist pour donner tout de suite de la tension à l’intrigue.';

  @override
  String get helpTipContrast =>
      'Essaie de combiner des tons contrastés pour obtenir des prompts moins prévisibles.';

  @override
  String get helpTipPreset =>
      'Utilise les presets quand tu veux une inspiration rapide ou une base solide à affiner.';

  @override
  String get helpTipCustom =>
      'Ajoute des entrées personnalisées seulement si l’option exacte dont tu as besoin n’existe pas déjà.';

  @override
  String get helpTipParty =>
      'Garde cohérents niveau, taille du groupe et archétypes pour éviter des prompts déséquilibrés.';
}
