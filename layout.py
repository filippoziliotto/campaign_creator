from __future__ import annotations

import streamlit as st
from pydantic import ValidationError

from actions import apply_selected_preset, init_state, randomize_and_notify
from story_selector import CampaignRequest, load_options, render_prompt
from styles import inject_styles
from widgets import (
    chip_multi_choice,
    render_context_completeness_indicator,
    render_dice_roll_animation,
    render_open_chatgpt_button,
    preset_choice,
    render_copy_prompt_button,
    render_parchment_output,
    render_quest_summary,
    section_divider,
    setting_choice,
)


_CAMPAIGN_ENTRY_CHOICES: list[tuple[str, str, str]] = [
    ("⚡ One-shot", "One-Shot", "1 sessione, ritmo rapido e payoff immediato."),
    ("🧭 Campagna breve", "Mini-campagna", "3-6 sessioni con progressione e cliffhanger."),
    ("👑 Campagna lunga", "Campagna lunga", "Archi narrativi estesi e sviluppo del mondo."),
    ("🗝️ Esplorazione dungeon", "Esplorazione dungeon", "Focus su mappe, rischio e scoperte multi-sessione."),
]


def _parse_custom_list(raw_text: str) -> list[str]:
    normalized = raw_text.replace("\n", ",").replace(";", ",")
    return [item.strip() for item in normalized.split(",") if item.strip()]


def _filter_presets_by_campaign_type(
    presets: dict[str, dict[str, object]], campaign_type: str
) -> dict[str, dict[str, object]]:
    normalized_campaign_type = campaign_type.strip().lower()
    return {
        name: values
        for name, values in presets.items()
        if str(values.get("campaign_type", "")).strip().lower() == normalized_campaign_type
    }


def _activate_campaign_type(campaign_type: str) -> None:
    st.session_state["campaign_type"] = campaign_type
    st.session_state["campaign_entry_completed"] = True
    st.session_state["active_preset_name"] = ""


def _return_to_entry() -> None:
    st.session_state["campaign_entry_completed"] = False
    st.session_state["active_preset_name"] = ""


def _render_campaign_entry_page() -> None:
    st.markdown(
        """
        <div class="hero">
            <h1>⚔️ Creatore Campagne D&amp;D</h1>
            <hr class="hero-rule">
            <p>Scegli il formato della tua avventura per iniziare.</p>
        </div>
        """,
        unsafe_allow_html=True,
    )
    st.subheader("Per cosa sei qui?")
    st.caption("Scegli uno stile di campagna. Potrai sempre cambiarlo dopo.")

    row_one = st.columns(2, gap="large")
    row_two = st.columns(2, gap="large")
    columns = [row_one[0], row_one[1], row_two[0], row_two[1]]

    for col, (label, value, description) in zip(columns, _CAMPAIGN_ENTRY_CHOICES, strict=True):
        with col:
            with st.container(border=True):
                st.markdown("<span class='entry-choice-marker'></span>", unsafe_allow_html=True)
                st.markdown(f"**{label}**")
                st.caption(description)
                st.button(
                    "Seleziona",
                    type="primary",
                    use_container_width=True,
                    key=f"entry_{value}",
                    on_click=_activate_campaign_type,
                    args=(value,),
                )


