# Streamlit App

Frontend Streamlit separato dalla logica backend.

## File
- `__init__.py`: export del runner frontend.
- `app.py`: bootstrap Streamlit (page config + gestione errori runtime).
- `layout.py`: composizione pagina, form, orchestrazione chiamate backend.
- `actions.py`: gestione stato UI (preset, randomizzazione, default session state).
- `widgets.py`: componenti UI riusabili (pills, indicatori, bottoni copia/apri ChatGPT).
- `styles.py`: CSS custom e caricamento texture decorative.
- `assets/`: immagini e SVG usati dallo stile dell'app.
