# Forgia Prompt Campagne D&D

Generatore prompt per campagne D&D con:
- frontend Streamlit (web)
- frontend Flutter (mobile)
- backend Python condiviso

La lingua di output resta italiano.

## Architettura
- `frontend/streamlit_app/`: UI Streamlit che usa direttamente i moduli backend Python.
- `frontend/flutter_app/`: UI Flutter che chiama backend via API HTTP.
- `backend/story_selector/`: validazione input, regole di generazione prompt, rendering template.
- `backend/api/`: adapter FastAPI con endpoint `/health`, `/options`, `/generate`.
- `app.py`: entrypoint minimale per avviare Streamlit.

## Setup Python
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Avvio Streamlit
```bash
streamlit run app.py
```

## Avvio API Backend (per Flutter)
```bash
uvicorn backend.api.app:app --reload --host 0.0.0.0 --port 8000
```

## Avvio Flutter
Prerequisito: Flutter SDK installato.

```bash
cd frontend/flutter_app
flutter create .          # necessario solo la prima volta per generare i folder piattaforma
flutter pub get
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

Per Android emulator usa `http://10.0.2.2:8000`.

## Struttura
```text
.
├── app.py
├── backend
│   ├── __init__.py
│   ├── api
│   │   ├── __init__.py
│   │   └── app.py
│   └── story_selector
│       ├── __init__.py
│       ├── schema.py
│       ├── prompt_builder.py
│       ├── render.py
│       ├── data
│       │   └── options.yaml
│       └── templates
│           ├── prompt_template.md
│           ├── prompt_template_one_shot.md
│           ├── prompt_template_mini_campaign.md
│           ├── prompt_template_long_campaign.md
│           └── prompt_template_dungeon_exploration.md
├── frontend
│   ├── streamlit_app
│   │   ├── app.py
│   │   ├── layout.py
│   │   ├── actions.py
│   │   ├── widgets.py
│   │   ├── styles.py
│   │   └── assets
│   │       ├── parchment.jpg
│   │       ├── watermark_dragon.png
│   │       └── divider.svg
│   └── flutter_app
│       ├── pubspec.yaml
│       └── lib
│           ├── main.dart
│           └── src
│               ├── config
│               ├── models
│               ├── services
│               └── ui
├── requirements.txt
├── LICENSE
└── .gitignore
```

## Esempio output
L'app produce un prompt con sezioni stabili:
- Dati campagna
- Vincoli e tono
- Struttura richiesta
- Formato output

Da copiare e incollare direttamente su ChatGPT.
