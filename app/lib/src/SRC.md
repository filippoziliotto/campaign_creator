# src

Questa cartella contiene tutto il codice applicativo del frontend Flutter, escluso il bootstrap minimo in `lib/main.dart`.
L'obiettivo della struttura e separare chiaramente:

1. modelli dati
2. servizi locali e asset bundle
3. sistema visivo
4. interfaccia utente e orchestrazione della flow

## Vista d'insieme

L'app segue una pipeline semplice ma esplicita:

1. `app.dart` crea il `MaterialApp` e applica il tema globale.
2. `services/` carica gli asset YAML/template e rende il prompt localmente.
3. `models/` definisce il contratto dati tra UI e service layer.
4. `ui/` costruisce la flow dell'app a partire dai modelli ottenuti dal service layer.

## File principali

- `app.dart`: entrypoint applicativo del layer `src`. Registra titolo, tema e pagina root del frontend, oggi situata in `ui/pages/shell/`.

## Cartelle

- `models/`: tipi del dominio frontend e helper di parsing delle opzioni.
- `services/`: caricamento asset locali e generazione del prompt on-device.
- `theme/`: design system dell'app. Palette, tipografia e temi dei componenti Material.
- `ui/`: shell, route page e widget della flow utente.
- `monetization/`: modulo di monetizzazione. Ad unit ID, servizi wrapper per ads e acquisti in-app, preferenze, coordinatore policy.

## Regole di dipendenza

Per mantenere il codice leggibile e facile da evolvere:

- `ui/` puo dipendere da `theme/`, `services/`, `models/` e `monetization/`.
- `services/` puo dipendere da `models/`.
- `models/` non deve dipendere da `ui/`, `services/` o `monetization/`.
- `theme/` non deve conoscere la logica di caricamento dati o i dettagli del prompt engine.
- `monetization/` non deve dipendere da `ui/`, `theme/` o `services/`. Puo dipendere da `shared_preferences` e dai plugin di ads/acquisti.

## Dove intervenire

- Se cambiano opzioni, preset o template: `assets/` e `services/`
- Se cambia il contratto dei modelli o il parsing: `models/`
- Se cambia il look and feel globale: `theme/`
- Se cambia la navigazione o la flow: `ui/`

## Nota architetturale attuale

La cartella `ui/pages/` non e piu piatta: ora e separata in `shell/`, `routes/`, `design/` e `parchment/`.
La parte ancora piu densa rimane `ui/pages/shell/campaign_builder_page.dart`, che oggi e il controller della flow:

- carica i dati iniziali
- mantiene lo stato del form
- orchestra la navigazione tra `Entry`, `Forge` e `Pergamena`
- costruisce le richieste verso il service locale di campagna

Se in futuro si vorra fare un ulteriore salto di qualita, la prossima estrazione naturale e un controller/store dedicato che sposti fuori dalla shell lo stato del builder.
