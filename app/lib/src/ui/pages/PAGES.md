# pages

Questa cartella contiene la feature UI principale del progetto: il campaign builder Flutter.
Non e piu una directory piatta. La struttura e stata separata per responsabilita operative, in modo che stato, layout route, sistema visivo locale e rendering della pergamena abbiano confini chiari.

## Struttura

- `shell/`: orchestrazione stateful della feature e moduli di route-level composition
- `routes/`: pagine e scaffold responsive che definiscono la struttura dei tre stage
- `design/`: atmosfera, primitives visuali e widget di motion condivisi
- `parchment/`: parser e rendering premium della schermata finale

## Come leggere la cartella

La dipendenza corretta va letta cosi:

1. `shell/` decide stato, validazioni, transizioni e chiamate al service layer
2. `routes/` riceve blocchi gia costruiti e li dispone nella pagina corretta
3. `design/` fornisce il vocabolario visivo della feature
4. `parchment/` si occupa del dominio UI specifico del prompt finale

Questo ordine evita che widget visivi inizino a conoscere il caricamento dati o che le route inglobino logica di business.

## Dettaglio per sottocartella

### `shell/`

Contiene il controller della feature e i moduli separati per route:

- `campaign_builder_page.dart`: stato condiviso, azioni, persistenza, validazione, navigazione
- `campaign_builder_entry_shell.dart`: composizione della route `Entry`
- `campaign_builder_forge_shell.dart`: composizione della route `Forge` e delle sue sezioni
- `campaign_builder_parchment_shell.dart`: composizione della route `Pergamena`

Questa suddivisione riduce il rischio di avere un unico file monolitico in cui stato, navigazione e layout di tutte le schermate si intrecciano.

### `routes/`

Contiene le pagine che definiscono il layout dei tre stage applicativi.
Questi file non dovrebbero contenere logica di orchestrazione: ricevono widget gia preparati dalla shell e li dispongono secondo la struttura responsive desiderata.

### `design/`

Qui vive il design system locale della feature.
Non e un design system globale dell'app, ma il set di elementi necessari a dare identita al campaign builder:

- atmosfera per campagna
- backdrop
- hero frame
- summary badge
- stage pill
- motion widget
- campaign cards interattive

Se un elemento viene riusato in piu punti della feature e non dipende dal service layer, probabilmente appartiene qui.

### `parchment/`

Contiene il rendering del prompt finale.
Questa cartella e dedicata alla presentazione della pergamena come oggetto UI distinto, con parsing dei capitoli e componenti premium di lettura/azione.

## Regole di dipendenza

Le dipendenze dovrebbero restare orientate in una sola direzione:

- `shell/` puo dipendere da `routes/`, `design/`, `parchment/`, `models/`, `services/`, `theme/`
- `routes/` puo dipendere da `design/` e ricevere widget composti dalla shell
- `design/` non deve dipendere da `shell/`
- `parchment/` non deve dipendere da `shell/`

Se questa direzione si rompe, la feature torna rapidamente a essere difficile da modificare.

## Quando aggiungere un nuovo file

Aggiungi un file in:

- `shell/` se introduce nuova logica di flow o compone una route/stage specifica
- `routes/` se introduce un nuovo scaffold o layout page-level
- `design/` se introduce un widget visuale riusabile o nuovi token atmosferici/motion
- `parchment/` se riguarda parsing o presentazione del prompt finale

## README locali

Ogni sottocartella contiene un `README.md` dedicato. Usali come documentazione di ownership e non come semplice indice file:

- `shell/README.md`: stato condiviso e moduli di route composition
- `routes/README.md`: struttura delle pagine
- `design/README.md`: sistema visivo e motion layer
- `parchment/README.md`: rendering e strumenti della pergamena
