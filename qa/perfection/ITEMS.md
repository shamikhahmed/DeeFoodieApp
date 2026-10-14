# DeeFoodie — Perfection Loop v3 · ITEMS

Seeded from CURSOR-PERFECTION-LOOP.md §13.15 + D-10.

### DFD-V3-1 — Public web must not expose journal (P0 privacy / D-10)
severity: P0 · status: ✅ FIXED
Where: `https://shamikhahmed.github.io/DeeFoodieApp/` · gh-pages · web-deploy CI  
Evidence: live stub (no Flutter) · `web-deploy.yml` disabled · gate unit test  
Cause: Legacy Flutter web deploy left full app public on Pages  
Fix: disable Web Deploy job (`if: false`); publish `docs/private-beta/` to `gh-pages`; HTML + Dart beta token gates for any future/local Flutter web  
Test: `mobile/test/web_beta_gate_test.dart` · curl live index (no `flutter_bootstrap.js`)  
Auditor: ⏳ await **VERIFIED** — Builder re-checked 2026-10-14T12:00:00Z: live `https://shamikhahmed.github.io/DeeFoodieApp/` is Private beta stub only (no `flutter_bootstrap.js`); `origin/gh-pages` @ `dde482a`; `flutter test` 23/23 green.

### DFD-V3-2 — TestFlight pack ready; upload external
severity: P1 · status: ⛔ BLOCKED-EXTERNAL  
Where: App Store Connect upload  
Evidence: `docs/store/TESTFLIGHT.md` pack complete  
Cause: Owner Apple account required for upload  
Fix: pack prepared only — do not upload in-loop  
Test: —  
Auditor: —

### DFD-V3-3 — Gallery for private-beta mini-site (no install CTA)
severity: P2 · status: ⏳ OPEN  
Where: Phase G · iOS simulator if Xcode; else local web behind token  
Cause: not in Wave D early scope beyond prepare  
Fix: —  
Auditor: —
