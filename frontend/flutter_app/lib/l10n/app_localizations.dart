import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it')
  ];

  /// No description provided for @appTitle.
  ///
  /// In it, this message translates to:
  /// **'Creatore Campagne D&D'**
  String get appTitle;

  /// No description provided for @appNameShort.
  ///
  /// In it, this message translates to:
  /// **'Creatore Campagne'**
  String get appNameShort;

  /// No description provided for @languageItalianShort.
  ///
  /// In it, this message translates to:
  /// **'🇮🇹 IT'**
  String get languageItalianShort;

  /// No description provided for @languageEnglishShort.
  ///
  /// In it, this message translates to:
  /// **'🇬🇧 EN'**
  String get languageEnglishShort;

  /// No description provided for @commonRetry.
  ///
  /// In it, this message translates to:
  /// **'Riprova'**
  String get commonRetry;

  /// No description provided for @commonOpen.
  ///
  /// In it, this message translates to:
  /// **'Apri'**
  String get commonOpen;

  /// No description provided for @appFreeFormat.
  ///
  /// In it, this message translates to:
  /// **'Formato libero'**
  String get appFreeFormat;

  /// No description provided for @appSettingPending.
  ///
  /// In it, this message translates to:
  /// **'Ambientazione da definire'**
  String get appSettingPending;

  /// No description provided for @appTwistPending.
  ///
  /// In it, this message translates to:
  /// **'Twist da definire'**
  String get appTwistPending;

  /// No description provided for @appStageEntry.
  ///
  /// In it, this message translates to:
  /// **'Scelta'**
  String get appStageEntry;

  /// No description provided for @appStageForge.
  ///
  /// In it, this message translates to:
  /// **'Forgia'**
  String get appStageForge;

  /// No description provided for @appStageParchment.
  ///
  /// In it, this message translates to:
  /// **'Pergamena'**
  String get appStageParchment;

  /// No description provided for @appOpenParchment.
  ///
  /// In it, this message translates to:
  /// **'Apri pergamena'**
  String get appOpenParchment;

  /// No description provided for @appSealParchment.
  ///
  /// In it, this message translates to:
  /// **'Sigilla pergamena'**
  String get appSealParchment;

  /// No description provided for @appSummaryLevel.
  ///
  /// In it, this message translates to:
  /// **'Lv {level}'**
  String appSummaryLevel(int level);

  /// No description provided for @appSummaryPartySize.
  ///
  /// In it, this message translates to:
  /// **'{size} PG'**
  String appSummaryPartySize(int size);

  /// No description provided for @appSummaryPreset.
  ///
  /// In it, this message translates to:
  /// **'Preset: {name}'**
  String appSummaryPreset(String name);

  /// No description provided for @appLoadOptionsError.
  ///
  /// In it, this message translates to:
  /// **'Impossibile caricare le opzioni: {error}'**
  String appLoadOptionsError(String error);

  /// No description provided for @appGenerationFailedError.
  ///
  /// In it, this message translates to:
  /// **'Generazione fallita: {error}'**
  String appGenerationFailedError(String error);

  /// No description provided for @appInvalidArchetypeSelection.
  ///
  /// In it, this message translates to:
  /// **'Hai selezionato {count} archetipi, ma il party è impostato a {size} PG.'**
  String appInvalidArchetypeSelection(int count, int size);

  /// No description provided for @appSnackForgedAndCopied.
  ///
  /// In it, this message translates to:
  /// **'Pergamena forgiata e prompt copiato negli appunti.'**
  String get appSnackForgedAndCopied;

  /// No description provided for @appSnackGenerationFailed.
  ///
  /// In it, this message translates to:
  /// **'Generazione fallita. Controlla il messaggio mostrato nella schermata.'**
  String get appSnackGenerationFailed;

  /// No description provided for @appSnackPromptCopied.
  ///
  /// In it, this message translates to:
  /// **'Prompt copiato negli appunti.'**
  String get appSnackPromptCopied;

  /// No description provided for @appSnackNoParchmentToShare.
  ///
  /// In it, this message translates to:
  /// **'Non c\'è ancora una pergamena da condividere.'**
  String get appSnackNoParchmentToShare;

  /// No description provided for @appSnackShareUnavailable.
  ///
  /// In it, this message translates to:
  /// **'Condivisione non disponibile: {error}'**
  String appSnackShareUnavailable(String error);

  /// No description provided for @appSnackGenerateFirst.
  ///
  /// In it, this message translates to:
  /// **'Genera prima una pergamena da inviare.'**
  String get appSnackGenerateFirst;

  /// No description provided for @appSnackChatGptOpened.
  ///
  /// In it, this message translates to:
  /// **'ChatGPT aperto. Il prompt è già negli appunti.'**
  String get appSnackChatGptOpened;

  /// No description provided for @appSnackChatGptCopiedOnly.
  ///
  /// In it, this message translates to:
  /// **'Impossibile aprire ChatGPT, ma il prompt è stato copiato.'**
  String get appSnackChatGptCopiedOnly;

  /// No description provided for @appSnackNoParchmentToSave.
  ///
  /// In it, this message translates to:
  /// **'Non c\'è nessuna pergamena da salvare.'**
  String get appSnackNoParchmentToSave;

  /// No description provided for @appSnackDraftSaved.
  ///
  /// In it, this message translates to:
  /// **'Bozza della pergamena salvata in locale.'**
  String get appSnackDraftSaved;

  /// No description provided for @appSnackDraftMemoryOnly.
  ///
  /// In it, this message translates to:
  /// **'Bozza salvata solo in memoria. Riavvia completamente l\'app per abilitare la persistenza locale.'**
  String get appSnackDraftMemoryOnly;

  /// No description provided for @appSnackSealedSavedAndCopied.
  ///
  /// In it, this message translates to:
  /// **'Pergamena sigillata: bozza salvata e prompt copiato.'**
  String get appSnackSealedSavedAndCopied;

  /// No description provided for @appSnackSealedCopiedOnlyMemory.
  ///
  /// In it, this message translates to:
  /// **'Pergamena sigillata: prompt copiato. Riavvia completamente l\'app per abilitare il salvataggio locale.'**
  String get appSnackSealedCopiedOnlyMemory;

  /// No description provided for @appSnackLocalSaveUnavailable.
  ///
  /// In it, this message translates to:
  /// **'Salvataggio locale non disponibile in questa sessione. Chiudi e rilancia l\'app per registrare il plugin.'**
  String get appSnackLocalSaveUnavailable;

  /// No description provided for @appDraftMemoryOnly.
  ///
  /// In it, this message translates to:
  /// **'Bozza mantenuta solo in memoria. Riavvia completamente l\'app per riattivare il salvataggio locale.'**
  String get appDraftMemoryOnly;

  /// No description provided for @appDraftAligned.
  ///
  /// In it, this message translates to:
  /// **'Bozza locale allineata il {dateTime}.'**
  String appDraftAligned(String dateTime);

  /// No description provided for @appDraftLastSaved.
  ///
  /// In it, this message translates to:
  /// **'Ultima bozza salvata il {dateTime}.'**
  String appDraftLastSaved(String dateTime);

  /// No description provided for @appErrorEyebrow.
  ///
  /// In it, this message translates to:
  /// **'Rituale interrotto'**
  String get appErrorEyebrow;

  /// No description provided for @appErrorTitle.
  ///
  /// In it, this message translates to:
  /// **'Il grimorio non risponde'**
  String get appErrorTitle;

  /// No description provided for @appErrorUnknownLoad.
  ///
  /// In it, this message translates to:
  /// **'Errore sconosciuto nel caricamento opzioni.'**
  String get appErrorUnknownLoad;

  /// No description provided for @entryCampaignTypesTitle.
  ///
  /// In it, this message translates to:
  /// **'Tipi di campagna'**
  String get entryCampaignTypesTitle;

  /// No description provided for @entryResumeTitle.
  ///
  /// In it, this message translates to:
  /// **'Riprendi la sessione'**
  String get entryResumeTitle;

  /// No description provided for @entryResumeSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Hai già una bozza attiva. Torna subito al punto giusto.'**
  String get entryResumeSubtitle;

  /// No description provided for @entryResumeForge.
  ///
  /// In it, this message translates to:
  /// **'Riprendi la forgia'**
  String get entryResumeForge;

  /// No description provided for @entryOpenForge.
  ///
  /// In it, this message translates to:
  /// **'Apri la forgia'**
  String get entryOpenForge;

  /// No description provided for @entryOpenParchment.
  ///
  /// In it, this message translates to:
  /// **'Apri la pergamena'**
  String get entryOpenParchment;

  /// No description provided for @entryBadgeDefault.
  ///
  /// In it, this message translates to:
  /// **'Formato'**
  String get entryBadgeDefault;

  /// No description provided for @entryDescriptionDefault.
  ///
  /// In it, this message translates to:
  /// **'Formato campagna disponibile nel backend.'**
  String get entryDescriptionDefault;

  /// No description provided for @entryBadgeOneShot.
  ///
  /// In it, this message translates to:
  /// **'Lama rapida'**
  String get entryBadgeOneShot;

  /// No description provided for @entryDescriptionOneShot.
  ///
  /// In it, this message translates to:
  /// **'Una missione ad alto impatto da giocare in una sola seduta, con payoff immediato e twist preciso.'**
  String get entryDescriptionOneShot;

  /// No description provided for @entryBadgeMiniCampaign.
  ///
  /// In it, this message translates to:
  /// **'Arco breve'**
  String get entryBadgeMiniCampaign;

  /// No description provided for @entryDescriptionMiniCampaign.
  ///
  /// In it, this message translates to:
  /// **'Una storia concentrata in poche sessioni, con progressione forte, escalation e finale netto.'**
  String get entryDescriptionMiniCampaign;

  /// No description provided for @entryBadgeLongCampaign.
  ///
  /// In it, this message translates to:
  /// **'Saga ampia'**
  String get entryBadgeLongCampaign;

  /// No description provided for @entryDescriptionLongCampaign.
  ///
  /// In it, this message translates to:
  /// **'Fazioni, cambi di equilibrio e sottotrame persistenti per una campagna da far crescere nel tempo.'**
  String get entryDescriptionLongCampaign;

  /// No description provided for @entryBadgeDungeon.
  ///
  /// In it, this message translates to:
  /// **'Profondità'**
  String get entryBadgeDungeon;

  /// No description provided for @entryDescriptionDungeon.
  ///
  /// In it, this message translates to:
  /// **'Una discesa strutturata tra mappe, rischio, logoramento e scoperte stratificate.'**
  String get entryDescriptionDungeon;

  /// No description provided for @forgeSectionWorld.
  ///
  /// In it, this message translates to:
  /// **'Mondo'**
  String get forgeSectionWorld;

  /// No description provided for @forgeSectionParty.
  ///
  /// In it, this message translates to:
  /// **'Party'**
  String get forgeSectionParty;

  /// No description provided for @forgeSectionNarrative.
  ///
  /// In it, this message translates to:
  /// **'Trama'**
  String get forgeSectionNarrative;

  /// No description provided for @forgeButtonForging.
  ///
  /// In it, this message translates to:
  /// **'Forgiando...'**
  String get forgeButtonForging;

  /// No description provided for @forgeNextParty.
  ///
  /// In it, this message translates to:
  /// **'Vai al Party'**
  String get forgeNextParty;

  /// No description provided for @forgeNextNarrative.
  ///
  /// In it, this message translates to:
  /// **'Vai alla Trama'**
  String get forgeNextNarrative;

  /// No description provided for @forgeReforgeParchment.
  ///
  /// In it, this message translates to:
  /// **'Riforgia la Pergamena'**
  String get forgeReforgeParchment;

  /// No description provided for @forgeForgeParchment.
  ///
  /// In it, this message translates to:
  /// **'Forgia la Pergamena'**
  String get forgeForgeParchment;

  /// No description provided for @forgeAdvanceBlockedWorld.
  ///
  /// In it, this message translates to:
  /// **'Definisci almeno tono, stile o temi prima di passare al party.'**
  String get forgeAdvanceBlockedWorld;

  /// No description provided for @forgeAdvanceBlockedParty.
  ///
  /// In it, this message translates to:
  /// **'Controlla livello, dimensione e archetipi del party prima di procedere.'**
  String get forgeAdvanceBlockedParty;

  /// No description provided for @forgeAdvanceBlockedNarrative.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi almeno un dettaglio narrativo prima di forgiare la pergamena.'**
  String get forgeAdvanceBlockedNarrative;

  /// No description provided for @forgeReadinessWorldReady.
  ///
  /// In it, this message translates to:
  /// **'Puoi passare al party.'**
  String get forgeReadinessWorldReady;

  /// No description provided for @forgeReadinessWorldPending.
  ///
  /// In it, this message translates to:
  /// **'Scegli formato, ambientazione e segnali chiave.'**
  String get forgeReadinessWorldPending;

  /// No description provided for @forgeReadinessPartyReady.
  ///
  /// In it, this message translates to:
  /// **'Puoi aprire la trama.'**
  String get forgeReadinessPartyReady;

  /// No description provided for @forgeReadinessPartyPending.
  ///
  /// In it, this message translates to:
  /// **'Definisci livello, dimensione e ruoli del gruppo.'**
  String get forgeReadinessPartyPending;

  /// No description provided for @forgeReadinessNarrativeReady.
  ///
  /// In it, this message translates to:
  /// **'Puoi forgiare la pergamena.'**
  String get forgeReadinessNarrativeReady;

  /// No description provided for @forgeReadinessNarrativePending.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi almeno un aggancio narrativo.'**
  String get forgeReadinessNarrativePending;

  /// No description provided for @forgeWorldSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Mondo e firma creativa'**
  String get forgeWorldSectionTitle;

  /// No description provided for @forgeWorldSectionSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Formato, ambientazione e segnali iniziali della campagna.'**
  String get forgeWorldSectionSubtitle;

  /// No description provided for @forgeFoundationLabel.
  ///
  /// In it, this message translates to:
  /// **'Fondazione'**
  String get forgeFoundationLabel;

  /// No description provided for @forgeFoundationTitle.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni base'**
  String get forgeFoundationTitle;

  /// No description provided for @forgeFoundationSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Formato, preset rapido e ambientazione.'**
  String get forgeFoundationSubtitle;

  /// No description provided for @forgeQuickPresetLabel.
  ///
  /// In it, this message translates to:
  /// **'Preset rapido'**
  String get forgeQuickPresetLabel;

  /// No description provided for @forgeApplyPreset.
  ///
  /// In it, this message translates to:
  /// **'Applica preset'**
  String get forgeApplyPreset;

  /// No description provided for @forgeApply.
  ///
  /// In it, this message translates to:
  /// **'Applica'**
  String get forgeApply;

  /// No description provided for @forgeSettingLabel.
  ///
  /// In it, this message translates to:
  /// **'Ambientazione'**
  String get forgeSettingLabel;

  /// No description provided for @forgeCustomSettingLabel.
  ///
  /// In it, this message translates to:
  /// **'Dettaglio ambientazione personalizzato'**
  String get forgeCustomSettingLabel;

  /// No description provided for @forgeCustomSettingHint.
  ///
  /// In it, this message translates to:
  /// **'Regno in guerra, frontiera sospesa, città verticale, arcipelago infernale...'**
  String get forgeCustomSettingHint;

  /// No description provided for @forgeTwistTitle.
  ///
  /// In it, this message translates to:
  /// **'Twist iniziale'**
  String get forgeTwistTitle;

  /// No description provided for @forgeTwistLabel.
  ///
  /// In it, this message translates to:
  /// **'Twist'**
  String get forgeTwistLabel;

  /// No description provided for @forgeCustomTwistLabel.
  ///
  /// In it, this message translates to:
  /// **'Twist personalizzato'**
  String get forgeCustomTwistLabel;

  /// No description provided for @forgeCustomTwistHint.
  ///
  /// In it, this message translates to:
  /// **'Un alleato mente, il dungeon è vivo, la missione è una trappola...'**
  String get forgeCustomTwistHint;

  /// No description provided for @forgeCreativeTitle.
  ///
  /// In it, this message translates to:
  /// **'Temi, tono e stile'**
  String get forgeCreativeTitle;

  /// No description provided for @forgeThemesTitle.
  ///
  /// In it, this message translates to:
  /// **'Temi'**
  String get forgeThemesTitle;

  /// No description provided for @forgeCustomThemesLabel.
  ///
  /// In it, this message translates to:
  /// **'Temi personalizzati'**
  String get forgeCustomThemesLabel;

  /// No description provided for @forgeCustomThemesHint.
  ///
  /// In it, this message translates to:
  /// **'Intrigo politico, redenzione, sopravvivenza, orrore cosmico...'**
  String get forgeCustomThemesHint;

  /// No description provided for @forgeToneTitle.
  ///
  /// In it, this message translates to:
  /// **'Tono'**
  String get forgeToneTitle;

  /// No description provided for @forgeStyleTitle.
  ///
  /// In it, this message translates to:
  /// **'Stile'**
  String get forgeStyleTitle;

  /// No description provided for @forgeToneStyleOverrideLabel.
  ///
  /// In it, this message translates to:
  /// **'Override tono e stile'**
  String get forgeToneStyleOverrideLabel;

  /// No description provided for @forgeToneStyleOverrideHint.
  ///
  /// In it, this message translates to:
  /// **'Es: tono: cupo, epico\nstile: sandbox, mystery'**
  String get forgeToneStyleOverrideHint;

  /// No description provided for @forgePartySectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Party e scala di gioco'**
  String get forgePartySectionTitle;

  /// No description provided for @forgePartySectionSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Livello, dimensione e ruoli principali del gruppo.'**
  String get forgePartySectionSubtitle;

  /// No description provided for @forgeScaleLabel.
  ///
  /// In it, this message translates to:
  /// **'Scala'**
  String get forgeScaleLabel;

  /// No description provided for @forgeScaleTitle.
  ///
  /// In it, this message translates to:
  /// **'Livello e dimensione'**
  String get forgeScaleTitle;

  /// No description provided for @forgePartyLevel.
  ///
  /// In it, this message translates to:
  /// **'Livello party: {level}'**
  String forgePartyLevel(int level);

  /// No description provided for @forgePartySize.
  ///
  /// In it, this message translates to:
  /// **'Numero personaggi: {size}'**
  String forgePartySize(int size);

  /// No description provided for @forgePartyArchetypesTitle.
  ///
  /// In it, this message translates to:
  /// **'Archetipi del party'**
  String get forgePartyArchetypesTitle;

  /// No description provided for @forgePartyArchetypesSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Seleziona fino a {size} archetipi.'**
  String forgePartyArchetypesSubtitle(int size);

  /// No description provided for @forgePartyArchetypesMaxReached.
  ///
  /// In it, this message translates to:
  /// **'Hai raggiunto il massimo di archetipi selezionabili per il party attuale.'**
  String get forgePartyArchetypesMaxReached;

  /// No description provided for @forgePartyInfoTitle.
  ///
  /// In it, this message translates to:
  /// **'Informazioni utili'**
  String get forgePartyInfoTitle;

  /// No description provided for @forgeCharacterNotesLabel.
  ///
  /// In it, this message translates to:
  /// **'Note sui personaggi'**
  String get forgeCharacterNotesLabel;

  /// No description provided for @forgeCharacterNotesHint.
  ///
  /// In it, this message translates to:
  /// **'Segreti, legami, paure, background importanti...'**
  String get forgeCharacterNotesHint;

  /// No description provided for @forgeConstraintsLabel.
  ///
  /// In it, this message translates to:
  /// **'Vincoli'**
  String get forgeConstraintsLabel;

  /// No description provided for @forgeConstraintsHint.
  ///
  /// In it, this message translates to:
  /// **'Durata breve, niente viaggi planari, boss finale obbligatorio...'**
  String get forgeConstraintsHint;

  /// No description provided for @forgeNarrativeSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Pressione narrativa'**
  String get forgeNarrativeSectionTitle;

  /// No description provided for @forgeNarrativeSectionSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Agganci, fazioni, incontri e limiti di contenuto.'**
  String get forgeNarrativeSectionSubtitle;

  /// No description provided for @forgeNarrativePanelTitle.
  ///
  /// In it, this message translates to:
  /// **'Trama e forze in gioco'**
  String get forgeNarrativePanelTitle;

  /// No description provided for @forgeNarrativeHooksLabel.
  ///
  /// In it, this message translates to:
  /// **'Agganci narrativi'**
  String get forgeNarrativeHooksLabel;

  /// No description provided for @forgeNarrativeHooksHint.
  ///
  /// In it, this message translates to:
  /// **'Missione iniziale, minaccia, mistero, countdown...'**
  String get forgeNarrativeHooksHint;

  /// No description provided for @forgeFactionsLabel.
  ///
  /// In it, this message translates to:
  /// **'Fazioni e poteri'**
  String get forgeFactionsLabel;

  /// No description provided for @forgeFactionsHint.
  ///
  /// In it, this message translates to:
  /// **'Gilde, culti, casate, antagonisti, alleati instabili...'**
  String get forgeFactionsHint;

  /// No description provided for @forgeNpcFocusLabel.
  ///
  /// In it, this message translates to:
  /// **'NPC chiave'**
  String get forgeNpcFocusLabel;

  /// No description provided for @forgeNpcFocusHint.
  ///
  /// In it, this message translates to:
  /// **'Mentore ambiguo, rivale, patrono, traditore...'**
  String get forgeNpcFocusHint;

  /// No description provided for @forgeEncounterFocusLabel.
  ///
  /// In it, this message translates to:
  /// **'Incontri desiderati'**
  String get forgeEncounterFocusLabel;

  /// No description provided for @forgeEncounterFocusHint.
  ///
  /// In it, this message translates to:
  /// **'Assedio, indagine sociale, inseguimento, boss finale...'**
  String get forgeEncounterFocusHint;

  /// No description provided for @forgeContentConstraintsTitle.
  ///
  /// In it, this message translates to:
  /// **'Vincoli di contenuto'**
  String get forgeContentConstraintsTitle;

  /// No description provided for @forgeIncludeNpcsLabel.
  ///
  /// In it, this message translates to:
  /// **'Includi NPC'**
  String get forgeIncludeNpcsLabel;

  /// No description provided for @forgeIncludeNpcsSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Il prompt includerà personaggi non giocanti rilevanti.'**
  String get forgeIncludeNpcsSubtitle;

  /// No description provided for @forgeIncludeEncountersLabel.
  ///
  /// In it, this message translates to:
  /// **'Includi incontri'**
  String get forgeIncludeEncountersLabel;

  /// No description provided for @forgeIncludeEncountersSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Il prompt suggerirà scene e combattimenti.'**
  String get forgeIncludeEncountersSubtitle;

  /// No description provided for @forgeSafetyNotesLabel.
  ///
  /// In it, this message translates to:
  /// **'Note di sicurezza'**
  String get forgeSafetyNotesLabel;

  /// No description provided for @forgeSafetyNotesHint.
  ///
  /// In it, this message translates to:
  /// **'Temi da evitare, linee e veli, limiti di tono...'**
  String get forgeSafetyNotesHint;

  /// No description provided for @forgeParchmentDirty.
  ///
  /// In it, this message translates to:
  /// **'Configurazione modificata: rigenera.'**
  String get forgeParchmentDirty;

  /// No description provided for @forgeParchmentReady.
  ///
  /// In it, this message translates to:
  /// **'Pergamena aggiornata.'**
  String get forgeParchmentReady;

  /// No description provided for @forgeParchmentIncomplete.
  ///
  /// In it, this message translates to:
  /// **'Completa la trama per generare.'**
  String get forgeParchmentIncomplete;

  /// No description provided for @statusReady.
  ///
  /// In it, this message translates to:
  /// **'Pronto'**
  String get statusReady;

  /// No description provided for @statusNeedsPolish.
  ///
  /// In it, this message translates to:
  /// **'Da rifinire'**
  String get statusNeedsPolish;

  /// No description provided for @parchmentReadyTitle.
  ///
  /// In it, this message translates to:
  /// **'Pergamena pronta'**
  String get parchmentReadyTitle;

  /// No description provided for @parchmentReadySubtitleStale.
  ///
  /// In it, this message translates to:
  /// **'Hai modificato la forgia: il prompt copiato non è più aggiornato.'**
  String get parchmentReadySubtitleStale;

  /// No description provided for @parchmentReadySubtitleAligned.
  ///
  /// In it, this message translates to:
  /// **'Il prompt copiato è allineato con lo stato attuale della forgia.'**
  String get parchmentReadySubtitleAligned;

  /// No description provided for @parchmentQuickActionsTitle.
  ///
  /// In it, this message translates to:
  /// **'Azioni rapide'**
  String get parchmentQuickActionsTitle;

  /// No description provided for @parchmentCopyPromptTitle.
  ///
  /// In it, this message translates to:
  /// **'Copia prompt'**
  String get parchmentCopyPromptTitle;

  /// No description provided for @parchmentCopyPromptSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Invia il prompt negli appunti.'**
  String get parchmentCopyPromptSubtitle;

  /// No description provided for @parchmentShareTitle.
  ///
  /// In it, this message translates to:
  /// **'Condividi'**
  String get parchmentShareTitle;

  /// No description provided for @parchmentShareSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Apre il menu di condivisione.'**
  String get parchmentShareSubtitle;

  /// No description provided for @parchmentOpenChatGptTitle.
  ///
  /// In it, this message translates to:
  /// **'Apri in ChatGPT'**
  String get parchmentOpenChatGptTitle;

  /// No description provided for @parchmentOpenChatGptSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Apre ChatGPT in una nuova scheda.'**
  String get parchmentOpenChatGptSubtitle;

  /// No description provided for @parchmentDraftUpdatedTitle.
  ///
  /// In it, this message translates to:
  /// **'Bozza aggiornata'**
  String get parchmentDraftUpdatedTitle;

  /// No description provided for @parchmentSaveDraftTitle.
  ///
  /// In it, this message translates to:
  /// **'Salva bozza'**
  String get parchmentSaveDraftTitle;

  /// No description provided for @parchmentSaveDraftSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Salva il prompt localmente per dopo.'**
  String get parchmentSaveDraftSubtitle;

  /// No description provided for @parchmentPromptCopied.
  ///
  /// In it, this message translates to:
  /// **'Prompt copiato'**
  String get parchmentPromptCopied;

  /// No description provided for @parchmentCopiedStaleBanner.
  ///
  /// In it, this message translates to:
  /// **'Hai modificato la forgia dopo l\'ultima generazione. Rigenera per aggiornare il prompt copiato.'**
  String get parchmentCopiedStaleBanner;

  /// No description provided for @parchmentCopiedSuccessBody.
  ///
  /// In it, this message translates to:
  /// **'La pergamena è stata forgiata con successo. Usa i rituali a destra per condividerla, salvarla o aprirla in ChatGPT.'**
  String get parchmentCopiedSuccessBody;

  /// No description provided for @atmosphereOneShot.
  ///
  /// In it, this message translates to:
  /// **'Urgenza cremisi'**
  String get atmosphereOneShot;

  /// No description provided for @atmosphereMiniCampaign.
  ///
  /// In it, this message translates to:
  /// **'Strada dorata'**
  String get atmosphereMiniCampaign;

  /// No description provided for @atmosphereLongCampaign.
  ///
  /// In it, this message translates to:
  /// **'Atlante verde'**
  String get atmosphereLongCampaign;

  /// No description provided for @atmosphereDungeon.
  ///
  /// In it, this message translates to:
  /// **'Volta di torce'**
  String get atmosphereDungeon;

  /// No description provided for @parchmentSeal.
  ///
  /// In it, this message translates to:
  /// **'SIGILLA'**
  String get parchmentSeal;

  /// No description provided for @parchmentSealAndCopy.
  ///
  /// In it, this message translates to:
  /// **'Sigilla e copia'**
  String get parchmentSealAndCopy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
