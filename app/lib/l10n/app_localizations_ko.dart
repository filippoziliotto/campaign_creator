// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'D&D 캠페인 크리에이터';

  @override
  String get appNameShort => '캠페인 크리에이터';

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
  String get commonRetry => '다시 시도';

  @override
  String get commonOpen => '열기';

  @override
  String get commonOptional => '선택';

  @override
  String get appFreeFormat => '형식 선택';

  @override
  String get appSettingPending => 'Ambientazione da definire';

  @override
  String get appTwistPending => 'Twist da definire';

  @override
  String get appStageEntry => '선택';

  @override
  String get appStageForge => '포지';

  @override
  String get appStageParchment => '양피지';

  @override
  String get appOpenParchment => '양피지 열기';

  @override
  String get appSealParchment => '양피지 봉인';

  @override
  String appSummaryLevel(int level) {
    return 'Lv $level';
  }

  @override
  String appSummaryPartySize(int size) {
    return '$size PG';
  }

  @override
  String appSummaryPreset(String name) {
    return 'Preset: $name';
  }

  @override
  String appLoadOptionsError(String error) {
    return 'Impossibile caricare le opzioni: $error';
  }

  @override
  String appGenerationFailedError(String error) {
    return 'Generazione fallita: $error';
  }

  @override
  String appInvalidArchetypeSelection(int count, int size) {
    return 'Hai selezionato $count archetipi, ma il party è impostato a $size PG.';
  }

  @override
  String get appSnackForgedAndCopied =>
      'Pergamena forgiata e prompt copiato negli appunti.';

  @override
  String get appSnackGenerationFailed =>
      'Generazione fallita. Controlla il messaggio mostrato nella schermata.';

  @override
  String get appSnackPromptCopied => 'Prompt copiato negli appunti.';

  @override
  String get appSnackNoParchmentToShare =>
      'Non c\'è ancora una pergamena da condividere.';

  @override
  String get appSnackShareUnavailableOnDevice =>
      'La condivisione non è disponibile su questo dispositivo.';

  @override
  String appSnackShareUnavailable(String error) {
    return 'Condivisione non disponibile: $error';
  }

  @override
  String get appSnackGenerateFirst => 'Genera prima una pergamena da inviare.';

  @override
  String get appSnackChatGptOpened =>
      'ChatGPT aperto. Il prompt è già negli appunti.';

  @override
  String get appSnackChatGptCopiedOnly =>
      'Impossibile aprire ChatGPT, ma il prompt è stato copiato.';

  @override
  String get appSnackPremiumUnlockedTemporary =>
      'Premium sbloccato per 5 minuti';

  @override
  String get appSnackRewardedAdUnavailable =>
      'Annuncio non disponibile in questo momento. Riprova tra poco.';

  @override
  String get appSnackNoParchmentToSave =>
      'Non c\'è nessuna pergamena da salvare.';

  @override
  String get appSnackDraftSaved => 'Bozza della pergamena salvata in locale.';

  @override
  String get appSnackDraftMemoryOnly =>
      'Bozza salvata solo in memoria. Riavvia completamente l\'app per abilitare la persistenza locale.';

  @override
  String get appSnackSealedSavedAndCopied =>
      'Pergamena sigillata: bozza salvata e prompt copiato.';

  @override
  String get appSnackSealedCopiedOnlyMemory =>
      'Pergamena sigillata: prompt copiato. Riavvia completamente l\'app per abilitare il salvataggio locale.';

  @override
  String get appSnackLocalSaveUnavailable =>
      'Salvataggio locale non disponibile in questa sessione. Chiudi e rilancia l\'app per registrare il plugin.';

  @override
  String get appDraftMemoryOnly =>
      'Bozza mantenuta solo in memoria. Riavvia completamente l\'app per riattivare il salvataggio locale.';

  @override
  String appDraftAligned(String dateTime) {
    return 'Bozza locale allineata il $dateTime.';
  }

  @override
  String appDraftLastSaved(String dateTime) {
    return 'Ultima bozza salvata il $dateTime.';
  }

  @override
  String get appErrorEyebrow => 'Rituale interrotto';

  @override
  String get appErrorTitle => 'Il grimorio non risponde';

  @override
  String get appErrorUnknownLoad =>
      'Errore sconosciuto nel caricamento opzioni.';

  @override
  String get entryCampaignTypesTitle => '캠페인 유형';

  @override
  String get entryResumeTitle => '세션 이어하기';

  @override
  String get entryResumeSubtitle =>
      'Hai già una bozza attiva. Torna subito al punto giusto.';

  @override
  String get entryResumeForge => 'Riprendi la forgia';

  @override
  String get entryOpenForge => 'Apri la forgia';

  @override
  String get entryHeroWelcomeTitle => 'Scegli la tua campagna';

  @override
  String get entryHeroWelcomeBody =>
      'Forgia il prompt della tua campagna, poi portalo in vita con la tua AI di fiducia.';

  @override
  String get entryHeroChooseRitual => 'Seleziona un formato per iniziare.';

  @override
  String get onboardingHowItWorks => 'Come funziona';

  @override
  String get onboardingChooseCampaignTitle => 'Scegli la tua campagna';

  @override
  String get onboardingChooseCampaignBody =>
      'Scegli prima il formato della campagna, così il resto dell\'impostazione avrà la forma giusta.';

  @override
  String get onboardingDefineDetailsTitle => 'Definisci i dettagli chiave';

  @override
  String get onboardingDefineDetailsBody =>
      'Imposta mondo, temi, tono, stile, party e twist prima di forgiare il prompt.';

  @override
  String get onboardingForgePromptTitle => 'Forgia il prompt';

  @override
  String get onboardingForgePromptBody =>
      'Genera il prompt finale e incollalo su ChatGPT.';

  @override
  String get onboardingGeneratedPromptTitle => 'Prompt generato';

  @override
  String get onboardingPastePromptSubtitle => 'Incolla lì il prompt generato.';

  @override
  String get onboardingNext => 'Avanti';

  @override
  String get onboardingBack => 'Indietro';

  @override
  String get onboardingSkip => 'Salta';

  @override
  String get onboardingStartForging => 'Inizia a forgiare';

  @override
  String get onboardingCopyStep => 'Copia';

  @override
  String get onboardingSettingExample => 'Regno di frontiera';

  @override
  String get onboardingThemesExample => 'Tensione politica';

  @override
  String get onboardingToneExample => 'Cupo e noir';

  @override
  String get onboardingStyleExample => 'Fantasy concreta';

  @override
  String get entryResetDraft => 'Nuova sessione';

  @override
  String get entryResetDraftConfirm => 'Bozza eliminata.';

  @override
  String get entryBadgeDefault => 'Formato';

  @override
  String get entryDescriptionDefault => '캠페인 형식이 기기에 준비되었습니다.';

  @override
  String get entryBadgeOneShot => 'Singola';

  @override
  String get entryDescriptionOneShot =>
      'Una missione ad alto impatto da giocare in una sola seduta, con payoff immediato e twist preciso.';

  @override
  String get entryBadgeMiniCampaign => 'Arco breve';

  @override
  String get entryDescriptionMiniCampaign =>
      'Una storia concentrata in poche sessioni, con progressione forte, escalation e finale netto.';

  @override
  String get entryBadgeLongCampaign => 'Saga ampia';

  @override
  String get entryDescriptionLongCampaign =>
      'Fazioni, cambi di equilibrio e sottotrame persistenti per una campagna da far crescere nel tempo.';

  @override
  String get entryBadgeDungeon => 'Profondità';

  @override
  String get entryDescriptionDungeon =>
      'Una discesa strutturata tra mappe, rischio, logoramento e scoperte stratificate.';

  @override
  String get forgeSectionWorld => 'Mondo';

  @override
  String get forgeSectionParty => 'Party';

  @override
  String get forgeSectionNarrative => 'Trama';

  @override
  String get forgeButtonForging => 'Forgiando...';

  @override
  String get forgeNextParty => 'Vai al Party';

  @override
  String get forgeNextNarrative => 'Vai alla Trama';

  @override
  String get forgeReforgeParchment => 'Riforgia la Pergamena';

  @override
  String get forgeForgeParchment => 'Forgia la Pergamena';

  @override
  String get forgeReforgeParchmentCompact => 'Riforgia Pergamena';

  @override
  String get forgeForgeParchmentCompact => 'Forgia Pergamena';

  @override
  String get forgeAdvanceBlockedWorld =>
      'Definisci almeno tono, stile o temi prima di passare al party.';

  @override
  String get forgeAdvanceBlockedParty =>
      'Controlla livello, dimensione e archetipi del party prima di procedere.';

  @override
  String get forgeAdvanceBlockedNarrative =>
      'Aggiungi almeno un dettaglio narrativo prima di forgiare la pergamena.';

  @override
  String get forgeReadinessWorldReady => 'Puoi passare al party.';

  @override
  String get forgeReadinessWorldPending =>
      'Scegli formato, ambientazione e segnali chiave.';

  @override
  String get forgeReadinessPartyReady => 'Puoi aprire la trama.';

  @override
  String get forgeReadinessPartyPending =>
      'Definisci livello, dimensione e ruoli del gruppo.';

  @override
  String get forgeReadinessNarrativeReady => 'Puoi forgiare la pergamena.';

  @override
  String get forgeReadinessNarrativePending =>
      'Aggiungi almeno un aggancio narrativo.';

  @override
  String get forgeWorldSectionTitle => 'Costruzione del Mondo';

  @override
  String get forgeWorldSectionSubtitle =>
      'Formato, ambientazione e segnali iniziali della campagna.';

  @override
  String get forgeFoundationLabel => 'Fondazione';

  @override
  String get forgeFoundationTitle => 'Impostazioni base';

  @override
  String get forgeFoundationSubtitle => 'Ambientazione e scenario.';

  @override
  String get forgePresetSectionTitle => 'Scegli un preset';

  @override
  String get forgePresetSectionSubtitle =>
      'Applica un preset per configurare rapidamente la campagna.';

  @override
  String get forgePresetPanelLabel => 'Preset';

  @override
  String get forgePresetPanelTitle => 'Preset rapidi';

  @override
  String get forgeQuickPresetLabel => 'Preset rapido';

  @override
  String get forgeNoPresetSelected => 'Nessun preset';

  @override
  String get forgeApplyPreset => 'Forgia con preset';

  @override
  String get forgeApply => 'Forgia con preset';

  @override
  String get forgeSettingLabel => 'Ambientazione';

  @override
  String get forgeCustomSettingLabel => 'Ambientazione personalizzata';

  @override
  String get forgeCustomSettingHint => 'Es: Inferno, città verticale';

  @override
  String get forgeTwistTitle => 'Twist iniziale';

  @override
  String get forgeTwistHelpTooltip => 'Aiuto twist iniziale';

  @override
  String get forgeTwistLabel => 'Twist';

  @override
  String get forgeCustomTwistLabel => 'Twist personalizzato';

  @override
  String get forgeCustomTwistHint =>
      'Un alleato mente, il dungeon è vivo, la missione è una trappola...';

  @override
  String get forgeCreativeTitle => 'Temi, tono e stile';

  @override
  String get forgeCreativeHelpTooltip => 'Aiuto direzione creativa';

  @override
  String get forgeCreativeHelpBody =>
      'Scegli temi, tono e stile narrativo della campagna.';

  @override
  String get forgeThemesTitle => 'Temi';

  @override
  String get forgeCustomThemesLabel => 'Temi personalizzati';

  @override
  String get forgeCustomThemesHint => 'Es: Steampunk, orrore cosmico';

  @override
  String get forgeToneTitle => 'Tono';

  @override
  String get forgeStyleTitle => 'Stile';

  @override
  String get forgeToneStyleOverrideLabel => 'Toni e stile personalizzati';

  @override
  String get forgeToneStyleOverrideHint => 'Es: Tono: cupo; Stile: gritty';

  @override
  String get forgePartySectionTitle => 'Party e scala di gioco';

  @override
  String get forgePartySectionSubtitle =>
      'Livello, dimensione e ruoli principali del gruppo.';

  @override
  String get forgeScaleLabel => 'Scala';

  @override
  String get forgeScaleTitle => 'Livello e dimensione';

  @override
  String forgePartyLevel(int level) {
    return 'Livello party: $level';
  }

  @override
  String forgePartySize(int size) {
    return 'Numero personaggi: $size';
  }

  @override
  String get forgePartyLevelPremiumHint => 'I livelli 4+ sono premium';

  @override
  String get forgePartySizePremiumHint => '5+ personaggi sono premium';

  @override
  String get forgePartyArchetypesTitle => 'Archetipi del party';

  @override
  String forgePartyArchetypesSubtitle(int size) {
    return 'Seleziona fino a $size archetipi.';
  }

  @override
  String get forgePartyArchetypesMaxReached =>
      'Hai raggiunto il massimo di archetipi selezionabili per il party attuale.';

  @override
  String get forgePartyInfoTitle => 'Informazioni utili';

  @override
  String get forgeCharacterNotesLabel => 'Note sui personaggi';

  @override
  String get forgeCharacterNotesHint =>
      'Segreti, legami, paure, background importanti...';

  @override
  String get forgeConstraintsLabel => 'Vincoli';

  @override
  String get forgeConstraintsHint =>
      'Durata breve, niente viaggi planari, boss finale obbligatorio...';

  @override
  String get forgeNarrativeSectionTitle => 'Pressione narrativa';

  @override
  String get forgeNarrativeSectionSubtitle =>
      'Agganci, fazioni e vincoli extra per personalizzare la pergamena.';

  @override
  String get forgeNarrativePanelTitle => 'Trama e forze in gioco';

  @override
  String get forgeNarrativeHooksLabel => 'Agganci narrativi';

  @override
  String get forgeNarrativeHooksHint =>
      'Missione iniziale, minaccia, mistero, countdown...';

  @override
  String get forgeFactionsLabel => 'Fazioni e poteri';

  @override
  String get forgeFactionsHint =>
      'Gilde, culti, casate, antagonisti, alleati instabili...';

  @override
  String get forgeNpcFocusLabel => 'NPC chiave';

  @override
  String get forgeNpcFocusHint =>
      'Mentore ambiguo, rivale, patrono, traditore...';

  @override
  String get forgeEncounterFocusLabel => 'Incontri desiderati';

  @override
  String get forgeEncounterFocusHint =>
      'Assedio, indagine sociale, inseguimento, boss finale...';

  @override
  String get forgeContentConstraintsTitle => 'Vincoli di contenuto';

  @override
  String get forgeIncludeNpcsLabel => 'Includi NPC';

  @override
  String get forgeIncludeNpcsSubtitle =>
      'Il prompt includerà personaggi non giocanti rilevanti.';

  @override
  String get forgeIncludeEncountersLabel => 'Includi incontri';

  @override
  String get forgeIncludeEncountersSubtitle =>
      'Il prompt suggerirà scene e combattimenti.';

  @override
  String get forgeSafetyNotesLabel => 'Note di sicurezza';

  @override
  String get forgeSafetyNotesHint =>
      'Temi da evitare, linee e veli, limiti di tono...';

  @override
  String get forgeParchmentDirty => 'Configurazione modificata: rigenera.';

  @override
  String get forgeParchmentReady => 'Pergamena aggiornata.';

  @override
  String get forgeParchmentIncomplete => 'Completa la trama per generare.';

  @override
  String get statusReady => 'Pronto';

  @override
  String get statusNeedsPolish => 'Da rifinire';

  @override
  String get parchmentReadyTitle => 'Pergamena pronta';

  @override
  String get parchmentReadySubtitleStale =>
      'Hai modificato la forgia: il prompt copiato non è più aggiornato.';

  @override
  String get parchmentReadySubtitleAligned =>
      'Il prompt copiato è allineato con lo stato attuale della forgia.';

  @override
  String get parchmentQuickActionsTitle => 'Azioni rapide';

  @override
  String get parchmentCopyPromptTitle => 'Copia prompt';

  @override
  String get parchmentPreviewPromptTooltip => 'Anteprima prompt';

  @override
  String get parchmentGoHomeTooltip => 'Torna alla home';

  @override
  String get parchmentPreviewSheetTitle => 'Anteprima prompt';

  @override
  String get parchmentPreviewSheetSubtitle =>
      'Controlla il prompt completo prima di copiarlo o incollarlo.';

  @override
  String get parchmentCopyPromptSubtitle => 'Invia il prompt negli appunti.';

  @override
  String get parchmentShareTitle => 'Condividi';

  @override
  String get parchmentShareSubtitle => 'Apre il menu di condivisione.';

  @override
  String get parchmentOpenChatGptTitle => 'Apri in ChatGPT';

  @override
  String get parchmentOpenChatGptSubtitle =>
      'Apre ChatGPT in una nuova scheda.';

  @override
  String get parchmentDraftUpdatedTitle => 'Bozza aggiornata';

  @override
  String get parchmentSaveDraftTitle => 'Salva bozza';

  @override
  String get parchmentSaveDraftSubtitle =>
      'Salva il prompt localmente per dopo.';

  @override
  String get parchmentPromptCopied => 'Prompt copiato';

  @override
  String get parchmentCopiedStaleBanner =>
      'Hai modificato la forgia dopo l\'ultima generazione. Rigenera per aggiornare il prompt copiato.';

  @override
  String get parchmentCopiedSuccessBody =>
      'La pergamena è stata forgiata con successo. Usa i rituali a destra per condividerla, salvarla o aprirla in ChatGPT.';

  @override
  String get atmosphereOneShot => 'Urgenza cremisi';

  @override
  String get atmosphereMiniCampaign => 'Strada dorata';

  @override
  String get atmosphereLongCampaign => 'Atlante verde';

  @override
  String get atmosphereDungeon => 'Volta di torce';

  @override
  String get parchmentSeal => 'SIGILLA';

  @override
  String get parchmentSealAndCopy => 'Sigilla e copia';

  @override
  String get infoDialogLine1 =>
      'Questa app è un generatore di prompt ispirato ai giochi di ruolo fantasy.';

  @override
  String get infoDialogLine2 =>
      'Non è affiliata a Dungeons & Dragons né a nessun altro Tool di AI.';

  @override
  String get infoDialogLine3 =>
      'Puoi usare i prompt con strumenti di AI per creare le tue storie.';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsLeaveReview => '리뷰 남기기';

  @override
  String get settingsShareApp => '앱 공유';

  @override
  String get settingsPrivacyOptions => 'Impostazioni privacy';

  @override
  String get settingsShareText =>
      'Scopri Campaign Forge, il generatore di campagne D&D: ';

  @override
  String get settingsLanguageLabel => '언어';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsThemeLabel => '테마';

  @override
  String get settingsThemeDark => 'Scuro';

  @override
  String get settingsThemeLight => 'Chiaro';

  @override
  String get settingsInfoLabel => 'Info';

  @override
  String get settingsVersion => 'Versione';

  @override
  String get settingsGoAdFree => 'Pubblicità';

  @override
  String get settingsGoAdFreePrice => '프리미엄 잠금 해제';

  @override
  String get settingsGoAdFreeSubtitle => 'Acquisto una tantum · £1.99';

  @override
  String settingsGoAdFreeSubtitleWithAmount(String price) {
    return 'Acquisto una tantum · $price';
  }

  @override
  String settingsGoAdFreePriceWithAmount(String price) {
    return '프리미엄 잠금 해제 — $price';
  }

  @override
  String get settingsRestorePurchases => 'Ripristina acquisti';

  @override
  String get settingsRestorePurchasesStarted => 'Ripristino acquisti in corso…';

  @override
  String get settingsRestorePurchasesComplete =>
      'Acquisti ripristinati con successo.';

  @override
  String get settingsAdFreeActive => 'Pubblicità rimosse';

  @override
  String get settingsIapUnavailable =>
      'Acquisti in-app non disponibili su questo dispositivo.';

  @override
  String get settingsIapProductNotFound =>
      'Prodotto non trovato. Riprova più tardi.';

  @override
  String get settingsPurchasePending => 'Acquisto in elaborazione…';

  @override
  String get settingsPurchaseCancelled => 'Acquisto annullato.';

  @override
  String get settingsPurchaseFailed => 'Acquisto non riuscito. Riprova.';

  @override
  String get premiumUnlockTitle => '프리미엄 기능';

  @override
  String get premiumUnlockBodyWithAd =>
      '광고를 보면 모든 프리미엄 기능을 5분 동안 잠금 해제할 수 있습니다. 영구적으로 이용하려면 프리미엄을 잠금 해제하세요.';

  @override
  String get premiumUnlockBodyNoAd => '이 기능을 영구적으로 이용하려면 프리미엄을 잠금 해제하세요.';

  @override
  String get premiumUnlockWatchAd => '광고 보기 (5분)';

  @override
  String get helpTitle => 'Guida';

  @override
  String get helpCampaignTypesTitle => '캠페인 유형';

  @override
  String get helpCampaignTypeOneShotTitle => 'One-Shot';

  @override
  String get helpCampaignTypeOneShotBody =>
      'Un\'avventura completa pensata per una sola sessione, con inizio forte, obiettivo chiaro e finale rapido. Sceglila quando vuoi ritmo alto e payoff immediato.';

  @override
  String get helpCampaignTypeMiniCampaignTitle => 'Mini-campagna';

  @override
  String get helpCampaignTypeMiniCampaignBody =>
      'Un arco breve che si sviluppa in poche sessioni, lasciando spazio a escalation e finale più netto. Ideale se vuoi qualcosa di compatto ma meno compresso di un one-shot.';

  @override
  String get helpCampaignTypeLongCampaignTitle => 'Campagna lunga';

  @override
  String get helpCampaignTypeLongCampaignBody =>
      'Una struttura estesa con fazioni, sottotrame e conseguenze che crescono nel tempo. Perfetta se vuoi continuità, progressione e un mondo che reagisce alle scelte del party.';

  @override
  String get helpCampaignTypeDungeonTitle => 'Esplorazione dungeon';

  @override
  String get helpCampaignTypeDungeonBody =>
      'Una campagna centrata su mappe, scoperta, attrito e segreti nascosti in luoghi pericolosi. Ottima se vuoi pressione costante, esplorazione e forte senso del luogo.';

  @override
  String get helpTipsTitle => '팁과 모범 사례';

  @override
  String get helpTipWorld =>
      'Parti da ambientazione e tema: sono i vincoli che danno coerenza al resto.';

  @override
  String get helpTipTheme =>
      'Usa 1-2 temi forti invece di accumulare troppe idee simili.';

  @override
  String get helpTipTwist => '반전을 선택해 줄거리에 즉각적인 긴장을 더하세요.';

  @override
  String get helpTipContrast =>
      'Prova a combinare toni in contrasto per ottenere prompt meno prevedibili.';

  @override
  String get helpTipPreset =>
      'Usa i preset quando vuoi ispirazione rapida o una base solida da rifinire.';

  @override
  String get helpTipCustom =>
      'Aggiungi voci custom solo quando l\'opzione esatta che ti serve non esiste già.';

  @override
  String get helpTipParty =>
      'Tieni coerenti livello, dimensione del party e archetipi per evitare prompt sbilanciati.';
}
