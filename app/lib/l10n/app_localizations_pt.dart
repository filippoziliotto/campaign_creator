// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Criador de Campanhas D&D';

  @override
  String get appNameShort => 'Criador de Campanhas';

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
  String get commonRetry => 'Tentar novamente';

  @override
  String get commonOpen => 'Abrir';

  @override
  String get commonOptional => 'Opcional';

  @override
  String get appFreeFormat => 'Escolher formato';

  @override
  String get appSettingPending => 'Ambientação por definir';

  @override
  String get appTwistPending => 'Reviravolta por definir';

  @override
  String get appStageEntry => 'Escolha';

  @override
  String get appStageForge => 'Forja';

  @override
  String get appStageParchment => 'Pergaminho';

  @override
  String get appOpenParchment => 'Abrir pergaminho';

  @override
  String get appSealParchment => 'Selar pergaminho';

  @override
  String appSummaryLevel(int level) {
    return 'Nv $level';
  }

  @override
  String appSummaryPartySize(int size) {
    return '$size PJs';
  }

  @override
  String appSummaryPreset(String name) {
    return 'Predefinição: $name';
  }

  @override
  String appLoadOptionsError(String error) {
    return 'Não foi possível carregar as opções: $error';
  }

  @override
  String appGenerationFailedError(String error) {
    return 'A geração falhou: $error';
  }

  @override
  String appInvalidArchetypeSelection(int count, int size) {
    return 'Selecionaste $count arquétipos, mas o grupo está definido para $size PJs.';
  }

  @override
  String get appSnackForgedAndCopied =>
      'Pergaminho forjado e prompt copiado para a área de transferência.';

  @override
  String get appSnackGenerationFailed =>
      'A geração falhou. Verifica a mensagem apresentada no ecrã.';

  @override
  String get appSnackPromptCopied =>
      'Prompt copiado para a área de transferência.';

  @override
  String get appSnackNoParchmentToShare =>
      'Ainda não há nenhum pergaminho para partilhar.';

  @override
  String get appSnackShareUnavailableOnDevice =>
      'A partilha não está disponível neste dispositivo.';

  @override
  String appSnackShareUnavailable(String error) {
    return 'Partilha indisponível: $error';
  }

  @override
  String get appSnackGenerateFirst =>
      'Gera primeiro um pergaminho antes de o enviar.';

  @override
  String get appSnackChatGptOpened =>
      'ChatGPT aberto. O prompt já está na área de transferência.';

  @override
  String get appSnackChatGptCopiedOnly =>
      'Não foi possível abrir o ChatGPT, mas o prompt foi copiado.';

  @override
  String get appSnackPremiumUnlockedTemporary =>
      'Premium desbloqueado por 5 minutos';

  @override
  String get appSnackNoParchmentToSave =>
      'Não há nenhum pergaminho para guardar.';

  @override
  String get appSnackDraftSaved =>
      'Rascunho do pergaminho guardado localmente.';

  @override
  String get appSnackDraftMemoryOnly =>
      'Rascunho guardado apenas em memória. Reinicia completamente a app para ativar a persistência local.';

  @override
  String get appSnackSealedSavedAndCopied =>
      'Pergaminho selado: rascunho guardado e prompt copiado.';

  @override
  String get appSnackSealedCopiedOnlyMemory =>
      'Pergaminho selado: prompt copiado. Reinicia completamente a app para ativar a gravação local.';

  @override
  String get appSnackLocalSaveUnavailable =>
      'A gravação local não está disponível nesta sessão. Fecha e volta a abrir a app para registar o plugin.';

  @override
  String get appDraftMemoryOnly =>
      'Rascunho mantido apenas em memória. Reinicia completamente a app para reativar a gravação local.';

  @override
  String appDraftAligned(String dateTime) {
    return 'Rascunho local alinhado em $dateTime.';
  }

  @override
  String appDraftLastSaved(String dateTime) {
    return 'Último rascunho guardado em $dateTime.';
  }

  @override
  String get appErrorEyebrow => 'Ritual interrompido';

  @override
  String get appErrorTitle => 'O grimório não está a responder';

  @override
  String get appErrorUnknownLoad => 'Erro desconhecido ao carregar as opções.';

  @override
  String get entryCampaignTypesTitle => 'Tipos de campanha';

  @override
  String get entryResumeTitle => 'Retomar sessão';

  @override
  String get entryResumeSubtitle =>
      'Já tens um rascunho ativo. Volta ao ponto certo.';

  @override
  String get entryResumeForge => 'Retomar forja';

  @override
  String get entryOpenForge => 'Abrir forja';

  @override
  String get entryHeroWelcomeTitle => 'Escolhe a tua campanha';

  @override
  String get entryHeroWelcomeBody =>
      'Forja o prompt da tua campanha e depois dá-lhe vida com a tua IA de confiança.';

  @override
  String get entryHeroChooseRitual => 'Seleciona um formato para começar.';

  @override
  String get entryResetDraft => 'Nova sessão';

  @override
  String get entryResetDraftConfirm => 'Rascunho limpo.';

  @override
  String get entryBadgeDefault => 'Formato';

  @override
  String get entryDescriptionDefault =>
      'Formato de campanha pronto no dispositivo.';

  @override
  String get entryBadgeOneShot => 'Lâmina rápida';

  @override
  String get entryDescriptionOneShot =>
      'Uma missão de alto impacto pensada para uma única sessão, com retorno imediato e uma reviravolta precisa.';

  @override
  String get entryBadgeMiniCampaign => 'Arco curto';

  @override
  String get entryDescriptionMiniCampaign =>
      'Uma história condensada em poucas sessões, com forte progressão, escalada e um final marcante.';

  @override
  String get entryBadgeLongCampaign => 'Saga ampla';

  @override
  String get entryDescriptionLongCampaign =>
      'Facções, equilíbrios em mudança e subtramas persistentes para uma campanha que cresce com o tempo.';

  @override
  String get entryBadgeDungeon => 'Profundezas';

  @override
  String get entryDescriptionDungeon =>
      'Uma descida estruturada por mapas, risco, desgaste e descobertas em camadas.';

  @override
  String get forgeSectionWorld => 'Mundo';

  @override
  String get forgeSectionParty => 'Grupo';

  @override
  String get forgeSectionNarrative => 'História';

  @override
  String get forgeButtonForging => 'A forjar...';

  @override
  String get forgeNextParty => 'Ir para o grupo';

  @override
  String get forgeNextNarrative => 'Ir para a história';

  @override
  String get forgeReforgeParchment => 'Reforjar pergaminho';

  @override
  String get forgeForgeParchment => 'Forjar pergaminho';

  @override
  String get forgeReforgeParchmentCompact => 'Reforjar pergaminho';

  @override
  String get forgeForgeParchmentCompact => 'Forjar pergaminho';

  @override
  String get forgeAdvanceBlockedWorld =>
      'Define pelo menos o tom, o estilo ou os temas antes de passar para o grupo.';

  @override
  String get forgeAdvanceBlockedParty =>
      'Verifica o nível, o tamanho e os arquétipos do grupo antes de continuar.';

  @override
  String get forgeAdvanceBlockedNarrative =>
      'Adiciona pelo menos um detalhe narrativo antes de forjar o pergaminho.';

  @override
  String get forgeReadinessWorldReady => 'Podes avançar para o grupo.';

  @override
  String get forgeReadinessWorldPending =>
      'Escolhe o formato, a ambientação e os sinais-chave.';

  @override
  String get forgeReadinessPartyReady => 'Podes abrir a história.';

  @override
  String get forgeReadinessPartyPending =>
      'Define o nível, o tamanho e os papéis do grupo.';

  @override
  String get forgeReadinessNarrativeReady => 'Podes forjar o pergaminho.';

  @override
  String get forgeReadinessNarrativePending =>
      'Adiciona pelo menos um gancho narrativo.';

  @override
  String get forgeWorldSectionTitle => 'Construção do mundo';

  @override
  String get forgeWorldSectionSubtitle =>
      'Formato, ambientação e os sinais de abertura da campanha.';

  @override
  String get forgeFoundationLabel => 'Fundação';

  @override
  String get forgeFoundationTitle => 'Configuração base';

  @override
  String get forgeFoundationSubtitle => 'Ambientação e cenário.';

  @override
  String get forgePresetSectionTitle => 'Escolher uma predefinição';

  @override
  String get forgePresetSectionSubtitle =>
      'Aplica uma predefinição para configurar rapidamente a tua campanha.';

  @override
  String get forgePresetPanelLabel => 'Predefinições';

  @override
  String get forgePresetPanelTitle => 'Predefinições rápidas';

  @override
  String get forgeQuickPresetLabel => 'Predefinição rápida';

  @override
  String get forgeNoPresetSelected => 'Sem predefinição';

  @override
  String get forgeApplyPreset => 'Forjar com predefinição';

  @override
  String get forgeApply => 'Forjar com predefinição';

  @override
  String get forgeSettingLabel => 'Ambientação';

  @override
  String get forgeCustomSettingLabel => 'Ambientação personalizada';

  @override
  String get forgeCustomSettingHint => 'Ex.: Reino em guerra, cidade vertical';

  @override
  String get forgeTwistTitle => 'Reviravolta inicial';

  @override
  String get forgeTwistLabel => 'Reviravolta';

  @override
  String get forgeCustomTwistLabel => 'Reviravolta personalizada';

  @override
  String get forgeCustomTwistHint =>
      'Um aliado mente, a masmorra está viva, a missão é uma armadilha...';

  @override
  String get forgeCreativeTitle => 'Temas, tom e estilo';

  @override
  String get forgeThemesTitle => 'Temas';

  @override
  String get forgeCustomThemesLabel => 'Temas personalizados';

  @override
  String get forgeCustomThemesHint => 'Ex.: Steampunk, horror cósmico';

  @override
  String get forgeToneTitle => 'Tom';

  @override
  String get forgeStyleTitle => 'Estilo';

  @override
  String get forgeToneStyleOverrideLabel => 'Tons e estilo personalizados';

  @override
  String get forgeToneStyleOverrideHint => 'Ex.: Tom: sombrio; Estilo: cru';

  @override
  String get forgePartySectionTitle => 'Grupo e escala do jogo';

  @override
  String get forgePartySectionSubtitle =>
      'Nível, tamanho e principais papéis do grupo.';

  @override
  String get forgeScaleLabel => 'Escala';

  @override
  String get forgeScaleTitle => 'Nível e tamanho';

  @override
  String forgePartyLevel(int level) {
    return 'Nível do grupo: $level';
  }

  @override
  String forgePartySize(int size) {
    return 'Número de personagens: $size';
  }

  @override
  String get forgePartyLevelPremiumHint => 'Níveis 4+ são premium';

  @override
  String get forgePartySizePremiumHint => '5+ personagens são premium';

  @override
  String get forgePartyArchetypesTitle => 'Arquétipos do grupo';

  @override
  String forgePartyArchetypesSubtitle(int size) {
    return 'Seleciona até $size arquétipos.';
  }

  @override
  String get forgePartyArchetypesMaxReached =>
      'Atingiste o máximo de arquétipos selecionáveis para o grupo atual.';

  @override
  String get forgePartyInfoTitle => 'Informações úteis';

  @override
  String get forgeCharacterNotesLabel => 'Notas de personagem';

  @override
  String get forgeCharacterNotesHint =>
      'Segredos, laços, medos, história importante...';

  @override
  String get forgeConstraintsLabel => 'Restrições';

  @override
  String get forgeConstraintsHint =>
      'Duração curta, sem viagens planares, chefe final obrigatório...';

  @override
  String get forgeNarrativeSectionTitle => 'Pressão narrativa';

  @override
  String get forgeNarrativeSectionSubtitle =>
      'Ganchos extra, facções e restrições para personalizar o pergaminho.';

  @override
  String get forgeNarrativePanelTitle => 'História e forças em jogo';

  @override
  String get forgeNarrativeHooksLabel => 'Ganchos narrativos';

  @override
  String get forgeNarrativeHooksHint =>
      'Missão inicial, ameaça, mistério, contagem decrescente...';

  @override
  String get forgeFactionsLabel => 'Facções e poderes';

  @override
  String get forgeFactionsHint =>
      'Guildas, cultos, casas nobres, antagonistas, aliados instáveis...';

  @override
  String get forgeNpcFocusLabel => 'PNJs-chave';

  @override
  String get forgeNpcFocusHint => 'Mentor ambíguo, rival, patrono, traidor...';

  @override
  String get forgeEncounterFocusLabel => 'Encontros desejados';

  @override
  String get forgeEncounterFocusHint =>
      'Cerco, investigação social, perseguição, chefe final...';

  @override
  String get forgeContentConstraintsTitle => 'Restrições de conteúdo';

  @override
  String get forgeIncludeNpcsLabel => 'Incluir PNJs';

  @override
  String get forgeIncludeNpcsSubtitle => 'O prompt incluirá PNJs relevantes.';

  @override
  String get forgeIncludeEncountersLabel => 'Incluir encontros';

  @override
  String get forgeIncludeEncountersSubtitle =>
      'O prompt sugerirá cenas e combates.';

  @override
  String get forgeSafetyNotesLabel => 'Notas de segurança';

  @override
  String get forgeSafetyNotesHint =>
      'Tópicos a evitar, linhas e véus, limites de tom...';

  @override
  String get forgeParchmentDirty => 'Configuração alterada: regenera.';

  @override
  String get forgeParchmentReady => 'Pergaminho atualizado.';

  @override
  String get forgeParchmentIncomplete => 'Conclui a história para gerar.';

  @override
  String get statusReady => 'Pronto';

  @override
  String get statusNeedsPolish => 'Precisa de polimento';

  @override
  String get parchmentReadyTitle => 'Pergaminho pronto';

  @override
  String get parchmentReadySubtitleStale =>
      'Alteraste a forja: o prompt copiado já não está atualizado.';

  @override
  String get parchmentReadySubtitleAligned =>
      'O prompt copiado está alinhado com o estado atual da forja.';

  @override
  String get parchmentQuickActionsTitle => 'Ações rápidas';

  @override
  String get parchmentCopyPromptTitle => 'Copiar prompt';

  @override
  String get parchmentCopyPromptSubtitle =>
      'Envia o prompt para a área de transferência.';

  @override
  String get parchmentShareTitle => 'Partilhar';

  @override
  String get parchmentShareSubtitle => 'Abre o menu de partilha.';

  @override
  String get parchmentOpenChatGptTitle => 'Abrir no ChatGPT';

  @override
  String get parchmentOpenChatGptSubtitle =>
      'Abre o ChatGPT num novo separador.';

  @override
  String get parchmentDraftUpdatedTitle => 'Rascunho atualizado';

  @override
  String get parchmentSaveDraftTitle => 'Guardar rascunho';

  @override
  String get parchmentSaveDraftSubtitle =>
      'Guarda o prompt localmente para mais tarde.';

  @override
  String get parchmentPromptCopied => 'Prompt copiado';

  @override
  String get parchmentCopiedStaleBanner =>
      'Alteraste a forja após a última geração. Regenera para atualizar o prompt copiado.';

  @override
  String get parchmentCopiedSuccessBody =>
      'O pergaminho foi forjado com sucesso. Usa os rituais à direita para o partilhar, guardar ou abrir no ChatGPT.';

  @override
  String get atmosphereOneShot => 'Urgência carmesim';

  @override
  String get atmosphereMiniCampaign => 'Estrada dourada';

  @override
  String get atmosphereLongCampaign => 'Atlas verde';

  @override
  String get atmosphereDungeon => 'Cofre da tocha';

  @override
  String get parchmentSeal => 'SELO';

  @override
  String get parchmentSealAndCopy => 'Selar e copiar';

  @override
  String get infoDialogLine1 =>
      'Esta app é um gerador de prompts inspirado em jogos de interpretação de fantasia.';

  @override
  String get infoDialogLine2 =>
      'Não está afiliada a Dungeons & Dragons nem a qualquer ferramenta de IA.';

  @override
  String get infoDialogLine3 =>
      'Podes usar os prompts com ferramentas de IA para criares as tuas próprias histórias.';

  @override
  String get settingsTitle => 'Definições';

  @override
  String get settingsLeaveReview => 'Deixar uma avaliação';

  @override
  String get settingsShareApp => 'Partilhar a app';

  @override
  String get settingsShareText =>
      'Descobre o Campaign Forge, o gerador de campanhas de D&D: ';

  @override
  String get settingsLanguageLabel => 'Idioma';

  @override
  String get settingsLanguageEnglish => 'Inglês';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsThemeLabel => 'Tema';

  @override
  String get settingsThemeDark => 'Escuro';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsInfoLabel => 'Info';

  @override
  String get settingsVersion => 'Versão';

  @override
  String get settingsGoAdFree => 'Anúncios';

  @override
  String get settingsGoAdFreePrice => 'Desbloquear Premium';

  @override
  String get settingsGoAdFreeSubtitle => 'Compra única · £1.99';

  @override
  String settingsGoAdFreeSubtitleWithAmount(String price) {
    return 'Compra única · $price';
  }

  @override
  String settingsGoAdFreePriceWithAmount(String price) {
    return 'Desbloquear Premium — $price';
  }

  @override
  String get settingsRestorePurchases => 'Restaurar compras';

  @override
  String get settingsRestorePurchasesStarted => 'A restaurar compras…';

  @override
  String get settingsRestorePurchasesComplete =>
      'Compras restauradas com sucesso.';

  @override
  String get settingsAdFreeActive => 'Anúncios removidos';

  @override
  String get settingsIapUnavailable =>
      'Compras dentro da app indisponíveis neste dispositivo.';

  @override
  String get settingsIapProductNotFound =>
      'Produto não encontrado. Tenta novamente mais tarde.';

  @override
  String get settingsPurchasePending => 'Compra em processamento…';

  @override
  String get settingsPurchaseCancelled => 'Compra cancelada.';

  @override
  String get settingsPurchaseFailed =>
      'A compra falhou. Por favor, tenta novamente.';

  @override
  String get helpTitle => 'Guia';

  @override
  String get helpCampaignTypesTitle => 'Tipos de campanha';

  @override
  String get helpCampaignTypeOneShotTitle => 'One-Shot';

  @override
  String get helpCampaignTypeOneShotBody =>
      'Uma aventura completa pensada para uma única sessão, com uma abertura forte, um objetivo claro e um desfecho rápido. Escolhe-a quando quiseres impulso imediato e um arco apertado.';

  @override
  String get helpCampaignTypeMiniCampaignTitle => 'Mini-campanha';

  @override
  String get helpCampaignTypeMiniCampaignBody =>
      'Um arco curto que se desenrola ao longo de algumas sessões, deixando espaço para escalada e um final mais marcante. Ideal quando queres algo compacto, mas menos comprimido do que um One-Shot.';

  @override
  String get helpCampaignTypeLongCampaignTitle => 'Campanha longa';

  @override
  String get helpCampaignTypeLongCampaignBody =>
      'Uma estrutura alargada com facções, subtramas e consequências que se desenvolvem ao longo do tempo. Ideal se quiseres continuidade, progressão e um mundo que reage às escolhas dos jogadores.';

  @override
  String get helpCampaignTypeDungeonTitle => 'Exploração de masmorra';

  @override
  String get helpCampaignTypeDungeonBody =>
      'Uma campanha focada em mapas, descoberta, desgaste e segredos escondidos em lugares perigosos. Perfeita quando queres pressão, exploração e um forte sentido de lugar.';

  @override
  String get helpTipsTitle => 'Dicas e boas práticas';

  @override
  String get helpTipWorld =>
      'Começa pela ambientação e pelo tema: são as restrições que mantêm tudo coerente.';

  @override
  String get helpTipTheme =>
      'Usa 1 ou 2 temas fortes em vez de acumulares demasiadas ideias semelhantes.';

  @override
  String get helpTipTwist =>
      'Escolhe uma reviravolta para dar tensão imediata ao enredo.';

  @override
  String get helpTipContrast =>
      'Experimenta combinar tons contrastantes para obter prompts menos previsíveis.';

  @override
  String get helpTipPreset =>
      'Usa predefinições quando quiseres inspiração rápida ou um ponto de partida forte.';

  @override
  String get helpTipCustom =>
      'Adiciona entradas personalizadas apenas quando a opção exata de que precisas ainda não existir.';

  @override
  String get helpTipParty =>
      'Mantém o nível, o tamanho do grupo e os arquétipos alinhados para evitar prompts desequilibrados.';
}
