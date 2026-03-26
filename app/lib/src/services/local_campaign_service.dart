import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

import '../models/campaign_models.dart';
import 'campaign_service.dart';

class LocalCampaignService implements CampaignService {
  @override
  Future<CampaignOptions> getOptions({String localeCode = 'it'}) async {
    final resolvedLocale = _resolveLocaleCode(localeCode);
    final raw =
        await rootBundle.loadString('assets/data/options_$resolvedLocale.yaml');
    return CampaignOptions.fromYaml(loadYaml(raw) as YamlMap);
  }

  @override
  Future<String> generatePrompt(CampaignGenerateRequest req) async {
    if (req.partyArchetypes.length > req.partySize) {
      throw ArgumentError(
        'Party archetypes (${req.partyArchetypes.length}) exceed party size (${req.partySize}).',
      );
    }

    final ctx = _buildContext(req);
    final templateAsset = _selectTemplate(req.campaignType, req.localeCode);
    final rawTemplate =
        await rootBundle.loadString('assets/templates/$templateAsset');
    final rendered = _render(rawTemplate, ctx);
    return _postProcess(rendered);
  }

  static String _resolveLocaleCode(String localeCode) {
    switch (localeCode.trim().toLowerCase()) {
      case 'it':
      case 'it-it':
        return 'it';
      case 'es':
      case 'es-es':
        return 'es';
      case 'fr':
      case 'fr-fr':
        return 'fr';
      case 'en':
      case 'en-us':
      case 'en-gb':
      default:
        return 'en';
    }
  }

  static const _templateFamilyByCampaignType = <String, String>{
    'one-shot': 'one_shot',
    'one shot': 'one_shot',
    'avventura singola': 'one_shot',
    'mini-campagna': 'mini_campaign',
    'mini campagna': 'mini_campaign',
    'mini-campaign': 'mini_campaign',
    'mini campaign': 'mini_campaign',
    'mini-campaña': 'mini_campaign',
    'mini campaña': 'mini_campaign',
    'mini-campagne': 'mini_campaign',
    'mini campagne': 'mini_campaign',
    'campagna lunga': 'long_campaign',
    'long campaign': 'long_campaign',
    'campaña larga': 'long_campaign',
    'campana larga': 'long_campaign',
    'longue campagne': 'long_campaign',
    'esplorazione dungeon': 'dungeon_exploration',
    'dungeon crawl': 'dungeon_exploration',
    'exploración de mazmorra': 'dungeon_exploration',
    'exploracion de mazmorra': 'dungeon_exploration',
    'exploration de donjon': 'dungeon_exploration',
  };

  static const _templatePathByFamily = <String, String>{
    'generic': 'prompt_template',
    'one_shot': 'prompt_template_one_shot',
    'mini_campaign': 'prompt_template_mini_campaign',
    'long_campaign': 'prompt_template_long_campaign',
    'dungeon_exploration': 'prompt_template_dungeon_exploration',
  };

  static const _gothicHorrorValues = <String>{
    'horror gotico',
    'gothic horror',
    'horror gótico',
    'horreur gothique',
  };

  static const _darkToneValues = <String>{
    'cupo',
    'dark',
    'sombrío',
    'sombrio',
    'sombre',
  };

  static const _noTwistValues = <String>{
    '',
    'nessun colpo di scena',
    'nessun twist',
    'no twist',
    'no twist requested',
    'none',
    'sin giro',
    'sin giro argumental',
    'sans rebondissement',
  };

