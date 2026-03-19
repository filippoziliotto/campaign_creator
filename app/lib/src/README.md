# src

Questa cartella contiene tutto il codice applicativo del frontend Flutter, escluso il bootstrap minimo in `lib/main.dart`.
L'obiettivo della struttura e separare chiaramente:

1. configurazione runtime
2. modelli dati
3. integrazione backend
4. sistema visivo
5. interfaccia utente e orchestrazione della flow

## Vista d'insieme

Il frontend segue una pipeline semplice ma esplicita:

1. `app.dart` crea il `MaterialApp` e applica il tema globale.
2. `config/` espone i valori runtime necessari al client.
3. `services/` parla con il backend Python via HTTP.
4. `models/` definisce il contratto dati tra backend e UI.
5. `ui/` costruisce la flow dell'app a partire dai modelli ottenuti dal service layer.

## File principali

- `app.dart`: entrypoint applicativo del layer `src`. Registra titolo, tema e pagina root del frontend, oggi situata in `ui/pages/shell/`.

## Cartelle

- `config/`: configurazione letta a runtime tramite `--dart-define` o valori di default.
- `models/`: tipi del dominio frontend, parsing JSON e payload inviati al backend.
- `services/`: infrastruttura di accesso ai dati esterni. In questo progetto e il client HTTP verso FastAPI.
- `theme/`: design system dell'app. Palette, tipografia e temi dei componenti Material.
- `ui/`: shell, route page e widget della flow utente.

## Regole di dipendenza

Per mantenere il codice leggibile e facile da evolvere:

- `ui/` puo dipendere da `theme/`, `services/`, `models/` e `config/`.
- `services/` puo dipendere da `models/`.
- `models/` non deve dipendere da `ui/` o `services/`.
- `theme/` non deve conoscere il backend o i modelli di dominio.
- `config/` deve rimanere minimale e priva di logica di business.

## Dove intervenire

- Se cambia l'host o la configurazione ambiente: `config/`
- Se cambia il payload del backend: `models/` e `services/`
- Se cambia il look and feel globale: `theme/`
- Se cambia la navigazione o la flow: `ui/`

## Nota architetturale attuale

La cartella `ui/pages/` non e piu piatta: ora e separata in `shell/`, `routes/`, `design/` e `parchment/`.
La parte ancora piu densa rimane `ui/pages/shell/campaign_builder_page.dart`, che oggi e il controller della flow:

- carica i dati iniziali
- mantiene lo stato del form
- orchestra la navigazione tra `Entry`, `Forge` e `Pergamena`
- costruisce i payload verso il backend

Se in futuro si vorra fare un ulteriore salto di qualita, la prossima estrazione naturale e un controller/store dedicato che sposti fuori dalla shell lo stato del builder.
