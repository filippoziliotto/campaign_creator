from __future__ import annotations

import streamlit as st

from layout import render_ui

st.set_page_config(
    page_title="Creatore Campagne D&D",
    page_icon="d20",
    layout="wide",
)


if __name__ == "__main__":
    try:
        render_ui()
    except Exception as exc:  # pragma: no cover - runtime safety fallback
        st.error("Si e verificato un errore durante il rendering della pagina.")
        st.exception(exc)
