// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Kreator Kampanii D&D';

  @override
  String get appNameShort => 'Kreator Kampanii';

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
  String get commonRetry => 'Ponów';

  @override
  String get commonOpen => 'Otwórz';

  @override
  String get commonOptional => 'Opcjonalne';

  @override
  String get appFreeFormat => 'Wybierz format';

  @override
  String get appSettingPending => 'Świat do określenia';

  @override
  String get appTwistPending => 'Zwrot akcji do określenia';

  @override
  String get appStageEntry => 'Wybór';

  @override
  String get appStageForge => 'Kuźnia';

  @override
  String get appStageParchment => 'Pergamin';

  @override
  String get appOpenParchment => 'Otwórz pergamin';

  @override
  String get appSealParchment => 'Zapieczętuj pergamin';

  @override
  String appSummaryLevel(int level) {
    return 'Poz. $level';
  }

  @override
  String appSummaryPartySize(int size) {
    return '$size BG';
  }

  @override
  String appSummaryPreset(String name) {
    return 'Preset: $name';
  }

  @override
  String appLoadOptionsError(String error) {
    return 'Nie udało się wczytać opcji: $error';
  }

  @override
  String appGenerationFailedError(String error) {
    return 'Generowanie nie powiodło się: $error';
  }

  @override
  String appInvalidArchetypeSelection(int count, int size) {
    return 'Wybrano $count archetypów, ale drużyna ma ustawione $size postaci.';
  }

  @override
  String get appSnackForgedAndCopied =>
      'Pergamin został wykuty, a prompt skopiowany do schowka.';

  @override
  String get appSnackGenerationFailed =>
      'Generowanie nie powiodło się. Sprawdź komunikat na ekranie.';

  @override
  String get appSnackPromptCopied => 'Prompt skopiowany do schowka.';

  @override
  String get appSnackNoParchmentToShare =>
      'Nie ma jeszcze pergaminu do udostępnienia.';

  @override
  String get appSnackShareUnavailableOnDevice =>
      'Udostępnianie nie jest dostępne na tym urządzeniu.';

  @override
  String appSnackShareUnavailable(String error) {
    return 'Udostępnianie niedostępne: $error';
  }

  @override
  String get appSnackGenerateFirst =>
      'Najpierw wygeneruj pergamin, zanim go wyślesz.';

  @override
  String get appSnackChatGptOpened =>
      'Otworzono ChatGPT. Prompt jest już w schowku.';

  @override
  String get appSnackChatGptCopiedOnly =>
      'Nie udało się otworzyć ChatGPT, ale prompt został skopiowany.';

  @override
  String get appSnackPremiumUnlockedTemporary =>
      'Premium odblokowane na 5 minut';

  @override
  String get appSnackRewardedAdUnavailable =>
      'Reklama jest teraz niedostępna. Spróbuj ponownie za chwilę.';

  @override
  String get appSnackNoParchmentToSave => 'Nie ma pergaminu do zapisania.';

  @override
  String get appSnackDraftSaved => 'Szkic pergaminu zapisano lokalnie.';

  @override
  String get appSnackDraftMemoryOnly =>
      'Szkic zapisano tylko w pamięci. Uruchom aplikację ponownie, aby włączyć lokalne zapisywanie.';

  @override
  String get appSnackSealedSavedAndCopied =>
      'Pergamin zapieczętowany: szkic zapisany, prompt skopiowany.';

  @override
  String get appSnackSealedCopiedOnlyMemory =>
      'Pergamin zapieczętowany: prompt skopiowany. Uruchom aplikację ponownie, aby włączyć lokalne zapisywanie.';

  @override
  String get appSnackLocalSaveUnavailable =>
      'Lokalne zapisywanie jest niedostępne w tej sesji. Zamknij i uruchom aplikację ponownie, aby zarejestrować wtyczkę.';

  @override
  String get appDraftMemoryOnly =>
      'Szkic zachowany tylko w pamięci. Uruchom aplikację ponownie, aby przywrócić lokalne zapisywanie.';

  @override
  String appDraftAligned(String dateTime) {
    return 'Lokalny szkic zsynchronizowano $dateTime.';
  }

  @override
  String appDraftLastSaved(String dateTime) {
    return 'Ostatni szkic zapisano $dateTime.';
  }

  @override
  String get appErrorEyebrow => 'Rytuał przerwany';

  @override
  String get appErrorTitle => 'Grimuar nie odpowiada';

  @override
  String get appErrorUnknownLoad => 'Nieznany błąd podczas wczytywania opcji.';

  @override
  String get entryCampaignTypesTitle => 'Typy kampanii';

  @override
  String get entryResumeTitle => 'Wznów sesję';

  @override
  String get entryResumeSubtitle =>
      'Masz już aktywny szkic. Wróć od razu do właściwego etapu.';

  @override
  String get entryResumeForge => 'Wznów kuźnię';

  @override
  String get entryOpenForge => 'Otwórz kuźnię';

  @override
  String get entryHeroWelcomeTitle => 'Wybierz swoją kampanię';

  @override
  String get entryHeroWelcomeBody =>
      'Wykuty prompt kampanii, a potem ożyw go przy pomocy zaufanej SI.';

  @override
  String get entryHeroChooseRitual => 'Wybierz format, aby rozpocząć.';

  @override
  String get onboardingHowItWorks => 'Jak to działa';

  @override
  String get onboardingChooseCampaignTitle => 'Wybierz kampanię';

  @override
  String get onboardingChooseCampaignBody =>
      'Najpierw wybierz format kampanii, aby reszta konfiguracji miała właściwy kształt.';

  @override
  String get onboardingDefineDetailsTitle => 'Określ kluczowe szczegóły';

  @override
  String get onboardingDefineDetailsBody =>
      'Ustaw świat, motywy, ton, styl, drużynę i zwrot akcji przed wykuciem promptu.';

  @override
  String get onboardingForgePromptTitle => 'Wykuj prompt';

  @override
  String get onboardingForgePromptBody =>
      'Wygeneruj końcowy prompt, podejrzyj go i wklej do ChatGPT.';

  @override
  String get onboardingGeneratedPromptTitle => 'Wygenerowany prompt';

  @override
  String get onboardingPastePromptSubtitle => 'Wklej tam wygenerowany prompt.';

  @override
  String get onboardingNext => 'Dalej';

  @override
  String get onboardingBack => 'Wstecz';

  @override
  String get onboardingSkip => 'Pomiń';

  @override
  String get onboardingStartForging => 'Zacznij kuć';

  @override
  String get onboardingCopyStep => 'Kopiuj';

  @override
  String get onboardingSettingExample => 'Pograniczne królestwo';

  @override
  String get onboardingThemesExample => 'Napięcie polityczne';

  @override
  String get onboardingToneExample => 'Mroczny i noir';

  @override
  String get onboardingStyleExample => 'Przyziemne fantasy';

  @override
  String get entryResetDraft => 'Nowa sesja';

  @override
  String get entryResetDraftConfirm => 'Szkic wyczyszczony.';

  @override
  String get entryBadgeDefault => 'Format';

  @override
  String get entryDescriptionDefault => 'Format kampanii gotowy na urządzeniu.';

  @override
  String get entryBadgeOneShot => 'Szybkie ostrze';

  @override
  String get entryDescriptionOneShot =>
      'Misja o dużym impakcie zaprojektowana na jedno posiedzenie, z natychmiastową wypłatą i precyzyjnym zwrotem akcji.';

  @override
  String get entryBadgeMiniCampaign => 'Krótki łuk';

  @override
  String get entryDescriptionMiniCampaign =>
      'Historia skondensowana do kilku sesji, z wyraźnym rozwojem, eskalacją i ostrym finałem.';

  @override
  String get entryBadgeLongCampaign => 'Szeroka saga';

  @override
  String get entryDescriptionLongCampaign =>
      'Frakcje, zmieniające się układy sił i trwałe wątki poboczne dla kampanii, która rośnie z czasem.';

  @override
  String get entryBadgeDungeon => 'Głębie';

  @override
  String get entryDescriptionDungeon =>
      'Ustrukturyzowane zejście przez mapy, ryzyko, wyczerpanie i warstwowe odkrycia.';

  @override
  String get forgeSectionWorld => 'Świat';

  @override
  String get forgeSectionParty => 'Drużyna';

  @override
  String get forgeSectionNarrative => 'Fabuła';

  @override
  String get forgeButtonForging => 'Kucie...';

  @override
  String get forgeNextParty => 'Przejdź do drużyny';

  @override
  String get forgeNextNarrative => 'Przejdź do fabuły';

  @override
  String get forgeReforgeParchment => 'Przekuj pergamin';

  @override
  String get forgeForgeParchment => 'Wykuj pergamin';

  @override
  String get forgeReforgeParchmentCompact => 'Przekuj pergamin';

  @override
  String get forgeForgeParchmentCompact => 'Wykuj pergamin';

  @override
  String get forgeAdvanceBlockedWorld =>
      'Określ przynajmniej ton, styl lub motywy, zanim przejdziesz do drużyny.';

  @override
  String get forgeAdvanceBlockedParty =>
      'Sprawdź poziom, liczebność i archetypy drużyny, zanim przejdziesz dalej.';

  @override
  String get forgeAdvanceBlockedNarrative =>
      'Dodaj przynajmniej jeden szczegół fabularny przed wykuciem pergaminu.';

  @override
  String get forgeReadinessWorldReady => 'Możesz przejść do drużyny.';

  @override
  String get forgeReadinessWorldPending =>
      'Wybierz format, świat i kluczowe sygnały.';

  @override
  String get forgeReadinessPartyReady => 'Możesz otworzyć fabułę.';

  @override
  String get forgeReadinessPartyPending =>
      'Określ poziom, liczebność i role grupy.';

  @override
  String get forgeReadinessNarrativeReady => 'Możesz wykuć pergamin.';

  @override
  String get forgeReadinessNarrativePending =>
      'Dodaj przynajmniej jeden haczyk fabularny.';

  @override
  String get forgeWorldSectionTitle => 'Budowanie świata';

  @override
  String get forgeWorldSectionSubtitle =>
      'Format, świat i początkowe sygnały kampanii.';

  @override
  String get forgeFoundationLabel => 'Podstawa';

  @override
  String get forgeFoundationTitle => 'Ustawienia bazowe';

  @override
  String get forgeFoundationSubtitle => 'Świat i scenariusz.';

  @override
  String get forgePresetSectionTitle => 'Wybierz preset';

  @override
  String get forgePresetSectionSubtitle =>
      'Zastosuj preset, aby szybko skonfigurować kampanię.';

  @override
  String get forgePresetPanelLabel => 'Presety';

  @override
  String get forgePresetPanelTitle => 'Szybkie presety';

  @override
  String get forgeQuickPresetLabel => 'Szybki preset';

  @override
  String get forgeNoPresetSelected => 'Brak presetu';

  @override
  String get forgeApplyPreset => 'Wykuj z presetem';

  @override
  String get forgeApply => 'Wykuj z presetem';

  @override
  String get forgeSettingLabel => 'Świat';

  @override
  String get forgeCustomSettingLabel => 'Własny świat';

  @override
  String get forgeCustomSettingHint =>
      'Np. królestwo w stanie wojny, pionowe miasto';

  @override
  String get forgeTwistTitle => 'Początkowy zwrot akcji';

  @override
  String get forgeTwistHelpTooltip =>
      'Pomoc dotycząca początkowego zwrotu akcji';

  @override
  String get forgeTwistLabel => 'Zwrot akcji';

  @override
  String get forgeCustomTwistLabel => 'Własny zwrot akcji';

  @override
  String get forgeCustomTwistHint =>
      'Sojusznik kłamie, loch żyje, misja jest pułapką...';

  @override
  String get forgeCreativeTitle => 'Motywy, ton i styl';

  @override
  String get forgeCreativeHelpTooltip => 'Pomoc dotycząca kierunku kreatywnego';

  @override
  String get forgeCreativeHelpBody =>
      'Wybierz motywy, ton i styl narracyjny swojej kampanii.';

  @override
  String get forgeThemesTitle => 'Motywy';

  @override
  String get forgeCustomThemesLabel => 'Własne motywy';

  @override
  String get forgeCustomThemesHint => 'Np. steampunk, kosmiczny horror';

  @override
  String get forgeToneTitle => 'Ton';

  @override
  String get forgeStyleTitle => 'Styl';

  @override
  String get forgeToneStyleOverrideLabel => 'Własny ton i styl';

  @override
  String get forgeToneStyleOverrideHint => 'Np. ton: mroczny; styl: brutalny';

  @override
  String get forgePartySectionTitle => 'Drużyna i skala gry';

  @override
  String get forgePartySectionSubtitle =>
      'Poziom, liczebność i główne role grupy.';

  @override
  String get forgeScaleLabel => 'Skala';

  @override
  String get forgeScaleTitle => 'Poziom i liczebność';

  @override
  String forgePartyLevel(int level) {
    return 'Poziom drużyny: $level';
  }

  @override
  String forgePartySize(int size) {
    return 'Liczba postaci: $size';
  }

  @override
  String get forgePartyLevelPremiumHint => 'Poziomy 4+ są premium';

  @override
  String get forgePartySizePremiumHint => '5+ postaci to premium';

  @override
  String get forgePartyArchetypesTitle => 'Archetypy drużyny';

  @override
  String forgePartyArchetypesSubtitle(int size) {
    return 'Wybierz do $size archetypów.';
  }

  @override
  String get forgePartyArchetypesMaxReached =>
      'Osiągnięto maksymalną liczbę archetypów możliwych do wybrania dla tej drużyny.';

  @override
  String get forgePartyInfoTitle => 'Przydatne informacje';

  @override
  String get forgeCharacterNotesLabel => 'Notatki o postaciach';

  @override
  String get forgeCharacterNotesHint =>
      'Sekrety, więzi, lęki, ważna przeszłość...';

  @override
  String get forgeConstraintsLabel => 'Ograniczenia';

  @override
  String get forgeConstraintsHint =>
      'Krótki czas trwania, brak podróży międzyplanarnych, obowiązkowy finałowy boss...';

  @override
  String get forgeNarrativeSectionTitle => 'Nacisk fabularny';

  @override
  String get forgeNarrativeSectionSubtitle =>
      'Dodatkowe haczyki, frakcje i ograniczenia, które personalizują pergamin.';

  @override
  String get forgeNarrativePanelTitle => 'Fabuła i siły w grze';

  @override
  String get forgeNarrativeHooksLabel => 'Haczyki fabularne';

  @override
  String get forgeNarrativeHooksHint =>
      'Misja otwierająca, zagrożenie, tajemnica, odliczanie...';

  @override
  String get forgeFactionsLabel => 'Frakcje i siły';

  @override
  String get forgeFactionsHint =>
      'Gildie, kulty, rody szlacheckie, antagoniści, niestabilni sojusznicy...';

  @override
  String get forgeNpcFocusLabel => 'Kluczowe BN';

  @override
  String get forgeNpcFocusHint =>
      'Dwuznaczny mentor, rywal, patron, zdrajca...';

  @override
  String get forgeEncounterFocusLabel => 'Pożądane spotkania';

  @override
  String get forgeEncounterFocusHint =>
      'Oblężenie, śledztwo społeczne, pościg, finałowy boss...';

  @override
  String get forgeContentConstraintsTitle => 'Ograniczenia treści';

  @override
  String get forgeIncludeNpcsLabel => 'Uwzględnij BN';

  @override
  String get forgeIncludeNpcsSubtitle =>
      'Prompt będzie zawierał istotne postacie niezależne.';

  @override
  String get forgeIncludeEncountersLabel => 'Uwzględnij spotkania';

  @override
  String get forgeIncludeEncountersSubtitle =>
      'Prompt zasugeruje sceny i walki.';

  @override
  String get forgeSafetyNotesLabel => 'Notatki bezpieczeństwa';

  @override
  String get forgeSafetyNotesHint =>
      'Tematy do unikania, linie i zasłony, granice tonu...';

  @override
  String get forgeParchmentDirty =>
      'Konfiguracja zmieniona: wygeneruj ponownie.';

  @override
  String get forgeParchmentReady => 'Pergamin jest aktualny.';

  @override
  String get forgeParchmentIncomplete => 'Uzupełnij fabułę, aby wygenerować.';

  @override
  String get statusReady => 'Gotowe';

  @override
  String get statusNeedsPolish => 'Wymaga dopracowania';

  @override
  String get parchmentReadyTitle => 'Pergamin gotowy';

  @override
  String get parchmentReadySubtitleStale =>
      'Zmieniłeś kuźnię: skopiowany prompt nie jest już aktualny.';

  @override
  String get parchmentReadySubtitleAligned =>
      'Skopiowany prompt jest zgodny z bieżącym stanem kuźni.';

  @override
  String get parchmentQuickActionsTitle => 'Szybkie akcje';

  @override
  String get parchmentCopyPromptTitle => 'Kopiuj prompt';

  @override
  String get parchmentPreviewPromptTooltip => 'Podgląd promptu';

  @override
  String get parchmentGoHomeTooltip => 'Powrót do startu';

  @override
  String get parchmentPreviewSheetTitle => 'Podgląd promptu';

  @override
  String get parchmentPreviewSheetSubtitle =>
      'Przejrzyj cały prompt przed skopiowaniem lub wklejeniem.';

  @override
  String get parchmentCopyPromptSubtitle => 'Wyślij prompt do schowka.';

  @override
  String get parchmentShareTitle => 'Udostępnij';

  @override
  String get parchmentShareSubtitle => 'Otwiera menu udostępniania.';

  @override
  String get parchmentOpenChatGptTitle => 'Otwórz w ChatGPT';

  @override
  String get parchmentOpenChatGptSubtitle => 'Otwiera ChatGPT w nowej karcie.';

  @override
  String get parchmentDraftUpdatedTitle => 'Szkic zaktualizowany';

  @override
  String get parchmentSaveDraftTitle => 'Zapisz szkic';

  @override
  String get parchmentSaveDraftSubtitle => 'Zapisz prompt lokalnie na później.';

  @override
  String get parchmentPromptCopied => 'Prompt skopiowany';

  @override
  String get parchmentCopiedStaleBanner =>
      'Zmieniłeś kuźnię po ostatnim generowaniu. Wygeneruj ponownie, aby odświeżyć skopiowany prompt.';

  @override
  String get parchmentCopiedSuccessBody =>
      'Pergamin został pomyślnie wykuty. Użyj rytuałów po prawej, aby go udostępnić, zapisać lub otworzyć w ChatGPT.';

  @override
  String get atmosphereOneShot => 'Karmazynowa pilność';

  @override
  String get atmosphereMiniCampaign => 'Złoty szlak';

  @override
  String get atmosphereLongCampaign => 'Zielony atlas';

  @override
  String get atmosphereDungeon => 'Sklepienie pochodni';

  @override
  String get parchmentSeal => 'PIECZĘĆ';

  @override
  String get parchmentSealAndCopy => 'Zapieczętuj i kopiuj';

  @override
  String get infoDialogLine1 =>
      'Ta aplikacja jest generatorem promptów inspirowanym fantasy grami fabularnymi.';

  @override
  String get infoDialogLine2 =>
      'Nie jest powiązana z Dungeons & Dragons ani z żadnym narzędziem językowym SI.';

  @override
  String get infoDialogLine3 =>
      'Możesz używać promptów z narzędziami SI do tworzenia własnych historii.';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get settingsLeaveReview => 'Zostaw opinię';

  @override
  String get settingsShareApp => 'Udostępnij aplikację';

  @override
  String get settingsPrivacyOptions => 'Ustawienia prywatności';

  @override
  String get settingsShareText =>
      'Odkryj Campaign Forge, generator kampanii D&D: ';

  @override
  String get settingsLanguageLabel => 'Język';

  @override
  String get settingsLanguageEnglish => 'Angielski';

  @override
  String get settingsLanguageItalian => 'Włoski';

  @override
  String get settingsThemeLabel => 'Motyw';

  @override
  String get settingsThemeDark => 'Ciemny';

  @override
  String get settingsThemeLight => 'Jasny';

  @override
  String get settingsInfoLabel => 'Informacje';

  @override
  String get settingsVersion => 'Wersja';

  @override
  String get settingsGoAdFree => 'Reklamy';

  @override
  String get settingsGoAdFreePrice => 'Odblokuj Premium';

  @override
  String get settingsGoAdFreeSubtitle => 'Jednorazowy zakup · £1.99';

  @override
  String settingsGoAdFreeSubtitleWithAmount(String price) {
    return 'Jednorazowy zakup · $price';
  }

  @override
  String settingsGoAdFreePriceWithAmount(String price) {
    return 'Odblokuj Premium — $price';
  }

  @override
  String get settingsRestorePurchases => 'Przywróć zakupy';

  @override
  String get settingsRestorePurchasesStarted => 'Przywracanie zakupów…';

  @override
  String get settingsRestorePurchasesComplete =>
      'Zakupy przywrócono pomyślnie.';

  @override
  String get settingsAdFreeActive => 'Reklamy usunięte';

  @override
  String get settingsIapUnavailable =>
      'Zakupy w aplikacji są niedostępne na tym urządzeniu.';

  @override
  String get settingsIapProductNotFound =>
      'Nie znaleziono produktu. Spróbuj ponownie później.';

  @override
  String get settingsPurchasePending => 'Przetwarzanie zakupu…';

  @override
  String get settingsPurchaseCancelled => 'Zakup anulowany.';

  @override
  String get settingsPurchaseFailed =>
      'Zakup nie powiódł się. Spróbuj ponownie.';

  @override
  String get premiumUnlockTitle => 'Funkcja premium';

  @override
  String get premiumUnlockBodyWithAd =>
      'Obejrzyj reklamę, aby odblokować wszystkie funkcje premium na 5 minut, albo odblokuj Premium, by mieć stały dostęp do wszystkiego.';

  @override
  String get premiumUnlockBodyNoAd =>
      'Odblokuj Premium, aby uzyskać stały dostęp do tej funkcji.';

  @override
  String get premiumUnlockWatchAd => 'Obejrzyj reklamę (5 min)';

  @override
  String get helpTitle => 'Przewodnik';

  @override
  String get helpCampaignTypesTitle => 'Typy kampanii';

  @override
  String get helpCampaignTypeOneShotTitle => 'One-Shot';

  @override
  String get helpCampaignTypeOneShotBody =>
      'Pełna przygoda zaprojektowana na jedną sesję, z mocnym otwarciem, jasnym celem i szybkim domknięciem. Wybierz ją, jeśli chcesz natychmiastowego tempa i zwartego łuku fabularnego.';

  @override
  String get helpCampaignTypeMiniCampaignTitle => 'Mini-kampania';

  @override
  String get helpCampaignTypeMiniCampaignBody =>
      'Krótki łuk rozgrywający się przez kilka sesji, z miejscem na eskalację i wyraźniejszy finał. Najlepszy wybór, gdy chcesz czegoś zwartego, ale mniej skompresowanego niż one-shot.';

  @override
  String get helpCampaignTypeLongCampaignTitle => 'Długa kampania';

  @override
  String get helpCampaignTypeLongCampaignBody =>
      'Rozbudowana struktura z frakcjami, wątkami pobocznymi i konsekwencjami rozwijającymi się z czasem. Idealna, jeśli chcesz ciągłości, progresji i świata reagującego na wybory graczy.';

  @override
  String get helpCampaignTypeDungeonTitle => 'Eksploracja lochu';

  @override
  String get helpCampaignTypeDungeonBody =>
      'Kampania skupiona na mapach, odkrywaniu, wyczerpaniu i sekretach ukrytych w niebezpiecznych miejscach. Doskonała, gdy chcesz presji, eksploracji i mocnego poczucia miejsca.';

  @override
  String get helpTipsTitle => 'Wskazówki i dobre praktyki';

  @override
  String get helpTipWorld =>
      'Zacznij od świata i motywu: to one wyznaczają ramy, które utrzymują wszystko w spójności.';

  @override
  String get helpTipTheme =>
      'Użyj 1 lub 2 mocnych motywów zamiast piętrzyć zbyt wiele podobnych pomysłów.';

  @override
  String get helpTipTwist =>
      'Wybierz zwrot akcji, aby od razu nadać fabule napięcie.';

  @override
  String get helpTipContrast =>
      'Łącz kontrastujące tony, aby uzyskać mniej przewidywalne prompty.';

  @override
  String get helpTipPreset =>
      'Używaj presetów, gdy chcesz szybkiej inspiracji albo mocnego punktu wyjścia.';

  @override
  String get helpTipCustom =>
      'Dodawaj własne wpisy tylko wtedy, gdy potrzebnej opcji nie ma już na liście.';

  @override
  String get helpTipParty =>
      'Utrzymuj zgodność poziomu, liczebności drużyny i archetypów, aby unikać nierównych promptów.';
}
