// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Creatore Campagne D&D';

  @override
  String get appNameShort => 'Creatore Campagne';

  @override
  String get languageItalianShort => '🇮🇹 IT';

  @override
  String get languageEnglishShort => '🇬🇧 EN';

  @override
  String get commonRetry => 'Riprova';

  @override
  String get commonOpen => 'Apri';

  @override
  String get appFreeFormat => 'Formato libero';

  @override
  String get appSettingPending => 'Ambientazione da definire';

  @override
  String get appTwistPending => 'Twist da definire';

  @override
  String get appStageEntry => 'Scelta';

  @override
  String get appStageForge => 'Forgia';

  @override
  String get appStageParchment => 'Pergamena';

  @override
  String get appOpenParchment => 'Apri pergamena';

  @override
  String get appSealParchment => 'Sigilla pergamena';

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
  String get entryCampaignTypesTitle => 'Tipi di campagna';

  @override
  String get entryResumeTitle => 'Riprendi la sessione';

  @override
  String get entryResumeSubtitle =>
      'Hai già una bozza attiva. Torna subito al punto giusto.';

  @override
  String get entryResumeForge => 'Riprendi la forgia';

  @override
  String get entryOpenForge => 'Apri la forgia';

  @override
  String get entryOpenParchment => 'Apri la pergamena';

  @override
  String get entryBadgeDefault => 'Formato';

  @override
  String get entryDescriptionDefault =>
      'Formato campagna disponibile nel backend.';

  @override
  String get entryBadgeOneShot => 'Lama rapida';

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
  String get forgeWorldSectionTitle => 'Mondo e firma creativa';

  @override
  String get forgeWorldSectionSubtitle =>
      'Formato, ambientazione e segnali iniziali della campagna.';

  @override
  String get forgeFoundationLabel => 'Fondazione';

  @override
  String get forgeFoundationTitle => 'Impostazioni base';

  @override
  String get forgeFoundationSubtitle =>
      'Formato, preset rapido e ambientazione.';

  @override
  String get forgeQuickPresetLabel => 'Preset rapido';

  @override
  String get forgeApplyPreset => 'Applica preset';

  @override
  String get forgeApply => 'Applica';

  @override
  String get forgeSettingLabel => 'Ambientazione';

  @override
  String get forgeCustomSettingLabel =>
      'Dettaglio ambientazione personalizzato';

  @override
  String get forgeCustomSettingHint =>
      'Regno in guerra, frontiera sospesa, città verticale, arcipelago infernale...';

  @override
  String get forgeTwistTitle => 'Twist iniziale';

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
  String get forgeThemesTitle => 'Temi';

  @override
  String get forgeCustomThemesLabel => 'Temi personalizzati';

  @override
  String get forgeCustomThemesHint =>
      'Intrigo politico, redenzione, sopravvivenza, orrore cosmico...';

  @override
  String get forgeToneTitle => 'Tono';

  @override
  String get forgeStyleTitle => 'Stile';

  @override
  String get forgeToneStyleOverrideLabel => 'Override tono e stile';

  @override
  String get forgeToneStyleOverrideHint =>
      'Es: tono: cupo, epico\nstile: sandbox, mystery';

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
      'Agganci, fazioni, incontri e limiti di contenuto.';

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
}
