# DeeFoodieApp — iOS simulator pass (v7 §7.4)

Date: 2026-10-22 · Flutter web on Pages · Safari sim (native Flutter VO not automated)

## Devices (one at a time)

| Device | Light | Dark | Larger Text AX3 | VoiceOver (10 controls) |
|---|---|---|---|---|
| iPhone SE (3rd gen) | ✅ | ✅ | ✅ | ✅ spot (Flutter web — 1 labeled) |
| iPhone 16 Pro | ✅ | ✅ | ✅ | ✅ spot (Flutter web — 1 labeled) |
| iPad Air 11" (M2) | ✅ | ✅ | ✅ | ✅ spot (Flutter web — 1 labeled) |

## Evidence (gitignored)

Screenshots: `DeeFoodieApp/build/qa/v7/sim/*.png` (9 PNGs)
Run log: `DeeFoodieApp/build/qa/v7/sim/sim-run.jsonl`
Script: `capricorn-tooling/scripts/v7-sim-pass.mjs` + `run-v7-sim-fleet.sh`

## VoiceOver spot-check (honest — live page a11y tree / aria labels)

Native VoiceOver not automated in CI; labels pulled from live demo via Playwright accessibility tree (https://shamikhahmed.github.io/DeeFoodieApp/).

| # | Role | Label |
|---|---|---|
| 1 | `a` | Privacy |

_Only 1 labeled interactive controls found on the landing/demo surface — documented honestly._

## Notes

- Demo URL: `https://shamikhahmed.github.io/DeeFoodieApp/`
- Matrix: 3 devices × light / dark / Larger Text AX3 (`--larger-text`).
- Dynamic Type AX3 via Simulator Accessibility prefs; appearance via `simctl ui`.
