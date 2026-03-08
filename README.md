# Forgia Prompt Campagne D&D

Web app Streamlit per creare un prompt strutturato da incollare su ChatGPT e generare una campagna D&D.
La lingua di output e sempre italiano.

## Obiettivo
L'app e ora divisa in frontend e backend Python:
- `frontend/streamlit_app/`: interfaccia Streamlit (input, preset, output, stile)
- `backend/`: validazione input, regole di generazione prompt, rendering template
- `app.py`: entrypoint Streamlit minimale che avvia il frontend

## Avvio locale
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
streamlit run app.py
```

## Pubblicazione rapida su Streamlit Community Cloud
1. Pubblica il repo su GitHub.
2. Crea una nuova app su Streamlit Cloud.
3. Seleziona il repo e imposta `app.py` come entrypoint.
4. Pubblica.

## Struttura
```text
.
├── app.py
├── backend
│   ├── __init__.py
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
│   └── streamlit_app
│       ├── app.py
│       ├── layout.py
│       ├── actions.py
│       ├── widgets.py
│       ├── styles.py
│       └── assets
│           ├── parchment.jpg
│           ├── watermark_dragon.png
│           └── divider.svg
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
