#!/usr/bin/env bash
# Development server — uses --reload for hot-restart.
# For production use: bash scripts/start_server_prod.sh
set -e
cd "$(dirname "$0")/.."
uvicorn server.api.app:app --reload --host 0.0.0.0 --port 8000
