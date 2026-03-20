# ui

Questa cartella contiene il layer di presentazione del frontend Flutter.
Qui vivono shell, route page, widget condivisi della flow e layout responsivi.

## Responsabilita

- orchestrare la navigazione della UX
- trasformare modelli e stato in widget
- mostrare feedback visivo, errori, loading e stato della flow
- applicare l'atmosfera visuale corretta per il tipo di campagna selezionato
- applicare micro-motion coerente con atmosfera, stato e reduced-motion settings
- presentare il prompt finale come esperienza di lettura e distribuzione, non come semplice textbox
- comporre il design system definito in `theme/`

## Struttura

- `pages/`: feature folder della flow principale, ulteriormente separata in `shell/`, `routes/`, `design/` e `parchment/`

## Architettura attuale

La UI del builder e organizzata in questo modo:

1. `ui/pages/shell/CampaignBuilderPage` e la shell della feature.
2. La shell mantiene stato condiviso, caricamento dati e azioni utente.
3. Un `Navigator` interno gestisce tre route distinte costruite da `ui/pages/routes/`:
   - Entry
   - Forge
   - Pergamena
4. Il tipo campagna attivo seleziona una `CampaignAtmosphereData` definita in `ui/pages/design/`.
5. La top bar rimane persistente mentre il contenuto cambia tramite route page full-screen.
6. La schermata finale usa componenti dedicati in `ui/pages/parchment/`.

## Scelte progettuali

Questa struttura serve a evitare due estremi comuni:

- UI tutta in un solo file monolitico e difficile da mantenere
- frammentazione prematura in troppi micro-widget senza ownership chiara

La separazione introdotta oggi divide:

- shell e stato della flow
- route page di layout
- primitive visuali condivise
- atmosfera visuale per modalita
- widget interattivi con motion state dedicato
- componenti specializzati della pergamena

## Dipendenze consentite

La UI puo dipendere da:

- `theme/`
- `models/`
- `services/`

Non dovrebbe introdurre logica di accesso diretto agli asset o parsing strutturato dei dati.

## Evoluzione naturale

Il prossimo refactor coerente, se la feature cresce ancora, e estrarre da `CampaignBuilderPage` un controller/store dedicato.
In quel punto `ui/` diventerebbe quasi interamente dichiarativa, con meno responsabilita di stato.
