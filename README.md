# DeeFoodieApp — Karachi Food Archive

Personal + city food journal for Karachi. Not a delivery app or Yelp clone — a digital memory of where you ate and what the city’s eateries were.

**Monorepo layout**

| Path | Stack | Role |
|------|-------|------|
| `mobile/` | Flutter (iOS ship target) | Consumer app |
| `api/` | NestJS + Prisma + PostGIS | REST API |
| `admin/` | *(deferred)* | Moderation portal |

Full product spec: [`CLAUDE.md`](CLAUDE.md).

## Quick start

### 1. Database

```bash
docker compose up -d
```

Postgres+PostGIS listens on host port **5435** (see `docker-compose.yml` if `DATABASE_URL` looks wrong).

### 2. API

```bash
cd api
pnpm install
pnpm run migrate:dev    # first time
pnpm run seed           # taxonomy + demo visits + exports offline bundle
pnpm run start:dev      # http://localhost:3000
```

Photo storage: `STORAGE_DRIVER=local` (default) or `s3` — see `api/.env.example`.

### 3. Mobile

```bash
cd mobile
flutter pub get
flutter gen-l10n
flutter run -d chrome
```

With live API:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000
```

Chrome preview (static build):

```bash
flutter build web --no-tree-shake-icons
cd mobile/build/web && python3 ../scripts/serve-web.py 8765
# open http://localhost:8765 — hard refresh after rebuilds (Cmd+Shift+R)
```

Offline demo: **`mobile/assets/demo/archive.json`** (**10,000 eateries**, OSM addresses, 27 linked visits, trails). Regenerated via:

```bash
cd api/prisma/scripts
node fetch-osm-karachi.mjs      # OpenStreetMap Karachi POIs
node generate-extra-eateries.mjs
node build-mobile-archive.mjs
```

Visits, badges, `visitCount`, venue details, and closed status are rebuilt together — do not hand-edit `archive.json`.

**Screen gallery (dev-only):** `mobile/screen-gallery.html` — VaultCap-style PNG index. `npm run gallery:capture` then `npm run gallery:serve` on :8766.

## Mobile features (current)

| Area | What’s built |
|------|----------------|
| **Design** | App-wide **journal notebook** — ruled paper, Fraunces + Caveat + Inter, paper cards (no glass blur) |
| **Home** | Karachi Score, personal dashboard, area photo chips, must-try, recent visits, wishlist preview |
| **Explore** | Search + venue/cuisine/area filters, high-contrast filter chips, sort |
| **Map** | OSM pins + **heat map** toggle (visited lit, rest grey) |
| **Journal** | **Book view default** — Apple Books page curl (`real_page_flip`), prev/next controls, Book/Timeline toggle, stickers + memory photos on spreads, timeline + mood filter, PDF export (⋮ menu) |
| **Profile** | Stats, areas · favorites · wishlist · dishes, language toggle, screen gallery |
| **Add / Edit visit** | Journal paper forms, moods, menu items, bill, multi-photo |
| **Eatery profile** | Hero photo, menu, visits, favorite ♥, wishlist, nearby |
| **Archive tools** | Areas (photo thumbs), favorites, wishlist, dishes, collections, Miss It?, dictionary |
| **Karachi identity** | Food Passport, Trails, Year in Food (`/wrapped`), seasonal collections, The Order |
| **i18n** | English + Roman Urdu (`app_en.arb` / `app_ur.arb`) |

## Auth (dev)

Stub middleware: send `X-User-Id` header; defaults to first seeded user. Clerk/Auth0 planned before real multi-user.

## CI

`.github/workflows/ios-build.yml` — `flutter test` + iOS build on push to `mobile/**` (no codesign; Simulator artifact). On-device: `mobile/scripts/run-on-iphone.sh`.

## Seed data

- `api/prisma/karachi-eateries-100.ts` — iconic Karachi venues (base set)
- `api/prisma/scripts/food-photo-pool.mjs` — cuisine/venue-aware cover photos
- `api/prisma/scripts/build-mobile-archive.mjs` — offline bundle (eateries + visits + trails)
- `api/prisma/scripts/build-mobile-archive.mjs` — writes `mobile/assets/demo/archive.json`
- Re-run after DB/schema changes to refresh the offline bundle

## Still open (high level)

- Real Karachi venue photos (Unsplash placeholders today)
- Hosted API (ngrok stopgap or Railway/Render)
- Clerk auth
- Sync visit book memories (stickers/photos) to API
- Area boundary polygons (PostGIS import)
- Admin portal (Phase 6)

See [`ROADMAP.md`](ROADMAP.md) and [`CHANGELOG.md`](CHANGELOG.md) for detail.
