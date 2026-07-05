# Changelog

All notable changes to this project. Dates in YYYY-MM-DD.

## 2026-07-05

### Added
- Initial master spec (`CLAUDE.md`): identity, stack, data model, phased feature plan, MVP decisions (4 rounds), scaffold status.
- Git repo initialized, monorepo layout (`/mobile`, `/api`, `/admin`, `/scripts`).
- App name locked: **DeeFoodieApp**.
- Logo/icon: cartoonish journal-page design (`assets/logo/logo.svg`) — hand-drawn notebook page, doodle coffee cup + cake slice + heart. Full iOS icon set (`mobile_icons/ios/`) and Android mipmap set (`mobile_icons/android/`) rasterized.
- Sticker pack (`assets/stickers/`): coffee cup, chai cup, cake slice, cupcake, biryani plate, samosa, and Karachi heritage motifs (Mazar-e-Quaid, Frere Hall, dhow boat) — same cartoon-outline style as the logo.
- `docker-compose.yml`: Postgres+PostGIS (host port 5435) and Redis (host port 6380) for local dev — ports remapped off defaults due to other local projects already occupying 5432/6379.
- NestJS API scaffolded in `/api` (Prisma 5.22 pinned — Prisma 7's new config-file-driven datasource setup was too fresh/unstable to build against yet). `PrismaService`/`PrismaModule`, stub `CurrentUserMiddleware` (reads `X-User-Id` header, defaults to first seeded user — real auth deferred), `GET /health`, `Dockerfile`.
- Prisma schema (`api/prisma/schema.prisma`) covering full data model: User, Eatery (+VenueType/Cuisine many-to-many, admin-editable taxonomy tables), Badge, Tag, EateryTimelineEvent, MenuVersion/MenuItem, Dish, Visit (+12 optional category sub-ratings), VisitItem, Photo, Collection, WishlistEntry, Trail/UserTrailProgress, Area. `geo`/`boundary` are PostGIS `Unsupported(...)` types, set via raw SQL.
- Initial migration applied to local DB; PostGIS extension enabled.
- Seed script (`api/prisma/seed.ts`, `pnpm run seed`): 12 VenueTypes, 12 Cuisines, 21 Areas, 2 users (you/friend), 40 seeded Karachi eateries with lng/lat + best-guess taxonomy tags.
- GitHub Actions iOS build workflow (`.github/workflows/ios-build.yml`) — builds Flutter iOS `--no-codesign` on every push to `mobile/**`, uploads `.app` artifact. Stopgap "test through GitHub" loop until local Xcode signing is set up.
- Glass UI direction locked (`CLAUDE.md` Section 1): full-app Apple-style adaptive blur/vibrancy material, illustrated Karachi skyline + real-photo backgrounds, journal/forms stay plain paper for legibility.
- `assets/backgrounds/karachi_skyline.svg`: illustrated skyline (Mazar-e-Quaid, Frere Hall, dhow boats, sea) matching sticker cartoon style.
- Sticker pack upgraded from flat cartoon to glossy die-cut style (white circle border, drop shadow, gradient shading) — no photorealistic/photo-cutout stickers were possible, no raster image-gen tool is connected in this environment.
- `/mobile` Flutter app scaffolded: Riverpod, English + Roman Urdu localization (`lib/l10n/`, ARB-based), bottom-nav shell (Home/Explore/Map/Journal/Profile), reusable `GlassSurface` widget (`BackdropFilter` blur + tint) and `KarachiBackground` widget wired on browsing screens, app icon generated for iOS+Android via `flutter_launcher_icons`. Verified rendering via `flutter build web` + Chrome preview (no local Xcode/Android SDK installed yet, so iOS/Android device builds go through CI or come later).

### Decisions locked this session
- 2 users only (you + friend), shared visits model — each logs own Visit per outing, visible to both, edit rights own-only.
- iOS-first platform priority; CI-driven build loop (no local Xcode workflow yet).
- Full bilingual UI planned: English + Roman Urdu via Flutter `intl`/ARB.
- ~40 iconic Karachi eateries bulk-seeded (no free API has adequate Karachi F&B coverage — compiled manually).
- Local Docker DB for dev; real hosting deferred, ngrok/tunnel stopgap for reaching the API outside the home network in the meantime.
- Real geographic Area polygons planned via OpenStreetMap/Overpass import (not yet implemented — Area.boundary column exists, unpopulated).
- Search ships with filters from day one (not deferred to Phase 2).
- Dish Rankings computed as average visit rating per dish, city-wide.

### Known gaps / not yet done
- `/mobile` Flutter app not yet scaffolded (Flutter SDK install was in progress via Homebrew at time of writing).
- `/admin` Next.js portal — intentionally deferred past Phase 5.
- No real hosting/ngrok tunnel set up yet — API only reachable on localhost currently.
- Area boundary polygons not imported yet.

## 2026-07-05 — Wave 1 (mobile)

### Added
- Flutter app: Riverpod, bilingual ARB, glass UI, ContentSheet readability fix.
- Onboarding (Karachi-wide craving), 280-eatery demo archive, Food Passport, Trails, share visit, craving engine.
- Add Visit menu picker, explore filters, areas/favorites/wishlist/dishes.
- Food photo orbs (Unsplash) replacing cartoon stickers in main UI.

## 2026-07-05 — Wave 2 (mobile)

### Added
- **Journal book view** — horizontal spread layout; timeline/book toggle on Journal tab.
- **Year in Food** (`/wrapped`) — templated stats + narrative from visit data (no LLM).
- **Seasonal collections** (`/seasonal/ramadan-iftar`, sehri, mango) — curated eatery picks.
- **Map heat map** — visited pins lit, unvisited grey; desaturated tiles when on.
- **Visit photo upload** — `image_picker` on Add Visit; base64 data URL on local visits.
- **Friend activity card** — latest non-You visit on Home (2-user pair model).
- **Trails in archive.json** — `build-mobile-archive.mjs` exports trails; `archiveTrailsProvider`.
- **AppHaptics** wrapper (`lib/utils/haptics.dart`).
- Screen gallery tiles: passport, trails, wrapped, seasonal, book view.
- l10n keys for all Wave 2 strings (EN + Roman Urdu).

### Still open
- Real Karachi venue photos (still Unsplash).
- API-backed visit photo upload + S3 storage.
- Full in-app social (deferred per spec).
- ngrok / real hosting for API outside home network.
- iOS device haptics QA (wrapper exists; needs real iPhone pass).

## 2026-07-05 — Contrast / readability pass (mobile)

### Fixed
- Bumped `textMuted` (0.6→0.75), `textSubtle` (0.4→0.58), added `textSecondary` (0.82).
- Typography: explicit `inkBrown` on titles/body/labels; secondary text darker.
- `GlassSurface`: default tint 0.86, `DefaultTextStyle` forces readable ink on all glass children.
- Background scrims stronger on all variants — less photo bleed-through behind text.
- Tab bar, chips, hints, text buttons — darker unselected/label colors.
- Targeted fixes: map pin labels, passport locked stamps, journal ratings, explore search field, dashboard tiles.

## 2026-07-05 — Profile photo (mobile)

### Added
- Profile avatar picker (`image_picker` → SharedPreferences data URL).
- Editable display name; new visits use it as `userName`.
- `ProfileAvatar` widget, `userProfileProvider`.

## 2026-07-05 (later same day)

### Decisions locked
- **iOS only, ship-target-wise.** Android code stays in the Flutter repo (free, since Flutter is cross-platform anyway) but is never built, tested, or shipped. No Play Store plans.
- **"Premium" clarified as polish, not monetization.** Free app, no paywall/IAP/subscription. The bar is Apple-grade craft — smooth animations, correct haptics, real iOS gesture conventions (swipe-back, long-press menus, drag-to-dismiss sheets) — not a pricing model.
- Added `PROMPT.md` — standalone detailed build-brief for the premium iOS app, written to be handed to Claude Code (or any agent/dev) as a self-contained spec for UI/UX craft expectations specifically, complementing `CLAUDE.md`'s product/data spec.

### Docs updated
- `CLAUDE.md` Section 1/2: iOS-only + premium-bar decisions added.
- `ROADMAP.md`: iOS-only/premium bar note added up top.
- `HANDOVER.md`: noted Android icon set is unused or kept for free.

## 2026-07-05 — Wave 3 (mobile)

### Added
- **Edit visit** (`/edit-visit/:id`) — owner-only edit/delete, backdate, companions, multi-photo, custom mood tags.
- **Add eatery** (`/add-eatery`) — fuzzy name+area duplicate warning; saves to local store (API hook ready).
- **Collections** (`/collections`) — user-made lists with detail view.
- **The Order** (`/order`) — dish/drink frequency from visit items.
- **Miss It?** (`/miss-it`) — closed eateries preserved in archive (Lal Qila, Pie in the Sky, Ginsoo in demo bundle).
- **Karachi Dictionary** (`/dictionary`) — static glossary content.
- **Nearby eateries** — haversine section on eatery profile.
- **Pioneer badge** — first-visit marker on eatery profile.
- **Friend profile** — editable friend name + avatar on Profile screen.
- **Local persistence** — `local_visits` + `local_eateries` SharedPreferences stores.
- **Add Visit companions** — Alone/Friends/Family/Work chip row.
- Screen gallery tiles for all Wave 3 routes.
- l10n keys (EN + Roman Urdu) for Wave 3 strings.

### Fixed
- `profile_screen.dart` stray brace broke `build`.
- Missing imports: `SeasonalScreen`, `SectionHeader`, `MoodChip`.

### Still open
- API `createEatery` not wired from Add Eatery screen yet.
- API photo upload + S3.
- Full offline sync queue.
- ngrok / hosted API.

## 2026-07-05 — Wave 4 (discounts + infra + taste)

### Added
- Golootlo/Peekaboo/bank card discount layer (curated deals, no public API)
- Extended onboarding (6 steps), taste profile, my cards screen
- API photo upload, sync queue, voice notes, PDF export, trail certificate
- OpenStreetMap Nominatim geocoding on Add Eatery

## 2026-07-05 — Journal book UI (app-wide)

### Added
- **App-wide journal aesthetic** — ruled `JournalPaper` on all tabs + pushed screens (`TabScreenScaffold`, `AppBackground` → paper).
- **Paper cards** — `GlassSurface` rewritten as solid notebook cards (blur glass removed).
- **Typography** — Fraunces titles, Caveat labels on tab bar and section chrome.
- **Journal book view** — `real_page_flip` page curl (iOS haptics + paper sound); prev/next `BookPageControls`; prominent Book/Timeline toggle on Journal tab.
- **Book memories** — sticker picker + gallery memory photos on spreads (`visit_book_memories_v1` in SharedPreferences).
- **Add/Edit Visit** — `JournalFormScaffold` paper forms.
- **Screen gallery v2** — `/gallery` with iPhone-frame mini previews grouped by tabs / journal / archive / Karachi.
- **API S3 storage layer** — `STORAGE_DRIVER=local|s3` in `api/src/storage/storage.service.ts`.
- **iOS on-device script** — `mobile/scripts/run-on-iphone.sh`.
- **Area photos** — `areaPhotoUrls` thumbs on home chips + areas list + area detail hero.

### Removed / changed
- Friend profile card removed from Home + Profile.
- Onboarding craving step removed (5 steps).
- Explore filter chips — higher contrast solid fill.

### Fixed
- Web deep links (`/gallery`, etc.) respect browser URL on first load.
- SPA static server script: `mobile/scripts/serve-web.py` (use instead of plain `python -m http.server`).
- Hosted API / ngrok.
- Real venue photos.
- Clerk auth.

## 2026-07-05 — Initial GitHub push prep (7500 eateries)

### Changed
- Demo archive **7500 eateries** (117 base + 7383 generated)
- `TARGET_TOTAL = 7500`

## 2026-07-05 — Screen gallery → VaultCap standalone (not in app)

### Changed
- Removed `/gallery` route, Profile link, in-app `ScreenGalleryScreen` / drawn previews
- **Dev-only** `mobile/screen-gallery.html` — VaultCap pattern: section pills, lightbox, embedded manifest, offline `file://`
- `npm run gallery:capture` — Playwright PNGs for 27 screens + manifest + embed
- `npm run gallery:serve` — browse at `:8766/screen-gallery.html`

## 2026-07-05 — Offline gallery + 2500-eatery archive

### Added
- **Offline screen gallery** — bundled `assets/gallery/manifest.json`, `GalleryLoader`, Riverpod provider; standalone `web/gallery.html` via `npm run gallery:embed`
- **2500 eateries** in demo archive (117 iconic base + 2383 generated) — chains, cafes, hotels, street food
- `TARGET_TOTAL = 2500` in `generate-extra-eateries.mjs`

### Changed
- Archive scale-up superseded 1050 count

## 2026-07-05 — Archive scale-up (1050 eateries)

### Added
- **1050 eateries** in demo archive (117 iconic base + 933 generated)
- **~100 Karachi hotels** (PC, Marriott, Mövenpick, Avari, Ramada, Beach Luxury + lesser-known)
- **15 outlets per famous hotel** — Chandni, Marco Polo, coffee shop, rooftop BBQ, etc.
- Named iconic hotel restaurants (PC Chandni, Marriott Nadia, Avari Dynasty, etc.)
- `Hotel Restaurant` venue type in DB seed
- Regen: `node scripts/generate-extra-eateries.mjs` → `build-mobile-archive.mjs`
