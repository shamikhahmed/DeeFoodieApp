# Handover

Read `CLAUDE.md` first — it's the actual source of truth (identity, stack, data model, feature phases, locked decisions). This doc is just "how to pick this up and start working."

## What this project is

**DeeFoodieApp** (concept name: Karachi Food Archive) — personal food journal + city-wide archive for Karachi. 2 users only (you + one friend), shared visit history. Full spec: `CLAUDE.md`.

## Repo layout

```
/api           NestJS backend, Prisma ORM
/mobile        Flutter app (iOS-only ship target) — Phase 1 + Waves 2–4 + journal book UI live
/admin         Next.js admin portal — deferred, not started
/scripts       misc scripts
/assets/logo   logo.svg source + rendered mobile_icons/
/assets/stickers  cake/coffee/heritage sticker SVGs for UI accents
/mobile_icons  rendered iOS + Android icon sets from assets/logo/logo.svg (Android set kept for free but unused — iOS-only ship target)
docker-compose.yml   local Postgres+PostGIS + Redis
CLAUDE.md      master spec — READ THIS FIRST
CHANGELOG.md   dated log of what's been built
ROADMAP.md     phase plan / what's next
```

## First-time setup

1. Install Docker Desktop, start it.
2. `docker compose up -d` from repo root — starts Postgres+PostGIS on **localhost:5435** and Redis on **localhost:6380** (not the default 5432/6379 — those were already taken by other local projects on this machine).
3. `cd api && pnpm install`
4. Copy `api/.env.example` to `api/.env` if missing (already points at port 5435).
5. `npx prisma migrate deploy` — applies existing migrations.
6. `pnpm run seed` — loads taxonomy (VenueType/Cuisine/Area), 2 placeholder users, ~40 Karachi eateries.
7. `pnpm run start:dev` — API on `localhost:3000`. Check `GET /health`.

For mobile:

```bash
cd mobile && flutter pub get && flutter gen-l10n && flutter run -d chrome
```

Offline demo: `assets/demo/archive.json` (**7500 eateries**, trails, visits). Rebuild:

```bash
cd api/prisma && node scripts/generate-extra-eateries.mjs && node scripts/build-mobile-archive.mjs
```

**Restart app** after regen — `ArchiveLoader` caches bundle.

Chrome preview:

```bash
cd mobile && flutter build web --no-tree-shake-icons && cd build/web && python3 ../scripts/serve-web.py 8765
```

**Screen gallery (dev-only):** `mobile/screen-gallery.html` — `npm run gallery:capture` then open file or `npm run gallery:serve` (:8766).

## Journal book UI (2026-07-05)

| Feature | Where |
|---------|-------|
| Ruled paper app-wide | All tabs + pushed screens |
| Book view + page curl | Journal tab (default) |
| Prev/next flip buttons | Below book |
| Book/Timeline toggle | Journal header |
| Stickers + memory photos | 😊 on book spread (local prefs) |
| Paper forms | Add/Edit Visit |
| Dev screen gallery | `mobile/screen-gallery.html` (VaultCap-style, not in app) |

## Wave 2 (2026-07-05)

| Feature | Route |
|---------|-------|
| Journal book view | Journal tab → book icon toggle |
| Year in Food | `/wrapped` |
| Seasonal (Ramadan, mango) | `/seasonal/:id` |
| Map heat map | Map tab → toggle switch |
| Visit photo upload | Add Visit → gallery (local/demo data URL) |
| Friend activity card | Home (2-user pair archive) |
| Trails in archive.json | `build-mobile-archive.mjs` exports trails |
| Dev screen gallery | `screen-gallery.html` — PNG index via `npm run gallery:capture` |

Still open: real Karachi venue photos, API photo upload to S3 (layer exists; wire all flows), sync book memories to API, device haptics polish on iPhone, ngrok/hosting, Clerk auth.

## Auth (current state)

No real auth yet. `CurrentUserMiddleware` (`api/src/auth/current-user.middleware.ts`) reads an `X-User-Id` header and falls back to the first seeded user if absent. Fine for 2-user dev use. Real auth (Clerk, free tier) plugs in before Phase 2 needs it — see `CLAUDE.md` Section 7a.

## Gotchas

- **Ports are non-default.** Postgres is 5435, Redis is 6380, because this machine already has other projects (TradePulse, TS360) squatting 5432/5434/6379. If something can't connect, check the port first, not the container.
- **Prisma is pinned to v5**, not the latest v7. Prisma 7 changed to a `prisma.config.ts`-driven datasource setup that broke `migrate`/`validate` with the old schema-file `url =` syntax. Didn't want to fight a brand-new API mid-scaffold. Revisit the upgrade later if it matters.
- **`geo` and `boundary` fields are Prisma `Unsupported(...)` types** (PostGIS geography columns). They can't be set through normal `prisma.eatery.create()` — Prisma excludes `Unsupported` fields from generated input types entirely. Set them via `prisma.$executeRawUnsafe(...)` right after the row is created (see `api/prisma/seed.ts` for the pattern).
- **No real hosting yet.** API only runs on localhost. Locked decision was to use an ngrok tunnel as a stopgap so the app is reachable from restaurants (outside home wifi) — not yet set up. When ngrok's rotating free URLs get annoying, that's the trigger to finally pick real hosting (Railway/Render/Supabase were the shortlisted options).
- **iOS testing has no local Xcode workflow set up.** CI (`.github/workflows/ios-build.yml`) builds `--no-codesign` on every push to `mobile/**` and uploads a `.app` artifact — Simulator-only until Apple Developer signing is configured.

## Where the visual identity lives

- `assets/logo/logo.svg` — source of truth for the app icon. Cartoon/doodle style: hand-drawn notebook page, coffee cup + cake + heart. Any icon regen should start from editing this SVG, then rerun the `rsvg-convert` loop (see git history / CHANGELOG for the exact commands) to refresh `mobile_icons/`.
- `assets/stickers/*.svg` — decorative accents (cake, coffee, chai, biryani, samosa, Karachi heritage landmarks) in the same outline style. Use these for empty states, onboarding, achievement/badge UI, etc. `_preview_sheet.png` in that folder is a contact sheet for quick visual reference.

## Next steps

See `ROADMAP.md`.
