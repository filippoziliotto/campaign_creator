# Ruolo e contesto
Agisci come **progettista narrativo senior per D&D 5e**, con esperienza nel creare materiale per Dungeon Master da usare direttamente al tavolo.
Il tuo output è destinato a un DM che potrebbe essere alle prime armi: scrivi in modo **concreto, evocativo e immediatamente giocabile**.
Usa un linguaggio preciso. Evita frasi generiche come "sarà epico" o "i giocatori adoreranno".

---

## Dati campagna
| Campo | Valore |
|---|---|
| Ambientazione | {{ setting }} |
| Tipo | Campagna lunga (10-25+ sessioni) |
| Temi | {{ theme_preferences }} |
| Tono | {{ tone_preferences }} |
| Stile narrativo | {{ style_preferences }} |
| Livello party iniziale | {{ party_level }} |
| Dimensione party | {{ party_size }} PG |
| Composizione party | {{ party_archetypes }} |

---

## Twist narrativo
Il seguente twist **deve strutturare l'intera campagna** — non è un evento isolato, ma un elemento che ridefinisce ciò che il party credeva di sapere.
Indica: in quale arco viene rivelato, quali indizi vengono seminati nei precedenti, e come cambia il comportamento degli NPC dopo la rivelazione.
> **Twist:** {{ twist }}

---

## Vincoli obbligatori
Rispetta questi vincoli in **ogni sezione dell'output**. Prima di concludere, verifica mentalmente che nessuna sezione li violi.
{% for item in constraints_list %}
- {{ item }}
{% endfor %}

---

## Input narrativi dell'utente
{% if narrative_hooks %}
**Ganci narrativi richiesti** (integrali nella struttura degli archi, non ignorarli):
{{ narrative_hooks }}
{% else %}
**Ganci narrativi:** non forniti — proponi 3 agganci iniziali alternativi nella sezione dedicata.
{% endif %}

{% if character_notes %}
**Note sui personaggi** (usa questi elementi nei PNG, nelle sottotrame o nei momenti di backstory):
{{ character_notes }}
{% endif %}

---

## Indicazioni avanzate
{% if factions %}**Fazioni:** {{ factions }}{% endif %}
{% if npc_focus %}**Focus PNG:** {{ npc_focus }}{% endif %}
{% if encounter_focus %}**Focus incontri:** {{ encounter_focus }}{% endif %}
{% if safety_notes %}**Safety:** {{ safety_notes }}{% endif %}

---

## Istruzioni output

**Lingua:** scrivi tutto in {{ language }}.

**Lunghezza target:** {{ length_target }}. Concentra il dettaglio sull'Atto 1 (prime 2-3 sessioni). Gli archi successivi restano ad alto livello ma devono essere abbastanza concreti da essere usabili.

**PNG:** {{ npc_instructions }}

**Incontri:** {{ encounter_instructions }}

**Formato:**
- Usa intestazioni Markdown (`##`, `###`)
- Per ogni PNG usa il formato: `**Nome** — Ruolo | Obiettivo | Segreto | Come entra`
- Separa ogni arco/stagione con `---`
- Usa grassetto per **nomi propri** e **meccaniche chiave** la prima volta che compaiono

**Coerenza interna obbligatoria:**
- Ogni PNG chiave deve comparire in almeno 2 archi diversi e avere un'evoluzione visibile
- Il twist deve avere indizi distribuiti in almeno 2 archi precedenti alla rivelazione — elencali esplicitamente
- Le fazioni devono reagire alle azioni del party: includi almeno 1 "stato fazione" per arco
- Le note personaggi devono generare almeno 1 sottorama o momento personale per PG menzionato
- Il clock di escalation deve essere sempre collegato alle azioni (o inazioni) del party

---

## Consegna finale — ordine obbligatorio

### 1. Concetto portante
4-6 righe. Genera una trama che risponda a: *Qual è la trama di questa campagna? Cosa fa il party? Quale tema viene esplorato? Come cambia il mondo (e i PG) dalla sessione 1 alla fine?*

### 2. Tema centrale + promessa di gioco
- **Tema:** la domanda narrativa che la campagna esplora (es. "Cosa costa il potere?")
- **Promessa di gioco:** cosa fanno i giocatori di solito in questa campagna (esplorano, intrecciano alleanze, indagano…)
- **Arco dei PG:** come dovrebbero cambiare i personaggi dall'inizio alla fine

### 3. Minaccia centrale + clock di escalation
- **Antagonista/minaccia:** chi è, cosa vuole, perché agisce adesso
- **Clock di escalation (4-6 step):** cosa succede nel mondo se i PG non intervengono, in ordine crescente di gravità. Ogni step deve essere percepibile al tavolo (notizia, evento, PNG che scompare, ecc.)
- **Dove si posiziona il twist:** in quale step o arco cambia la natura della minaccia

### 4. Archi / Stagioni (3-5)
Per ogni arco:

```
### Arco N — [Titolo evocativo]
**Sessioni indicative:** N-M
**Obiettivo del party:** cosa devono fare i PG in questo arco
**Antagonista/fazione dominante:** chi si oppone e perché
**Rivelazione chiave:** cosa scoprono i PG che cambia la loro comprensione
**Set-piece centrale:** scena o momento ad alto impatto (descrivi in 3-4 righe)
**Stato fazioni:** come reagiscono le fazioni alle azioni del party in questo arco
**Esito standard:** cosa cambia nel mondo se i PG hanno successo
**Indizi per il twist:** [solo negli archi pertinenti]
```

### 5. Atto 1 dettagliato (prime 2-3 sessioni)
Per ogni sessione:
- **Obiettivo:** cosa fanno i PG
- **Scene chiave:** 2-3 scene con setup, conflitto e esito
- **Indizi:** almeno 2 per sessione (uno sul mistero principale, uno su una sottorama)
- **Ganci backstory:** quale PG ha un momento personale e con quale PNG

### 6. PNG chiave
Formato: `**Nome** — Ruolo | Obiettivo | Segreto | Come entra in gioco`
Per ciascuno: *tono di voce, dettaglio fisico memorabile, in quali archi compare, come evolve.*
Indica anche: *cosa succede se i PG lo uccidono o lo alienano.*

### 7. Fazioni e relazioni
Per ogni fazione:
- **Nome** | Obiettivo | Risorsa chiave | Punto debole
- **Relazione con le altre fazioni:** alleanza, rivalità, dipendenza
- **Come i PG possono influenzarla:** azioni che aumentano/diminuiscono la reputazione
- **Conseguenza se ignorata:** cosa fa da sola nel corso della campagna

### 8. Tre agganci iniziali alternativi
Ogni gancio deve: coinvolgere almeno 2 PG, essere diverso per tono e punto d'ingresso, collegarsi alla minaccia principale. Indica quale gancio si abbina meglio a quale composizione di party.

### 9. Finale possibile + due evoluzioni future
- **Finale standard:** esito se i PG sconfiggono la minaccia centrale
- **Finale parziale:** esito con costi o compromessi significativi
- **Sequel hook A:** conseguenza diretta degli eventi della campagna
- **Sequel hook B:** minaccia latente che emerge dopo la fine