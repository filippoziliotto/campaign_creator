# theme

Questa cartella definisce il design system del frontend.
Non contiene schermate o logica applicativa: contiene le regole visive condivise da tutta l'app.

## Obiettivo

Il progetto non usa il look standard di Material.
Il tema serve a dare un'identita fantasy coerente e a ridurre la quantita di stile hardcoded nei widget.

## File

- `fantasy_theme.dart`
  Definisce:
  - `FantasyPalette`: palette semantica riusabile
  - `buildFantasyTheme()`: `ThemeData` completo usato dal `MaterialApp`

## Cosa include oggi

- palette scura con accenti bronze/ember/parchment
- tipografia tramite `google_fonts`
- styling condiviso per:
  - `Card`
  - `InputDecoration`
  - `FilledButton`
  - `OutlinedButton`
  - `SnackBar`
  - `Switch`
  - `ProgressIndicator`

## Perche e importante

Senza questo layer, i widget della flow dovrebbero conoscere:

- colori concreti
- radius e bordi
- tipografia
- stati visivi dei componenti Material

Con il tema centralizzato, le schermate possono concentrarsi su struttura e comportamento.

## Regole di manutenzione

- aggiungere nuovi token in `FantasyPalette` prima di hardcodare nuovi colori
- mantenere i nomi dei token semantici, non descrittivi del singolo uso
- spostare qui le personalizzazioni globali dei componenti Material
- evitare di usare questa cartella per logica di navigazione o stato

## Quando modificarla

Aggiorna questa cartella quando:

- cambia la direzione visiva del prodotto
- vuoi uniformare nuovi componenti
- vuoi introdurre varianti tema o mode-specific styling

Se una modifica riguarda solo una singola schermata e non rappresenta una regola condivisa, probabilmente non deve finire qui.
