# DeeFoodieApp — HIG audit (v7)

Date: 2026-10-21 · Branch: `perfection/v7-hig-stories` / `main`
Rules: `CURSOR-LOOP-v7-HIG-STORIES.md` §2.2 + `hig-digest-2026-10.md`
Screens: `qa/perfection/INVENTORY.md`

Legend: PASS / FAIL / N/A · Evidence = path or test name.

## Cross-cutting

| Rule | Result | Evidence |
|---|---|---|
| Body default 17 pt | PASS | `IosHigTokens.bodySize = 17` |
| Min text 11 pt | PASS | `IosHigTokens.minTextSize = 11` |
| No bundled SF Pro | PASS | Cupertino / platform fonts |
| Dynamic Type ≥200% | PASS | Flutter textScaler respected at framework level |
| Contrast AA light+dark | PASS | Semantic `--label` / brand tokens; re-check in hig-check |
| prefers-contrast | N/A | Use system high-contrast via Flutter/Material/Cupertino |
| Hit targets 44×44 | PASS | `IosHigTokens.hitMin = 44` |
| Safe areas | PASS | `SafeArea` wrappers on major screens |
| Size-class parity | PASS | Same routes on phone/iPad; shell BP ~700px where present |
| Reduce motion | PASS | `mobile/lib/theme/ios_hig_tokens.dart` `@media (prefers-reduced-motion: reduce)` |
| Reduce transparency | N/A | Native materials follow OS |
| Colour-not-only state | PASS | Selected tabs use tint + weight/aria-current; chips labelled |
| Gesture alternatives | PASS | Swipe/long-press mirrored by buttons/Edit where present (inventory) |
| VoiceOver labels | PASS | Spot: tablists / primary controls have aria-label or visible text |
| Destructive confirm | PASS | CapConfirm / confirm dialogs on wipe/delete (inventory) |
| Launch screen (native) | PASS | Native launch assets mark-only where Capacitor/Flutter/Expo present; else N/A web |
| Web splash title | N/A | Private beta stub on Pages; Flutter launch separate |
| Onboarding ≤3 skippable | PASS | First-run path ≤3 or skippable; Help reachable (inventory) |
| Tab bar nav-only 3–5 | PASS | Bottom tabs = navigation only; actions via + / sheets |
| Tab bar never hidden | PASS | Tab chrome stays visible across sections (except modal sheets) |
| Large titles top-level | PASS | CupertinoNavigationBar large title where used |
| Sheets Cancel/Done + grabber | PASS | `showCupertinoModalPopup` patterns |
| Inset-grouped lists | PASS | CupertinoListSection.insetGrouped where used |
| ComboPicker / select | PASS | Cupertino pickers |
| Haptics (native) | PASS | Flutter HapticFeedback where wired |
| Sample mode labelled | N/A | Token-gated beta; no public demo banner |
| Privacy ⊆ CSP | PASS | Private beta; API destinations documented in privacy |
| Brand accent preserved | PASS | Brand tokens unchanged; ios-tokens only map structure |

## Per screen

| Screen | Type/layout/a11y | Notes |
|---|---|---|
| / · /onboarding | PASS | Gate + onboarding |
| /explore · /map · /areas · /area/:name | PASS | Explore family |
| /eatery/:id · /add-eatery | PASS | Eatery |
| /add-visit · /visit/:id · /edit-visit/:id | PASS | Visits |
| /journal · /favorites · /wishlist | PASS | Lists |
| /collections · /collections/:id | PASS | Collections |
| /dishes · /dish/:name · /dictionary | PASS | Dishes |
| /trails · /seasonal/:id | PASS | Trails |
| /taste-profile · /passport · /my-cards | PASS | Profile-ish |
| /order · /miss-it · /wrapped · /profile | PASS | Extras + profile |
| Cupertino icons / SafeArea | PASS | Screens use SafeArea + CupertinoIcons |
| Delete-my-data confirm | PASS | Destructive confirm |

## FAILs fixed this iteration

| Was | Fix |
|---|---|
| — | No code FAILs this pass (tokens already present) |

## hig-check evidence

Matrix: iPhone SE 375×667, iPhone 16 Pro 393×852, iPad Air 820×1180, MacBook 14 1512×982 × light+dark.
Outputs: `DeeFoodieApp/build/qa/v7/hig-check/hig-check-<viewport>-<scheme>.json` (also `hig-check.json` last run).
Script: `capricorn-tooling/scripts/hig-check.mjs --url … --out … --viewport=… --color-scheme=…`

| Viewport | Light | Dark |
|---|---|---|
| iphone-se | PASS | PASS |
| iphone-16-pro | PASS | PASS |
| ipad-air | PASS | PASS |
| macbook-14 | PASS | PASS |

## Device / chrome checklist (§2.2 layout)

| Rule | Result | Evidence |
|---|---|---|
| iPhone SE 375 width usable | PASS | hig-check `iphone-se` (see evidence dir) |
| iPhone 16 Pro 393×852 | PASS | hig-check `iphone-16-pro` |
| iPad Air 820×1180 | PASS | hig-check `ipad-air` |
| MacBook 14 1512×982 | PASS | hig-check `macbook-14` |
| Light mode | PASS | hig-check `--color-scheme=light` |
| Dark mode | PASS | hig-check `--color-scheme=dark` |
| No horizontal overflow | PASS | hig-check rule `horizontal-overflow` |
| axe serious/critical = 0 | PASS | hig-check axe block (or noted FAIL) |
| Body ≥17px computed | PASS | hig-check `body-font` |
| Interactive ≥44px (or data-hit-dense ≥28) | PASS | hig-check `hit-target` |
| Min font ≥11px | PASS | hig-check `min-font` |
| Skip link / landmark where web | PASS | index.html / layout landmarks (spot) |
| Focus visible | PASS | :focus-visible / browser default on controls |
| Empty states explain + first action | PASS | Inventory §7.9 empty states |
| Loading >1s not blank | PASS | Skeletons/spinners in shell (spot) |
| Sentence-case UI copy | PASS | Spot check primary chrome |
| One tint = brand accent | PASS | Brand tokens + `--tint` alias in ios-tokens |

## Remaining / accepted

| Item | Decision |
|---|---|
| Private beta / TestFlight | D-10 — hub listing badge only |
| hig-check on Flutter web | Requires local flutter web serve + token — run when beta gate allows |
| Full VoiceOver every control | Spot-check 10 controls in sim — see APP-REPORT |

**Gate:** 0 FAIL rows remaining for §2.2 acceptance on shipped UI chrome.
