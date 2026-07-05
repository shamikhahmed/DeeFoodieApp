# DeeFoodieApp — Premium iOS Build Brief

Standalone prompt for building the **UI/UX craft layer** of DeeFoodieApp. Hand this to Claude Code (or any agent/developer) alongside `CLAUDE.md` — `CLAUDE.md` is the product/data/feature spec, this is the "make it feel premium" spec. Read both; `CLAUDE.md` wins on scope/features, this file wins on interaction/motion/polish detail.

## The one-line brief

Build a free, no-paywall, iOS-only iPhone app that could pass for something Apple's own design team shipped — for a personal+shared Karachi food journal and city archive. Every screen must clear an Apple-grade craft bar before it's considered done, not just "renders without errors."

## Platform

- **iOS only.** No Android build, test, or App Store listing, ever, unless explicitly asked later. Flutter is used for velocity, not for cross-platform reach — write UI code that leans into iOS idioms even though it's not literally UIKit/SwiftUI.
- Target recent iPhone hardware (Face ID-era and later) — don't budget effort for old small-screen devices.
- Respect Dynamic Type, Dark Mode, and Safe Area on every screen. Test both light and dark.

## Craft bar — what "premium" actually means here

No paywall, no subscription, no IAP. "Premium" is entirely about polish:

1. **Motion.** Every state change animates — no instant snaps. Use spring curves (`Curves.easeOutCubic` / custom springs), not linear. Screen transitions should feel like iOS's own push/pop/modal-sheet motion, not Material's default slide-up.
2. **Haptics.** Every meaningful tap (save a visit, add to wishlist, pull-to-refresh trigger, rating star tap) gets the correct haptic (`HapticFeedback.lightImpact`/`mediumImpact`/`selectionClick` as appropriate) — not decorative, not on every single tap indiscriminately.
3. **Gestures.** Swipe-back-to-pop on every pushed screen. Long-press context menus (`UIContextMenu`-style) on eatery cards and visit entries instead of only tap-to-open. Drag-to-dismiss on modal sheets, with rubber-banding at the edges, not a hard cutoff.
4. **Glass material.** Per `CLAUDE.md` Section 1 — nav bars, cards, sheets, tab bar use the `GlassSurface` widget (blur + adaptive tint). Glass must feel alive: subtle parallax as content scrolls behind it, not a static blurred rectangle.
5. **Typography & spacing.** Apple HIG spacing scale (8pt grid), no arbitrary padding numbers. Headings get real hierarchy (size + weight, not just size). Line-height generous enough to breathe — this is a journal app, text needs to feel readable, not cramped.
6. **Empty states.** Every list/screen that can be empty gets an illustrated empty state (use the sticker pack in `assets/stickers/`), not a bare "No data" text string.
7. **Loading states.** Skeleton loaders (shimmer, matching the glass/paper aesthetic) instead of spinners wherever a list or card is loading. Spinners only for full-screen blocking waits.
8. **Error states.** Never a raw exception or a generic "Something went wrong." Every error state is written in-voice (warm, personal, matches the notebook/journal tone) and offers a retry action.
9. **Pull-to-refresh** everywhere a list can be refreshed (Home, Journal, Explore), with a custom refresh indicator matching the café aesthetic, not the default Material spinner.
10. **Icon & asset fidelity.** App icon, in-app stickers, and skyline background must render crisply at every scale (`@1x`/`@2x`/`@3x` equivalents) — no blurry upscaled raster in any UI surface.

## Screen-by-screen craft notes

- **Home:** glass cards over the Karachi skyline background (already scaffolded). Cards should have a subtle entrance stagger animation on first load (each card fades/slides in ~40ms after the previous), not all appearing at once.
- **Explore / Search:** filter chips (venueType, cuisine, area, AC, family-friendly — per `CLAUDE.md` Section 7a-2) animate open/closed, feel like iOS's own filter-sheet pattern. Results list uses smooth insert/remove animations when filters change, not a hard rebuild flash.
- **Eatery Profile:** hero image (blurred behind glass header per the two-background-layer rule in `CLAUDE.md` Section 1) with a parallax effect as the user scrolls the page underneath it, like Apple Music's album view.
- **Add Visit / Journal / forms:** plain legible paper surface (already locked — no heavy glass here). But "plain" doesn't mean "unpolished" — inputs get focus animations, star ratings animate on tap (small bounce), photo picker uses the native iOS picker sheet feel.
- **Map:** pin drop-in animation when the map first loads or filters change, not pins just appearing. Heat Map (Phase 4) transitions between "explored" and "unexplored" states with a soft fade, not a hard color swap.
- **Food Passport / Karachi Score:** since this is the one deliberately gamified surface (per `CLAUDE.md` identity), lean into a satisfying "stamp" animation when a new area unlocks — this is the emotional payoff moment of the whole app, don't undersell it.

## Explicitly NOT premium (don't build these)

- No paywall, subscription screen, or IAP flow of any kind.
- No aggressive onboarding carousel with 5 skippable slides — get the user into the app fast.
- No fake urgency/engagement patterns (streaks-you-must-keep, red badge notification dots) — conflicts with the "quiet, not corporate" identity in `CLAUDE.md` Section 1.

## How to use this doc

- Before marking any Phase 1+ screen "done" (per `ROADMAP.md`), check it against the Craft Bar section above.
- If a screen can't reasonably hit all 10 craft points yet (e.g. backend isn't wired), that's fine — ship the interaction/motion layer first with placeholder data, then wire data, rather than shipping data-wired-but-janky.
- When in doubt about an iOS interaction pattern, default to what Apple's own first-party apps (Music, Photos, Notes, Reminders) actually do — not what's easiest in Flutter's default Material widgets.
