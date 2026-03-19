"""Template rendering and final prompt cleanup."""

from __future__ import annotations

import re
from pathlib import Path

from jinja2 import Environment, FileSystemLoader

from .prompt_builder import build_prompt_context
from .schema import CampaignRequest

_DEFAULT_TEMPLATE_NAME = "prompt_template.md"
_TEMPLATE_DIR = Path(__file__).resolve().parent / "templates"
_TEMPLATE_BY_CAMPAIGN_TYPE = {
    "one-shot": "prompt_template_one_shot.md",
    "one shot": "prompt_template_one_shot.md",
    "oneshot": "prompt_template_one_shot.md",
    "avventura singola": "prompt_template_one_shot.md",
    "mini-campagna": "prompt_template_mini_campaign.md",
    "mini campagna": "prompt_template_mini_campaign.md",
    "mini-campaign": "prompt_template_mini_campaign.md",
    "mini campaign": "prompt_template_mini_campaign.md",
    "campagna lunga": "prompt_template_long_campaign.md",
    "long campaign": "prompt_template_long_campaign.md",
    "esplorazione dungeon": "prompt_template_dungeon_exploration.md",
    "dungeon crawl": "prompt_template_dungeon_exploration.md",
}


def _build_environment() -> Environment:
    return Environment(
        loader=FileSystemLoader(str(_TEMPLATE_DIR)),
        trim_blocks=True,
        lstrip_blocks=True,
        autoescape=False,
    )


def _post_process(text: str) -> str:
    text = re.sub(r"[ \t]+\n", "\n", text)
    text = re.sub(r"\n{3,}", "\n\n", text)
    return text.strip() + "\n"


def _select_template_name(campaign_type: str) -> str:
    normalized_type = " ".join(campaign_type.strip().lower().split())
    return _TEMPLATE_BY_CAMPAIGN_TYPE.get(normalized_type, _DEFAULT_TEMPLATE_NAME)


def render_prompt(request: CampaignRequest) -> str:
    """Render the final markdown prompt from a validated request."""

    env = _build_environment()
    template_name = _select_template_name(request.campaign_type)
    template = env.get_template(template_name)
    rendered = template.render(**build_prompt_context(request))
    return _post_process(rendered)
