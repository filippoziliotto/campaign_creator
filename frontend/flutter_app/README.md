# Flutter Frontend

Frontend mobile in Flutter che usa il backend Python via HTTP.

## Stato del progetto
Questo repository contiene il codice Dart del frontend (`lib/`).
Le cartelle piattaforma (`android/`, `ios/`, `web/`, `macos/`, `windows/`, `linux/`) non sono incluse.

## Setup rapido
1. Installa Flutter SDK.
2. Da `frontend/flutter_app`, genera i file piattaforma se mancanti:
   ```bash
   flutter create .
   ```
3. Installa dipendenze:
   ```bash
   flutter pub get
   ```
4. Avvia l'app:
   ```bash
   flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
   ```

## API richiesta
L'app richiede i seguenti endpoint dal backend Python:
- `GET /options`
- `POST /generate`
- `GET /health`

## Note emulatori
- Android emulator: usa `http://10.0.2.2:8000`
- iOS simulator: usa `http://127.0.0.1:8000`
