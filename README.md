# Forgia Prompt Campagne D&D

Web app Streamlit per creare un prompt strutturato da incollare su ChatGPT e generare una campagna D&D.
La lingua di output e sempre italiano.

## Obiettivo
L'app separa la logica dall'interfaccia:
- `story_selector/`: validazione, regole, rendering prompt
- `app.py`: interfaccia Streamlit (input, preset, output)

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
├── requirements.txt
├── story_selector
│   ├── __init__.py
│   ├── schema.py
│   ├── prompt_builder.py
│   ├── render.py
│   ├── data
│   │   └── options.yaml
│   └── templates
│       └── prompt_template.md
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
