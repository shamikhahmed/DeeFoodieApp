#!/usr/bin/env bash
# DFD-V3-1 / D-10 — Replace public Flutter gh-pages with Private beta stub.
# Does NOT publish the journal web app.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STUB="$ROOT/docs/private-beta"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

test -f "$STUB/index.html"
cp -R "$STUB"/. "$TMP"/
cd "$TMP"
git init -q
git checkout -q -b gh-pages
git add -A
git -c user.name='DeeFoodie Builder' -c user.email='builder@deefoodie.local' \
  commit -q -m "DFD-V3-1: private beta stub (no public Flutter web)"
git remote add origin "$(git -C "$ROOT" remote get-url origin)"
git push -f origin gh-pages
echo "Published private-beta stub to origin/gh-pages"
