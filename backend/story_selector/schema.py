"""Schema and option loading for campaign prompt inputs."""

from __future__ import annotations

from pathlib import Path
from typing import Any, Literal

import yaml
from pydantic import BaseModel, Field, model_validator


class CampaignRequest(BaseModel):
    """Validated input model consumed by the prompt builder."""

    setting: str = Field(..., min_length=2, max_length=80)
    campaign_type: str = Field(..., min_length=2, max_length=80)
    theme_preferences: list[str] = Field(default_factory=list)
    tone_preferences: list[str] = Field(default_factory=list)
    style_preferences: list[str] = Field(default_factory=list)
    party_level: int = Field(..., ge=1, le=20)
    party_size: int = Field(..., ge=1, le=8)
    party_archetypes: list[str] = Field(default_factory=list)
    twist: str = Field(..., min_length=2, max_length=140)
    narrative_hooks: str = Field(default="", max_length=1200)
    character_notes: str = Field(default="", max_length=1200)
    constraints: str = Field(default="", max_length=1200)
    factions: str = Field(default="", max_length=800)
    npc_focus: str = Field(default="", max_length=400)
    encounter_focus: str = Field(default="", max_length=400)
    safety_notes: str = Field(default="", max_length=800)
    include_npcs: bool = True
    include_encounters: bool = True
    language: Literal["Italiano"] = "Italiano"

    @model_validator(mode="after")
    def validate_party_archetypes(self) -> "CampaignRequest":
        if len(self.party_archetypes) > self.party_size:
            raise ValueError(
                "Il numero di archetipi non puo superare la dimensione del party."
            )

        self.theme_preferences = _normalize_preferences(self.theme_preferences, "tema")
        self.tone_preferences = _normalize_preferences(self.tone_preferences, "tono")
        self.style_preferences = _normalize_preferences(self.style_preferences, "stile")
        return self


def _normalize_preferences(values: list[str], field_name: str) -> list[str]:
    cleaned: list[str] = []
    for value in values:
        text = value.strip()
        if not text:
            continue
        if len(text) > 80:
            raise ValueError(f"Una preferenza {field_name} supera il limite di 80 caratteri.")
        if text not in cleaned:
            cleaned.append(text)
    return cleaned


def _default_options_path() -> Path:
    return Path(__file__).resolve().parent / "data" / "options.yaml"


def load_options(path: str | Path | None = None) -> dict[str, Any]:
    """Load controlled option lists and presets from YAML."""

    source = Path(path) if path else _default_options_path()
    with source.open("r", encoding="utf-8") as handle:
        data = yaml.safe_load(handle) or {}

    required_keys = {
        "settings",
        "campaign_types",
        "themes",
        "tones",
        "styles",
        "party_archetypes",
        "twists",
        "presets",
    }
    missing = sorted(required_keys - set(data))
    if missing:
        raise ValueError(f"Missing keys in options file: {', '.join(missing)}")

    return data
