from __future__ import annotations

import base64
import mimetypes
from pathlib import Path

import streamlit as st

_APP_DIR = Path(__file__).resolve().parent
_ASSETS_DIR = _APP_DIR / "assets"

_GRAIN_FALLBACK_URI = (
    "data:image/svg+xml;base64,"
    "PHN2ZyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHdpZHRoPScxMjAnIGhlaWdodD0nMTIwJyB2aWV3Qm94PScwIDAgMTIwIDEyMCc+PGZpbHRlciBpZD0nbm9pc2UnPjxmZVR1cmJ1bGVuY2UgdHlwZT0nZnJhY3RhbE5vaXNlJyBiYXNlRnJlcXVlbmN5PScwLjg1JyBudW1PY3RhdmVzPScyJyBzdGl0Y2hUaWxlcz0nc3RpdGNoJy8+PC9maWx0ZXI+PHJlY3Qgd2lkdGg9JzEyMCcgaGVpZ2h0PScxMjAnIGZpbHRlcj0ndXJsKCNub2lzZSknIG9wYWNpdHk9JzAuMDg1Jy8+PC9zdmc+"
)

_WATERMARK_FALLBACK_URI = (
    "data:image/svg+xml;base64,"
    "PHN2ZyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHdpZHRoPSc0MjAnIGhlaWdodD0nNDIwJyB2aWV3Qm94PScwIDAgNDIwIDQyMCc+PGcgZmlsbD0nbm9uZScgc3Ryb2tlPScjNmM0ZjI2JyBzdHJva2Utb3BhY2l0eT0nMC4xMycgc3Ryb2tlLXdpZHRoPSc5Jz48Y2lyY2xlIGN4PScyMTAnIGN5PScyMTAnIHI9JzE0OCcvPjxwYXRoIGQ9J00yMTAgNzggTDI2NSAyMTAgTDIxMCAzNDIgTDE1NSAyMTAgWicvPjxwYXRoIGQ9J00yMTAgMTIwIEwyMTAgMzAwJy8+PHBhdGggZD0nTTEyMCAyMTAgTDMwMCAyMTAnLz48L2c+PC9zdmc+"
)


def _asset_data_uri(filename: str, fallback: str = "") -> str:
    asset_path = _ASSETS_DIR / filename
    if not asset_path.exists():
        return fallback
    try:
        mime_type, _ = mimetypes.guess_type(asset_path.name)
        mime_type = mime_type or "application/octet-stream"
        encoded = base64.b64encode(asset_path.read_bytes()).decode("ascii")
        return f"data:{mime_type};base64,{encoded}"
    except OSError:
        return fallback


_GRAIN_TEXTURE_URI = _asset_data_uri("parchment.jpg", _GRAIN_FALLBACK_URI)
_WATERMARK_TEXTURE_URI = _asset_data_uri("watermark_dragon.png", _WATERMARK_FALLBACK_URI)
_DIVIDER_TEXTURE_URI = _asset_data_uri("divider.svg")


def get_divider_texture_uri() -> str:
    return _DIVIDER_TEXTURE_URI


