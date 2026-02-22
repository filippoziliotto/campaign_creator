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
    """Return a data URI for a local asset file, with graceful fallback."""
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
    css = """
        <style>
        @import url('https://fonts.googleapis.com/css2?family=Cinzel:wght@500;700&family=Crimson+Text:wght@400;600;700&display=swap');

        html, body, [class*="css"] {
            font-family: 'Crimson Text', serif;
            line-height: 1.45;
        }

        h1, h2, h3 {
            font-family: 'Cinzel', serif;
            letter-spacing: 0.04em;
        }

        .stApp {
            background-image:
                linear-gradient(rgba(245, 236, 214, 0.42), rgba(245, 236, 214, 0.42)),
                url("__GRAIN_TEXTURE__"),
                url("__WATERMARK_TEXTURE__"),
                radial-gradient(circle at 5% 5%, rgba(193, 154, 64, 0.25), transparent 33%),
                radial-gradient(circle at 95% 95%, rgba(43, 74, 108, 0.2), transparent 38%),
                linear-gradient(130deg, #efe2c4 0%, #dfccaa 45%, #ceb88e 100%);
            background-repeat: no-repeat, repeat, no-repeat, no-repeat, no-repeat, no-repeat;
            background-size: auto, 260px 260px, 300px 300px, auto, auto, auto;
            background-position: center, left top, right 1.2rem bottom 0.8rem, center, center, center;
            background-blend-mode: normal, soft-light, normal, normal, normal, normal;
        }

        .block-container {
            padding-top: 1.3rem;
            padding-bottom: 2.5rem;
            max-width: 1220px;
        }

        .hero {
            background: linear-gradient(132deg, rgba(31, 23, 13, 0.95), rgba(70, 45, 16, 0.88));
            border: 1px solid rgba(221, 176, 80, 0.75);
            border-radius: 18px;
            padding: 1.2rem 1.4rem;
            margin-bottom: 1rem;
            box-shadow: 0 10px 35px rgba(34, 20, 3, 0.22);
        }

        .hero h1 {
            margin: 0;
            color: #f6eedb;
            font-size: 2rem;
        }

        .hero p {
            margin: 0.32rem 0 0;
            color: #f3e7cf;
            font-size: 1.06rem;
        }

        [data-testid="stSidebar"] {
            background: linear-gradient(180deg, rgba(42, 28, 11, 0.95), rgba(26, 20, 14, 0.95));
            border-right: 1px solid rgba(208, 165, 81, 0.35);
        }

        [data-testid="stSidebar"] * {
            color: #f5ead3;
        }

        [data-testid="stVerticalBlockBorderWrapper"] {
            background: linear-gradient(180deg, rgba(252, 244, 226, 0.82), rgba(243, 229, 197, 0.78));
            border: 1px solid rgba(160, 122, 53, 0.35);
            border-radius: 16px;
            box-shadow: 0 6px 24px rgba(57, 35, 9, 0.12);
            margin-bottom: 0.3rem;
        }

        [data-testid="stWidgetLabel"] p {
            color: #3f2d1b;
            font-weight: 700;
            letter-spacing: 0.01em;
        }

        .stTextArea textarea,
        .stSelectbox div[data-baseweb="select"],
        .stMultiSelect div[data-baseweb="select"],
        .stNumberInput input,
        .stSlider {
            background: rgba(255, 249, 238, 0.86);
        }

        .stSelectbox div[data-baseweb="select"] {
            border: 1px solid rgba(169, 131, 63, 0.45);
            border-radius: 12px;
        }

        [data-testid="stButton"] > button[kind="primary"],
        [data-testid="stBaseButton-primary"] {
            border-radius: 999px;
            border: 1px solid rgba(125, 28, 20, 0.95);
            background: linear-gradient(180deg, #b4281d 0%, #8a1f16 100%);
            color: #fff3de;
            font-weight: 700;
            box-shadow: 0 6px 16px rgba(95, 20, 14, 0.35);
            transition: all 0.18s ease;
        }

        [data-testid="stButton"] > button[kind="primary"]:hover,
        [data-testid="stBaseButton-primary"]:hover {
            border-color: rgba(181, 140, 56, 0.95);
            background: linear-gradient(180deg, #e0b763 0%, #bf8d39 100%);
            color: #2a1c0f;
            transform: translateY(-1px);
        }

        [data-testid="stBaseButton-secondary"] {
            border-color: rgba(169, 131, 63, 0.45);
            background: rgba(255, 249, 238, 0.84);
            color: #3f2d1b;
            border-radius: 999px;
        }

        [data-testid="stBaseButton-secondary"]:hover {
            border-color: rgba(160, 98, 34, 0.8);
            background: rgba(246, 233, 201, 0.92);
            color: #2d1f11;
        }

        .party-kpi {
            background: rgba(255, 249, 238, 0.82);
            border: 1px solid rgba(169, 131, 63, 0.35);
            border-radius: 14px;
            padding: 0.55rem 0.75rem;
            margin-top: 0.35rem;
        }

        .party-kpi-label {
            display: block;
            color: #5f4930;
            font-size: 0.86rem;
            line-height: 1.1;
        }

        .party-kpi-value {
            display: block;
            color: #2f2214;
            font-family: 'Cinzel', serif;
            font-size: 1.2rem;
            line-height: 1.2;
            margin-top: 0.1rem;
        }

        .quest-summary {
            display: flex;
            flex-wrap: wrap;
            gap: 0.45rem;
            margin: 0.45rem 0 0.45rem;
        }

        .quest-pill {
            background: rgba(248, 236, 205, 0.82);
            border: 1px solid rgba(167, 129, 58, 0.42);
            border-radius: 999px;
            padding: 0.28rem 0.68rem;
            font-size: 0.96rem;
            color: #332413;
        }

        .preset-seal {
            display: inline-block;
            margin-top: 0.2rem;
            background: linear-gradient(180deg, rgba(161, 43, 33, 0.95), rgba(126, 31, 24, 0.95));
            border: 1px solid rgba(206, 167, 89, 0.72);
            border-radius: 999px;
            color: #f7e9cf;
            padding: 0.25rem 0.76rem;
            font-size: 0.9rem;
        }

        .preset-description {
            margin-top: 0.35rem;
            padding: 0.55rem 0.7rem;
            border-radius: 12px;
            background: rgba(255, 249, 238, 0.78);
            border: 1px solid rgba(169, 131, 63, 0.32);
            color: #4a3621;
            font-size: 0.93rem;
            line-height: 1.35;
        }

        .ornament-divider {
            text-align: center;
            margin: 0.05rem 0;
            line-height: 0;
            color: rgba(111, 77, 29, 0.9);
            font-size: 0.98rem;
            letter-spacing: 0.22rem;
            pointer-events: none;
        }

        .ornament-divider img {
            width: min(280px, 74%);
            opacity: 0.84;
            filter: sepia(40%) saturate(85%);
            vertical-align: middle;
            display: block;
            margin: 0 auto;
        }

        .parchment-output {
            background: linear-gradient(180deg, rgba(252, 244, 226, 0.95), rgba(241, 227, 196, 0.9));
            border: 1px solid rgba(162, 122, 51, 0.45);
            border-radius: 16px;
            padding: 1rem 1.1rem;
            max-height: 460px;
            overflow-y: auto;
            box-shadow: inset 0 1px 8px rgba(92, 65, 28, 0.12);
        }

        .parchment-output pre {
            margin: 0;
            white-space: pre-wrap;
            word-wrap: break-word;
            color: #2b1e12;
            font-family: 'Crimson Text', serif;
            font-size: 1.03rem;
            line-height: 1.5;
        }
        </style>
        """
    css = css.replace("__GRAIN_TEXTURE__", _GRAIN_TEXTURE_URI).replace(
        "__WATERMARK_TEXTURE__", _WATERMARK_TEXTURE_URI
    )
    st.markdown(css, unsafe_allow_html=True)
