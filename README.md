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
node fetch-osm-karachi.mjs           # OpenStreetMap (free)
node build-static-photo-map.mjs      # Wikimedia area/chain photos (free)
node generate-extra-eateries.mjs
node build-mobile-archive.mjs
# optional: node fetch-free-venue-photos.mjs  # Wikipedia og:image enrich (slow, free)
```

Visits, badges, `visitCount`, venue details, and closed status are rebuilt together — do not hand-edit `archive.json`.

**Screen gallery (dev-only):** `mobile/screen-gallery.html` — VaultCap-style PNG index (onboarding welcome + chains, map clusters, journal book). `bash scripts/fetch-backgrounds.sh` once for bundled JPGs. `npm run gallery:capture` then `npm run gallery:serve` on :8766.

## Mobile features (current)

| Area | What’s built |
|------|----------------|
| **Design** | App-wide **journal notebook** — ruled paper, Fraunces + Caveat + Inter, paper cards (no glass blur) |
| **Home** | Score → map heat, seasonal strip, near-me GPS, friend visit, mood strip, quick log, chains row |
| **Explore** | Filters persist; haven't-been + price bands; deal badges on cards |
| **Map** | Clustering, heat toggle, plan tonight, trail highlights, visit-sized pins |
| **Journal** | Year dividers, mood themes, voice chip, share card image |
| **Dishes** | Dish detail page with archive ratings |
| **Eatery** | Compare visits, nearby section |
| **Areas** | Neighborhood stories |
| **Profile** | Stats, areas · favorites · wishlist · dishes, language toggle, screen gallery |
| **Add / Edit visit** | Journal paper forms, moods, menu items, bill, multi-photo |
| **Eatery profile** | Hero photo, menu, visits, favorite ♥, wishlist, nearby |
| **Archive tools** | Areas (photo thumbs), favorites, wishlist, dishes, collections, Miss It?, dictionary |
| **Karachi identity** | Food Passport, Trails, Year in Food (`/wrapped`), seasonal collections, The Order |
| **i18n** | English + Roman Urdu (`app_en.arb` / `app_ur.arb`) |

## Auth (dev)

Stub middleware: send `X-User-Id` header; defaults to first seeded user. Clerk/Auth0 planned before real multi-user.

## CI & open via GitHub

| Workflow | What |
|----------|------|
| `web-deploy.yml` | Flutter web → **GitHub Pages** |
| `ios-build.yml` | iOS Simulator `.app` artifact |

**Web (phone browser):** Pages enabled on `gh-pages` branch — auto-deploys every push.  
Open: **https://shamikhahmed.github.io/DeeFoodieApp/** (wait 1–2 min after first deploy)

No manual Settings step needed — workflow pushes `gh-pages` and Pages serves it.

**iOS:** Actions → latest run → **ios-app** artifact (Simulator only until signing).

`ios-build.yml` runs `patch-real-page-flip.sh` first — fixes `real_page_flip` `createPlayer` → `makePlayer` on Xcode 15+.

## Seed data

- `api/prisma/karachi-eateries-100.ts` — iconic Karachi venues (base set)
- `api/prisma/scripts/karachi-areas.mjs` — **67 neighborhoods** (centroids + addresses)
- `api/prisma/scripts/free-karachi-photos.mjs` — Wikimedia cover photos (free)
- `api/prisma/scripts/build-mobile-archive.mjs` — offline bundle (eateries + visits + trails)

## Still open (high level)

- Hosted API (ngrok stopgap or Railway/Render)
- Clerk auth
- Sync visit book memories (stickers/photos) to API
- Area boundary polygons (PostGIS import)
- Admin portal (Phase 6)

See [`ROADMAP.md`](ROADMAP.md) and [`CHANGELOG.md`](CHANGELOG.md) for detail.
