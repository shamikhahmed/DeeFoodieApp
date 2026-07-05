#!/usr/bin/env bash
# Fix real_page_flip iOS build: createPlayer → makePlayer (Xcode 15+ / CoreHaptics API).
set -euo pipefail
CACHE="${PUB_CACHE:-$HOME/.pub-cache}"
FOUND=0
while IFS= read -r -d '' f; do
  FOUND=1
  if grep -q 'createPlayer(with:' "$f"; then
    if [[ "$(uname)" == Darwin ]]; then
      sed -i '' 's/createPlayer(with:/makePlayer(with:/g' "$f"
    else
      sed -i 's/createPlayer(with:/makePlayer(with:/g' "$f"
    fi
    echo "patched $f"
  fi
done < <(find "$CACHE" -path '*/real_page_flip-*/ios/real_page_flip/Sources/real_page_flip/RealPageFlipPlugin.swift' -print0 2>/dev/null || true)
if [ "$FOUND" -eq 0 ]; then
  echo "patch-real-page-flip: plugin not found (skip)"
fi
