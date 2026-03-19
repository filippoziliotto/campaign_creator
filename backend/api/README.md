# API

Adapter HTTP (FastAPI) sopra il backend Python, utile per frontend esterni come Flutter.

## File
- `__init__.py`: export dell'app FastAPI.
- `app.py`: definisce l'app e gli endpoint.

## Endpoint
- `GET /health`: check di stato.
- `GET /options`: restituisce le opzioni campagna da `options.yaml`.
- `POST /generate`: valida input e restituisce il prompt generato.
