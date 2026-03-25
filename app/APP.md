# Flutter Frontend

Campaign Forge ora funziona interamente offline. Le opzioni sono caricate da asset YAML inclusi nell'app e la generazione del prompt avviene sul dispositivo.

## Stato del progetto

Questo repository contiene il codice Dart del frontend (`lib/`) e le cartelle
piattaforma Flutter (`android/`, `ios/`, `web/`, `macos/`, `windows/`, `linux/`).

## Setup rapido

1. Installa Flutter SDK.
2. Installa dipendenze:

   ```bash
   flutter pub get
   ```

3. Avvia l'app:

   ```bash
   flutter run
   ```

## Dati e template inclusi

L'app usa questi asset locali:

- `assets/data/options.yaml`
- `assets/data/options_en.yaml`
- `assets/templates/prompt_template*.md`

## Build di produzione

**Android:**

1. Genera il keystore (una tantum) — vedi `android/key.properties.example`
2. Crea `android/key.properties` con le tue credenziali (file gitignored)
3. Esegui il build:

   ```bash
   flutter build appbundle
   ```

**iOS:**

```bash
flutter build ipa
```

## Nota di runtime

L'app non richiede un server locale o remoto. L'unica interazione di rete opzionale è l'apertura del sito di ChatGPT dal browser tramite l'azione dedicata.
