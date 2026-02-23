from __future__ import annotations

import base64
from html import escape

import streamlit as st
import streamlit.components.v1 as components

from styles import get_divider_texture_uri


def chip_choice(
    label: str, options: list[str], key: str, help_text: str | None = None
) -> str:
    if key not in st.session_state or st.session_state[key] not in options:
        st.session_state[key] = options[0]

    if hasattr(st, "pills"):
        value = st.pills(
            label,
            options,
            selection_mode="single",
            key=key,
            help=help_text,
        )
        return value if value is not None else st.session_state[key]

    return st.selectbox(label, options, key=key, help=help_text)


def setting_choice(
    label: str,
    options: list[str],
    descriptions: dict[str, str],
    key: str,
) -> str:
    selected_setting = chip_choice(label, options, key=key)
    if selected_setting in descriptions:
        st.caption(f"{descriptions[selected_setting]}")

    return selected_setting


def preset_choice(
    label: str,
    options: list[str],
    descriptions: dict[str, str],
    key: str,
) -> str:
    selected_preset = chip_choice(label, options, key=key)
    description = str(descriptions.get(selected_preset, "")).strip()
    if description:
        lines = [escape(line.strip()) for line in description.splitlines() if line.strip()]
        rendered = "<br>".join(lines)
        st.markdown(
            f"<div class='preset-description'>{rendered}</div>",
            unsafe_allow_html=True,
        )
    return selected_preset


def chip_multi_choice(
    label: str, options: list[str], key: str, help_text: str | None = None
) -> list[str]:
    raw_value = st.session_state.get(key, [])
    if isinstance(raw_value, str):
        normalized = [raw_value] if raw_value in options else []
    elif isinstance(raw_value, list):
        normalized = [item for item in raw_value if item in options]
    else:
        normalized = []
    st.session_state[key] = normalized

    if hasattr(st, "pills"):
        value = st.pills(
            label,
            options,
            selection_mode="multi",
            key=key,
            help=help_text,
        )
        return value if value is not None else st.session_state[key]

    return st.multiselect(label, options, key=key, help=help_text)


def segmented_choice(
    label: str, options: list[str], key: str, help_text: str | None = None
) -> str:
    if key not in st.session_state or st.session_state[key] not in options:
        st.session_state[key] = options[0]

    if hasattr(st, "segmented_control"):
        value = st.segmented_control(
            label,
            options,
            selection_mode="single",
            key=key,
            help=help_text,
        )
        return value if value is not None else st.session_state[key]

    return st.radio(label, options, key=key, horizontal=True, help=help_text)


def section_divider() -> None:
    divider_texture_uri = get_divider_texture_uri()
    if divider_texture_uri:
        st.markdown(
            (
                "<div class='ornament-divider'>"
                f"<img src='{divider_texture_uri}' alt='decorative divider'></div>"
            ),
            unsafe_allow_html=True,
        )
    else:
        st.markdown("<div class='ornament-divider'>✦ ✦ ✦</div>", unsafe_allow_html=True)


def render_quest_summary() -> None:
    custom_setting = str(st.session_state.get("custom_setting", "")).strip()
    setting_text = custom_setting if custom_setting else str(st.session_state.get("setting", "-"))

    custom_theme_raw = str(st.session_state.get("custom_theme", "")).strip()
    if custom_theme_raw:
        custom_theme_values = [
            item.strip()
            for item in custom_theme_raw.replace("\n", ",").replace(";", ",").split(",")
            if item.strip()
        ]
        theme_text = ", ".join(custom_theme_values[:2]) if custom_theme_values else "mix libero"
    else:
        theme_values = st.session_state.get("theme_preferences", [])
        theme_text = ", ".join(theme_values[:2]) if theme_values else "mix libero"

    summary_items = [
        f"🗺️ {setting_text}",
        f"⚔️ Lv {st.session_state.get('party_level', '-')}",
        f"👥 {st.session_state.get('party_size', '-')} PG",
        f"🕯️ {theme_text}",
        f"🧩 {st.session_state.get('twist', '-')}",
    ]

    pills = "".join(
        f"<span class='quest-pill'>{escape(str(item))}</span>" for item in summary_items
    )
    st.markdown(f"<div class='quest-summary'>{pills}</div>", unsafe_allow_html=True)

    active_preset = str(st.session_state.get("active_preset_name", "")).strip()
    if active_preset:
        preset_label = escape(active_preset)
        st.markdown(
            f"<div class='preset-seal'>🧙 Preset attivo: {preset_label}</div>",
            unsafe_allow_html=True,
        )


