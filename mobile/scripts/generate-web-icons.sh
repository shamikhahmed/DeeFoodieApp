#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
SRC="assets/icon/app_icon.png"
WEB="web"
mkdir -p "$WEB/icons"

resize() {
  local size="$1"
  local out="$2"
  if command -v magick >/dev/null 2>&1; then
    magick "$SRC" -resize "${size}x${size}" "$out"
  elif command -v convert >/dev/null 2>&1; then
    convert "$SRC" -resize "${size}x${size}" "$out"
  elif command -v sips >/dev/null 2>&1; then
    sips -z "$size" "$size" "$SRC" --out "$out" >/dev/null
  else
    echo "Need ImageMagick, convert, or sips to resize icons" >&2
    exit 1
  fi
}

for size in 192 512; do
  resize "$size" "$WEB/icons/Icon-${size}.png"
  cp "$WEB/icons/Icon-${size}.png" "$WEB/icons/Icon-maskable-${size}.png"
done

cp "$WEB/icons/Icon-192.png" "$WEB/favicon.png"
echo "Web icons written to $WEB/icons/ and $WEB/favicon.png"
