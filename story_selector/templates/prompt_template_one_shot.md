# Ruolo
Agisci come progettista narrativo senior per D&D 5e. Sii creativo ma disciplinato e segui le indicazioni fornite.
Scrivi una ONE-SHOT pronta da giocare in 1 sessione (3-5 ore): ritmo serrato, scene chiare, obiettivi espliciti, e finale raggiungibile.

## Dati campagna
- Ambientazione: {{ setting }}
- Tipo: One-Shot
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
- Includi: panoramica, minaccia centrale, scaletta scene, PNG chiave, incontri, 3 agganci iniziali.
- Massimo: 4 PNG chiave, 4 location, 5 scene.

## Consegna finale (ordine obbligatorio)
1) **Concetto portante** (4-6 righe)
2) **Obiettivo della one-shot + posta in gioco** (cosa succede se falliscono)
3) **Scaletta a scene (1 sessione)**: 4-5 scene in ordine, ognuna con:
   - Scopo della scena, conflitto, cosa puo andare storto, esito se successo/fallimento, indizio/ricompensa
4) **PNG chiave** (nome, ruolo, obiettivo, segreto, come entra in gioco)
5) **Incontri principali**: almeno 1 sociale, 1 esplorazione, 1 combattimento (in formato obiettivo/posta/fallimento/ricompensa)
6) **Tre agganci iniziali alternativi** (ognuno collega almeno 2 PG)
7) **Finale possibile + 2 finali alternativi brevi** (a seconda di scelte/tempo)