def render_context_completeness_indicator(
    narrative_hooks: str,
    character_notes: str,
    constraints: str,
    factions: str,
    npc_focus: str,
    encounter_focus: str,
    safety_notes: str,
) -> None:
    def _filled(value: str) -> bool:
        return bool((value or "").strip())

    advanced_filled = any(_filled(item) for item in (factions, npc_focus, encounter_focus))

    sections = [
        ("Ganci narrativi", _filled(narrative_hooks)),
        ("Note personaggi", _filled(character_notes)),
        ("Limiti e preferenze", _filled(constraints)),
        ("Dettagli avanzati", advanced_filled),
        ("Safety", _filled(safety_notes)),
    ]
    completed_sections = sum(is_done for _, is_done in sections)
    total_sections = len(sections)
    progress_percent = int((completed_sections / total_sections) * 100)

    if completed_sections <= 1:
        quality_text = "Contesto ancora essenziale."
    elif completed_sections <= 3:
        quality_text = "Contesto buono."
    else:
        quality_text = "Contesto ricco."

    st.caption(
        f"🧭 Completezza contesto: {completed_sections}/{total_sections} sezioni compilate."
    )
    st.progress(progress_percent)
    st.caption(quality_text)

    missing_sections = [label for label, is_done in sections if not is_done]
    if missing_sections:
        st.caption("Per arricchire il prompt puoi aggiungere: " + ", ".join(missing_sections))


def render_dice_roll_animation() -> None:
    st.markdown(
        """
        <div class="dice-roll-flash">
            <span class="dice-roll-icon">🎲</span>
            <span class="dice-roll-text">Il fato rimescola i fili del destino...</span>
        </div>
        """,
        unsafe_allow_html=True,
    )


def render_parchment_output(prompt_text: str) -> None:
    with st.container(border=True):
        with st.container(height=460):
            st.markdown(prompt_text)


def render_copy_prompt_button(prompt_text: str) -> None:
    encoded = base64.b64encode(prompt_text.encode("utf-8")).decode("ascii")
    button_id = f"copy_prompt_{abs(hash(prompt_text)) % 10_000_000}"
    components.html(
        f"""
        <div style="display:flex;align-items:center;gap:0.7rem;">
            <button id="{button_id}"
                style="
                    width:100%;
                    border:1px solid rgba(125, 28, 20, 0.95);
                    border-radius:999px;
                    background:linear-gradient(180deg,#b4281d 0%,#8a1f16 100%);
                    color:#fff3de;
                    padding:0.5rem 0.9rem;
                    font-size:0.95rem;
                    font-weight:700;
                    cursor:pointer;
                ">
                📋 Copia prompt
            </button>
        </div>
        <div id="{button_id}_status"
            style="font-size:0.82rem;color:#644a2b;margin-top:0.2rem;min-height:1.2rem;"></div>
        <script>
        const btn = document.getElementById("{button_id}");
        const status = document.getElementById("{button_id}_status");
        btn.addEventListener("click", async () => {{
            try {{
                const bytes = Uint8Array.from(atob("{encoded}"), c => c.charCodeAt(0));
                const text = new TextDecoder().decode(bytes);
                await navigator.clipboard.writeText(text);
                status.textContent = "Prompt copiato negli appunti.";
            }} catch (err) {{
                status.textContent = "Impossibile copiare automaticamente in questo browser.";
            }}
            setTimeout(() => {{ status.textContent = ""; }}, 2200);
        }});
        </script>
        """,
        height=78,
    )


def render_open_chatgpt_button(prompt_text: str) -> None:
    encoded = base64.b64encode(prompt_text.encode("utf-8")).decode("ascii")
    button_id = f"open_chatgpt_{abs(hash(prompt_text)) % 10_000_000}"
    components.html(
        f"""
        <div style="display:flex;align-items:center;gap:0.7rem;">
            <button id="{button_id}"
                style="
                    width:100%;
                    border:1px solid rgba(125, 28, 20, 0.95);
                    border-radius:999px;
                    background:linear-gradient(180deg,#b4281d 0%,#8a1f16 100%);
                    color:#fff3de;
                    padding:0.5rem 0.9rem;
                    font-size:0.95rem;
                    font-weight:700;
                    cursor:pointer;
                ">
                🚀 Apri ChatGPT (prompt copiato)
            </button>
        </div>
        <div id="{button_id}_status"
            style="font-size:0.82rem;color:#644a2b;margin-top:0.2rem;min-height:1.2rem;"></div>
        <script>
        const btn = document.getElementById("{button_id}");
        const status = document.getElementById("{button_id}_status");
        btn.addEventListener("click", async () => {{
            let copied = false;
            try {{
                const bytes = Uint8Array.from(atob("{encoded}"), c => c.charCodeAt(0));
                const text = new TextDecoder().decode(bytes);
                await navigator.clipboard.writeText(text);
                copied = true;
            }} catch (err) {{
                copied = false;
            }}

            const win = window.open("https://chatgpt.com", "_blank", "noopener,noreferrer");
            if (!win) {{
                status.textContent = copied
                    ? "Prompt copiato. Popup bloccato: apri manualmente chatgpt.com."
                    : "Popup bloccato e copia non riuscita in questo browser.";
            }} else {{
                status.textContent = copied
                    ? "ChatGPT aperto. Incolla con Cmd/Ctrl+V."
                    : "ChatGPT aperto. Copia automatica non riuscita, copia manualmente il prompt.";
            }}
            setTimeout(() => {{ status.textContent = ""; }}, 2800);
        }});
        </script>
        """,
        height=84,
    )
