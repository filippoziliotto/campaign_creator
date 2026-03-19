#!/usr/bin/env bash
# Production server — no hot-reload, 2 workers.
set -e
cd "$(dirname "$0")/.."
uvicorn server.api.app:app --workers 2 --host 0.0.0.0 --port 8000
