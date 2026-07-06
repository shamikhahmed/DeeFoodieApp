#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../assets/backgrounds"
fetch() {
  local url="$1"
  local out="$2"
  echo "→ $out"
  curl -fsSL "$url" -o "$out" || echo "  skip $out (curl failed — keep existing if any)"
}
fetch 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Seaview_%28Clifton_Beach%29_Karachi.jpg/1280px-Seaview_%28Clifton_Beach%29_Karachi.jpg' karachi_clifton_sunset.jpg
fetch 'https://upload.wikimedia.org/wikipedia/commons/4/4e/Food_street%2C_Burns_Road%2C_Karachi.jpg' karachi_food_street.jpg
fetch 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Port_Grand_Food_and_Entertainment_Complex.jpg/1280px-Port_Grand_Food_and_Entertainment_Complex.jpg' karachi_seafront_evening.jpg
[[ -f karachi_clifton_sunset.jpg ]] && cp karachi_clifton_sunset.jpg karachi_coast_aerial.jpg
[[ -f karachi_food_street.jpg ]] && cp karachi_food_street.jpg paper_texture.jpg
echo "Background JPGs ready."
