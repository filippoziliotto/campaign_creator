// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'D&D Kampagnenersteller';

  @override
  String get appNameShort => 'Kampagnenersteller';

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
  String get commonRetry => 'Erneut versuchen';

  @override
  String get commonOpen => 'Öffnen';

  @override
  String get commonOptional => 'Optional';

  @override
  String get appFreeFormat => 'Format wählen';

  @override
  String get appSettingPending => 'Setting festlegen';

  @override
  String get appTwistPending => 'Twist festlegen';

  @override
  String get appStageEntry => 'Auswahl';

  @override
  String get appStageForge => 'Schmiede';

  @override
  String get appStageParchment => 'Pergament';

  @override
  String get appOpenParchment => 'Pergament öffnen';

  @override
  String get appSealParchment => 'Pergament versiegeln';

  @override
  String appSummaryLevel(int level) {
    return 'Stufe $level';
  }

  @override
  String appSummaryPartySize(int size) {
    return '$size SC';
  }

  @override
  String appSummaryPreset(String name) {
    return 'Preset: $name';
  }

  @override
  String appLoadOptionsError(String error) {
    return 'Optionen konnten nicht geladen werden: $error';
  }

  @override
  String appGenerationFailedError(String error) {
    return 'Generierung fehlgeschlagen: $error';
  }

  @override
  String appInvalidArchetypeSelection(int count, int size) {
    return 'Du hast $count Archetypen gewählt, aber die Gruppe ist auf $size SC eingestellt.';
  }

  @override
  String get appSnackForgedAndCopied =>
      'Pergament geschmiedet und Prompt in die Zwischenablage kopiert.';

  @override
  String get appSnackGenerationFailed =>
      'Generierung fehlgeschlagen. Prüfe die eingeblendete Meldung.';

  @override
  String get appSnackPromptCopied => 'Prompt in die Zwischenablage kopiert.';

  @override
  String get appSnackNoParchmentToShare =>
      'Es gibt noch kein Pergament zum Teilen.';

  @override
  String get appSnackShareUnavailableOnDevice =>
      'Teilen ist auf diesem Gerät nicht verfügbar.';

  @override
  String appSnackShareUnavailable(String error) {
    return 'Teilen nicht verfügbar: $error';
  }

  @override
  String get appSnackGenerateFirst =>
      'Erzeuge zuerst ein Pergament, bevor du es sendest.';

  @override
  String get appSnackChatGptOpened =>
      'ChatGPT geöffnet. Der Prompt liegt bereits in der Zwischenablage.';

  @override
  String get appSnackChatGptCopiedOnly =>
      'ChatGPT konnte nicht geöffnet werden, aber der Prompt wurde kopiert.';

  @override
  String get appSnackPremiumUnlockedTemporary =>
      'Premium für 5 Minuten freigeschaltet';

  @override
  String get appSnackRewardedAdUnavailable =>
      'Die Werbung ist im Moment nicht verfügbar. Versuche es gleich noch einmal.';

  @override
  String get appSnackNoParchmentToSave =>
      'Es gibt kein Pergament zum Speichern.';

  @override
  String get appSnackDraftSaved => 'Pergament-Entwurf lokal gespeichert.';

  @override
  String get appSnackDraftMemoryOnly =>
      'Entwurf nur im Speicher gesichert. Starte die App vollständig neu, um lokale Persistenz zu aktivieren.';

  @override
  String get appSnackSealedSavedAndCopied =>
      'Pergament versiegelt: Entwurf gespeichert und Prompt kopiert.';

  @override
  String get appSnackSealedCopiedOnlyMemory =>
      'Pergament versiegelt: Prompt kopiert. Starte die App vollständig neu, um lokales Speichern zu aktivieren.';

  @override
  String get appSnackLocalSaveUnavailable =>
      'Lokales Speichern ist in dieser Sitzung nicht verfügbar. Schließe und starte die App erneut, um das Plugin zu registrieren.';

  @override
  String get appDraftMemoryOnly =>
      'Entwurf nur im Speicher gehalten. Starte die App vollständig neu, um lokales Speichern wieder zu aktivieren.';

  @override
  String appDraftAligned(String dateTime) {
    return 'Lokaler Entwurf abgeglichen am $dateTime.';
  }

  @override
  String appDraftLastSaved(String dateTime) {
    return 'Letzter Entwurf gespeichert am $dateTime.';
  }

  @override
  String get appErrorEyebrow => 'Ritual unterbrochen';

  @override
  String get appErrorTitle => 'Das Grimoire reagiert nicht';

  @override
  String get appErrorUnknownLoad =>
      'Unbekannter Fehler beim Laden der Optionen.';

  @override
  String get entryCampaignTypesTitle => 'Kampagnentypen';

  @override
  String get entryResumeTitle => 'Sitzung fortsetzen';

  @override
  String get entryResumeSubtitle =>
      'Du hast bereits einen aktiven Entwurf. Springe direkt an die richtige Stelle zurück.';

  @override
  String get entryResumeForge => 'Schmiede fortsetzen';

  @override
  String get entryOpenForge => 'Schmiede öffnen';

  @override
  String get entryHeroWelcomeTitle => 'Wähle deine Kampagne';

  @override
  String get entryHeroWelcomeBody =>
      'Schmiede deinen Kampagnen-Prompt und erwecke ihn dann mit deiner vertrauten KI zum Leben.';

  @override
  String get entryHeroChooseRitual => 'Wähle ein Format, um zu beginnen.';

  @override
  String get onboardingHowItWorks => 'So funktioniert\'s';

  @override
  String get onboardingChooseCampaignTitle => 'Wähle deine Kampagne';

  @override
  String get onboardingChooseCampaignBody =>
      'Wähle zuerst das Kampagnenformat, damit der Rest der Einrichtung die richtige Form bekommt.';

  @override
  String get onboardingDefineDetailsTitle => 'Lege die Schlüsseldetails fest';

  @override
  String get onboardingDefineDetailsBody =>
      'Lege Welt, Themen, Ton, Stil, Gruppe und Twist fest, bevor du den Prompt schmiedest.';

  @override
  String get onboardingForgePromptTitle => 'Schmiede den Prompt';

  @override
  String get onboardingForgePromptBody =>
      'Erzeuge den endgültigen Prompt, prüfe ihn in der Vorschau und übernimm ihn in ChatGPT, wenn du bereit bist, ihn einzufügen.';

  @override
  String get onboardingGeneratedPromptTitle => 'Generierter Prompt';

  @override
  String get onboardingPastePromptSubtitle =>
      'Füge den generierten Prompt dort ein.';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingBack => 'Zurück';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingStartForging => 'Schmieden starten';

  @override
  String get onboardingCopyStep => 'Kopieren';

  @override
  String get onboardingSettingExample => 'Grenzreich';

  @override
  String get onboardingThemesExample => 'Politische Spannungen';

  @override
  String get onboardingToneExample => 'Düster & noir';

  @override
  String get onboardingStyleExample => 'Geerdete Fantasy';

  @override
  String get entryResetDraft => 'Neue Sitzung';

  @override
  String get entryResetDraftConfirm => 'Entwurf gelöscht.';

  @override
  String get entryBadgeDefault => 'Format';

  @override
  String get entryDescriptionDefault =>
      'Kampagnenformat direkt auf dem Gerät bereit.';

  @override
  String get entryBadgeOneShot => 'Schnelle Klinge';

  @override
  String get entryDescriptionOneShot =>
      'Eine wirkungsvolle Mission für eine einzige Sitzung, mit sofortigem Payoff und präzisem Twist.';

  @override
  String get entryBadgeMiniCampaign => 'Kurzer Bogen';

  @override
  String get entryDescriptionMiniCampaign =>
      'Eine Geschichte für wenige Sitzungen, mit klarer Steigerung, Eskalation und scharfem Finale.';

  @override
  String get entryBadgeLongCampaign => 'Weite Saga';

  @override
  String get entryDescriptionLongCampaign =>
      'Fraktionen, wechselnde Machtverhältnisse und dauerhafte Nebenhandlungen für eine Kampagne, die mit der Zeit wächst.';

  @override
  String get entryBadgeDungeon => 'Tiefen';

  @override
  String get entryDescriptionDungeon =>
      'Ein strukturierter Abstieg durch Karten, Risiko, Zermürbung und mehrschichtige Entdeckungen.';

  @override
  String get forgeSectionWorld => 'Welt';

  @override
  String get forgeSectionParty => 'Gruppe';

  @override
  String get forgeSectionNarrative => 'Geschichte';

  @override
  String get forgeButtonForging => 'Wird geschmiedet...';

  @override
  String get forgeNextParty => 'Zur Gruppe';

  @override
  String get forgeNextNarrative => 'Zur Geschichte';

  @override
  String get forgeReforgeParchment => 'Pergament neu schmieden';

  @override
  String get forgeForgeParchment => 'Pergament schmieden';

  @override
  String get forgeReforgeParchmentCompact => 'Pergament neu schmieden';

  @override
  String get forgeForgeParchmentCompact => 'Pergament schmieden';

  @override
  String get forgeAdvanceBlockedWorld =>
      'Lege mindestens Ton, Stil oder Themen fest, bevor du zur Gruppe gehst.';

  @override
  String get forgeAdvanceBlockedParty =>
      'Prüfe Gruppenstufe, Größe und Archetypen, bevor du fortfährst.';

  @override
  String get forgeAdvanceBlockedNarrative =>
      'Füge mindestens ein narratives Detail hinzu, bevor du das Pergament schmiedest.';

  @override
  String get forgeReadinessWorldReady => 'Du kannst zur Gruppe weitergehen.';

  @override
  String get forgeReadinessWorldPending =>
      'Wähle Format, Setting und Kernsignale.';

  @override
  String get forgeReadinessPartyReady => 'Du kannst die Geschichte öffnen.';

  @override
  String get forgeReadinessPartyPending =>
      'Lege Stufe, Größe und Gruppenrollen fest.';

  @override
  String get forgeReadinessNarrativeReady =>
      'Du kannst das Pergament schmieden.';

  @override
  String get forgeReadinessNarrativePending =>
      'Füge mindestens einen narrativen Aufhänger hinzu.';

  @override
  String get forgeWorldSectionTitle => 'Weltenbau';

  @override
  String get forgeWorldSectionSubtitle =>
      'Format, Setting und die ersten Signale der Kampagne.';

  @override
  String get forgeFoundationLabel => 'Grundlage';

  @override
  String get forgeFoundationTitle => 'Basiskonfiguration';

  @override
  String get forgeFoundationSubtitle => 'Setting und Ausgangssituation.';

  @override
  String get forgePresetSectionTitle => 'Preset wählen';

  @override
  String get forgePresetSectionSubtitle =>
      'Wende ein Preset an, um deine Kampagne schnell zu konfigurieren.';

  @override
  String get forgePresetPanelLabel => 'Presets';

  @override
  String get forgePresetPanelTitle => 'Schnelle Presets';

  @override
  String get forgeQuickPresetLabel => 'Schnelles Preset';

  @override
  String get forgeNoPresetSelected => 'Kein Preset';

  @override
  String get forgeApplyPreset => 'Mit Preset schmieden';

  @override
  String get forgeApply => 'Mit Preset schmieden';

  @override
  String get forgeSettingLabel => 'Setting';

  @override
  String get forgeCustomSettingLabel => 'Eigenes Setting';

  @override
  String get forgeCustomSettingHint =>
      'Z. B. Königreich im Krieg, vertikale Stadt';

  @override
  String get forgeTwistTitle => 'Auftakt-Twist';

  @override
  String get forgeTwistHelpTooltip => 'Hilfe zum Auftakt-Twist';

  @override
  String get forgeTwistLabel => 'Twist';

  @override
  String get forgeCustomTwistLabel => 'Eigener Twist';

  @override
  String get forgeCustomTwistHint =>
      'Ein Verbündeter lügt, der Dungeon lebt, die Mission ist eine Falle...';

  @override
  String get forgeCreativeTitle => 'Themen, Ton und Stil';

  @override
  String get forgeCreativeHelpTooltip => 'Hilfe zur kreativen Ausrichtung';

  @override
  String get forgeCreativeHelpBody =>
      'Wähle Themen, Ton und Erzählstil deiner Kampagne.';

  @override
  String get forgeThemesTitle => 'Themen';

  @override
  String get forgeCustomThemesLabel => 'Eigene Themen';

  @override
  String get forgeCustomThemesHint => 'Z. B. Steampunk, kosmischer Horror';

  @override
  String get forgeToneTitle => 'Ton';

  @override
  String get forgeStyleTitle => 'Stil';

  @override
  String get forgeToneStyleOverrideLabel => 'Eigene Ton- & Stilvorgaben';

  @override
  String get forgeToneStyleOverrideHint => 'Z. B. Ton: düster; Stil: gritty';

  @override
  String get forgePartySectionTitle => 'Gruppe und Spielmaßstab';

  @override
  String get forgePartySectionSubtitle =>
      'Stufe, Größe und zentrale Gruppenrollen.';

  @override
  String get forgeScaleLabel => 'Maßstab';

  @override
  String get forgeScaleTitle => 'Stufe und Größe';

  @override
  String forgePartyLevel(int level) {
    return 'Gruppenstufe: $level';
  }

  @override
  String forgePartySize(int size) {
    return 'Anzahl der Charaktere: $size';
  }

  @override
  String get forgePartyLevelPremiumHint => 'Stufen ab 4 sind premium';

  @override
  String get forgePartySizePremiumHint => '5+ Charaktere sind premium';

  @override
  String get forgePartyArchetypesTitle => 'Gruppenarchetypen';

  @override
  String forgePartyArchetypesSubtitle(int size) {
    return 'Wähle bis zu $size Archetypen.';
  }

  @override
  String get forgePartyArchetypesMaxReached =>
      'Du hast die maximale Anzahl an Archetypen für die aktuelle Gruppe erreicht.';

  @override
  String get forgePartyInfoTitle => 'Nützliche Informationen';

  @override
  String get forgeCharacterNotesLabel => 'Charakternotizen';

  @override
  String get forgeCharacterNotesHint =>
      'Geheimnisse, Bindungen, Ängste, wichtige Hintergrundgeschichte...';

  @override
  String get forgeConstraintsLabel => 'Einschränkungen';

  @override
  String get forgeConstraintsHint =>
      'Kurze Dauer, keine Planarreisen, verpflichtender Endboss...';

  @override
  String get forgeNarrativeSectionTitle => 'Narrativer Druck';

  @override
  String get forgeNarrativeSectionSubtitle =>
      'Zusätzliche Aufhänger, Fraktionen und Einschränkungen, um das Pergament zu individualisieren.';

  @override
  String get forgeNarrativePanelTitle => 'Geschichte und wirkende Kräfte';

  @override
  String get forgeNarrativeHooksLabel => 'Narrative Aufhänger';

  @override
  String get forgeNarrativeHooksHint =>
      'Auftaktmission, Bedrohung, Geheimnis, Countdown...';

  @override
  String get forgeFactionsLabel => 'Fraktionen und Mächte';

  @override
  String get forgeFactionsHint =>
      'Gilden, Kulte, Adelshäuser, Antagonisten, instabile Verbündete...';

  @override
  String get forgeNpcFocusLabel => 'Zentrale NSC';

  @override
  String get forgeNpcFocusHint =>
      'Ambivalenter Mentor, Rivale, Auftraggeber, Verräter...';

  @override
  String get forgeEncounterFocusLabel => 'Gewünschte Begegnungen';

  @override
  String get forgeEncounterFocusHint =>
      'Belagerung, soziale Ermittlung, Verfolgungsjagd, Endboss...';

  @override
  String get forgeContentConstraintsTitle => 'Inhaltliche Grenzen';

  @override
  String get forgeIncludeNpcsLabel => 'NSC einbeziehen';

  @override
  String get forgeIncludeNpcsSubtitle =>
      'Der Prompt enthält relevante Nichtspielercharaktere.';

  @override
  String get forgeIncludeEncountersLabel => 'Begegnungen einbeziehen';

  @override
  String get forgeIncludeEncountersSubtitle =>
      'Der Prompt schlägt Szenen und Kämpfe vor.';

  @override
  String get forgeSafetyNotesLabel => 'Safety-Hinweise';

  @override
  String get forgeSafetyNotesHint =>
      'Zu vermeidende Themen, Lines and Veils, Ton-Grenzen...';

  @override
  String get forgeParchmentDirty => 'Konfiguration geändert: neu generieren.';

  @override
  String get forgeParchmentReady => 'Pergament ist aktuell.';

  @override
  String get forgeParchmentIncomplete =>
      'Vervollständige die Geschichte, um zu generieren.';

  @override
  String get statusReady => 'Bereit';

  @override
  String get statusNeedsPolish => 'Braucht Feinschliff';

  @override
  String get parchmentReadyTitle => 'Pergament bereit';

  @override
  String get parchmentReadySubtitleStale =>
      'Du hast die Schmiede geändert: Der kopierte Prompt ist nicht mehr aktuell.';

  @override
  String get parchmentReadySubtitleAligned =>
      'Der kopierte Prompt ist mit dem aktuellen Schmiedestatus abgestimmt.';

  @override
  String get parchmentQuickActionsTitle => 'Schnellaktionen';

  @override
  String get parchmentCopyPromptTitle => 'Prompt kopieren';

  @override
  String get parchmentPreviewPromptTooltip => 'Prompt-Vorschau';

  @override
  String get parchmentGoHomeTooltip => 'Zur Startseite';

  @override
  String get parchmentPreviewSheetTitle => 'Prompt-Vorschau';

  @override
  String get parchmentPreviewSheetSubtitle =>
      'Prüfe den vollständigen Prompt, bevor du ihn kopierst oder einfügst.';

  @override
  String get parchmentCopyPromptSubtitle =>
      'Sendet den Prompt in die Zwischenablage.';

  @override
  String get parchmentShareTitle => 'Teilen';

  @override
  String get parchmentShareSubtitle => 'Öffnet das Teilen-Menü.';

  @override
  String get parchmentOpenChatGptTitle => 'In ChatGPT öffnen';

  @override
  String get parchmentOpenChatGptSubtitle =>
      'Öffnet ChatGPT in einem neuen Tab.';

  @override
  String get parchmentDraftUpdatedTitle => 'Entwurf aktualisiert';

  @override
  String get parchmentSaveDraftTitle => 'Entwurf speichern';

  @override
  String get parchmentSaveDraftSubtitle =>
      'Speichere den Prompt lokal für später.';

  @override
  String get parchmentPromptCopied => 'Prompt kopiert';

  @override
  String get parchmentCopiedStaleBanner =>
      'Du hast die Schmiede nach der letzten Generierung verändert. Generiere neu, um den kopierten Prompt zu aktualisieren.';

  @override
  String get parchmentCopiedSuccessBody =>
      'Das Pergament wurde erfolgreich geschmiedet. Nutze die Rituale rechts, um es zu teilen, zu speichern oder in ChatGPT zu öffnen.';

  @override
  String get atmosphereOneShot => 'Purpurene Dringlichkeit';

  @override
  String get atmosphereMiniCampaign => 'Goldener Pfad';

  @override
  String get atmosphereLongCampaign => 'Grüner Atlas';

  @override
  String get atmosphereDungeon => 'Fackelgewölbe';

  @override
  String get parchmentSeal => 'VERSIEGELN';

  @override
  String get parchmentSealAndCopy => 'Versiegeln und kopieren';

  @override
  String get infoDialogLine1 =>
      'Diese App ist ein Prompt-Generator, inspiriert von Fantasy-Rollenspielen.';

  @override
  String get infoDialogLine2 =>
      'Sie ist weder mit Dungeons & Dragons noch mit einem KI-Sprachtool verbunden.';

  @override
  String get infoDialogLine3 =>
      'Du kannst die Prompts mit KI-Tools nutzen, um deine eigenen Geschichten zu erschaffen.';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsLeaveReview => 'Bewertung hinterlassen';

  @override
  String get settingsShareApp => 'App teilen';

  @override
  String get settingsPrivacyOptions => 'Datenschutzeinstellungen';

  @override
  String get settingsShareText =>
      'Entdecke Campaign Forge, den D&D-Kampagnengenerator: ';

  @override
  String get settingsLanguageLabel => 'Sprache';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsThemeLabel => 'Thema';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsInfoLabel => 'Info';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsGoAdFree => 'Werbung';

  @override
  String get settingsGoAdFreePrice => 'Premium Freischalten';

  @override
  String get settingsGoAdFreeSubtitle => 'Einmalkauf · £1.99';

  @override
  String settingsGoAdFreeSubtitleWithAmount(String price) {
    return 'Einmalkauf · $price';
  }

  @override
  String settingsGoAdFreePriceWithAmount(String price) {
    return 'Premium freischalten — $price';
  }

  @override
  String get settingsRestorePurchases => 'Käufe wiederherstellen';

  @override
  String get settingsRestorePurchasesStarted =>
      'Käufe werden wiederhergestellt…';

  @override
  String get settingsRestorePurchasesComplete =>
      'Käufe erfolgreich wiederhergestellt.';

  @override
  String get settingsAdFreeActive => 'Werbung entfernt';

  @override
  String get settingsIapUnavailable =>
      'In-App-Käufe sind auf diesem Gerät nicht verfügbar.';

  @override
  String get settingsIapProductNotFound =>
      'Produkt nicht gefunden. Versuche es später erneut.';

  @override
  String get settingsPurchasePending => 'Kauf wird verarbeitet…';

  @override
  String get settingsPurchaseCancelled => 'Kauf abgebrochen.';

  @override
  String get settingsPurchaseFailed =>
      'Kauf fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get premiumUnlockTitle => 'Premium-Funktion';

  @override
  String get premiumUnlockBodyWithAd =>
      'Sieh dir eine Werbung an, um alle Premium-Funktionen für 5 Minuten freizuschalten, oder schalte Premium frei, um dauerhaft auf alles zuzugreifen.';

  @override
  String get premiumUnlockBodyNoAd =>
      'Schalte Premium frei, um dauerhaft auf diese Funktion zuzugreifen.';

  @override
  String get premiumUnlockWatchAd => 'Werbung ansehen (5 Min.)';

  @override
  String get helpTitle => 'Leitfaden';

  @override
  String get helpCampaignTypesTitle => 'Kampagnentypen';

  @override
  String get helpCampaignTypeOneShotTitle => 'One-Shot';

  @override
  String get helpCampaignTypeOneShotBody =>
      'Ein vollständiges Abenteuer für genau eine Sitzung, mit starkem Einstieg, klarem Ziel und schnellem Abschluss. Wähle es, wenn du sofortiges Tempo und einen kompakten Bogen willst.';

  @override
  String get helpCampaignTypeMiniCampaignTitle => 'Mini-Kampagne';

  @override
  String get helpCampaignTypeMiniCampaignBody =>
      'Ein kurzer Handlungsbogen über einige Sitzungen, mit Raum für Eskalation und ein klareres Finale. Ideal, wenn du etwas Kompaktes willst, das trotzdem mehr Luft hat als ein One-Shot.';

  @override
  String get helpCampaignTypeLongCampaignTitle => 'Lange Kampagne';

  @override
  String get helpCampaignTypeLongCampaignBody =>
      'Eine ausgedehnte Struktur mit Fraktionen, Nebenhandlungen und Folgen, die sich über Zeit entfalten. Perfekt, wenn du Kontinuität, Entwicklung und eine Welt willst, die auf Spielerentscheidungen reagiert.';

  @override
  String get helpCampaignTypeDungeonTitle => 'Dungeon-Erkundung';

  @override
  String get helpCampaignTypeDungeonBody =>
      'Eine Kampagne rund um Karten, Entdeckung, Ressourcenverschleiß und Geheimnisse in gefährlichen Orten. Besonders geeignet, wenn du Druck, Erkundung und ein starkes Ortsgefühl willst.';

  @override
  String get helpTipsTitle => 'Tipps & Best Practices';

  @override
  String get helpTipWorld =>
      'Starte mit Setting und Thema: Das sind die Leitplanken, die allem Kohärenz geben.';

  @override
  String get helpTipTheme =>
      'Nutze 1 bis 2 starke Themen, statt zu viele ähnliche Ideen anzuhäufen.';

  @override
  String get helpTipTwist =>
      'Wähle einen Twist, um der Handlung sofort Spannung zu geben.';

  @override
  String get helpTipContrast =>
      'Kombiniere gegensätzliche Töne, um weniger vorhersehbare Prompts zu erhalten.';

  @override
  String get helpTipPreset =>
      'Nutze Presets, wenn du schnelle Inspiration oder eine starke Ausgangsbasis willst.';

  @override
  String get helpTipCustom =>
      'Füge eigene Einträge nur hinzu, wenn die genaue Option, die du brauchst, noch nicht vorhanden ist.';

  @override
  String get helpTipParty =>
      'Halte Stufe, Gruppengröße und Archetypen im Einklang, damit die Prompts ausgewogen bleiben.';
}
