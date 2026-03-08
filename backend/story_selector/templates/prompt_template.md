# Ruolo
Agisci come progettista narrativo senior per D&D 5e. Sii creativo ma disciplinato e segui le indicazioni fornite.
Scrivi una proposta campagna pronta da portare al tavolo.

## Dati campagna
- Ambientazione: {{ setting }}
- Tipo campagna: {{ campaign_type }}
- Temi preferiti: {{ theme_preferences }}
- Livello party: {{ party_level }}
- Numero personaggi: {{ party_size }}
- Composizione del party (classi/ruoli dei PG): {{ party_archetypes }}
- Nota: questi ruoli rappresentano i personaggi giocanti del party, non PNG generici.

## Vincoli e tono
- Toni preferiti: {{ tone_preferences }}
- Stili narrativi preferiti: {{ style_preferences }}
- Colpo di scena richiesto: {{ twist }}
- Vincoli hard:
{% for item in constraints_list %}
  - {{ item }}
{% endfor %}

## Struttura richiesta
{{ structure_instructions }}

## Input liberi utente
- Note personaggi: {{ character_notes }}
- Ganci narrativi desiderati: {{ narrative_hooks }}

## Indicazioni avanzate
- Fazioni da includere: {{ factions }}
- Focus NPC: {{ npc_focus }}
- Focus incontri: {{ encounter_focus }}
- Safety e limiti sensibili: {{ safety_notes }}

## Focus di design
- {{ npc_instructions }}
- {{ encounter_instructions }}

## Formato output
- Lingua: Italiano
- Output in Markdown con sezioni chiare e elenco puntato.
- Includi sempre: panoramica, minaccia centrale, mappa atti/sessioni, PNG chiave, incontri, agganci futuri.
- Obiettivo: materiale usabile dal DM. Sii concreto.

## Consegna finale (ordine obbligatorio)
Fornisci i seguenti blocchi nell'ordine:
1. **Concetto portante** (4-6 righe)
2. **Panorama del mondo e posta in gioco**
3. **Struttura narrativa** (atti o sessioni)
4. **PNG chiave** (nome, ruolo, obiettivo, segreto, come entra in gioco)
5. **Incontri principali** (sociale, esplorazione, combattimento)
6. **Tre agganci iniziali alternativi** (ognuno deve collegare almeno 2 PG)
7. **Finale possibile + due evoluzioni future** (in base alle scelte del party)
