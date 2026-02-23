from __future__ import annotations

import random
from typing import Any

import streamlit as st


def apply_preset(preset_name: str, presets: dict[str, dict[str, object]]) -> None:
    preset_values = presets[preset_name]
    for key, value in preset_values.items():
        if key == "theme":
            st.session_state["theme_preferences"] = [str(value)]
            continue
        if key == "tone":
            st.session_state["tone_preferences"] = [str(value)]
            continue
        if key == "style":
            st.session_state["style_preferences"] = [str(value)]
            continue
        st.session_state[key] = value


def randomize_closed_choices(options: dict[str, Any]) -> None:
    settings = list(options["settings"])
    themes = list(options["themes"])
    tones = list(options["tones"])
    styles = list(options["styles"])
    twists = list(options["twists"])
    archetypes = list(options["party_archetypes"])

    st.session_state["setting"] = random.choice(settings)
    st.session_state["twist"] = random.choice(twists)

    theme_count = random.randint(1, min(2, len(themes)))
    tone_count = random.randint(1, min(2, len(tones)))
    style_count = random.randint(1, min(2, len(styles)))
    st.session_state["theme_preferences"] = random.sample(themes, k=theme_count)
    st.session_state["tone_preferences"] = random.sample(tones, k=tone_count)
    st.session_state["style_preferences"] = random.sample(styles, k=style_count)

    st.session_state["party_level"] = random.randint(1, 10)

    archetype_count = random.randint(0, min(6, len(archetypes)))
    if archetype_count == 0:
        st.session_state["party_archetypes"] = []
        st.session_state["party_size"] = 3
    else:
        st.session_state["party_archetypes"] = random.sample(archetypes, k=archetype_count)
        st.session_state["party_size"] = archetype_count


def apply_selected_preset(presets: dict[str, dict[str, object]]) -> None:
    preset_name = str(st.session_state.get("preset_name", ""))
    if preset_name in presets:
        apply_preset(preset_name, presets)
        st.session_state["active_preset_name"] = preset_name
        st.session_state["ui_toast_message"] = "🧙 Preset applicato"


def randomize_and_notify(options: dict[str, Any]) -> None:
    randomize_closed_choices(options)
    st.session_state["active_preset_name"] = ""
    st.session_state["just_rolled_dice"] = True
    st.session_state["ui_toast_message"] = "🎲 Il fato ha lanciato i dadi"


def init_state(options: dict[str, Any]) -> None:
    presets = options["presets"]
    default_preset = next(iter(presets))

    if "preset_name" not in st.session_state:
        st.session_state["preset_name"] = default_preset

    if st.session_state["preset_name"] not in presets:
        st.session_state["preset_name"] = default_preset

    st.session_state.setdefault("active_preset_name", "")
    st.session_state.setdefault("setting", options["settings"][0])
    st.session_state.setdefault("campaign_type", options["campaign_types"][0])
    st.session_state.setdefault("twist", options["twists"][0])
    if "party_level" not in st.session_state:
        st.session_state["party_level"] = 3
    if "party_size" not in st.session_state:
        st.session_state["party_size"] = 4
    st.session_state.setdefault("party_archetypes", [])
    st.session_state.setdefault("narrative_hooks", "")
    st.session_state.setdefault("character_notes", "")
    st.session_state.setdefault("constraints", "")
    st.session_state.setdefault("custom_twist", "")
    st.session_state.setdefault("custom_setting", "")
    st.session_state.setdefault("custom_theme", "")
    st.session_state.setdefault("factions", "")
    st.session_state.setdefault("npc_focus", "")
    st.session_state.setdefault("encounter_focus", "")
    st.session_state.setdefault("safety_notes", "")
    st.session_state.setdefault("include_npcs", True)
    st.session_state.setdefault("include_encounters", True)
    st.session_state.setdefault("just_forged", False)
    st.session_state.setdefault("just_rolled_dice", False)
    st.session_state.setdefault("theme_preferences", [])
    st.session_state.setdefault("tone_preferences", [])
    st.session_state.setdefault("style_preferences", [])

    if st.session_state["setting"] not in options["settings"]:
        st.session_state["setting"] = options["settings"][0]
    if st.session_state["campaign_type"] not in options["campaign_types"]:
        st.session_state["campaign_type"] = options["campaign_types"][0]
    if st.session_state["twist"] not in options["twists"]:
        st.session_state["twist"] = options["twists"][0]
    if not isinstance(st.session_state["party_level"], int) or not (
        1 <= st.session_state["party_level"] <= 20
    ):
        st.session_state["party_level"] = 3
    if not isinstance(st.session_state["party_size"], int) or not (
        1 <= st.session_state["party_size"] <= 7
    ):
        st.session_state["party_size"] = 4

    if (
        not st.session_state["theme_preferences"]
        and st.session_state.get("theme") in options["themes"]
    ):
        st.session_state["theme_preferences"] = [st.session_state["theme"]]
    if (
        not st.session_state["tone_preferences"]
        and st.session_state.get("tone") in options["tones"]
    ):
        st.session_state["tone_preferences"] = [st.session_state["tone"]]
    if (
        not st.session_state["style_preferences"]
        and st.session_state.get("style") in options["styles"]
    ):
        st.session_state["style_preferences"] = [st.session_state["style"]]
