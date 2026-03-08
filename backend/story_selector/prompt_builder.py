"""Rules for translating validated inputs into prompt-ready sections."""

from __future__ import annotations

from typing import Any

from .schema import CampaignRequest

_STRUCTURE_RULES = {
    "Avventura singola": (
        "Progetta una struttura in 3 atti: apertura, sviluppo, climax+epilogo. "
        "Includi una timeline orientativa da 1 sessione."
    ),
    "Mini-campagna": (
        "Progetta un arco da 4-6 sessioni con progressione chiara delle poste in gioco, "
        "rivelazioni intermedie e finale ad alto impatto."
    ),
    "Campagna lunga": (
        "Progetta un arco da 10+ sessioni con sottotrame, evoluzione dei PNG chiave, "
        "fazioni e conseguenze persistenti delle scelte del party."
    ),
    "Esplorazione dungeon": (
        "Progetta una campagna centrata su esplorazione a livelli, gestione risorse, "
        "trappole, scoperte e ritorni strategici in superficie."
    ),
    "One-shot": (
        "Progetta una struttura in 3 atti: apertura, sviluppo, climax+epilogo. "
        "Includi una timeline orientativa da 1 sessione."
    ),
    "Mini-campaign": (
        "Progetta un arco da 4-6 sessioni con progressione chiara delle poste in gioco, "
        "rivelazioni intermedie e finale ad alto impatto."
    ),
    "Long campaign": (
        "Progetta un arco da 10+ sessioni con sottotrame, evoluzione dei PNG chiave, "
        "fazioni e conseguenze persistenti delle scelte del party."
    ),
    "Dungeon crawl": (
        "Progetta una campagna centrata su esplorazione a livelli, gestione risorse, "
        "trappole, scoperte e ritorni strategici in superficie."
    ),
}


def _split_non_empty_lines(raw: str) -> list[str]:
    return [line.strip() for line in raw.replace("\r", "\n").split("\n") if line.strip()]


def _build_constraint_list(request: CampaignRequest) -> list[str]:
    constraints = _split_non_empty_lines(request.constraints)

    theme_preferences = {item.lower() for item in request.theme_preferences}
    tone_preferences = {item.lower() for item in request.tone_preferences}

    if {"horror gotico", "gothic horror"} & theme_preferences and not any(
        "gore" in c.lower() for c in constraints
    ):
        constraints.append(
            "Mantieni l'orrore atmosferico; evita gore esplicito e descrizioni splatter."
        )

    if {"cupo", "dark"} & tone_preferences and not any(
        "agency" in c.lower() or "agenzia" in c.lower() for c in constraints
    ):
        constraints.append(
            "Mantieni l'agenzia dei personaggi: evita scene inevitabili senza scelta."
        )

    if not constraints:
        constraints.append("Nessun vincolo extra fornito dall'utente.")

    return constraints


def build_prompt_context(request: CampaignRequest) -> dict[str, Any]:
    """Build template context with derived instructions."""

    structure_instructions = _STRUCTURE_RULES.get(
        request.campaign_type,
        "Progetta una campagna modulare con inizio forte, escalation e payoff finale.",
    )

    npc_instructions = (
        "Definisci almeno 5 PNG con obiettivi, segreti e voce distintiva."
        if request.include_npcs
        else "PNG opzionali: usa solo i necessari alla trama principale."
    )

    encounter_instructions = (
        "Includi 3-5 incontri significativi con obiettivo narrativo, non solo tattico."
        if request.include_encounters
        else "Riduci gli incontri da combattimento e spingi su investigazione/sociale."
    )

    narrative_hooks = request.narrative_hooks.strip() or (
        "Se il campo e vuoto, proponi 3 ganci iniziali alternativi da cui scegliere."
    )

    character_notes = request.character_notes.strip() or (
        "Nessuna nota personaggi fornita: crea legami possibili con il mondo di gioco."
    )
    factions = request.factions.strip() or (
        "Non specificate: proponi 2-3 fazioni coerenti con ambientazione e conflitto principale."
    )
    npc_focus = request.npc_focus.strip() or (
        "Nessun focus specifico: varia i PNG tra alleati, rivali e neutrali ambigui."
    )
    encounter_focus = request.encounter_focus.strip() or (
        "Bilancia incontro sociale, esplorazione e combattimento in base al ritmo della campagna."
    )
    safety_notes = request.safety_notes.strip() or (
        "Rispetta i limiti gia indicati; evita contenuti potenzialmente sensibili non richiesti."
    )

    party_archetypes = (
        ", ".join(request.party_archetypes)
        if request.party_archetypes
        else "Non specificata: proponi una composizione coerente di classi/ruoli per i PG."
    )
    theme_preferences = (
        ", ".join(request.theme_preferences)
        if request.theme_preferences
        else "Nessuna preferenza forte (mix libero)."
    )
    tone_preferences = (
        ", ".join(request.tone_preferences)
        if request.tone_preferences
        else "Nessuna preferenza forte (mix libero)."
    )
    style_preferences = (
        ", ".join(request.style_preferences)
        if request.style_preferences
        else "Nessuna preferenza forte (mix libero)."
    )

    return {
        "setting": request.setting,
        "campaign_type": request.campaign_type,
        "theme_preferences": theme_preferences,
        "tone_preferences": tone_preferences,
        "style_preferences": style_preferences,
        "party_level": request.party_level,
        "party_size": request.party_size,
        "party_archetypes": party_archetypes,
        "twist": request.twist,
        "narrative_hooks": narrative_hooks,
        "character_notes": character_notes,
        "factions": factions,
        "npc_focus": npc_focus,
        "encounter_focus": encounter_focus,
        "safety_notes": safety_notes,
        "constraints_list": _build_constraint_list(request),
        "structure_instructions": structure_instructions,
        "npc_instructions": npc_instructions,
        "encounter_instructions": encounter_instructions,
        "language": request.language,
    }