def inject_styles() -> None:
    css = r"""
        <style>
        @import url('https://fonts.googleapis.com/css2?family=Cinzel:wght@500;700;900&family=Cinzel+Decorative:wght@700&family=Crimson+Text:ital,wght@0,400;0,600;0,700;1,400;1,600&display=swap');

        /* ── Base ─────────────────────────────────────────── */
        html, body, [class*="css"] {
            font-family: 'Crimson Text', serif;
            line-height: 1.5;
        }

        h1, h2, h3, h4 {
            font-family: 'Cinzel', serif;
            letter-spacing: 0.05em;
        }

        /* ── App background — aged parchment ─────────────── */
        .stApp {
            background-image:
                linear-gradient(rgba(240, 228, 200, 0.50), rgba(240, 228, 200, 0.50)),
                url("__GRAIN_TEXTURE__"),
                url("__WATERMARK_TEXTURE__"),
                radial-gradient(ellipse at 8% 6%, rgba(180, 130, 50, 0.28), transparent 38%),
                radial-gradient(ellipse at 92% 94%, rgba(30, 55, 90, 0.22), transparent 40%),
                linear-gradient(150deg, #f0e2c2 0%, #e0c89a 40%, #c9a86c 100%);
            background-repeat: no-repeat, repeat, no-repeat, no-repeat, no-repeat, no-repeat;
            background-size: auto, 200px 200px, 340px 340px, auto, auto, auto;
            background-position: center, left top, right 1.5rem bottom 1rem, center, center, center;
            background-blend-mode: normal, overlay, normal, normal, normal, normal;
        }

        .block-container {
            padding-top: 1.5rem;
            padding-bottom: 3rem;
            max-width: 1240px;
        }

        /* ── Hero — Quest Board ───────────────────────────── */
        .hero {
            position: relative;
            background: linear-gradient(145deg, #1a0e05 0%, #2e1a0a 40%, #1e1208 100%);
            border: 2px solid #c49a2a;
            border-radius: 4px;
            padding: 1.6rem 2rem 1.5rem;
            margin-bottom: 1.2rem;
            box-shadow:
                0 0 0 4px rgba(92, 58, 14, 0.6),
                0 0 0 7px rgba(196, 154, 42, 0.18),
                0 16px 48px rgba(20, 10, 2, 0.55);
            overflow: hidden;
        }

        /* Corner ornaments via pseudo-elements */
        .hero::before, .hero::after {
            content: '✦';
            position: absolute;
            color: #c49a2a;
            font-size: 1.1rem;
            opacity: 0.75;
        }
        .hero::before { top: 0.5rem; left: 0.7rem; }
        .hero::after  { bottom: 0.5rem; right: 0.7rem; }

        .hero h1 {
            margin: 0;
            color: #f5e8c0;
            font-family: 'Cinzel Decorative', 'Cinzel', serif;
            font-size: 2.1rem;
            font-weight: 700;
            text-shadow:
                0 0 18px rgba(196, 154, 42, 0.5),
                0 2px 4px rgba(0,0,0,0.8);
            letter-spacing: 0.07em;
        }

        .hero p {
            margin: 0.45rem 0 0;
            color: #d4bc8a;
            font-family: 'Crimson Text', serif;
            font-style: italic;
            font-size: 1.08rem;
            letter-spacing: 0.02em;
        }

        /* decorative rule inside hero */
        .hero-rule {
            border: none;
            border-top: 1px solid rgba(196, 154, 42, 0.4);
            margin: 0.85rem 0 0.7rem;
        }

        /* ── Section subheaders — Chapter titles ─────────── */
        [data-testid="stSubheader"],
        .stSubheader {
            font-family: 'Cinzel', serif !important;
            font-size: 1.08rem !important;
            font-weight: 700 !important;
            color: #2a1508 !important;
            letter-spacing: 0.06em !important;
            border-left: 3px solid #9b2317;
            padding-left: 0.6rem;
            margin-bottom: 0.5rem !important;
        }

        /* ── Containers — Leather-bound panels ───────────── */
        [data-testid="stVerticalBlockBorderWrapper"] {
            background:
                linear-gradient(180deg, rgba(253, 246, 228, 0.90) 0%, rgba(244, 231, 202, 0.86) 100%);
            border: 1px solid rgba(148, 108, 42, 0.50);
            border-top: 2px solid rgba(155, 35, 23, 0.55);
            border-radius: 6px;
            box-shadow:
                0 4px 18px rgba(50, 28, 6, 0.14),
                inset 0 1px 0 rgba(255, 240, 200, 0.6);
            margin-bottom: 0.4rem;
        }

        /* ── Caption — flavor text ────────────────────────── */
        [data-testid="stCaptionContainer"] p,
        .stCaption {
            font-style: italic !important;
            color: #6b4c2a !important;
            font-size: 0.93rem !important;
            letter-spacing: 0.01em;
        }

        /* ── Widget labels ────────────────────────────────── */
        [data-testid="stWidgetLabel"] p {
            color: #2e1a08;
            font-family: 'Cinzel', serif;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 0.04em;
            text-transform: uppercase;
        }

        /* ── Pills — Tavern Board Tags ────────────────────── */
        /* single-select pill (selected) */
        [data-testid="stPills"] [aria-selected="true"] > div {
            background: linear-gradient(160deg, #9b2317 0%, #6e1910 100%) !important;
            color: #f7e9cf !important;
            border: 1px solid #c04535 !important;
            border-radius: 3px !important;
            font-family: 'Cinzel', serif !important;
            font-size: 0.78rem !important;
            font-weight: 700 !important;
            letter-spacing: 0.05em !important;
            text-transform: uppercase !important;
            box-shadow: 0 2px 8px rgba(100, 20, 10, 0.4) !important;
        }

        /* unselected pill */
        [data-testid="stPills"] [aria-selected="false"] > div {
            background: rgba(252, 244, 222, 0.80) !important;
            color: #3d2510 !important;
            border: 1px solid rgba(148, 108, 42, 0.45) !important;
            border-radius: 3px !important;
            font-family: 'Cinzel', serif !important;
            font-size: 0.78rem !important;
            letter-spacing: 0.04em !important;
            text-transform: uppercase !important;
        }

        [data-testid="stPills"] [aria-selected="false"] > div:hover {
            background: rgba(244, 228, 190, 0.95) !important;
            border-color: rgba(155, 100, 35, 0.7) !important;
            color: #1e0e05 !important;
        }

        /* ── Segmented control ────────────────────────────── */
        [data-testid="stSegmentedControl"] button[aria-selected="true"] {
            background: linear-gradient(160deg, #9b2317, #6e1910) !important;
            color: #f7e9cf !important;
            border-radius: 3px !important;
            font-family: 'Cinzel', serif !important;
            font-size: 0.75rem !important;
            letter-spacing: 0.05em !important;
        }

        [data-testid="stSegmentedControl"] button {
            font-family: 'Cinzel', serif !important;
            font-size: 0.75rem !important;
            letter-spacing: 0.04em !important;
            color: #3d2510 !important;
        }

        /* ── Selectbox & Multiselect ─────────────────────── */
        .stTextArea textarea,
        .stSelectbox div[data-baseweb="select"],
        .stMultiSelect div[data-baseweb="select"],
        .stNumberInput input {
            background: rgba(255, 251, 240, 0.90) !important;
            border: 1px solid rgba(148, 108, 42, 0.40) !important;
            border-radius: 4px !important;
            color: #2a1508 !important;
            font-family: 'Crimson Text', serif !important;
            font-size: 1rem !important;
        }

        .stTextArea textarea::placeholder {
            color: #9a7a55 !important;
            font-style: italic;
        }

        /* multiselect tags */
        [data-baseweb="tag"] {
            background: rgba(155, 35, 23, 0.15) !important;
            border: 1px solid rgba(155, 35, 23, 0.35) !important;
            border-radius: 3px !important;
            color: #5a1a12 !important;
            font-family: 'Cinzel', serif !important;
            font-size: 0.74rem !important;
            letter-spacing: 0.03em !important;
        }

        /* ── Toggle ──────────────────────────────────────── */
        [data-testid="stToggle"] [data-checked="true"] {
            background-color: #9b2317 !important;
        }

        /* ── Expander ─────────────────────────────────────── */
        [data-testid="stExpander"] summary {
            font-family: 'Cinzel', serif !important;
            font-size: 0.82rem !important;
            letter-spacing: 0.04em !important;
            color: #3d2510 !important;
            font-weight: 700 !important;
        }

        /* ── Primary button — Crimson seal ───────────────── */
        [data-testid="stButton"] > button[kind="primary"],
        [data-testid="stBaseButton-primary"] {
            border-radius: 3px;
            border: 1px solid #7a1e14;
            border-bottom: 3px solid #5a1510;
            background: linear-gradient(180deg, #c23124 0%, #8f2018 50%, #6e1910 100%);
            color: #f7e8cc;
            font-family: 'Cinzel', serif;
            font-size: 0.86rem;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            box-shadow:
                0 4px 16px rgba(100, 20, 10, 0.38),
                inset 0 1px 0 rgba(255, 200, 170, 0.18);
            transition: all 0.15s ease;
        }

        [data-testid="stButton"] > button[kind="primary"]:hover,
        [data-testid="stBaseButton-primary"]:hover {
            background: linear-gradient(180deg, #d4ac4a 0%, #b8892e 50%, #9a7020 100%);
            border-color: #8a6518;
            border-bottom-color: #6a4e12;
            color: #1e1005;
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(160, 110, 20, 0.40);
        }

        [data-testid="stButton"] > button[kind="primary"]:active,
        [data-testid="stBaseButton-primary"]:active {
            transform: translateY(1px);
            border-bottom-width: 1px;
        }

        /* ── Secondary button ─────────────────────────────── */
        [data-testid="stBaseButton-secondary"] {
            border: 1px solid rgba(148, 108, 42, 0.55);
            border-bottom: 2px solid rgba(120, 85, 30, 0.5);
            background: linear-gradient(180deg, rgba(255,249,236,0.92), rgba(242,228,196,0.88));
            color: #2e1a08;
            border-radius: 3px;
            font-family: 'Cinzel', serif;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            transition: all 0.15s ease;
        }

        [data-testid="stBaseButton-secondary"]:hover {
            border-color: rgba(155, 100, 35, 0.8);
            background: linear-gradient(180deg, rgba(246,233,200,0.98), rgba(235,215,178,0.95));
            color: #1a0e05;
            transform: translateY(-1px);
        }

        /* ── Party KPI badge ──────────────────────────────── */
        .party-kpi {
            background: linear-gradient(135deg, rgba(30, 18, 6, 0.88), rgba(50, 30, 10, 0.82));
            border: 1px solid rgba(196, 154, 42, 0.5);
            border-radius: 4px;
            padding: 0.6rem 0.85rem;
            margin-top: 0.4rem;
            box-shadow: 0 3px 12px rgba(20, 10, 2, 0.3);
        }

        .party-kpi-label {
            display: block;
            color: #a08050;
            font-family: 'Cinzel', serif;
            font-size: 0.72rem;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            line-height: 1.1;
        }

        .party-kpi-value {
            display: block;
            color: #f5e8c0;
            font-family: 'Cinzel', serif;
            font-size: 1.25rem;
            font-weight: 700;
            line-height: 1.25;
            margin-top: 0.12rem;
            text-shadow: 0 0 12px rgba(196, 154, 42, 0.35);
        }

        /* ── Quest summary pills ──────────────────────────── */
        .quest-summary {
            display: flex;
            flex-wrap: wrap;
            gap: 0.4rem;
            margin: 0.5rem 0 0.5rem;
        }

        .quest-pill {
            background: linear-gradient(160deg, rgba(30, 18, 6, 0.82), rgba(45, 27, 8, 0.78));
            border: 1px solid rgba(196, 154, 42, 0.45);
            border-radius: 2px;
            padding: 0.3rem 0.72rem;
            font-family: 'Cinzel', serif;
            font-size: 0.82rem;
            letter-spacing: 0.04em;
            color: #e8d5a8;
            box-shadow: 0 2px 6px rgba(10, 5, 0, 0.25);
        }

        /* ── Preset seal ──────────────────────────────────── */
        .preset-seal {
            display: inline-block;
            margin-top: 0.25rem;
            background: linear-gradient(160deg, #9b2317, #6e1910);
            border: 1px solid rgba(196, 154, 42, 0.6);
            border-radius: 2px;
            color: #f7e9cf;
            padding: 0.28rem 0.8rem;
            font-family: 'Cinzel', serif;
            font-size: 0.82rem;
            letter-spacing: 0.05em;
            box-shadow: 0 2px 8px rgba(100, 20, 10, 0.35);
        }

        /* ── Preset description ───────────────────────────── */
        .preset-description {
            margin-top: 0.4rem;
            padding: 0.6rem 0.8rem;
            border-radius: 4px;
            background: rgba(255, 249, 235, 0.82);
            border-left: 3px solid rgba(155, 35, 23, 0.6);
            color: #3d2510;
            font-family: 'Crimson Text', serif;
            font-style: italic;
            font-size: 0.97rem;
            line-height: 1.4;
        }

        /* ── Ornament divider ─────────────────────────────── */
        .ornament-divider {
            text-align: center;
            margin: 0.2rem 0;
            line-height: 0;
            color: rgba(111, 77, 29, 0.9);
            font-size: 0.98rem;
            letter-spacing: 0.22rem;
            pointer-events: none;
        }

        .ornament-divider img {
            width: min(260px, 68%);
            opacity: 0.78;
            filter: sepia(45%) saturate(80%);
            vertical-align: middle;
            display: block;
            margin: 0 auto;
        }

        /* text fallback divider */
        .ornament-divider-text {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            margin: 0.4rem 0;
            color: rgba(148, 108, 42, 0.65);
            font-size: 0.75rem;
            letter-spacing: 0.18rem;
        }

        .ornament-divider-text::before,
        .ornament-divider-text::after {
            content: '';
            flex: 1;
            border-top: 1px solid rgba(148, 108, 42, 0.35);
        }

        /* ── Parchment output ─────────────────────────────── */
        .parchment-output {
            position: relative;
            background:
                linear-gradient(180deg, rgba(253, 246, 228, 0.97) 0%, rgba(242, 228, 198, 0.93) 100%);
            border: 1px solid rgba(148, 108, 42, 0.50);
            border-top: 3px solid rgba(148, 108, 42, 0.60);
            border-radius: 4px;
            padding: 1.2rem 1.3rem 1rem;
            max-height: 500px;
            overflow-y: auto;
            box-shadow:
                inset 0 2px 12px rgba(90, 60, 20, 0.10),
                0 8px 28px rgba(40, 22, 6, 0.16);
        }

        /* scroll custom */
        .parchment-output::-webkit-scrollbar { width: 8px; }
        .parchment-output::-webkit-scrollbar-track { background: rgba(220, 200, 160, 0.3); border-radius: 4px; }
        .parchment-output::-webkit-scrollbar-thumb { background: rgba(148, 108, 42, 0.45); border-radius: 4px; }

        /* top decorative label */
        .parchment-output::before {
            content: '— Pergamena —';
            display: block;
            text-align: center;
            font-family: 'Cinzel', serif;
            font-size: 0.72rem;
            letter-spacing: 0.18em;
            color: rgba(148, 108, 42, 0.6);
            margin-bottom: 0.7rem;
            text-transform: uppercase;
        }

        .parchment-output pre {
            margin: 0;
            white-space: pre-wrap;
            word-wrap: break-word;
            color: #1e1208;
            font-family: 'Crimson Text', serif;
            font-size: 1.05rem;
            line-height: 1.6;
        }

        /* ── Toast ────────────────────────────────────────── */
        [data-testid="stToast"] {
            background: linear-gradient(135deg, #1e1208, #2e1a0a) !important;
            border: 1px solid rgba(196, 154, 42, 0.5) !important;
            color: #f5e8c0 !important;
            border-radius: 4px !important;
            font-family: 'Cinzel', serif !important;
            font-size: 0.85rem !important;
            letter-spacing: 0.04em !important;
        }

        /* ── Info/Success alerts ──────────────────────────── */
        [data-testid="stAlert"] {
            border-radius: 4px !important;
            font-family: 'Crimson Text', serif !important;
            font-size: 1rem !important;
        }

        /* ── Sidebar ──────────────────────────────────────── */
        [data-testid="stSidebar"] {
            background: linear-gradient(180deg, rgba(28, 18, 8, 0.97), rgba(18, 12, 6, 0.97));
            border-right: 1px solid rgba(196, 154, 42, 0.30);
        }

        [data-testid="stSidebar"] * {
            color: #e8d5a8;
        }
        </style>
    """
    css = css.replace("__GRAIN_TEXTURE__", _GRAIN_TEXTURE_URI).replace(
        "__WATERMARK_TEXTURE__", _WATERMARK_TEXTURE_URI
    )
    st.markdown(css, unsafe_allow_html=True)