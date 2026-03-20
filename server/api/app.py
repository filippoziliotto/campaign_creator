from __future__ import annotations

from typing import Any

from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from server import CampaignRequest, load_options, render_prompt


class GeneratePromptResponse(BaseModel):
    prompt: str


def create_app() -> FastAPI:
    api = FastAPI(
        title="Creatore Campagne D&D API",
        description="API HTTP per opzioni campagna e generazione prompt.",
        version="0.1.0",
    )

    # Keep CORS open so mobile/web frontends can call this API in development.
    api.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    @api.get("/health")
    def health() -> dict[str, str]:
        return {"status": "ok"}

    @api.get("/options")
    def options(lang: str = Query(default="it", pattern="^(it|en)$")) -> dict[str, Any]:
        try:
            return load_options(lang=lang)
        except Exception as exc:  # pragma: no cover - runtime safety fallback
            raise HTTPException(status_code=500, detail=f"Failed loading options: {exc}") from exc

    @api.post("/generate", response_model=GeneratePromptResponse)
    def generate(request: CampaignRequest) -> GeneratePromptResponse:
        try:
            return GeneratePromptResponse(prompt=render_prompt(request))
        except Exception as exc:  # pragma: no cover - runtime safety fallback
            raise HTTPException(status_code=500, detail=f"Failed rendering prompt: {exc}") from exc

    return api


app = create_app()
