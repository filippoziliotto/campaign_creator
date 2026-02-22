# Ruolo
Agisci come progettista narrativo senior per D&D 5e. Sii creativo ma disciplinato e segui le indicazioni fornite.
Scrivi una CAMPAGNA LUNGA (10-25+ sessioni): definisci arc portante, archi secondari, evoluzione del mondo e spazio per backstory dei PG.

## Dati campagna
- Ambientazione: {{ setting }}
- Tipo: Campagna lunga
- Temi: {{ theme_preferences }}
- Livello party iniziale: {{ party_level }} | Party size: {{ party_size }}
- PG (classi/ruoli): {{ party_archetypes }}

## Vincoli e tono
- Toni: {{ tone_preferences }} | Stili: {{ style_preferences }}
- Twist (se richiesto): {{ twist }}
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
- Includi: tema, minaccia centrale, stagioni/archi, PNG chiave, fazioni, set-piece, agganci futuri.
- Non scrivere 25 sessioni dettagliate: dai una mappa ad alto livello + dettagli solo per l'atto iniziale.

## Consegna finale (ordine obbligatorio)
1) **Concetto portante** (4-6 righe)
2) **Tema della campagna + promessa di gioco** (cosa i giocatori fanno di solito)
3) **Minaccia centrale + clock di escalation**:
   - 4-6 step di peggioramento se i PG non intervengono
4) **Archi/Stagioni (3-5)**:
   - Per ciascuno: obiettivo, antagonista/fazione dominante, rivelazione, set-piece, esito
5) **Atto 1 dettagliato (prime 2-3 sessioni)**:
   - obiettivi, scene clou, indizi, ganci alle backstory dei PG
6) **PNG chiave** (nome, ruolo, obiettivo, segreto, come entra in gioco)
7) **Fazioni e relazioni** (chi vuole cosa, conflitti, come i PG possono influenzarle)
8) **Tre agganci iniziali alternativi** (ognuno collega almeno 2 PG)
9) **Finale possibile + due evoluzioni future** (rami principali + sequel hook)
