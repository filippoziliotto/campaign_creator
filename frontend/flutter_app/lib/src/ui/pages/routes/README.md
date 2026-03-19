# routes

Questa cartella contiene le route page della feature e il contenitore scrollabile condiviso.
Qui non dovrebbe esserci logica di dominio: le route ricevono widget gia preparati dalla shell e decidono solo come disporli.

## File

### `entry_page.dart`

Route page della schermata iniziale.
Compone:

- hero iniziale
- banner di errore opzionale
- griglia dei tipi campagna
- pannello di ripresa rapida

### `forge_page.dart`

Route page della fase di configurazione.
Compone:

- hero della forgia
- ribbon delle sezioni
- sezione attiva
- pannello di controllo/sintesi

Gestisce soprattutto il passaggio tra layout a colonna singola e layout a due pannelli.

### `parchment_page.dart`

Route page finale.
Compone:

- hero finale
- foglio pergamena
- rail laterale di azioni e stato

Qui vive la scelta di layout wide/mobile per la schermata finale, inclusa l'applicazione del reveal unfold del foglio.

### `stage_route_scaffold.dart`

Contenitore scrollabile condiviso dalle route page.
Centralizza:

- `ScrollController`
- `Scrollbar`
- `SingleChildScrollView`
- larghezza massima del contenuto
- padding standard

## Regola di ownership

Se una modifica cambia il “dove” sono disposti i blocchi, appartiene qui.
Se cambia il “cosa” fanno i blocchi o come vengono calcolati, appartiene altrove.
