# Campaign Forge — D&D Campaign Creator

A D&D campaign prompt generator with a Flutter mobile app and a Python API backend.

## Architecture

- `app/` — Flutter frontend (iOS + Android)
- `server/` — Python FastAPI backend
  - `server/api/` — HTTP endpoints (`/health`, `/options`, `/generate`)
  - `server/story_selector/` — prompt generation logic, templates, schema
- `docs/` — privacy policy and project documentation

## Setup

### Backend

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r server/requirements.txt
```

Start the server:

```bash
bash scripts/start_server.sh
# or directly:
uvicorn server.api.app:app --reload --host 0.0.0.0 --port 8000
```

### Flutter App

Requires Flutter SDK.

```bash
cd app
flutter pub get
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

For Android emulator use `http://10.0.2.2:8000`.

## Structure

```text
.
├── .github/
│   └── workflows/
│       ├── flutter.yml
│       └── server.yml
├── app/
│   ├── lib/
│   │   ├── main.dart
│   │   └── src/
│   │       ├── app.dart
│   │       ├── config/
│   │       ├── models/
│   │       ├── services/
│   │       ├── theme/
│   │       └── ui/
│   ├── android/
│   ├── ios/
│   ├── assets/
│   └── pubspec.yaml
├── server/
│   ├── api/
│   │   └── app.py
│   ├── story_selector/
│   │   ├── schema.py
│   │   ├── prompt_builder.py
│   │   ├── render.py
│   │   ├── data/
│   │   │   └── options.yaml
│   │   └── templates/
│   └── requirements.txt
├── docs/
│   └── privacy_policy.md
├── scripts/
│   └── start_server.sh
├── .env.example
├── LICENSE
└── README.md
```

## Output

The app produces a structured D&D campaign prompt ready to paste into ChatGPT.
