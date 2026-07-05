#!/usr/bin/env bash
# Expose local NestJS API to internet via ngrok (free tier — URL rotates).
set -euo pipefail
API_PORT="${API_PORT:-3000}"
if ! command -v ngrok >/dev/null 2>&1; then
  echo "Install ngrok: https://ngrok.com/download"
  echo "Then: ngrok config add-authtoken <token>"
  exit 1
fi
echo "Tunneling http://localhost:$API_PORT"
echo "Set Flutter: flutter run --dart-define=API_BASE_URL=<ngrok-https-url>"
exec ngrok http "$API_PORT"
