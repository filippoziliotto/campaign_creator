// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Creador de Campañas D&D';

  @override
  String get appNameShort => 'Creador de Campañas';

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
  String get commonRetry => 'Reintentar';

  @override
  String get commonOpen => 'Abrir';

  @override
  String get commonOptional => 'Opcional';

  @override
  String get appFreeFormat => 'Elige formato';

  @override
  String get appSettingPending => 'Ambientación por definir';

  @override
  String get appTwistPending => 'Giro por definir';

  @override
  String get appStageEntry => 'Elección';

  @override
  String get appStageForge => 'Forja';

  @override
  String get appStageParchment => 'Pergamino';

  @override
  String get appOpenParchment => 'Abrir pergamino';

  @override
  String get appSealParchment => 'Sellar pergamino';

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
      'Pergamino forjado y prompt copiado al portapapeles.';

  @override
  String get appSnackGenerationFailed =>
      'La generación ha fallado. Revisa el mensaje en pantalla.';

  @override
  String get appSnackPromptCopied => 'Prompt copiado al portapapeles.';

  @override
  String get appSnackNoParchmentToShare =>
      'Todavía no hay ningún pergamino para compartir.';

  @override
  String get appSnackShareUnavailableOnDevice =>
      'La función de compartir no está disponible en este dispositivo.';

  @override
  String appSnackShareUnavailable(String error) {
    return 'Compartir no disponible: $error';
  }

  @override
  String get appSnackGenerateFirst =>
      'Genera primero un pergamino antes de enviarlo.';

  @override
  String get appSnackChatGptOpened =>
      'ChatGPT se abrió. El prompt ya está en el portapapeles.';

  @override
  String get appSnackChatGptCopiedOnly =>
      'No se pudo abrir ChatGPT, pero el prompt se copió.';

  @override
  String get appSnackPremiumUnlockedTemporary =>
      'Premium desbloqueado durante 5 minutos';

  @override
  String get appSnackNoParchmentToSave => 'There is no parchment to save.';

  @override
  String get appSnackDraftSaved =>
      'Borrador del pergamino guardado localmente.';

  @override
  String get appSnackDraftMemoryOnly =>
      'Borrador guardado solo en memoria. Reinicia completamente la app para activar la persistencia local.';

  @override
  String get appSnackSealedSavedAndCopied =>
      'Pergamino sellado: borrador guardado y prompt copiado.';

  @override
  String get appSnackSealedCopiedOnlyMemory =>
      'Pergamino sellado: prompt copiado. Reinicia completamente la app para activar el guardado local.';

  @override
  String get appSnackLocalSaveUnavailable =>
      'Local saving is unavailable in this session. Close and relaunch the app to register the plugin.';

  @override
  String get appDraftMemoryOnly =>
      'Borrador mantenido solo en memoria. Reinicia completamente la app para reactivar el guardado local.';

  @override
  String appDraftAligned(String dateTime) {
    return 'Borrador local sincronizado el $dateTime.';
  }

  @override
  String appDraftLastSaved(String dateTime) {
    return 'Último borrador guardado el $dateTime.';
  }

  @override
  String get appErrorEyebrow => 'Ritual interrumpido';

  @override
  String get appErrorTitle => 'El grimorio no responde';

  @override
  String get appErrorUnknownLoad => 'Error desconocido al cargar las opciones.';

  @override
  String get entryCampaignTypesTitle => 'Tipos de campaña';

  @override
  String get entryResumeTitle => 'Reanudar sesión';

  @override
  String get entryResumeSubtitle =>
      'Ya tienes un borrador activo. Vuelve al punto correcto.';

  @override
  String get entryResumeForge => 'Reanudar forja';

  @override
  String get entryOpenForge => 'Abrir forja';

  @override
  String get entryHeroWelcomeTitle => 'Elige tu campaña';

  @override
  String get entryHeroWelcomeBody =>
      'Forja el prompt de tu campaña y luego llévalo a la vida con tu IA de confianza.';

  @override
  String get entryHeroChooseRitual => 'Selecciona un formato para empezar.';

  @override
  String get entryResetDraft => 'Nueva sesión';

  @override
  String get entryResetDraftConfirm => 'Borrador eliminado.';

  @override
  String get entryBadgeDefault => 'Formato';

  @override
  String get entryDescriptionDefault =>
      'Formato de campaña listo en el dispositivo.';

  @override
  String get entryBadgeOneShot => 'Rápida';

  @override
  String get entryDescriptionOneShot =>
      'Una misión de alto impacto pensada para una sola sesión, con recompensa inmediata y un giro preciso.';

  @override
  String get entryBadgeMiniCampaign => 'Arco breve';

  @override
  String get entryDescriptionMiniCampaign =>
      'Una historia condensada en pocas sesiones, con progresión fuerte, escalada y un final nítido.';

  @override
  String get entryBadgeLongCampaign => 'Saga amplia';

  @override
  String get entryDescriptionLongCampaign =>
      'Facciones, equilibrios cambiantes y subtramas persistentes para una campaña que crece con el tiempo.';

  @override
  String get entryBadgeDungeon => 'Profundidades';

  @override
  String get entryDescriptionDungeon =>
      'Un descenso estructurado entre mapas, riesgo, desgaste y descubrimientos por capas.';

  @override
  String get forgeSectionWorld => 'Mundo';

  @override
  String get forgeSectionParty => 'Grupo';

  @override
  String get forgeSectionNarrative => 'Historia';

  @override
  String get forgeButtonForging => 'Forjando...';

  @override
  String get forgeNextParty => 'Ir al Grupo';

  @override
  String get forgeNextNarrative => 'Ir a la Historia';

  @override
  String get forgeReforgeParchment => 'Reforjar pergamino';

  @override
  String get forgeForgeParchment => 'Forjar pergamino';

  @override
  String get forgeReforgeParchmentCompact => 'Reforjar pergamino';

  @override
  String get forgeForgeParchmentCompact => 'Forjar pergamino';

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
  String get forgeWorldSectionTitle => 'Construcción del mundo';

  @override
  String get forgeWorldSectionSubtitle =>
      'Formato, ambientación y señales iniciales de la campaña.';

  @override
  String get forgeFoundationLabel => 'Fundación';

  @override
  String get forgeFoundationTitle => 'Configuración base';

  @override
  String get forgeFoundationSubtitle => 'Ambientación y escenario.';

  @override
  String get forgePresetSectionTitle => 'Elegir preset';

  @override
  String get forgePresetSectionSubtitle =>
      'Aplica un preset para configurar rápidamente tu campaña.';

  @override
  String get forgePresetPanelLabel => 'Presets';

  @override
  String get forgePresetPanelTitle => 'Quick presets';

  @override
  String get forgeQuickPresetLabel => 'Quick preset';

  @override
  String get forgeNoPresetSelected => 'Sin preset';

  @override
  String get forgeApplyPreset => 'Forjar con preset';

  @override
  String get forgeApply => 'Forjar con preset';

  @override
  String get forgeSettingLabel => 'Ambientación';

  @override
  String get forgeCustomSettingLabel => 'Ambientación personalizada';

  @override
  String get forgeCustomSettingHint =>
      'P. ej. reino en guerra, ciudad vertical';

  @override
  String get forgeTwistTitle => 'Giro inicial';

  @override
  String get forgeTwistLabel => 'Giro';

  @override
  String get forgeCustomTwistLabel => 'Giro personalizado';

  @override
  String get forgeCustomTwistHint =>
      'Un aliado miente, la mazmorra está viva, la misión es una trampa...';

  @override
  String get forgeCreativeTitle => 'Temas, tono y estilo';

  @override
  String get forgeThemesTitle => 'Temas';

  @override
  String get forgeCustomThemesLabel => 'Temas personalizados';

  @override
  String get forgeCustomThemesHint => 'P. ej. steampunk, horror cósmico';

  @override
  String get forgeToneTitle => 'Tono';

  @override
  String get forgeStyleTitle => 'Estilo';

  @override
  String get forgeToneStyleOverrideLabel => 'Tonos y estilo personalizados';

  @override
  String get forgeToneStyleOverrideHint =>
      'P. ej. Tono: sombrío; Estilo: crudo';

  @override
  String get forgePartySectionTitle => 'Grupo y escala de juego';

  @override
  String get forgePartySectionSubtitle =>
      'Nivel, tamaño y roles principales del grupo.';

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
  String get forgePartyLevelPremiumHint => 'Los niveles 4+ son premium';

  @override
  String get forgePartySizePremiumHint => '5+ personajes son premium';

  @override
  String get forgePartyArchetypesTitle => 'Arquetipos del grupo';

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
  String get forgeCharacterNotesLabel => 'Notas de personaje';

  @override
  String get forgeCharacterNotesHint =>
      'Secrets, bonds, fears, important backstory...';

  @override
  String get forgeConstraintsLabel => 'Restricciones';

  @override
  String get forgeConstraintsHint =>
      'Short duration, no planar travel, mandatory final boss...';

  @override
  String get forgeNarrativeSectionTitle => 'Presión narrativa';

  @override
  String get forgeNarrativeSectionSubtitle =>
      'Ganchos, facciones y restricciones extra para personalizar el pergamino.';

  @override
  String get forgeNarrativePanelTitle => 'Story and forces in play';

  @override
  String get forgeNarrativeHooksLabel => 'Ganchos narrativos';

  @override
  String get forgeNarrativeHooksHint =>
      'Opening mission, threat, mystery, countdown...';

  @override
  String get forgeFactionsLabel => 'Facciones y poderes';

  @override
  String get forgeFactionsHint =>
      'Guilds, cults, noble houses, antagonists, unstable allies...';

  @override
  String get forgeNpcFocusLabel => 'PNJ clave';

  @override
  String get forgeNpcFocusHint => 'Ambiguous mentor, rival, patron, traitor...';

  @override
  String get forgeEncounterFocusLabel => 'Encuentros deseados';

  @override
  String get forgeEncounterFocusHint =>
      'Siege, social investigation, chase, final boss...';

  @override
  String get forgeContentConstraintsTitle => 'Restricciones de contenido';

  @override
  String get forgeIncludeNpcsLabel => 'Incluir PNJ';

  @override
  String get forgeIncludeNpcsSubtitle =>
      'El prompt incluirá personajes no jugadores relevantes.';

  @override
  String get forgeIncludeEncountersLabel => 'Incluir encuentros';

  @override
  String get forgeIncludeEncountersSubtitle =>
      'El prompt sugerirá escenas y combates.';

  @override
  String get forgeSafetyNotesLabel => 'Notas de seguridad';

  @override
  String get forgeSafetyNotesHint =>
      'Temas a evitar, líneas y velos, límites de tono...';

  @override
  String get forgeParchmentDirty =>
      'La configuración cambió: vuelve a generar.';

  @override
  String get forgeParchmentReady => 'Pergamino actualizado.';

  @override
  String get forgeParchmentIncomplete => 'Completa la historia para generar.';

  @override
  String get statusReady => 'Listo';

  @override
  String get statusNeedsPolish => 'Necesita pulido';

  @override
  String get parchmentReadyTitle => 'Pergamino listo';

  @override
  String get parchmentReadySubtitleStale =>
      'Has cambiado la forja: el prompt copiado ya no está actualizado.';

  @override
  String get parchmentReadySubtitleAligned =>
      'El prompt copiado está sincronizado con el estado actual de la forja.';

  @override
  String get parchmentQuickActionsTitle => 'Acciones rápidas';

  @override
  String get parchmentCopyPromptTitle => 'Copiar prompt';

  @override
  String get parchmentCopyPromptSubtitle => 'Envía el prompt al portapapeles.';

  @override
  String get parchmentShareTitle => 'Compartir';

  @override
  String get parchmentShareSubtitle => 'Abre el menú de compartir.';

  @override
  String get parchmentOpenChatGptTitle => 'Abrir en ChatGPT';

  @override
  String get parchmentOpenChatGptSubtitle =>
      'Abre ChatGPT en una nueva pestaña.';

  @override
  String get parchmentDraftUpdatedTitle => 'Borrador actualizado';

  @override
  String get parchmentSaveDraftTitle => 'Guardar borrador';

  @override
  String get parchmentSaveDraftSubtitle =>
      'Guarda el prompt localmente para usarlo más tarde.';

  @override
  String get parchmentPromptCopied => 'Prompt copiado';

  @override
  String get parchmentCopiedStaleBanner =>
      'Has cambiado la forja después de la última generación. Vuelve a generar para actualizar el prompt copiado.';

  @override
  String get parchmentCopiedSuccessBody =>
      'El pergamino se ha forjado correctamente. Usa los rituales de la derecha para compartirlo, guardarlo o abrirlo en ChatGPT.';

  @override
  String get atmosphereOneShot => 'Urgencia carmesí';

  @override
  String get atmosphereMiniCampaign => 'Camino dorado';

  @override
  String get atmosphereLongCampaign => 'Atlas verde';

  @override
  String get atmosphereDungeon => 'Bóveda de antorchas';

  @override
  String get parchmentSeal => 'SELLAR';

  @override
  String get parchmentSealAndCopy => 'Sellar y copiar';

  @override
  String get infoDialogLine1 =>
      'Esta app es un generador de prompts inspirado en los juegos de rol de fantasía.';

  @override
  String get infoDialogLine2 =>
      'No está afiliada a Dungeons & Dragons ni a ninguna herramienta de IA.';

  @override
  String get infoDialogLine3 =>
      'Puedes usar los prompts con herramientas de IA para crear tus propias historias.';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsLeaveReview => 'Dejar una reseña';

  @override
  String get settingsShareApp => 'Compartir la app';

  @override
  String get settingsShareText =>
      'Descubre Campaign Forge, el generador de campañas de D&D: ';

  @override
  String get settingsLanguageLabel => 'Idioma';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsThemeLabel => 'Tema';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsInfoLabel => 'Info';

  @override
  String get settingsVersion => 'Versión';

  @override
  String get settingsGoAdFree => 'Anuncios';

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
    return 'Desbloquear premium — $price';
  }

  @override
  String get settingsRestorePurchases => 'Restaurar compras';

  @override
  String get settingsRestorePurchasesStarted => 'Restaurando compras…';

  @override
  String get settingsRestorePurchasesComplete =>
      'Compras restauradas correctamente.';

  @override
  String get settingsAdFreeActive => 'Anuncios eliminados';

  @override
  String get settingsIapUnavailable =>
      'Las compras integradas no están disponibles en este dispositivo.';

  @override
  String get settingsIapProductNotFound =>
      'Producto no encontrado. Vuelve a intentarlo más tarde.';

  @override
  String get settingsPurchasePending => 'Procesando compra…';

  @override
  String get settingsPurchaseCancelled => 'Compra cancelada.';

  @override
  String get settingsPurchaseFailed =>
      'La compra ha fallado. Inténtalo de nuevo.';

  @override
  String get premiumUnlockTitle => 'Función premium';

  @override
  String get premiumUnlockBodyWithAd =>
      'Mira un anuncio para desbloquear todas las funciones premium durante 5 minutos, o desbloquea Premium para acceder a todo de forma permanente.';

  @override
  String get premiumUnlockBodyNoAd =>
      'Desbloquea Premium para acceder a esta función de forma permanente.';

  @override
  String get premiumUnlockWatchAd => 'Ver anuncio (5 min)';

  @override
  String get helpTitle => 'Guía';

  @override
  String get helpCampaignTypesTitle => 'Tipos de campaña';

  @override
  String get helpCampaignTypeOneShotTitle => 'One-Shot';

  @override
  String get helpCampaignTypeOneShotBody =>
      'Una aventura completa pensada para una sola sesión, con inicio fuerte, objetivo claro y cierre rápido. Elígela cuando quieras ritmo alto y recompensa inmediata.';

  @override
  String get helpCampaignTypeMiniCampaignTitle => 'Mini-campaña';

  @override
  String get helpCampaignTypeMiniCampaignBody =>
      'Un arco corto que se desarrolla en pocas sesiones, con espacio para escalar y cerrar con más fuerza. Ideal si quieres algo compacto pero menos comprimido que un one-shot.';

  @override
  String get helpCampaignTypeLongCampaignTitle => 'Campaña larga';

  @override
  String get helpCampaignTypeLongCampaignBody =>
      'Una estructura amplia con facciones, subtramas y consecuencias que crecen con el tiempo. Perfecta si quieres continuidad, progresión y un mundo que responda a las decisiones del grupo.';

  @override
  String get helpCampaignTypeDungeonTitle => 'Exploración de mazmorras';

  @override
  String get helpCampaignTypeDungeonBody =>
      'Una campaña centrada en mapas, descubrimiento, desgaste y secretos ocultos en lugares peligrosos. Funciona muy bien si buscas presión, exploración y un lugar con identidad fuerte.';

  @override
  String get helpTipsTitle => 'Consejos y buenas prácticas';

  @override
  String get helpTipWorld =>
      'Empieza por la ambientación y el tema: son los límites que dan coherencia al resto.';

  @override
  String get helpTipTheme =>
      'Usa 1 o 2 temas fuertes en vez de acumular demasiadas ideas parecidas.';

  @override
  String get helpTipTwist =>
      'Elige un giro para dar tensión inmediata a la trama.';

  @override
  String get helpTipContrast =>
      'Prueba a combinar tonos en contraste para obtener prompts menos previsibles.';

  @override
  String get helpTipPreset =>
      'Usa los presets cuando quieras inspiración rápida o una base sólida desde la que partir.';

  @override
  String get helpTipCustom =>
      'Añade entradas personalizadas solo cuando la opción exacta que necesitas no exista ya.';

  @override
  String get helpTipParty =>
      'Mantén alineados nivel, tamaño del grupo y arquetipos para evitar prompts desequilibrados.';
}
