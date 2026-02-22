"""Template rendering and final prompt cleanup."""

from __future__ import annotations

import re
from pathlib import Path

from jinja2 import Environment, FileSystemLoader

from .prompt_builder import build_prompt_context
from .schema import CampaignRequest

_TEMPLATE_NAME = "prompt_template.md"
_TEMPLATE_DIR = Path(__file__).resolve().parent / "templates"


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


def render_prompt(request: CampaignRequest) -> str:
    """Render the final markdown prompt from a validated request."""

    env = _build_environment()
    template = env.get_template(_TEMPLATE_NAME)
    rendered = template.render(**build_prompt_context(request))
    return _post_process(rendered)
