# DeeFoodieApp (Karachi Food Archive) — Master Project Spec

App name: **DeeFoodieApp**. "Karachi Food Archive" remains the product concept/description; DeeFoodieApp is the actual name used in package IDs, app store listing, repo, etc.

Single source of truth for Claude Code. Read fully before writing code. Follow exactly. Do not invent scope beyond this doc without asking.

## 1. Identity

Not a restaurant directory, not a delivery app, not Yelp-for-Karachi.

**It is: the digital memory of Karachi's food culture.**

Two archives, always:
1. **Personal Archive** — every user's own food journal, visit by visit, year by year.
2. **City Archive** — every eatery's permanent record: opens, closes, menu changes, price history, photos, community memory — preserved even after a place shuts down.

Design personality: warm café/notebook aesthetic, not corporate. Coffee browns, cream/beige, dark green accents, handwritten-style headings, soft illustration. Quiet — no infinite scroll, no influencer/social-bait patterns, no engagement gamification beyond what's listed below (Food Passport, Karachi Score, Trails are the *only* gamification allowed).

**UI material (locked 2026-07-05, updated same day):** App-wide **journal notebook** aesthetic — ruled paper (`JournalPaper`), Fraunces + Caveat + Inter typography, solid paper cards (`GlassSurface`). Book view uses `real_page_flip` page curl on Journal tab. Adaptive glass blur retired from main UI; journal/forms stay legible paper surfaces.

Karachi-only scope. Never build multi-city support prematurely — architecture should not hardcode "Karachi" as a magic string, but do not build a city-switcher UI or city model complexity until explicitly asked.

**Platform target (locked 2026-07-05): iOS only.** Ship target is iPhone/App Store. Flutter is kept cross-platform for free (Android code stays in the repo, untouched), but Android is never built, tested, or shipped — no Android time budget, no Play Store plans. Every design/UX decision optimizes for iOS conventions (SF Symbols-style iconography, iOS navigation patterns, Apple HIG spacing/typography) rather than trying to look neutral across platforms.

**Premium bar (locked 2026-07-05):** "premium" means Apple-grade polish and craft — not monetization. Free app, no paywall, no subscription, no IAP. The bar is: this should feel like it could ship from Apple's own design team — smooth animations, correct haptics, no jank, pixel-accurate spacing, real iOS gesture conventions (swipe-back, long-press context menus, drag-to-dismiss sheets). Every screen should be held to that standard before being called done, not just "functionally works."

## 2. Tech Stack

