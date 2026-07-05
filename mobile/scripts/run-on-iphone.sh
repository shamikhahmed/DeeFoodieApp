#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

API_URL="${API_BASE_URL:-http://localhost:3000}"

echo "DeeFoodieApp — real iPhone run"
echo "API: $API_URL"
echo ""
echo "Plug in iPhone, trust Mac, then:"
echo "  flutter devices"
echo ""

if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter not found in PATH"
  exit 1
fi

flutter pub get
flutter devices

DEVICE_ID="${1:-}"
if [[ -z "$DEVICE_ID" ]]; then
  DEVICE_ID="$(flutter devices 2>/dev/null | rg 'iPhone|ios' | head -1 | awk -F '•' '{print $2}' | xargs || true)"
fi

if [[ -z "$DEVICE_ID" ]]; then
  echo "No iOS device found. Pass device id: ./scripts/run-on-iphone.sh <device-id>"
  exit 1
fi

echo "Running on: $DEVICE_ID"
flutter run -d "$DEVICE_ID" \
  --dart-define=API_BASE_URL="$API_URL" \
  --release