  static const Map<String, _PromptLocaleBundle> _bundles =
      <String, _PromptLocaleBundle>{
    'it': _PromptLocaleBundle(
      languageLabel: 'Italiano',
      themeFallback: 'Nessuna preferenza forte (mix libero).',
      toneFallback: 'Nessuna preferenza forte (mix libero).',
      styleFallback: 'Nessuna preferenza forte (mix libero).',
      defaultStructure:
          'Progetta una campagna modulare con inizio forte, escalation e payoff finale.',
      partyArchetypesFallback: "Non specificata dall'utente.",
      noTwistReference: 'il punto di svolta principale',
      twistReferencePattern: 'il twist "{twist}"',
      npcInstructionsEnabled:
          'Definisci almeno 5 PNG con obiettivi, segreti e voce distintiva.',
      npcInstructionsDisabled:
          'PNG opzionali: usa solo i necessari alla trama principale.',
      encounterInstructionsEnabled:
          'Includi 3-5 incontri significativi con obiettivo narrativo, non solo tattico.',
      encounterInstructionsDisabled:
          'Riduci gli incontri da combattimento e spingi su investigazione/sociale.',
      missingPartyComposition:
          'Se la composizione del party manca, proponi una combinazione coerente di classi e ruoli per i PG.',
      missingNarrativeHooks:
          'Se i ganci narrativi mancano, proponi 3 agganci iniziali alternativi.',
      missingCharacterNotes:
          'Se mancano note personaggi, crea legami plausibili tra i PG e il mondo.',
      missingFactions:
          'Se mancano fazioni, proponi 2-3 fazioni coerenti con ambientazione e conflitto centrale.',
      missingNpcFocus:
          'Se manca un focus PNG, varia i PNG tra alleati, rivali e neutrali ambigui.',
      missingEncounterFocus:
          'Se manca un focus incontri, bilancia scene sociali, esplorazione e combattimento in base al ritmo della campagna.',
      missingSafetyNotes:
          'Se mancano note di safety, evita contenuti sensibili non richiesti e resta entro limiti impliciti ragionevoli.',
      missingTwist:
          'Costruisci la storia attorno a un reveal forte, una svolta o un punto di escalation.',
      qualityRules: <String>[
        'Rispetta gli input selezionati. Non sostituire ambientazione, temi, tono o stile con alternative più facili.',
        'Se due input sono in tensione, risolvili creativamente senza ignorarne nessuno.',
        'Evita placeholder fantasy generici se non vengono resi specifici con dettagli concreti.',
        'Ogni PNG, fazione, luogo e incontro deve avere almeno un tratto distintivo memorabile e usabile al tavolo.',
        'Preferisci conseguenze percepibili al tavolo rispetto a lore astratto o backstory che non entra mai in gioco.',
      ],
      horrorConstraint:
          "Mantieni l'orrore atmosferico; evita gore esplicito e descrizioni splatter.",
      agencyConstraint:
          "Mantieni l'agenzia dei personaggi: evita scene inevitabili senza scelta significativa.",
      noConstraintsProvided: "Nessun vincolo extra fornito dall'utente.",
      structureRulesByFamily: <String, String>{
        'one_shot':
            'Progetta una struttura in 3 atti: apertura, sviluppo, climax+epilogo. Includi una timeline orientativa da 1 sessione.',
        'mini_campaign':
            'Progetta un arco da 4-6 sessioni con progressione chiara delle poste in gioco, rivelazioni intermedie e finale ad alto impatto.',
        'long_campaign':
            'Progetta un arco da 10+ sessioni con sottotrame, evoluzione dei PNG chiave, fazioni e conseguenze persistenti delle scelte del party.',
        'dungeon_exploration':
            'Progetta una campagna centrata su esplorazione a livelli, gestione risorse, trappole, scoperte e ritorni strategici in superficie.',
      },
    ),
    'en': _PromptLocaleBundle(
      languageLabel: 'English',
      themeFallback: 'No strong preference (free mix).',
      toneFallback: 'No strong preference (free mix).',
      styleFallback: 'No strong preference (free mix).',
      defaultStructure:
          'Design a modular campaign with a strong opening, escalation, and final payoff.',
      partyArchetypesFallback: 'Not specified by the user.',
      noTwistReference: 'the main turning point',
      twistReferencePattern: 'the twist "{twist}"',
      npcInstructionsEnabled:
          'Define at least 5 NPCs with goals, secrets, and a distinct voice.',
      npcInstructionsDisabled:
          'NPCs are optional: use only those necessary for the main plot.',
      encounterInstructionsEnabled:
          'Include 3-5 meaningful encounters with a narrative goal, not only a tactical one.',
      encounterInstructionsDisabled:
          'Reduce combat encounters and lean more on investigation and social play.',
      missingPartyComposition:
          'If party composition is missing, propose a coherent combination of PC classes and roles.',
      missingNarrativeHooks:
          'If narrative hooks are missing, propose 3 alternative opening hooks.',
      missingCharacterNotes:
          'If character notes are missing, create plausible ties between the PCs and the world.',
      missingFactions:
          'If factions are missing, propose 2-3 factions coherent with the setting and central conflict.',
      missingNpcFocus:
          'If NPC focus is missing, vary NPCs between allies, rivals, and ambiguous neutrals.',
      missingEncounterFocus:
          'If encounter focus is missing, balance social, exploration, and combat scenes according to the campaign rhythm.',
      missingSafetyNotes:
          'If safety notes are missing, avoid unrequested sensitive content and stay within reasonable implied boundaries.',
      missingTwist:
          'Build around a strong reveal, reversal, or escalation pivot.',
      qualityRules: <String>[
        'Respect the selected inputs. Do not replace setting, themes, tone, or style with easier alternatives.',
        'If two inputs are in tension, resolve them creatively without ignoring either one.',
        'Avoid generic fantasy placeholders unless they are made specific through concrete detail.',
        'Every NPC, faction, location, and encounter must have at least one memorable and table-usable differentiator.',
        'Prefer visible table consequences over abstract lore or backstory that never enters play.',
      ],
      horrorConstraint:
          'Keep the horror atmospheric; avoid explicit gore and splatter descriptions.',
      agencyConstraint:
          'Preserve player agency: avoid inevitable scenes with no meaningful choice.',
      noConstraintsProvided: 'No extra constraints provided by the user.',
      structureRulesByFamily: <String, String>{
        'one_shot':
            'Design a 3-act structure: opening, development, climax plus epilogue. Include an approximate timeline for 1 session.',
        'mini_campaign':
            'Design a 4-6 session arc with clear escalation of stakes, mid-arc reveals, and a high-impact ending.',
        'long_campaign':
            'Design a 10+ session arc with subplots, evolving key NPCs, factions, and lasting consequences for party choices.',
        'dungeon_exploration':
            'Design a campaign centered on multi-level exploration, resource management, traps, discoveries, and strategic returns to the surface.',
      },
    ),
    'es': _PromptLocaleBundle(
      languageLabel: 'Español',
      themeFallback: 'Sin una preferencia fuerte (mezcla libre).',
      toneFallback: 'Sin una preferencia fuerte (mezcla libre).',
      styleFallback: 'Sin una preferencia fuerte (mezcla libre).',
      defaultStructure:
          'Diseña una campaña modular con una apertura fuerte, escalada y un desenlace final contundente.',
      partyArchetypesFallback: 'No especificada por el usuario.',
      noTwistReference: 'el punto de giro principal',
      twistReferencePattern: 'el giro "{twist}"',
      npcInstructionsEnabled:
          'Define al menos 5 PNJ con objetivos, secretos y una voz distintiva.',
      npcInstructionsDisabled:
          'Los PNJ son opcionales: usa solo los necesarios para la trama principal.',
      encounterInstructionsEnabled:
          'Incluye de 3 a 5 encuentros significativos con un objetivo narrativo, no solo táctico.',
      encounterInstructionsDisabled:
          'Reduce los encuentros de combate y apóyate más en la investigación y el juego social.',
      missingPartyComposition:
          'Si falta la composición del grupo, propón una combinación coherente de clases y roles de PJ.',
      missingNarrativeHooks:
          'Si faltan los ganchos narrativos, propón 3 aperturas alternativas.',
      missingCharacterNotes:
          'Si faltan las notas de personaje, crea lazos plausibles entre los PJ y el mundo.',
      missingFactions:
          'Si faltan facciones, propón de 2 a 3 facciones coherentes con el entorno y el conflicto central.',
      missingNpcFocus:
          'Si falta el foco en PNJ, alterna PNJ entre aliados, rivales y neutrales ambiguos.',
      missingEncounterFocus:
          'Si falta el foco de encuentros, equilibra escenas sociales, exploración y combate según el ritmo de la campaña.',
      missingSafetyNotes:
          'Si faltan notas de seguridad, evita contenido sensible no solicitado y mantente dentro de límites razonables implícitos.',
      missingTwist:
          'Construye la historia alrededor de una revelación fuerte, un giro o un punto de escalada.',
      qualityRules: <String>[
        'Respeta las opciones elegidas. No sustituyas ambientación, temas, tono o estilo por alternativas más fáciles.',
        'Si dos entradas están en tensión, resuélvelas con creatividad sin ignorar ninguna.',
        'Evita los marcadores genéricos de fantasía salvo que se vuelvan específicos mediante detalles concretos.',
        'Cada PNJ, facción, localización y encuentro debe tener al menos un rasgo memorable y útil en mesa.',
        'Prefiere consecuencias visibles en mesa antes que trasfondo abstracto o lore que nunca entra en juego.',
      ],
      horrorConstraint:
          'Mantén el horror atmosférico; evita el gore explícito y las descripciones splatter.',
      agencyConstraint:
          'Preserva la agencia de los jugadores: evita escenas inevitables sin elección significativa.',
      noConstraintsProvided:
          'No se proporcionaron restricciones adicionales por parte del usuario.',
      structureRulesByFamily: <String, String>{
        'one_shot':
            'Diseña una estructura en 3 actos: apertura, desarrollo, clímax+epílogo. Incluye una línea temporal aproximada de 1 sesión.',
        'mini_campaign':
            'Diseña un arco de 4-6 sesiones con una escalada clara de las apuestas, revelaciones intermedias y un final de alto impacto.',
        'long_campaign':
            'Diseña un arco de 10+ sesiones con subtramas, evolución de los PNJ clave, facciones y consecuencias persistentes de las decisiones del grupo.',
        'dungeon_exploration':
            'Diseña una campaña centrada en exploración por niveles, gestión de recursos, trampas, descubrimientos y regresos estratégicos a la superficie.',
      },
    ),
    'fr': _PromptLocaleBundle(
      languageLabel: 'Français',
      themeFallback: 'Pas de préférence forte (mélange libre).',
      toneFallback: 'Pas de préférence forte (mélange libre).',
      styleFallback: 'Pas de préférence forte (mélange libre).',
      defaultStructure:
          'Conçois une campagne modulaire avec une ouverture forte, une montée en puissance et un aboutissement final marquant.',
      partyArchetypesFallback: "Non précisée par l'utilisateur.",
      noTwistReference: 'le point de bascule principal',
      twistReferencePattern: 'le rebondissement "{twist}"',
      npcInstructionsEnabled:
          'Définis au moins 5 PNJ avec des objectifs, des secrets et une voix distincte.',
      npcInstructionsDisabled:
          'Les PNJ sont optionnels : utilise seulement ceux qui servent la trame principale.',
      encounterInstructionsEnabled:
          'Inclue 3 à 5 rencontres significatives avec un objectif narratif, pas seulement tactique.',
      encounterInstructionsDisabled:
          "Réduis les rencontres de combat et appuie-toi davantage sur l'enquête et le jeu social.",
      missingPartyComposition:
          "Si la composition du groupe manque, propose une combinaison cohérente de classes et de rôles de PJ.",
      missingNarrativeHooks:
          "Si les accroches narratives manquent, propose 3 ouvertures alternatives.",
      missingCharacterNotes:
          "Si les notes de personnage manquent, crée des liens plausibles entre les PJ et le monde.",
      missingFactions:
          "Si les factions manquent, propose 2 à 3 factions cohérentes avec le cadre et le conflit central.",
      missingNpcFocus:
          'Si le focus PNJ manque, varie les PNJ entre alliés, rivaux et neutres ambigus.',
      missingEncounterFocus:
          "Si le focus sur les rencontres manque, équilibre scènes sociales, exploration et combat selon le rythme de la campagne.",
      missingSafetyNotes:
          'Si les notes de sécurité manquent, évite tout contenu sensible non demandé et reste dans des limites implicites raisonnables.',
      missingTwist:
          "Construis l'histoire autour d'une révélation forte, d'un retournement ou d'un point d'escalade.",
      qualityRules: <String>[
        'Respecte les choix sélectionnés. Ne remplace pas le cadre, les thèmes, le ton ou le style par des alternatives plus faciles.',
        'Si deux entrées sont en tension, résous-les avec créativité sans en ignorer aucune.',
        'Évite les clichés de fantasy génériques sauf s’ils deviennent précis grâce à des détails concrets.',
        'Chaque PNJ, faction, lieu et rencontre doit avoir au moins un trait mémorable et exploitable en jeu.',
        'Privilégie des conséquences visibles en jeu plutôt qu’un lore abstrait ou un passé qui n’entre jamais en scène.',
      ],
      horrorConstraint:
          "Garde l'horreur atmosphérique ; évite le gore explicite et les descriptions splatter.",
      agencyConstraint:
          'Préserve le libre arbitre des joueurs : évite les scènes inévitables sans choix significatif.',
      noConstraintsProvided:
          "Aucune contrainte supplémentaire n'a été fournie par l'utilisateur.",
      structureRulesByFamily: <String, String>{
        'one_shot':
            "Conçois une structure en 3 actes : ouverture, développement, climax+épilogue. Inclue une chronologie approximative d'une session.",
        'mini_campaign':
            'Conçois un arc de 4 à 6 sessions avec une montée claire des enjeux, des révélations intermédiaires et une fin à fort impact.',
        'long_campaign':
            'Conçois un arc de 10+ sessions avec des intrigues secondaires, des PNJ clés en évolution, des factions et des conséquences durables des choix du groupe.',
        'dungeon_exploration':
            "Conçois une campagne centrée sur une exploration à étages, la gestion des ressources, les pièges, les découvertes et les retours stratégiques à la surface.",
      },
    ),
  };