- **Mobile app:** Flutter (iOS-only ship target; codebase stays cross-platform but Android is never built/tested/shipped)
- **Backend:** NestJS (Node/TypeScript)
- **DB:** PostgreSQL + PostGIS (geospatial)
- **ORM:** Prisma
- **Cache:** Redis
- **Search:** Postgres full-text search initially (pg_trgm + tsvector). Do not add Elasticsearch/OpenSearch until data volume or query complexity actually requires it.
- **Object storage:** S3-compatible (photos, galleries)
- **Maps:** Mapbox (or OpenStreetMap tiles if cost is a concern — decide at implementation time based on free-tier limits)
- **Auth:** Clerk or Auth0 — pick one at setup, do not build custom auth
- **Admin portal:** Next.js (App Router), for moderation, restaurant curation, badge assignment
- **Infra:** Docker Compose for local dev; GitHub Actions for CI; deployment target TBD (Vercel for admin/web, Fly.io/Railway/Render for API+DB — decide when we get there, don't over-architect now)

Coding standards: TypeScript strict mode everywhere on backend/admin. No `any`. Prisma schema is the source of truth for DB types — do not hand-write duplicate DTOs where Prisma types suffice. Flutter: use Riverpod or Bloc for state (pick one, stay consistent), null-safety everywhere, no God-widgets — break screens into small composable widgets.

No comments explaining *what* code does. Only comment non-obvious *why*.

## 3. Data Model (core entities)

```
User
 - id, name, email, avatarUrl, joinedAt
 - stats (derived, not stored): visitsCount, areasExplored, karachiScorePct

Eatery
 - id, name, venueTypes[] (FK to VenueType table, many-to-many), cuisines[] (FK to Cuisine table, many-to-many), area, address (nullable), geo (PostGIS point, nullable at DB level for Prisma-compat, but app should always collect it on add — see Section 9)
 - description, coverPhotoUrl
 - openingHours, contact, parking, seating (indoor/outdoor), ac, familyFriendly, wheelchairAccessible
 - status: active | closed
 - closedAt, closedRememberedFor (text) -- only when status = closed
 - badges: Badge[]
 - createdAt (first added to archive)

Badge
 - id, label (Karachi Classic, Since 1975, Local Legend, Family Favorite, Hidden Institution, Hidden Gem)
 - assigned manually via admin, never auto-algorithmic for Hidden Gem specifically

VenueType (admin-editable table, not hardcoded enum)
 - id, name (Cafe, Restaurant, Dhaba, Canteen, Bakery, Street Food, Dessert Shop, Ice Cream Parlor, Tea Spot, Juice Bar, Fast Food, BBQ Joint, ...)
 - seed with initial list, addable later via Prisma Studio/admin with no migration

Cuisine (admin-editable table, not hardcoded enum)
 - id, name (Desi, Chinese, BBQ, Seafood, Pizza, Biryani, Nihari, Breakfast, Continental, ...)
 - seed with initial list, addable later via Prisma Studio/admin with no migration

EateryTimelineEvent
 - id, eateryId, year, eventText  (opened, renovated, award, ownership change, closed, etc.)

MenuVersion
 - id, eateryId, effectiveYear, items: MenuItem[]

MenuItem
 - id, menuVersionId, dishId (FK to Dish, nullable if unmatched), name, price

Dish
 - id, name, category (links "Chicken Alfredo" across all eateries citywide)

Visit  (the core personal-archive unit — one row per visit, never one review per restaurant)
 - id, userId, eateryId, date, time, rating (overall + optional category ratings: food/service/atmosphere/cleanliness/value/wait/comfort/parking/wifi/studyFriendly/dateFriendly/familyFriendly)
 - reviewText
 - photos: Photo[]
 - itemsOrdered: VisitItem[] (links to Dish where possible, plus freeform name)
 - totalBill, favoriteItem, wouldVisitAgain (bool)
 - companions (optional freeform or tag: alone/friends/family/work)
 - moodTags: string[] (Date, Friends, Family, Alone, Work, Late Night, Study, Birthday, Celebration, Comfort Food)
 - memoryNote (optional freeform, e.g. "First date.")

VisitItem
 - id, visitId, dishId (nullable), name, type (food/drink/dessert)

Photo
 - id, url, eateryId (nullable), visitId (nullable), galleryCategory (food/drinks/desserts/interior/exterior/menu/ambience)

Collection (user-made lists)
 - id, userId, name, eateryIds[], pinned (bool)

WishlistEntry
 - id, userId, eateryId, reason, recommendedBy, priority

Trail
 - id, name, description, eateryIds[] (ordered)
UserTrailProgress
 - id, userId, trailId, visitedEateryIds[]

Area (Karachi neighborhood)
 - id, name, description, popularDishes[], boundary (PostGIS polygon, optional)
```

Notes:
- Every review lives on a `Visit`, never on `Eatery` directly. Eatery's "average rating" is a derived aggregate over its Visits.
- Closing an eatery never deletes it — set `status: closed`, keep all Visits/Photos/MenuVersions intact. This is the "Miss It?" / "Restaurants We Miss" feature.
- Price history and dish rankings are derived queries over `MenuItem` and `VisitItem`, not separately maintained tables.

## 4. Feature List (build order = priority order)

### Phase 1 — Core Archive (MVP)
1. Auth (sign up/login)
2. Add Eatery (name, category, area, map location, description, initial photos)
3. Eatery Profile page (all fields from data model, photo gallery by category)
4. Add Visit (date, time, rating, review, items ordered, bill, photos, mood tags, memory note)
5. Visit Journal — list/timeline of a user's own visits, filterable by mood tag, area, rating
6. Explore — browse by category
7. Karachi Areas — browse by neighborhood, neighborhood page
8. Search (name, area, category, dish)
9. Basic map with pins

### Phase 2 — Personalization
10. Favorites & Collections (unlimited user-made lists)
11. Wishlist
12. Compare Visits (same eatery across years, shown chronologically on eatery page)
13. Tags (customizable descriptive tags on eateries)
14. "If You're Here..." nearby recommendations (PostGIS radius query)

### Phase 3 — City Archive & History
15. "Miss It?" closed-eatery archive
16. Eatery Timeline (opened/renovated/awarded/closed events)
17. Menu Archive (versioned menus by year) + Cost Over Time graph
18. Food Archive — browse by dish across the whole city, Dish Rankings ("Best Kunafa" city-wide)
19. Badges & Institutions (admin-assigned)

### Phase 4 — Karachi Identity Features
20. Karachi Specials sections (Burns Road Legends, Bun Kabab Trail, etc. — curated Trail entities)
21. Seasonal Karachi (Ramadan/Iftar/Sehri/Mango Season — time-boxed curated collections, admin managed)
22. Karachi Dictionary (static glossary content page)
23. Food Trails with progress tracking
24. Heat Map (visited eateries lit up on map, rest greyed)
25. Food Passport (area stamps) + Karachi Score (% of city explored)

### Phase 5 — Insights
26. Personal Statistics dashboard
27. "Timeline of Your Karachi" year-by-year narrative (generated from Visit data, not AI-authored prose in v1 — templated sentences from stats)
28. "The Order" — most-ordered dish/drink breakdown per user

### Phase 6 — Admin & Moderation
29. Next.js admin portal: eatery CRUD, badge assignment, timeline event entry, menu version entry, closed-eatery marking, photo moderation, trail curation

### Explicitly deferred (do not build until asked)
- Following friends / social sharing / public profiles
- Community-wide ratings weighting algorithms
- AI-powered recommendations
- Oral history audio/video uploads
- Multi-city expansion
- Achievement badges beyond Food Passport/Karachi Score

## 5. Screens (Flutter app, high level)

Home → Explore → Area pages → Eatery Profile → Add Visit flow → Visit Journal → Search → Map (+ Heat Map toggle) → Collections → Wishlist → Food Archive (dish pages) → Trails → Food Passport → Personal Stats → Profile/Settings

Navigation: bottom tab bar — Home, Explore, Map, Journal, Profile. Everything else pushed on top.

## 6. Non-functional

- Offline: cache last-viewed eateries and user's own visits locally (Flutter local DB, e.g. Drift/Isar) so journal is viewable offline; writes queue and sync when back online.
- Privacy: Visits are private to the user by default in v1 (no public/social layer yet per deferred list).
- Photos: client-side compress before upload.

## 7a-2. MVP Decisions (locked 2026-07-05, round 4 — most recent)

- App name: **DeeFoodieApp** (see title). Use as package ID base, e.g. `com.deefoodieapp.*`.
- Dish Rankings: computed as average visit rating tied to each dish, city-wide across all visits — works with sparse (2-user) data, just improves as archive grows. No manual curation needed.
- Search: build filters alongside search from Phase 1 day one (not deferred to Phase 2) — e.g. venueType, cuisine, area, AC, family-friendly, price-range chips alongside the text search bar.
- Deploy-readiness: write the NestJS API with a Dockerfile and full env-based (12-factor) config from the start, even though real hosting choice is deferred — costs nothing now, avoids a scramble later when the ngrok tunnel workflow breaks down.

## 7a. MVP Decisions (locked 2026-07-05, round 3)

- Ratings: 1-5 stars, half-star increments allowed. Overall rating required per Visit; all category sub-ratings optional.
- Visits: fully editable and deletable by their owner, any time. Backdating to any past date is allowed (needed to seed personal history / power "Timeline of Your Karachi").
- Shared model (you + friend): each person logs their own separate Visit per outing (not one shared record). Both visits show together on the eatery page. Each user can only edit/delete their own visits, but can view the other's.
- Adding eateries, marking closed, entering menu versions: either user can do any of these freely, no approval workflow — pure trust-based 2-user model.
- Dish matching: visit items are free-text at entry time (zero friction while eating); linking free-text items to a canonical `Dish` record happens later as a background/admin cleanup task.
- Duplicate eateries: prevent at add-time with a fuzzy name+area match warning ("Kolachi already exists in Clifton — use it?"), AND build a merge script/tool as a fallback for when duplicates slip through anyway.
- Photos: unlimited per visit, client-side compressed before upload.
- Karachi Score: % of defined `Area` records visited (not % of eateries).
- Trails: admin-curated only for MVP (via seed data/Prisma Studio), no user-facing trail builder yet.
- "Timeline of Your Karachi": templated sentences generated deterministically from visit stats — no LLM call, no API cost.
- Notifications: none for MVP — pure pull/open-app usage, no FCM/APNs setup needed.
- Data export/backup: deferred past MVP.
- Offline: poor-connectivity resilience only (cache last-viewed data, queue writes) — not full offline-first.
- Area boundaries: real geographic polygons, sourced from OpenStreetMap/Overpass API via a one-time import script (Karachi neighborhood boundaries), stored as PostGIS polygons on `Area`.
- **Hosting/reachability:** app must be usable from restaurants (outside home network), not local-network-only. For now: tunnel local Docker Postgres+API to the internet via ngrok (or similar) as a stopgap. Real free-tier hosting decision (Railway/Render/Supabase) deferred — revisit once ngrok friction becomes annoying (ngrok URLs rotate on free tier, which will be the forcing function to finally pick real hosting).
- Dev vs prod DB: local Docker Postgres+PostGIS for dev, tunneled to internet for the actual 2-user real usage in the meantime (see above) — not a separate hosted prod DB yet.

## 7b. MVP Decisions (locked 2026-07-05, round 2)

- Users: exactly two — you and one friend. Not a private-per-user model: visits/reviews are **shared between the two of you**. Build a minimal `sharedWith` model (both users are implicitly in one shared group) rather than a full following/friend system — no public/social layer beyond this pair.
- Seed data: bulk-seed ~30-50 well-known Karachi eateries (iconic names — Burns Road, Boat Basin, Do Darya, famous chains/institutions) via a seed script, compiled manually/AI-assisted since no free API covers Karachi F&B well.
- Language: full bilingual UI — English + Roman Urdu, every label/button has both, language toggle in settings. Use a proper i18n setup (Flutter `intl` + ARB files) from the start, not hardcoded strings, so this doesn't become a rewrite later.
- Platform priority: **iOS first** (flipped from earlier Android-first draft — user corrected to iOS). Superseded 2026-07-05: iOS is now the *only* ship target, see Section 1 — Android is not "later," it's not planned at all.
- iOS build/test: no local Xcode/simulator workflow yet — user wants to test "through GitHub," meaning CI-driven builds (GitHub Actions building the Flutter iOS app). Set up a GitHub Actions workflow that builds the iOS app on every push as the primary feedback loop; local Xcode Simulator setup is a fallback to suggest if CI builds prove too slow to iterate with.
- Git: init repo now, monorepo layout (`/mobile`, `/api`, `/admin` later), pnpm for backend.

## 7c. MVP Decisions (locked 2026-07-05, round 1)

- Team: solo build, informal (friend suggests ideas, you execute). No CI/team conventions overhead yet.
- Auth: deferred — stub a fake-auth middleware (single dev user) for Phase 1, plug Clerk (free tier) in before Phase 2 needs real users.
- DB: local Docker Postgres + PostGIS only. No managed hosting yet.
- Storage: local filesystem (Docker volume) for photos in dev. Swap to S3/R2/Supabase Storage later — code the storage layer behind one interface so swap is a config change, not a rewrite.
- Devices: real iPhone/Android available — test on real hardware, not just simulator, before calling a feature done.
- Admin portal: deferred past Phase 1-5. Use Prisma Studio + seed scripts for data entry until Phase 6.
- Free-tier-everything: prefer free tiers across the board — Mapbox/OSM free tier for maps, Clerk free tier for auth later, no paid infra during MVP. When it's time to look for restaurant/food data APIs (menus, ratings, place info for Karachi), research free options (Google Places API has a free monthly credit; OpenStreetMap/Overpass API is fully free for place data but sparse for Karachi F&B) — flag realistically that food-specific data for Karachi will mostly be user-submitted, not pulled from an API, since no free API has good Karachi restaurant coverage.

## 8. Execution Rules for Claude Code

- Build phase by phase, in the order listed in Section 4. Do not skip ahead.
- Before starting a phase, confirm Prisma schema changes needed, migrate, then build API endpoints, then Flutter screens.
- Never assume a requirement not in this doc — ask, or make the smallest reasonable assumption and note it in the PR description.
- Keep this file updated: when a real architectural decision is made that deviates from this doc, edit this file in the same commit.
- No dead code, no speculative abstractions, no unused scaffolding "for later."

## 9. Scaffold Status (as of 2026-07-06)

Already built — do not re-scaffold, extend instead:
- `/api`: NestJS app, PrismaService, stub auth middleware, `GET /health`, Dockerfile, **storage service** (`STORAGE_DRIVER=local|s3`).
- Prisma schema at `api/prisma/schema.prisma` matches Section 3, migrated to local Docker Postgres+PostGIS. `geo`/`boundary` set via raw SQL.
- Seed + **10,000-eatery demo archive** (`fetch-osm-karachi.mjs` + `generate-extra-eateries.mjs` + `build-mobile-archive.mjs` → `mobile/assets/demo/archive.json`).
- `docker-compose.yml`: Postgres+PostGIS **5435**, Redis **6380**.
- App icon/logo at `assets/logo/logo.svg`; stickers at `assets/stickers/`.
- `.github/workflows/ios-build.yml`: Flutter test + iOS build on `mobile/**` pushes.
- **`/mobile` Flutter app (Phase 1 + Waves 2–4 on demo archive):**
  - 5-tab shell (Home · Explore · Map · Journal · Profile)
  - Journal **book view** (page curl, live page counter, visit time on spread, friends/family memory photos, 21 stickers)
  - **Map clustering** at low zoom + heat toggle; **plan tonight** + trail highlights + visit-sized pins
  - **Home** — chains, near-me GPS, seasonal strip, friend card, mood strip, quick log; score → map heat
  - **Explore** — persisted filters, haven't-been, price bands, deal badges
  - **Dish detail** `/dish/:name` with visit-based rankings; compare visits on eatery profile
  - **Journal** — year dividers, mood spread themes, voice chip, share-as-image
  - **Visit templates** per eatery; sync queue banner; API visit `time` sync
  - App-wide ruled paper + paper cards
  - Add/Edit Visit journal forms, Food Passport, Trails, wrapped, seasonal, collections, order, miss-it, dictionary
  - Dev screen gallery: `mobile/screen-gallery.html` (VaultCap-style, not shipped in app)
  - Chrome dev via `flutter build web` + static server (port 8765)
  - iOS on-device script: `mobile/scripts/run-on-iphone.sh`

Not yet built: `/admin` Next.js portal (deferred past Phase 5). Real hosting/ngrok, Clerk auth, API sync for book memories, area boundary polygon import.
