import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

import '../models/campaign_models.dart';
import 'campaign_service.dart';

class LocalCampaignService implements CampaignService {
  @override
  Future<CampaignOptions> getOptions({String lang = 'it'}) async {
    final path = lang == 'en'
        ? 'assets/data/options_en.yaml'
        : 'assets/data/options.yaml';
    final raw = await rootBundle.loadString(path);
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
    final templateAsset = _selectTemplate(req.campaignType);
    final rawTemplate =
        await rootBundle.loadString('assets/templates/$templateAsset');
    final rendered = _render(rawTemplate, ctx);
    return _postProcess(rendered);
  }

  // ---------------------------------------------------------------------------
  // Template selection — port of render.py._select_template_name
  // ---------------------------------------------------------------------------

  static const _templateByType = <String, String>{
    'one-shot': 'prompt_template_one_shot.md',
    'one shot': 'prompt_template_one_shot.md',
    'avventura singola': 'prompt_template_one_shot.md',
    'mini-campagna': 'prompt_template_mini_campaign.md',
    'mini campagna': 'prompt_template_mini_campaign.md',
    'mini-campaign': 'prompt_template_mini_campaign.md',
    'mini campaign': 'prompt_template_mini_campaign.md',
    'campagna lunga': 'prompt_template_long_campaign.md',
    'long campaign': 'prompt_template_long_campaign.md',
    'esplorazione dungeon': 'prompt_template_dungeon_exploration.md',
    'dungeon crawl': 'prompt_template_dungeon_exploration.md',
  };

  static String _selectTemplate(String campaignType) {
    final normalized =
        campaignType.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    return _templateByType[normalized] ?? 'prompt_template.md';
  }

  // ---------------------------------------------------------------------------
  // Context building — port of prompt_builder.py.build_prompt_context
  // ---------------------------------------------------------------------------

