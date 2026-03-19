# story_selector

Core backend per trasformare input campagna in prompt finale.

## File
- `__init__.py`: re-export delle funzioni principali del package.
- `schema.py`: modello Pydantic `CampaignRequest` e caricamento opzioni da YAML.
- `prompt_builder.py`: regole di business per derivare contesto, vincoli e istruzioni.
- `render.py`: selezione template e rendering Jinja2 con post-processing del testo.
- `data/`: dati configurabili (liste opzioni, preset).
- `templates/`: template markdown per i diversi tipi di campagna.
