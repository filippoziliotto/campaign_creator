# Ruolo
Agisci come progettista narrativo senior per D&D 5e. Sii creativo ma disciplinato e segui le indicazioni fornite.
Scrivi una campagna centrata su ESPLORAZIONE DUNGEON: dungeon giocabile, loop di esplorazione, fazioni interne, e progressione del rischio.

## Dati campagna
- Ambientazione: {{ setting }}
- Tipo: Esplorazione dungeon
- Temi: {{ theme_preferences }}
- Livello party: {{ party_level }} | Party size: {{ party_size }}
- PG (classi/ruoli): {{ party_archetypes }}

## Vincoli e tono
- Toni: {{ tone_preferences }} | Stili: {{ style_preferences }}
- Twist: {{ twist }}
- Vincoli hard:
{% for item in constraints_list %}
  - {{ item }}
{% endfor %}

## Input utente
- Note personaggi: {{ character_notes }}
- Ganci desiderati: {{ narrative_hooks }}

## Indicazioni avanzate (se vuote, ignora)
- Fazioni: {{ factions }} | Focus NPC: {{ npc_focus }} | Focus incontri: {{ encounter_focus }}
- Safety: {{ safety_notes }}

## Output (Markdown, concreto, giocabile)
- Obiettivo: materiale per masterare un dungeon multi-sessione.
- Massimo: 3 livelli/zone, 6 stanze chiave per livello (descrizione breve ma giocabile).

## Consegna finale (ordine obbligatorio)
1) **Concetto portante** (4-6 righe)
2) **Perche il dungeon esiste + posta in gioco**
3) **Struttura del dungeon (overview)**:
   - Tema visivo, regole speciali (magia, luce, rumore), e loop di esplorazione (rest, rifornimenti, rischi)
4) **Mappa a zone/livelli (1-3)**:
   - Per ogni livello: obiettivo, pericolo distintivo, 2 ingressi/uscite, 1 shortcut/loop, 1 revelation
5) **Fazioni interne (2-3)**:
   - obiettivi, risorse, cosa offrono ai PG, cosa succede se i PG le aiutano/tradiscono
6) **Stanze/Set-piece chiave**:
   - 6 per livello: cosa si vede, cosa succede, trigger, indizio/ricompensa, variante se falliscono
7) **Incontri principali** (sociale/esplorazione/combattimento) con obiettivo/posta/fallimento/ricompensa
8) **Tre agganci iniziali alternativi** (ognuno collega almeno 2 PG)
9) **Finale possibile + due evoluzioni future** (dungeon cambia, nuova minaccia emerge, livello segreto, ecc.)
