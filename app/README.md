# Flutter Frontend

Frontend mobile in Flutter che usa il backend Python via HTTP.

## Stato del progetto

Questo repository contiene il codice Dart del frontend (`lib/`) e le cartelle
piattaforma Flutter (`android/`, `ios/`, `web/`, `macos/`, `windows/`, `linux/`).

## Setup rapido

1. Installa Flutter SDK.
2. Installa dipendenze:

   ```bash
   flutter pub get
   ```

3. Avvia l'app (dev locale):

   ```bash
   # iOS simulator
   flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
   # Android emulator
   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
   ```

## API richiesta

L'app richiede i seguenti endpoint dal backend Python:

- `GET /options`
- `POST /generate`
- `GET /health`

## Build di produzione

**Android:**

1. Genera il keystore (una tantum) — vedi `android/key.properties.example`
2. Crea `android/key.properties` con le tue credenziali (file gitignored)
3. Esegui il build:

   ```bash
   flutter build appbundle --dart-define=API_BASE_URL=https://tuo-backend.com
   ```

**iOS:**

```bash
flutter build ipa --dart-define=API_BASE_URL=https://tuo-backend.com
```

> Il flag `--dart-define=API_BASE_URL=...` è obbligatorio per i build di produzione.
> Senza di esso l'app non raggiungerà il backend.
