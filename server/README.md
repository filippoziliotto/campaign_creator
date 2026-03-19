# Backend

Questa cartella contiene tutta la logica Python del backend.

## File
- `__init__.py`: espone l'API backend pubblica (`CampaignRequest`, `load_options`, `render_prompt`).
- `story_selector/`: package core di validazione, regole e rendering prompt.
- `api/`: adapter FastAPI per esporre endpoint HTTP consumabili da frontend esterni (es. Flutter).
