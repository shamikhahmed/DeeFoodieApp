# DeeFoodie — Perfection Loop v3 · STATE

Updated: 2026-10-14T11:25:00Z  
Phase: **E → F** (DFD-V3-1 P0 FIXED; hand to Auditor)  
Branch: `perfection/deefoodie-v3`  
App version: 1.0.0+3 (no release bump — Phase I)

## Last commits
- Tip: `a799ec7d6cdc69f6b14e9e5735d0ce01041f43d1` on `perfection/deefoodie-v3`
- Fix: `47907749a9381ffdbf1eb7eabfb4f432cb107078`
- Base main: `c78cc9acd7bfd42268449e427e60872844f5e1e2`
- Live gh-pages stub: `dde482a485d261510227d8b8be599f06a05abd38`
- DFD-V3-1: disable `web-deploy.yml` · private-beta Pages stub · Flutter/HTML web beta token gate
- DFD-V3-2: TestFlight pack prepared · upload **BLOCKED-EXTERNAL**

## What's running
- Public Pages: Private beta stub only (no Flutter journal) at `/DeeFoodieApp/` — live verified (no `flutter_bootstrap.js`)
- Local Flutter web (if built): HTML gate + Dart `WebBetaGate` before routes

## Public access gate (how)
1. **CI:** `web-deploy.yml` job `if: false` — no auto publish of Flutter web.
2. **Live Pages:** `docs/private-beta/` force-published to `gh-pages` — landing + privacy only; `robots: noindex`.
3. **If Flutter web is run/built:** `mobile/web/index.html` blocks `flutter_bootstrap.js` until session token ≥32 chars; Dart `WebBetaGateScreen` also blocks router until `AuthTokenStore` has a valid bearer.
4. **Hub:** already `privateBeta: true` — "Private beta" / no install link.

## Next 3 actions (Auditor)
1. Clean checkout `perfection/deefoodie-v3`; confirm `web-deploy.yml` has `if: false`.
2. Fetch live `https://shamikhahmed.github.io/DeeFoodieApp/` — must be Private beta stub (no `flutter_bootstrap.js`).
3. Mark DFD-V3-1 ✅ VERIFIED; leave DFD-V3-2 ⛔ BLOCKED-EXTERNAL; DFD-V3-3 gallery OPEN.

## Reproduce
```bash
cd /Users/shamikhahmed/Projects/Cap/Cap-Apps/DeeFoodieApp
git checkout perfection/deefoodie-v3
curl -sL https://shamikhahmed.github.io/DeeFoodieApp/ | head -40
# expect: "Private beta" heading, no flutter_bootstrap.js
cd mobile && flutter test test/web_beta_gate_test.dart
```
