from __future__ import annotations

import streamlit as st
from pydantic import ValidationError

from actions import apply_selected_preset, init_state, randomize_and_notify
from story_selector import CampaignRequest, load_options, render_prompt
from styles import inject_styles
from widgets import (
    chip_choice,
    chip_multi_choice,
    render_open_chatgpt_button,
    preset_choice,
    render_copy_prompt_button,
    render_parchment_output,
    render_quest_summary,
    section_divider,
    segmented_choice,
    setting_choice,
)


def render_ui() -> None:
    options = load_options()
    inject_styles()
    init_state(options)
    pending_toast_message = st.session_state.pop("ui_toast_message", "")
    if pending_toast_message:
        st.toast(pending_toast_message)

    # ── Hero ──────────────────────────────────────────────────────────
    st.markdown(
        """
        <div class="hero">
            <h1>⚔️ Creatore Campagne D&amp;D</h1>
            <hr class="hero-rule">
            <p>Forgia la tua avventura. Configura la campagna e genera un prompt pronto da incollare su ChatGPT.</p>
        </div>
        """,
        unsafe_allow_html=True,
    )

    render_quest_summary()
    section_divider()

    # ── Two-column layout ─────────────────────────────────────────────
    left_col, right_col = st.columns(2, gap="large")

    # ── LEFT: Campagna ────────────────────────────────────────────────
    with left_col:
        st.subheader("🗺️ Campagna")

        with st.container(border=True):
            st.caption("✦ Mondo e formato")
            setting = setting_choice(
                "Ambientazione",
                options["settings"],
                options.get("setting_descriptions", {}),
                key="setting",
            )
            campaign_type = chip_choice(
                "Tipo di campagna",
                options["campaign_types"],
                key="campaign_type",
            )

        section_divider()

        with st.container(border=True):
            st.caption("✦ Tono e stile narrativo")
            theme_preferences = chip_multi_choice(
                "Tema",
                options["themes"],
                key="theme_preferences",
                help_text="Seleziona uno o più temi. Clic per attivare/disattivare.",
            )
            tone_preferences = chip_multi_choice(
                "Tono",
                options["tones"],
                key="tone_preferences",
                help_text="Seleziona uno o più toni. Clic per attivare/disattivare.",
            )
            style_preferences = chip_multi_choice(
                "Stile",
                options["styles"],
                key="style_preferences",
                help_text="Seleziona uno o più stili. Clic per attivare/disattivare.",
            )

        section_divider()

        with st.container(border=True):
            st.caption("✦ Direzione narrativa")
            twist = chip_choice("Colpo di scena", options["twists"], key="twist")
            output_length = segmented_choice(
                "Lunghezza output",
                options["output_lengths"],
                key="output_length",
            )
            st.caption("📜 Il prompt viene generato sempre in italiano.")

    # ── RIGHT: Party e Vincoli ────────────────────────────────────────
    with right_col:
        st.subheader("⚔️ Party e Vincoli")

        with st.container(border=True):
            st.caption("✦ Composizione del gruppo")
            level_col, size_col = st.columns(2)
            with level_col:
                party_level = st.selectbox(
                    "Livello party",
                    options=list(range(1, 21)),
                    key="party_level",
                    help="Livello medio del gruppo avventuriero.",
                )
            with size_col:
                party_size = st.selectbox(
                    "Dimensione party",
                    options=list(range(1, 8)),
                    key="party_size",
                    help="Numero di personaggi giocanti.",
                )
            party_archetypes = st.multiselect(
                "Composizione party (classi / ruoli)",
                options["party_archetypes"],
                key="party_archetypes",
                help=(
                    "Indica le classi o i ruoli dei PG. "
                    "Lascia vuoto per lasciare al modello la scelta."
                ),
            )
            st.markdown(
                (
                    "<div class='party-kpi'>"
                    "<span class='party-kpi-label'>📋 Riepilogo rapido</span>"
                    f"<span class='party-kpi-value'>⚔️ Lv {party_level}"
                    f"&nbsp;&nbsp;|&nbsp;&nbsp;👥 {party_size} PG</span>"
                    "</div>"
                ),
                unsafe_allow_html=True,
            )

        section_divider()

        with st.container(border=True):
            st.caption("✦ Vincoli e input narrativi")
            narrative_hooks = st.text_area(
                "Ganci narrativi preferiti",
                key="narrative_hooks",
                height=105,
                placeholder="Es: mistero su una città volante, reliquia rubata, rivalità tra casate...",
            )
            character_notes = st.text_area(
                "Nomi o note sui personaggi",
                key="character_notes",
                height=105,
                placeholder="Es: un paladino in crisi di fede, una ladra ex-spia, un mago ossessionato dai portali.",
            )
            constraints = st.text_area(
                "Limiti e preferenze",
                key="constraints",
                height=105,
                placeholder="Una riga per vincolo. Es: no romanticismo, no orrore corporeo, focus su diplomazia.",
            )
            with st.expander("⚙️ Avanzato: NPC, fazioni, incontri, safety", expanded=False):
                include_npcs = st.toggle("Includi PNG chiave", key="include_npcs")
                include_encounters = st.toggle(
                    "Includi incontri strutturati", key="include_encounters"
                )
                factions = st.text_area(
                    "Fazioni coinvolte (opzionale)",
                    key="factions",
                    height=80,
                    placeholder="Es: gilda dei mercanti, culto draconico, casata nobiliare rivale.",
                )
                npc_focus = st.text_input(
                    "Focus PNG (opzionale)",
                    key="npc_focus",
                    placeholder="Es: PNG moralmente ambiguo che tradisce a metà campagna.",
                )
                encounter_focus = st.text_input(
                    "Focus incontri (opzionale)",
                    key="encounter_focus",
                    placeholder="Es: pochi combattimenti, più investigazione e dilemmi sociali.",
                )
                safety_notes = st.text_area(
                    "Safety e contenuti sensibili (opzionale)",
                    key="safety_notes",
                    height=80,
                    placeholder="Es: evita body horror, niente violenza esplicita.",
                )

        section_divider()

        with st.container(border=True):
            st.caption("✦ Preset e casualità")
            preset_choice(
                "Preset rapido",
                list(options["presets"].keys()),
                options.get("preset_descriptions", {}),
                key="preset_name",
            )
            preset_col, random_col = st.columns(2)
            with preset_col:
                st.button(
                    "🧙 Applica preset",
                    use_container_width=True,
                    on_click=apply_selected_preset,
                    args=(options["presets"],),
                )
            with random_col:
                st.button(
                    "🎲 Tira i dadi",
                    use_container_width=True,
                    on_click=randomize_and_notify,
                    args=(options,),
                )
            st.caption("Il preset precompila i campi chiusi. Il dado crea una bozza casuale.")

    # ── Generate ──────────────────────────────────────────────────────
    section_divider()
    generate_clicked = st.button(
        "📜 Forgia la Pergamena", type="primary", use_container_width=True
    )

    if generate_clicked:
        try:
            request = CampaignRequest(
                setting=setting,
                campaign_type=campaign_type,
                theme_preferences=theme_preferences,
                tone_preferences=tone_preferences,
                style_preferences=style_preferences,
                party_level=party_level,
                party_size=party_size,
                party_archetypes=party_archetypes,
                twist=twist,
                narrative_hooks=narrative_hooks,
                character_notes=character_notes,
                constraints=constraints,
                factions=factions,
                npc_focus=npc_focus,
                encounter_focus=encounter_focus,
                safety_notes=safety_notes,
                output_length=output_length,
                include_npcs=include_npcs,
                include_encounters=include_encounters,
            )
            st.session_state["generated_prompt"] = render_prompt(request)
            st.session_state["just_forged"] = True
            st.toast("📜 Pergamena forgiata con successo!")
        except ValidationError as exc:
            st.error(f"⚠️ Input non validi: {exc}")

    if st.session_state.pop("just_forged", False):
        st.success("✨ La pergamena è pronta. Copiane il contenuto o aprila direttamente in ChatGPT.")

    # ── Output ────────────────────────────────────────────────────────
    section_divider()
    st.subheader("📜 Pergamena Generata")

    generated_prompt = st.session_state.get("generated_prompt", "")
    if generated_prompt:
        render_parchment_output(generated_prompt)
        action_left, action_right = st.columns(2)
        with action_left:
            render_copy_prompt_button(generated_prompt)
        with action_right:
            render_open_chatgpt_button(generated_prompt)
    else:
        st.info("⚗️ Configura la campagna e forgia la tua pergamena per vederla qui.")