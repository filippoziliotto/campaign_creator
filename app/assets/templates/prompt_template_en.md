# Role
Act as a senior narrative designer for D&D 5e. Be creative but disciplined, and follow the guidance provided.
Write a campaign proposal ready to bring to the table.

## Campaign data
- Setting: {{ setting }}
- Campaign type: {{ campaign_type }}
- Preferred themes: {{ theme_preferences }}
- Party level: {{ party_level }}
- Number of characters: {{ party_size }}
- Party composition (PC classes/roles): {{ party_archetypes }}
- Note: these roles represent the player characters in the party, not generic NPCs.

## Constraints and tone
- Preferred tones: {{ tone_preferences }}
- Preferred narrative styles: {{ style_preferences }}
- Requested twist: {{ twist }}
- Hard constraints:
{% for item in constraints_list %}
  - {{ item }}
{% endfor %}

## Requested structure
{{ structure_instructions }}

## Freeform user input
- Character notes: {{ character_notes }}
- Desired narrative hooks: {{ narrative_hooks }}

## Advanced guidance
- Factions to include: {{ factions }}
- NPC focus: {{ npc_focus }}
- Encounter focus: {{ encounter_focus }}
- Safety and sensitive boundaries: {{ safety_notes }}

## Design focus
- {{ npc_instructions }}
- {{ encounter_instructions }}

## Output format
- Language: English
- Output in Markdown with clear sections and bullet lists.
- Always include: overview, central threat, act/session map, key NPCs, encounters, future hooks.
- Goal: usable material for the DM. Be concrete.

## Final delivery (required order)
Provide the following blocks in order:
1. **Core concept** (4-6 lines)
2. **World overview and stakes**
3. **Narrative structure** (acts or sessions)
4. **Key NPCs** (name, role, goal, secret, how they enter play)
5. **Main encounters** (social, exploration, combat)
6. **Three alternative opening hooks** (each must connect at least 2 PCs)
7. **Possible ending + two future evolutions** (based on party choices)
