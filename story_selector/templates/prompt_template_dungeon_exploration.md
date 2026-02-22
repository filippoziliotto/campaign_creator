# Ruolo e contesto
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

## Indicazioni avanzate
**Fazioni**
{{ factions }}

**Focus PNG**
{{ npc_focus }}

**Focus incontri**
{{ encounter_focus }}

**Safety**
{{ safety_notes }}

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
# Ruolo e contesto
Agisci come **progettista narrativo senior per D&D 5e**, con esperienza nel creare materiale per Dungeon Master da usare direttamente al tavolo.
Il tuo output è destinato a un DM che potrebbe essere alle prime armi: scrivi in modo **concreto, evocativo e immediatamente giocabile**.
Usa un linguaggio preciso. Evita frasi generiche come "sarà epico" o "i giocatori adoreranno".

---

## Dati campagna
| Campo | Valore |
|---|---|
| Ambientazione | {{ setting }} |
| Tipo | Esplorazione dungeon (multi-sessione) |
| Temi | {{ theme_preferences }} |
| Tono | {{ tone_preferences }} |
| Stile narrativo | {{ style_preferences }} |
| Livello party | {{ party_level }} |
| Dimensione party | {{ party_size }} PG |
| Composizione party | {{ party_archetypes }} |

---

## Twist narrativo
Il seguente twist **deve alterare la comprensione del dungeon stesso** — non è un evento esterno, ma qualcosa che ribalta ciò che il party credeva di sapere sul luogo o sulla minaccia.
Indica in quale livello/zona viene rivelato e quali indizi ambientali lo anticipano nei livelli precedenti.
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
**Ganci narrativi richiesti** (integrali nella struttura del dungeon e negli agganci iniziali):
{{ narrative_hooks }}
{% else %}
**Ganci narrativi:** non forniti — proponi 3 agganci iniziali alternativi nella sezione dedicata.
{% endif %}

{% if character_notes %}
**Note sui personaggi** (usa questi elementi nei PNG interni o negli indizi del dungeon):
{{ character_notes }}
{% endif %}

---

## Indicazioni avanzate
**Fazioni**
{{ factions }}

**Focus PNG**
{{ npc_focus }}

**Focus incontri**
{{ encounter_focus }}

**Safety**
{{ safety_notes }}

---

## Istruzioni output

**Lingua:** scrivi tutto in {{ language }}.

**Lunghezza target:** {{ length_target }}. Distribuisci il dettaglio equamente tra i livelli. Le stanze chiave devono avere abbastanza dettaglio da essere masterabili senza preparazione extra.

**PNG:** {{ npc_instructions }}

**Incontri:** {{ encounter_instructions }}

**Formato:**
- Usa intestazioni Markdown (`##`, `###`)
- Per ogni stanza usa il formato strutturato indicato sotto
- Separa ogni livello/zona con `---`
- Usa grassetto per **nomi propri**, **trappole**, **oggetti chiave** la prima volta che compaiono

**Coerenza interna obbligatoria:**
- Ogni fazione interna deve avere una presenza fisica in almeno 2 stanze distinte
- Il twist deve essere anticipato da almeno 2 indizi ambientali nei livelli precedenti — elencali esplicitamente
- Il dungeon deve funzionare come sistema vivo: indica almeno 2 eventi che cambiano se il party ritarda o torna dopo una pausa
- Ogni livello deve avere almeno 1 collegamento narrativo con il livello successivo (oggetto, indizio, PNG in fuga)
- Le note personaggi devono legarsi ad almeno 1 stanza chiave o PNG interno

---

## Consegna finale — ordine obbligatorio

### 1. Concetto portante
4-6 righe. Genera una trama che risponda a: *Cos'è questo dungeon? Perché esiste? Qual è la promessa esplorativa? Quale emozione deve dominare?*

### 2. Perché il dungeon esiste + posta in gioco
- **Origine:** chi lo ha costruito, perché, cosa è andato storto
- **Posta in gioco:** cosa succede se i PG non entrano, non finiscono, o falliscono
- **Ricompensa:** cosa guadagna concretamente il party se riesce
- **Dove si integra il twist:** in quale livello e con quale impatto sulla posta in gioco

### 3. Struttura del dungeon (overview)
- **Tema visivo e atmosferico:** cosa vedono, sentono, annusano i PG al primo ingresso
- **Regole speciali:** magia, luce, rumore, gravità, tempo — qualcosa che rende questo dungeon unico
- **Loop di esplorazione:** dove i PG possono riposare, rifornirsi, ritirarsi — e a quale costo
- **Scala del rischio:** come aumenta la pericolosità scendendo di livello

### 4. Mappa a zone / livelli (1-3 livelli)
Per ogni livello:

```
### Livello N — [Nome evocativo]
**Tema:** elemento dominante (architettura, creature, magia)
**Obiettivo del party in questo livello:** cosa cercano
**Pericolo distintivo:** una minaccia unica di questo livello (non solo mostri)
**Ingressi/uscite (min 2):** come si entra e come si esce
**Shortcut/loop:** collegamento non ovvio con un altro livello o zona
**Revelation:** cosa scoprono i PG che cambia la loro comprensione del dungeon
**Indizi per il twist:** [solo nel livello pertinente]
**Evento dinamico:** cosa cambia se il party torna dopo un riposo lungo
```

### 5. Fazioni interne (2-3)
Per ogni fazione:
- **Nome** | Obiettivo nel dungeon | Risorsa/vantaggio | Punto debole
- **Cosa offrono ai PG** se trattano (informazione, via sicura, equipaggiamento)
- **Cosa fanno se i PG li aiutano:** conseguenza positiva concreta
- **Cosa fanno se i PG li tradiscono o li ignorano:** reazione e conseguenze
- **Dove si trovano fisicamente:** in quali stanze/livelli

### 6. Stanze / Set-piece chiave
Massimo 6 per livello. Per ogni stanza:

```
### Stanza [N.X] — [Nome]
**Cosa si vede:** descrizione in 2-3 righe (sensoriale, non solo visiva)
**Cosa succede:** evento o situazione attiva (non statica)
**Trigger:** cosa attiva la complicazione principale
**Indizio/ricompensa:** cosa ottengono i PG che esplorano bene
**Variante se falliscono:** come avanza la storia senza bloccarsi
**Collegamento fazione:** [se applicabile]
```

### 7. Incontri principali
Almeno 1 per tipo (sociale, esplorazione, combattimento) per livello.
Per ciascuno:
- **Tipo** | **Livello** | **Setup**
- **Obiettivo PG vs obiettivo antagonista/fazione**
- **Posta:** guadagno / perdita
- **Fallimento non letale:** come avanza la storia comunque
- **Connessione narrativa:** come questo incontro cambia la percezione del dungeon

### 8. Tre agganci iniziali alternativi
Ogni gancio deve: coinvolgere almeno 2 PG, essere diverso per tono e punto d'ingresso, spiegare perché il party entra nel dungeon. Indica quale gancio si abbina meglio a quale composizione di party.

### 9. Finale possibile + due evoluzioni future
- **Finale standard:** esito se i PG completano l'obiettivo principale del dungeon
- **Finale parziale:** esito con perdite o obiettivo incompleto
- **Evoluzione A:** cosa emerge dopo che il dungeon è "risolto" (nuovo livello segreto, conseguenza esterna)
- **Evoluzione B:** cosa succede se il party lascia il dungeon a metà e ci torna settimane dopo