  static Map<String, Object> _buildContext(CampaignGenerateRequest req) {
    const structureRules = <String, String>{
      'Avventura singola':
          'Progetta una struttura in 3 atti: apertura, sviluppo, climax+epilogo. Includi una timeline orientativa da 1 sessione.',
      'Mini-campagna':
          'Progetta un arco da 4-6 sessioni con progressione chiara delle poste in gioco, rivelazioni intermedie e finale ad alto impatto.',
      'Campagna lunga':
          'Progetta un arco da 10+ sessioni con sottotrame, evoluzione dei PNG chiave, fazioni e conseguenze persistenti delle scelte del party.',
      'Esplorazione dungeon':
          'Progetta una campagna centrata su esplorazione a livelli, gestione risorse, trappole, scoperte e ritorni strategici in superficie.',
      'One-Shot':
          'Progetta una struttura in 3 atti: apertura, sviluppo, climax+epilogo. Includi una timeline orientativa da 1 sessione.',
      'Mini-campaign':
          'Progetta un arco da 4-6 sessioni con progressione chiara delle poste in gioco, rivelazioni intermedie e finale ad alto impatto.',
      'Long campaign':
          'Progetta un arco da 10+ sessioni con sottotrame, evoluzione dei PNG chiave, fazioni e conseguenze persistenti delle scelte del party.',
      'Dungeon crawl':
          'Progetta una campagna centrata su esplorazione a livelli, gestione risorse, trappole, scoperte e ritorni strategici in superficie.',
    };

    final npcInstructions = req.includeNpcs
        ? 'Definisci almeno 5 PNG con obiettivi, segreti e voce distintiva.'
        : 'PNG opzionali: usa solo i necessari alla trama principale.';
    final encounterInstructions = req.includeEncounters
        ? 'Includi 3-5 incontri significativi con obiettivo narrativo, non solo tattico.'
        : 'Riduci gli incontri da combattimento e spingi su investigazione/sociale.';

    // Constraint list with augmentation — port of prompt_builder.py._build_constraint_list
    final constraints = req.constraints
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final themesLower =
        req.themePreferences.map((t) => t.toLowerCase()).toSet();
    final tonesLower = req.tonePreferences.map((t) => t.toLowerCase()).toSet();
    if (themesLower
            .intersection({'horror gotico', 'gothic horror'}).isNotEmpty &&
        !constraints.any((c) => c.toLowerCase().contains('gore'))) {
      constraints.add(
          "Mantieni l'orrore atmosferico; evita gore esplicito e descrizioni splatter.");
    }
    if (tonesLower.intersection({'cupo', 'dark'}).isNotEmpty &&
        !constraints.any((c) =>
            c.toLowerCase().contains('agency') ||
            c.toLowerCase().contains('agenzia'))) {
      constraints.add(
          "Mantieni l'agenzia dei personaggi: evita scene inevitabili senza scelta.");
    }
    if (constraints.isEmpty) {
      constraints.add("Nessun vincolo extra fornito dall'utente.");
    }

    String orFallback(String s, String f) => s.trim().isEmpty ? f : s.trim();

    return {
      'setting': req.setting,
      'campaign_type': req.campaignType,
      'theme_preferences': req.themePreferences.isNotEmpty
          ? req.themePreferences.join(', ')
          : 'Nessuna preferenza forte (mix libero).',
      'tone_preferences': req.tonePreferences.isNotEmpty
          ? req.tonePreferences.join(', ')
          : 'Nessuna preferenza forte (mix libero).',
      'style_preferences': req.stylePreferences.isNotEmpty
          ? req.stylePreferences.join(', ')
          : 'Nessuna preferenza forte (mix libero).',
      'party_level': req.partyLevel,
      'party_size': req.partySize,
      'party_archetypes': req.partyArchetypes.isNotEmpty
          ? req.partyArchetypes.join(', ')
          : 'Non specificata: proponi una composizione coerente di classi/ruoli per i PG.',
      'twist': req.twist,
      'narrative_hooks': orFallback(req.narrativeHooks,
          'Se il campo e vuoto, proponi 3 ganci iniziali alternativi da cui scegliere.'),
      'character_notes': orFallback(req.characterNotes,
          'Nessuna nota personaggi fornita: crea legami possibili con il mondo di gioco.'),
      'factions': orFallback(req.factions,
          'Non specificate: proponi 2-3 fazioni coerenti con ambientazione e conflitto principale.'),
      'npc_focus': orFallback(req.npcFocus,
          'Nessun focus specifico: varia i PNG tra alleati, rivali e neutrali ambigui.'),
      'encounter_focus': orFallback(req.encounterFocus,
          'Bilancia incontro sociale, esplorazione e combattimento in base al ritmo della campagna.'),
      'safety_notes': orFallback(req.safetyNotes,
          'Rispetta i limiti gia indicati; evita contenuti potenzialmente sensibili non richiesti.'),
      'constraints_list': constraints,
      'structure_instructions': structureRules[req.campaignType] ??
          'Progetta una campagna modulare con inizio forte, escalation e payoff finale.',
      'npc_instructions': npcInstructions,
      'encounter_instructions': encounterInstructions,
      'language': req.language,
    };
  }

  // ---------------------------------------------------------------------------
  // Minimal Jinja2 renderer — handles {{ var }}, {% if %}...{% endif %},
  // {% for item in list %}...{% endfor %} with trim_blocks equivalent.
  // ---------------------------------------------------------------------------

  static String _render(String template, Map<String, Object> ctx) {
    // 1. {% for item in <list_key> %}...{% endfor %}
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

    // 2. {% if var %}...{% endif %}  (no else needed)
    template = template.replaceAllMapped(
      RegExp(
        r'\{%-?\s*if\s+(\w+)\s*-?%\}\n?(.*?)\{%-?\s*endif\s*-?%\}\n?',
        dotAll: true,
      ),
      (m) {
        final key = m.group(1)!;
        final body = m.group(2)!;
        final val = ctx[key];
        final truthy =
            val is String ? val.isNotEmpty : val != null && val != false;
        return truthy ? body : '';
      },
    );

    // 3. {{ var }}
    template = template.replaceAllMapped(
      RegExp(r'\{\{\s*(\w+)\s*\}\}'),
      (m) => ctx[m.group(1)]?.toString() ?? '',
    );

    return template;
  }

  // ---------------------------------------------------------------------------
  // Post-processing — port of render.py._post_process
  // ---------------------------------------------------------------------------

  static String _postProcess(String text) {
    text = text.split('\n').map((l) => l.trimRight()).join('\n');
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return '${text.trim()}\n';
  }
}