  static String _selectTemplate(String campaignType, String localeCode) {
    final resolvedLocale = _resolveLocaleCode(localeCode);
    final normalized =
        campaignType.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    final family = _templateFamilyByCampaignType[normalized] ?? 'generic';
    final basePath = _templatePathByFamily[family] ?? _templatePathByFamily['generic']!;
    return '${basePath}_$resolvedLocale.md';
  }

  static Map<String, Object> _buildContext(CampaignGenerateRequest req) {
    final localeCode = _resolveLocaleCode(req.localeCode);
    final bundle = _bundles[localeCode] ?? _bundles['en']!;
    final family = _templateFamilyByCampaignType[
            req.campaignType.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ')] ??
        'generic';
    final normalizedTwist = _normalizeTwist(req.twist);
    final hasTwist = normalizedTwist.isNotEmpty;

    final npcInstructions = req.includeNpcs
        ? bundle.npcInstructionsEnabled
        : bundle.npcInstructionsDisabled;
    final encounterInstructions = req.includeEncounters
        ? bundle.encounterInstructionsEnabled
        : bundle.encounterInstructionsDisabled;
    final twistReference = hasTwist
        ? bundle.twistReferencePattern.replaceAll('{twist}', normalizedTwist)
        : bundle.noTwistReference;

    final hasAdditionalUserInputs = req.narrativeHooks.trim().isNotEmpty ||
        req.characterNotes.trim().isNotEmpty ||
        req.factions.trim().isNotEmpty ||
        req.npcFocus.trim().isNotEmpty ||
        req.encounterFocus.trim().isNotEmpty ||
        req.safetyNotes.trim().isNotEmpty;

    final missingInputRules = <String>[
      if (req.partyArchetypes.isEmpty) bundle.missingPartyComposition,
      if (req.narrativeHooks.trim().isEmpty) bundle.missingNarrativeHooks,
      if (req.characterNotes.trim().isEmpty) bundle.missingCharacterNotes,
      if (req.factions.trim().isEmpty) bundle.missingFactions,
      if (req.npcFocus.trim().isEmpty) bundle.missingNpcFocus,
      if (req.encounterFocus.trim().isEmpty) bundle.missingEncounterFocus,
      if (req.safetyNotes.trim().isEmpty) bundle.missingSafetyNotes,
      if (!hasTwist) bundle.missingTwist,
    ];

    final constraints = req.constraints
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final themesLower = req.themePreferences.map((t) => t.toLowerCase()).toSet();
    final tonesLower = req.tonePreferences.map((t) => t.toLowerCase()).toSet();

    if (themesLower.intersection(_gothicHorrorValues).isNotEmpty &&
        !constraints.any((c) => c.toLowerCase().contains('gore'))) {
      constraints.add(bundle.horrorConstraint);
    }
    if (tonesLower.intersection(_darkToneValues).isNotEmpty &&
        !constraints.any((c) {
          final normalized = c.toLowerCase();
          return normalized.contains('agency') ||
              normalized.contains('agenzia') ||
              normalized.contains('agencia') ||
              normalized.contains('libre arbitre');
        })) {
      constraints.add(bundle.agencyConstraint);
    }
    if (constraints.isEmpty) {
      constraints.add(bundle.noConstraintsProvided);
    }

    final settingSummary = req.settingSummary.trim();

    return <String, Object>{
      'setting': req.setting,
      'setting_summary': settingSummary,
      'has_setting_summary': settingSummary.isNotEmpty,
      'campaign_type': req.campaignType,
      'theme_preferences': req.themePreferences.isNotEmpty
          ? req.themePreferences.join(', ')
          : bundle.themeFallback,
      'tone_preferences': req.tonePreferences.isNotEmpty
          ? req.tonePreferences.join(', ')
          : bundle.toneFallback,
      'style_preferences': req.stylePreferences.isNotEmpty
          ? req.stylePreferences.join(', ')
          : bundle.styleFallback,
      'party_level': req.partyLevel,
      'party_size': req.partySize,
      'party_archetypes': req.partyArchetypes.isNotEmpty
          ? req.partyArchetypes.join(', ')
          : bundle.partyArchetypesFallback,
      'twist': normalizedTwist,
      'has_twist': hasTwist,
      'twist_reference': twistReference,
      'narrative_hooks': req.narrativeHooks.trim(),
      'character_notes': req.characterNotes.trim(),
      'factions': req.factions.trim(),
      'npc_focus': req.npcFocus.trim(),
      'encounter_focus': req.encounterFocus.trim(),
      'safety_notes': req.safetyNotes.trim(),
      'has_additional_user_inputs': hasAdditionalUserInputs,
      'missing_input_rules': missingInputRules,
      'has_missing_input_rules': missingInputRules.isNotEmpty,
      'quality_rules': bundle.qualityRules,
      'constraints_list': constraints,
      'structure_instructions':
          bundle.structureRulesByFamily[family] ?? bundle.defaultStructure,
      'npc_instructions': npcInstructions,
      'encounter_instructions': encounterInstructions,
      'language': bundle.languageLabel,
    };
  }

  static String _normalizeTwist(String twist) {
    final trimmed = twist.trim();
    final normalized = trimmed.toLowerCase();
    if (_noTwistValues.contains(normalized)) {
      return '';
    }
    return trimmed;
  }

  static String _render(String template, Map<String, Object> ctx) {
    template = template.replaceAllMapped(
      RegExp(
        r'\{%-?\s*for\s+(\w+)\s+in\s+(\w+)\s*-?%\}\n?(.*?)\{%-?\s*endfor\s*-?%\}\n?',
        dotAll: true,
      ),
      (m) {
        final itemVar = m.group(1)!;
        final listKey = m.group(2)!;
        final body = m.group(3)!;
        final list = ctx[listKey];
        if (list is! List) return '';
        return list.map((item) {
          return body.replaceAll('{{ $itemVar }}', item.toString());
        }).join();
      },
    );

    template = template.replaceAllMapped(
      RegExp(
        r'\{%-?\s*if\s+(\w+)\s*-?%\}\n?(.*?)\{%-?\s*endif\s*-?%\}\n?',
        dotAll: true,
      ),
      (m) {
        final key = m.group(1)!;
        final body = m.group(2)!;
        final val = ctx[key];
        final truthy = switch (val) {
          String() => val.isNotEmpty,
          Iterable() => val.isNotEmpty,
          Map() => val.isNotEmpty,
          bool() => val,
          _ => val != null,
        };
        return truthy ? '${body.trimRight()}\n' : '';
      },
    );

    template = template.replaceAllMapped(
      RegExp(r'\{\{\s*(\w+)\s*\}\}'),
      (m) => ctx[m.group(1)]?.toString() ?? '',
    );

    return template;
  }

  static String _postProcess(String text) {
    text = text.split('\n').map((l) => l.trimRight()).join('\n');
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return '${text.trim()}\n';
  }
}

class _PromptLocaleBundle {
  const _PromptLocaleBundle({
    required this.languageLabel,
    required this.themeFallback,
    required this.toneFallback,
    required this.styleFallback,
    required this.defaultStructure,
    required this.partyArchetypesFallback,
    required this.noTwistReference,
    required this.twistReferencePattern,
    required this.npcInstructionsEnabled,
    required this.npcInstructionsDisabled,
    required this.encounterInstructionsEnabled,
    required this.encounterInstructionsDisabled,
    required this.missingPartyComposition,
    required this.missingNarrativeHooks,
    required this.missingCharacterNotes,
    required this.missingFactions,
    required this.missingNpcFocus,
    required this.missingEncounterFocus,
    required this.missingSafetyNotes,
    required this.missingTwist,
    required this.qualityRules,
    required this.horrorConstraint,
    required this.agencyConstraint,
    required this.noConstraintsProvided,
    required this.structureRulesByFamily,
  });

  final String languageLabel;
  final String themeFallback;
  final String toneFallback;
  final String styleFallback;
  final String defaultStructure;
  final String partyArchetypesFallback;
  final String noTwistReference;
  final String twistReferencePattern;
  final String npcInstructionsEnabled;
  final String npcInstructionsDisabled;
  final String encounterInstructionsEnabled;
  final String encounterInstructionsDisabled;
  final String missingPartyComposition;
  final String missingNarrativeHooks;
  final String missingCharacterNotes;
  final String missingFactions;
  final String missingNpcFocus;
  final String missingEncounterFocus;
  final String missingSafetyNotes;
  final String missingTwist;
  final List<String> qualityRules;
  final String horrorConstraint;
  final String agencyConstraint;
  final String noConstraintsProvided;
  final Map<String, String> structureRulesByFamily;
}
