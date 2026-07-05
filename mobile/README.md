# DeeFoodieApp — Mobile

Flutter app for the Karachi Food Archive. **iOS ship target**; Chrome for dev preview.

## Run

```bash
flutter pub get
flutter gen-l10n
flutter run -d chrome
```

Live API:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000
```

Static web preview:

```bash
flutter build web --no-tree-shake-icons
cd build/web && python3 ../scripts/serve-web.py 8765
```

Open **http://localhost:8765** — use `serve-web.py` (not plain `http.server`) so deep links work. Hard refresh after each build (`Cmd+Shift+R`).

**Screen gallery (dev-only, not in app):** VaultCap-style standalone `mobile/screen-gallery.html` — every screen PNG, section filters, lightbox, offline via embedded manifest.

```bash
cd mobile
flutter build web
cd build/web && python3 ../../scripts/serve-web.py 8765   # separate terminal
npm install && npm run gallery:capture   # PNGs + manifest + embed
npm run gallery:serve                      # http://localhost:8766/screen-gallery.html
```

Or open `mobile/screen-gallery.html` directly (`file://`) after `gallery:capture`.

## Demo archive (10,000 eateries)

- **117** curated iconic Karachi venues (enriched: phone, hours, branches, Google/social reviews)
- **~4,600** OpenStreetMap POIs (real addresses where tagged)
- **Generated** fill to 10,000 with Karachi street addresses + phones
- Cover photos: official/venue URLs for iconic spots; bundled Karachi area JPG fallback (no Unsplash)

Offline bundle: `assets/demo/archive.json`

```bash
cd api/prisma
node scripts/generate-extra-eateries.mjs
node scripts/build-mobile-archive.mjs
```

**Full app restart** after regen (`ArchiveLoader` caches bundle).

Archive integrity test:

```bash
cd mobile && flutter test test/archive_integrity_test.dart
```

Full DB seed:

```bash
docker compose up -d
cd api && pnpm run seed
```

## Design system (2026-07-05)

| Piece | Implementation |
|-------|----------------|
| **Paper shell** | `JournalPaper` — ruled lines + left margin on all tab screens |
| **Cards** | `GlassSurface` → solid paper cards app-wide |
| **Typography** | Fraunces (titles), Caveat (hand labels), Inter (body) |
| **Tab bar** | Cream paper + Caveat labels (`GlassNavBar`) |
| **Forms** | `JournalFormScaffold` on Add/Edit Visit |
| **Book** | `real_page_flip` double-spread, leather cover, haptics + paper sound on iOS |
| **Memories** | Stickers (`assets/stickers/`) + gallery photos on book spreads — local `SharedPreferences` |

## Features

### Core tabs

| Feature | Route / entry |
|---------|----------------|
| **Home** | `/` — area photo chips, dashboard, discover links |
| **Explore** | `/explore` — search, sort, high-contrast filter chips |
| **Map** | `/map` — OSM + heat map toggle |
| **Journal** | `/journal` — book view default, timeline toggle, mood filter |
| **Profile** | `/profile` — stats, links, language |

### Journal & visits

| Feature | Route / entry |
|---------|----------------|
| **Book view** | Journal → Book toggle — page curl, prev/next chevrons |
| **Stickers + memory photos** | 😊 on book spread → `BookMemoryPickerSheet` |
| **Timeline** | Journal → Timeline toggle |
| **Add visit** | `/add-visit` — journal paper form |
| **Edit visit** | `/edit-visit/:id` — backdate, photos, delete |
| **Visit detail** | `/visit/:id` — journal paper |
| **PDF export** | Journal ⋮ menu |
| **Share visit** | Visit detail → share card |

### Archive & Karachi

| Feature | Route |
|---------|-------|
| Eatery profile | `/eatery/:id` |
| Add eatery | `/add-eatery` |
| Areas | `/areas`, `/area/:name` |
| Favorites / Wishlist / Dishes | `/favorites`, `/wishlist`, `/dishes` |
| Collections | `/collections` |
| Food Passport | `/passport` |
| Trails | `/trails` |
| Year in Food | `/wrapped` |
| Seasonal | `/seasonal/:id` |
| The Order | `/order` |
| Miss It? | `/miss-it` |
| Karachi Dictionary | `/dictionary` |
| Onboarding | `/onboarding` (5 steps, no craving picker) |

**Dev screen gallery:** `screen-gallery.html` (not shipped in app — see top of this README).

## Architecture

```
lib/
  api/           ApiClient + Riverpod providers
  constants/     Trails, seasonal, food visuals, journal stickers
  data/          ArchiveLoader
  models/        Eatery, Visit, VisitItem
  providers/     Passport, journal view, map heat, visit book memories, …
  router/        GoRouter + AppShell (5 tabs)
  screens/
  utils/         Haptics, journal PDF, archive merge
  widgets/       JournalPaper, JournalBookView, GlassSurface, TabScreenScaffold,
                 ScreenGalleryPhone, BookMemoryPickerSheet, …
```

**State:** Riverpod 3.

## User-local data (SharedPreferences)

| Key | Use |
|-----|-----|
| `visit_book_memories_v1` | Per-visit stickers + memory photos on book spreads |
| `onboarding_craving` | Home spotlight (legacy; onboarding simplified) |
| `favorite_eatery_ids` | Favorites |
| `wishlist_entries` | Wishlist |
| `local_visits` / `local_eateries` | Offline writes |
| `user_profile` | Display name + avatar data URL |

## Quality

```bash
flutter analyze
flutter build web --no-tree-shake-icons
```

iOS CI: `.github/workflows/ios-build.yml`. On-device: `./scripts/run-on-iphone.sh`.

## Still open

- Real Karachi venue photos
- API sync for book memories + visit photos to S3
- ngrok / hosted API
- Full offline sync queue polish
- iOS on-device QA (haptics, page-flip sound)
