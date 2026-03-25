# shell

Questa cartella contiene il layer di orchestrazione della feature `campaign builder`.
Qui vive il controller stateful della flow, insieme ai moduli che costruiscono le tre route principali (`entry`, `forge`, `parchment`) partendo da uno stato condiviso.

L'obiettivo della cartella non e disegnare ogni dettaglio UI. Il suo compito e decidere:

- quale stage della feature e attivo
- quali dati sono gia disponibili
- quando una transizione e consentita
- quando una richiesta di generazione puo essere avviata
- quali azioni finali devono essere esposte all'utente

## File

### `campaign_builder_page.dart`

Questo e il file radice della shell.
Contiene il `StatefulWidget` principale e tutto lo stato condiviso della feature.

Responsabilita principali:

- istanziare il `CampaignService`
- caricare `CampaignOptions` dagli asset locali
- mantenere i `TextEditingController`
- serializzare lo stato UI in `CampaignGenerateRequest`
- orchestrare la route flow tra `Entry`, `Forge` e `Pergamena`
- applicare il tema atmosferico corretto in base al tipo di campagna
- gestire persistenza locale, clipboard, share e apertura di ChatGPT
- centralizzare le regole di avanzamento (`_canAdvanceWorldSection`, `_canAdvancePartySection`, `_canForgeNarrativeSection`)

In pratica: questo file e il cervello della feature, non il posto giusto per disegnare widget complessi di una singola schermata.

### `campaign_builder_entry_shell.dart`

Modulo della route `Entry`.
Costruisce i blocchi della prima schermata usando lo stato presente nella shell principale.

Responsabilita:

- hero iniziale della feature
- griglia dei tipi di campagna
- pannello di ripresa veloce quando esiste una bozza o una pergamena gia generata

Questo file deve rimanere focalizzato sulla route di ingresso. Se una modifica riguarda la scelta del formato o la ripresa del lavoro precedente, il punto corretto e qui.

### `campaign_builder_forge_shell.dart`

Modulo della route `Forge`.
Raccoglie tutta la UI della costruzione guidata, comprese le tre sottosezioni della forgia.

Responsabilita:

- hero della forgia
- ribbon delle sezioni (`Mondo`, `Party`, `Trama`)
- pannello di controllo e CTA primaria
- contenuti della sezione `Mondo`
- contenuti della sezione `Party`
- contenuti della sezione `Trama`
- helper di form strettamente locali alla forgia (`dropdown`, `chip selector`, `stat block`, `multiline field`)

Regola pratica:
se un cambiamento tocca l'editing del prompt prima della generazione, quasi certamente parte da questo file.

### `campaign_builder_parchment_shell.dart`

Modulo della route `Pergamena`.
Costruisce la schermata finale usando il prompt gia generato e le azioni esposte dalla shell.

Responsabilita:

- hero finale della pergamena
- sidebar con compendio, navigazione e action rail
- collegamento al rendering premium della pergamena (`PremiumParchmentSheet`)

Questo file non deve contenere il parser del prompt o i componenti visivi interni del foglio: quelli appartengono alla cartella `parchment/`.

## Dipendenze interne

La relazione tra i file della cartella e intenzionalmente asimmetrica:

- `campaign_builder_page.dart` dichiara lo stato e le azioni condivise
- i file `campaign_builder_*_shell.dart` leggono e usano quello stato tramite `part of`
- i file stage-specific non dovrebbero introdurre nuovo stato globale della feature

Questo approccio evita di duplicare campi o controller tra schermate e permette di separare il codice per route senza spezzare la sorgente di verita.

## Cosa deve stare qui

- stato della flow
- regole di navigazione tra route e sezioni
- validazioni cross-screen
- integrazione con service layer locale e servizi di piattaforma
- mapping da stato condiviso a root widget delle route

## Cosa non deve stare qui

- primitives di design riusabili
- backdrop, hero frame, pill, card e widget visuali di base
- parser o rendering interno della pergamena
- logica generica di theming che puo vivere in `design/`

## Come modificare senza degradare l'architettura

Se devi introdurre una nuova route o una nuova sezione della forgia:

1. aggiungi stato e regole nel file shell principale solo se servono davvero a tutta la feature
2. metti il layout della route o sezione nel modulo shell piu vicino
3. sposta i widget riusabili in `design/` o `parchment/` se iniziano a essere condivisi

Se invece una modifica richiede contemporaneamente:

- cambi di stato
- cambi di validazione
- cambi di navigazione

allora la shell e il punto corretto.
