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
  String get entryResumeSubtitle => '이미 진행 중인 초안이 있습니다. 적절한 지점으로 바로 돌아가세요.';

  @override
  String get entryResumeForge => '포지 이어하기';

  @override
  String get entryOpenForge => '포지 열기';

  @override
  String get entryHeroWelcomeTitle => '캠페인을 선택하세요';

  @override
  String get entryHeroWelcomeBody => '캠페인 프롬프트를 제작한 뒤, 신뢰하는 AI로 생명을 불어넣으세요.';

  @override
  String get entryHeroChooseRitual => '시작할 형식을 선택하세요.';

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
  String get entryResetDraft => '새 세션';

  @override
  String get entryResetDraftConfirm => '초안이 지워졌습니다.';

  @override
  String get entryBadgeDefault => '형식';

  @override
  String get entryDescriptionDefault => '캠페인 형식이 기기에 준비되었습니다.';

  @override
  String get entryBadgeOneShot => '빠른 일격';

  @override
  String get entryDescriptionOneShot =>
      '단 한 번의 세션을 위해 설계된 강렬한 임무로, 즉각적인 보상과 선명한 반전을 제공합니다.';

  @override
  String get entryBadgeMiniCampaign => '짧은 아크';

  @override
  String get entryDescriptionMiniCampaign =>
      '몇 번의 세션에 응축된 이야기로, 강한 진행감, 고조, 날카로운 결말을 담고 있습니다.';

  @override
  String get entryBadgeLongCampaign => '장대한 사가';

  @override
  String get entryDescriptionLongCampaign =>
      '시간에 따라 성장하는 캠페인을 위한 세력, 변화하는 균형, 지속되는 서브플롯이 중심입니다.';

  @override
  String get entryBadgeDungeon => '심연';

  @override
  String get entryDescriptionDungeon =>
      '지도, 위험, 소모, 층층이 이어지는 발견으로 이루어진 구조적 하강입니다.';

  @override
  String get forgeSectionWorld => '세계';

  @override
  String get forgeSectionParty => '파티';

  @override
  String get forgeSectionNarrative => '이야기';

  @override
  String get forgeButtonForging => '제작 중...';

  @override
  String get forgeNextParty => '파티로 이동';

  @override
  String get forgeNextNarrative => '이야기로 이동';

  @override
  String get forgeReforgeParchment => '양피지 다시 제작';

  @override
  String get forgeForgeParchment => '양피지 제작';

  @override
  String get forgeReforgeParchmentCompact => '다시 제작';

  @override
  String get forgeForgeParchmentCompact => '양피지 제작';

  @override
  String get forgeAdvanceBlockedWorld => '파티로 이동하기 전에 최소한 톤, 스타일 또는 테마를 정하세요.';

  @override
  String get forgeAdvanceBlockedParty => '계속하기 전에 파티 레벨, 인원수, 아키타입을 확인하세요.';

  @override
  String get forgeAdvanceBlockedNarrative =>
      '양피지를 제작하기 전에 최소 하나의 서사 요소를 추가하세요.';

  @override
  String get forgeReadinessWorldReady => '이제 파티 섹션으로 이동할 수 있습니다.';

  @override
  String get forgeReadinessWorldPending => '형식, 배경, 핵심 신호를 선택하세요.';

  @override
  String get forgeReadinessPartyReady => '이제 이야기 섹션을 열 수 있습니다.';

  @override
  String get forgeReadinessPartyPending => '레벨, 인원수, 그룹 역할을 정하세요.';

  @override
  String get forgeReadinessNarrativeReady => '양피지를 제작할 수 있습니다.';

  @override
  String get forgeReadinessNarrativePending => '최소 하나의 서사 훅을 추가하세요.';

  @override
  String get forgeWorldSectionTitle => '세계 구축';

  @override
  String get forgeWorldSectionSubtitle => '형식, 배경, 그리고 캠페인의 첫 신호를 정합니다.';

  @override
  String get forgeFoundationLabel => '기초';

  @override
  String get forgeFoundationTitle => '기본 설정';

  @override
  String get forgeFoundationSubtitle => '배경과 시나리오.';

  @override
  String get forgePresetSectionTitle => '프리셋 선택';

  @override
  String get forgePresetSectionSubtitle => '프리셋을 적용해 캠페인을 빠르게 설정하세요.';

  @override
  String get forgePresetPanelLabel => '프리셋';

  @override
  String get forgePresetPanelTitle => '빠른 프리셋';

  @override
  String get forgeQuickPresetLabel => '빠른 프리셋';

  @override
  String get forgeNoPresetSelected => '프리셋 없음';

  @override
  String get forgeApplyPreset => '프리셋으로 제작';

  @override
  String get forgeApply => '프리셋으로 제작';

  @override
  String get forgeSettingLabel => '배경';

  @override
  String get forgeCustomSettingLabel => '사용자 지정 배경';

  @override
  String get forgeCustomSettingHint => '예: 전쟁 중인 왕국, 수직 도시';

  @override
  String get forgeTwistTitle => '오프닝 반전';

  @override
  String get forgeTwistHelpTooltip => '오프닝 반전 도움말';

  @override
  String get forgeTwistLabel => '반전';

  @override
  String get forgeCustomTwistLabel => '사용자 지정 반전';

  @override
  String get forgeCustomTwistHint => '동료가 거짓말한다, 던전이 살아 있다, 임무가 함정이다...';

  @override
  String get forgeCreativeTitle => '테마, 톤, 스타일';

  @override
  String get forgeCreativeHelpTooltip => '창작 방향 도움말';

  @override
  String get forgeCreativeHelpBody => '캠페인의 테마, 톤, 서사 스타일을 선택하세요.';

  @override
  String get forgeThemesTitle => '테마';

  @override
  String get forgeCustomThemesLabel => '사용자 지정 테마';

  @override
  String get forgeCustomThemesHint => '예: 스팀펑크, 코스믹 호러';

  @override
  String get forgeToneTitle => '톤';

  @override
  String get forgeStyleTitle => '스타일';

  @override
  String get forgeToneStyleOverrideLabel => '사용자 지정 톤 및 스타일';

  @override
  String get forgeToneStyleOverrideHint => '예: 톤: 다크; 스타일: 거칠고 현실적';

  @override
  String get forgePartySectionTitle => '파티와 게임 규모';

  @override
  String get forgePartySectionSubtitle => '레벨, 인원수, 주요 그룹 역할을 정합니다.';

  @override
  String get forgeScaleLabel => '규모';

  @override
  String get forgeScaleTitle => '레벨과 인원수';

  @override
  String forgePartyLevel(int level) {
    return '파티 레벨: $level';
  }

  @override
  String forgePartySize(int size) {
    return '캐릭터 수: $size';
  }

  @override
  String get forgePartyLevelPremiumHint => '레벨 4 이상은 프리미엄입니다';

  @override
  String get forgePartySizePremiumHint => '캐릭터 5명 이상은 프리미엄입니다';

  @override
  String get forgePartyArchetypesTitle => '파티 아키타입';

  @override
  String forgePartyArchetypesSubtitle(int size) {
    return '최대 $size개의 아키타입을 선택하세요.';
  }

  @override
  String get forgePartyArchetypesMaxReached =>
      '현재 파티에 대해 선택 가능한 최대 아키타입 수에 도달했습니다.';

  @override
  String get forgePartyInfoTitle => '유용한 정보';

  @override
  String get forgeCharacterNotesLabel => '캐릭터 메모';

  @override
  String get forgeCharacterNotesHint => '비밀, 유대, 두려움, 중요한 배경 이야기...';

  @override
  String get forgeConstraintsLabel => '제약 조건';

  @override
  String get forgeConstraintsHint => '짧은 플레이 시간, 차원 이동 금지, 필수 최종 보스...';

  @override
  String get forgeNarrativeSectionTitle => '서사 압력';

  @override
  String get forgeNarrativeSectionSubtitle => '양피지를 맞춤화할 추가 훅, 세력, 제약 조건입니다.';

  @override
  String get forgeNarrativePanelTitle => '이야기와 작동하는 세력';

  @override
  String get forgeNarrativeHooksLabel => '서사 훅';

  @override
  String get forgeNarrativeHooksHint => '시작 임무, 위협, 미스터리, 카운트다운...';

  @override
  String get forgeFactionsLabel => '세력과 권력';

  @override
  String get forgeFactionsHint => '길드, 컬트, 귀족 가문, 적대자, 불안정한 동맹...';

  @override
  String get forgeNpcFocusLabel => '핵심 NPC';

  @override
  String get forgeNpcFocusHint => '애매한 멘토, 라이벌, 후원자, 배신자...';

  @override
  String get forgeEncounterFocusLabel => '원하는 조우';

  @override
  String get forgeEncounterFocusHint => '공성전, 사회적 조사, 추격전, 최종 보스...';

  @override
  String get forgeContentConstraintsTitle => '콘텐츠 제약';

  @override
  String get forgeIncludeNpcsLabel => 'NPC 포함';

  @override
  String get forgeIncludeNpcsSubtitle => '프롬프트에 관련 비플레이어 캐릭터가 포함됩니다.';

  @override
  String get forgeIncludeEncountersLabel => '조우 포함';

  @override
  String get forgeIncludeEncountersSubtitle => '프롬프트가 장면과 전투를 제안합니다.';

  @override
  String get forgeSafetyNotesLabel => '안전 메모';

  @override
  String get forgeSafetyNotesHint => '피해야 할 주제, 라인과 베일, 톤 제한...';

  @override
  String get forgeParchmentDirty => '설정이 변경되었습니다: 다시 생성하세요.';

  @override
  String get forgeParchmentReady => '양피지가 최신 상태입니다.';

  @override
  String get forgeParchmentIncomplete => '생성하려면 이야기를 완성하세요.';

  @override
  String get statusReady => '준비 완료';

  @override
  String get statusNeedsPolish => '다듬기 필요';

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
  String get settingsPrivacyOptions => '개인정보 설정';

  @override
  String get settingsShareText => 'D&D 캠페인 생성기 Campaign Forge를 확인해 보세요: ';

  @override
  String get settingsLanguageLabel => '언어';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsThemeLabel => '테마';

  @override
  String get settingsThemeDark => '다크';

  @override
  String get settingsThemeLight => '라이트';

  @override
  String get settingsInfoLabel => '정보';

  @override
  String get settingsVersion => '버전';

  @override
  String get settingsGoAdFree => '광고';

  @override
  String get settingsGoAdFreePrice => '프리미엄 잠금 해제';

  @override
  String get settingsGoAdFreeSubtitle => '일회성 구매 · £1.99';

  @override
  String settingsGoAdFreeSubtitleWithAmount(String price) {
    return '일회성 구매 · $price';
  }

  @override
  String settingsGoAdFreePriceWithAmount(String price) {
    return '프리미엄 잠금 해제 — $price';
  }

  @override
  String get settingsRestorePurchases => '구매 복원';

  @override
  String get settingsRestorePurchasesStarted => '구매 복원 중…';

  @override
  String get settingsRestorePurchasesComplete => '구매가 성공적으로 복원되었습니다.';

  @override
  String get settingsAdFreeActive => '광고 제거됨';

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
  String get helpTitle => '가이드';

  @override
  String get helpCampaignTypesTitle => '캠페인 유형';

  @override
  String get helpCampaignTypeOneShotTitle => 'One-Shot';

  @override
  String get helpCampaignTypeOneShotBody =>
      '강한 도입, 분명한 목표, 빠른 보상을 갖춘 단일 세션용 완결형 모험입니다. 즉각적인 추진력과 압축된 전개가 필요할 때 적합합니다.';

  @override
  String get helpCampaignTypeMiniCampaignTitle => '미니 캠페인';

  @override
  String get helpCampaignTypeMiniCampaignBody =>
      '몇 번의 세션에 걸쳐 진행되는 짧은 아크로, 상승과 더 날카로운 결말을 담을 여유가 있습니다. 원샷보다 덜 압축된 콤팩트한 구성을 원할 때 적합합니다.';

  @override
  String get helpCampaignTypeLongCampaignTitle => '장기 캠페인';

  @override
  String get helpCampaignTypeLongCampaignBody =>
      '시간에 따라 발전하는 세력, 서브플롯, 결과를 담은 장기 구조입니다. 연속성, 성장, 플레이어 선택에 반응하는 세계를 원할 때 이상적입니다.';

  @override
  String get helpCampaignTypeDungeonTitle => '던전 탐험';

  @override
  String get helpCampaignTypeDungeonBody =>
      '지도, 발견, 자원 소모, 위험한 장소에 숨겨진 비밀에 초점을 둔 캠페인입니다. 압박감, 탐험, 강한 장소성을 원할 때 잘 맞습니다.';

  @override
  String get helpTipsTitle => '팁과 모범 사례';

  @override
  String get helpTipWorld => '배경과 테마부터 시작하세요. 전체를 일관되게 유지해 주는 핵심 제약입니다.';

  @override
  String get helpTipTheme => '비슷한 아이디어를 너무 많이 쌓기보다 강한 테마 1~2개를 선택하세요.';

  @override
  String get helpTipTwist => '반전을 선택해 줄거리에 즉각적인 긴장을 더하세요.';

  @override
  String get helpTipContrast => '대비되는 톤을 조합해 더 예측하기 어려운 프롬프트를 만들어 보세요.';

  @override
  String get helpTipPreset => '빠른 영감이나 강한 출발점이 필요할 때 프리셋을 사용하세요.';

  @override
  String get helpTipCustom => '필요한 옵션이 기존에 없을 때만 사용자 지정 항목을 추가하세요.';

  @override
  String get helpTipParty => '불균형한 프롬프트를 피하려면 레벨, 파티 규모, 아키타입을 맞춰 두세요.';
}