def render_ui() -> None:
    options = load_options()
    inject_styles()
    init_state(options)
    st.session_state.setdefault("campaign_entry_completed", False)
    pending_toast_message = st.session_state.pop("ui_toast_message", "")
    if pending_toast_message:
        st.toast(pending_toast_message)

    if not st.session_state.get("campaign_entry_completed", False):
        _render_campaign_entry_page()
        return

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
    top_left, top_right = st.columns([4, 1])
    with top_left:
        render_quest_summary()
    with top_right:
        st.button(
            "⬅️ Cambia tipo",
            use_container_width=True,
            key="change_campaign_type_top",
            on_click=_return_to_entry,
        )

    # ── Two-column layout ─────────────────────────────────────────────
    left_col, right_col = st.columns(2, gap="large")

    # ── LEFT: Campagna ────────────────────────────────────────────────
    with left_col:
        st.subheader("🗺️ Campagna")

        with st.container(border=True):
            st.caption("✦ Mondo e formato")
            campaign_type = str(st.session_state.get("campaign_type", "Mini-campagna"))
            st.caption(f"🎯 Tipo selezionato: **{campaign_type}**")
            selected_setting = setting_choice(
                "Ambientazione",
                options["settings"],
                options.get("setting_descriptions", {}),
                key="setting",
            )
            custom_setting = st.text_input(
                "Suggerisci un'ambientazione",
                key="custom_setting",
                max_chars=80,
                placeholder="Es: arcipelago di citta-stato sospese nel cielo.",
            )
            st.caption("Se compilato, questo testo sovrascrive la scelta del menu.")
            setting = custom_setting.strip() if custom_setting.strip() else selected_setting

        #section_divider()

        with st.container(border=True):
            st.caption("✦ Tono e stile narrativo")
            selected_theme_preferences = chip_multi_choice(
                "Tema",
                options["themes"],
                key="theme_preferences",
                help_text="Seleziona uno o più temi. Clic per attivare/disattivare.",
            )
            custom_theme = st.text_input(
                "Suggerisci un tema",
                key="custom_theme",
                max_chars=240,
                placeholder="Es: rovina morale, esplorazione del proibito, redenzione.",
            )
            st.caption(
                "Se compilato, questo testo sovrascrive i temi selezionati. "
                "Puoi separare più temi con virgola."
            )
            parsed_custom_theme = _parse_custom_list(custom_theme)
            theme_preferences = (
                parsed_custom_theme if parsed_custom_theme else selected_theme_preferences
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

        #section_divider()

        with st.container(border=True):
            st.caption("✦ Direzione narrativa")
            selected_twist = st.selectbox(
                "Colpo di scena",
                options["twists"],
                key="twist",
            )
            custom_twist = st.text_input(
                "Suggerisci tu un colpo di scena",
                key="custom_twist",
                max_chars=140,
                placeholder="Es: il vero mandante è uno dei mentori dei PG.",
            )
            st.caption("Se compilato, questo testo sovrascrive la scelta del menu.")
            twist = custom_twist.strip() if custom_twist.strip() else selected_twist
            # st.caption("📜 Il prompt viene generato sempre in italiano.")

        #section_divider()

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

        #section_divider()

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
            render_context_completeness_indicator(
                narrative_hooks=narrative_hooks,
                character_notes=character_notes,
                constraints=constraints,
                factions=factions,
                npc_focus=npc_focus,
                encounter_focus=encounter_focus,
                safety_notes=safety_notes,
            )

        #section_divider()

        with st.container(border=True):
            st.caption("✦ Tira i dadi")
            st.button(
                "🎲 Tira i dadi",
                use_container_width=True,
                on_click=randomize_and_notify,
                args=(options,),
            )
            st.caption("Genera una bozza casuale sui campi chiusi, mantenendo il tipo campagna scelto.")
            if st.session_state.pop("just_rolled_dice", False):
                render_dice_roll_animation()

    with st.container(border=True):
        st.caption("✦ Preset rapido")
        filtered_presets = _filter_presets_by_campaign_type(
            options["presets"],
            campaign_type,
        )
        if filtered_presets:
            preset_choice(
                "Preset rapido",
                list(filtered_presets.keys()),
                options.get("preset_descriptions", {}),
                key="preset_name",
            )
            st.button(
                "🧙 Applica preset",
                use_container_width=True,
                on_click=apply_selected_preset,
                args=(filtered_presets,),
            )
            st.caption(
                f"Mostrati solo preset per: {campaign_type}. "
                "Applicane uno per precompilare i campi principali."
            )
        else:
            st.info(f"Nessun preset disponibile per: {campaign_type}.")

    # ── Generate ──────────────────────────────────────────────────────
    #section_divider()
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
    #section_divider()
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
