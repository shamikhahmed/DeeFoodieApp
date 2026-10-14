# DeeFoodie — APP-REPORT v3 (Builder draft → Auditor)

**Version:** 1.0.0+3  
**Branch:** `perfection/deefoodie-v3`  
**Updated:** 2026-10-14  
**Live URL:** https://shamikhahmed.github.io/DeeFoodieApp/ — **Private beta stub only** (not the Flutter journal)  
**Distribution:** Private TestFlight (D-10) · hub Private beta · no public install

## Items

| ID | Severity | Status |
|---|---|---|
| DFD-V3-1 | P0 | ✅ FIXED (await Auditor VERIFIED) |
| DFD-V3-2 | P1 | ⛔ BLOCKED-EXTERNAL (upload) |
| DFD-V3-3 | P2 | ⏳ OPEN |

## How public access is gated
1. Web Deploy workflow disabled (`if: false`).
2. `gh-pages` hosts `docs/private-beta/` stub (no `flutter_bootstrap.js`).
3. Any Flutter web build: HTML session token gate + Dart `WebBetaGate` before routes.
4. Hub catalog: `privateBeta: true` — no install CTA.

## Gates (honest delta for Wave D early)

| Gate | Result | Notes |
|---|---|---|
| G10 Security / privacy | ✅ delta | Public web no longer serves journal |
| G11 / G14 TestFlight | ⛔ | Pack ready; upload EXTERNAL |
| Device-qa / LH on Flutter web | ⏭ | Public Flutter web withdrawn |

## BLOCKED-EXTERNAL owner steps (DFD-V3-2)
1. Archive IPA with Apple Distribution cert.
2. Upload to App Store Connect / TestFlight.
3. Add two Internal Testers; issue API tokens via `api` CLI.
