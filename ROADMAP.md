# Roadmap

Phase order is priority order — don't skip ahead. Full feature detail in `CLAUDE.md` Section 4. This doc tracks status; `CLAUDE.md` is still the source of truth for scope.

**iOS only, premium bar.** Ship target is iPhone/App Store exclusively — Android is never built/tested/shipped. Free app, no paywall; "premium" means Apple-grade polish (animations, haptics, iOS gesture conventions), not monetization.

## Phase 0 — Scaffold (done)

- [x] Master spec (`CLAUDE.md`)
- [x] Git repo + monorepo layout
- [x] Logo/icon + sticker pack
- [x] Docker Compose (Postgres+PostGIS, Redis)
- [x] Prisma schema + initial migration
- [x] NestJS API skeleton (stub auth, health check, Dockerfile, S3 storage interface)
- [x] Seed script + **10,000-eatery** demo archive (OSM + enriched)
- [x] GitHub Actions iOS CI build
- [x] Flutter app — journal notebook UI, book view, screen gallery
- [ ] ngrok/tunnel so the API is reachable outside home wifi

## Phase 1 — Core Archive (MVP) — largely built on demo archive

- [ ] Auth (stub → Clerk when it matters)
- [x] Add Eatery flow (local + duplicate warning; API hook partial)
- [x] Eatery Profile page
- [x] Add Visit + Edit Visit (journal paper forms, photos)
- [x] Visit Journal (book view + timeline, mood filter, PDF)
- [x] Explore (browse + filters)
- [x] Karachi Areas (neighborhood pages + area photos)
- [x] Search + filters
- [x] Basic map with pins + heat map toggle

## Phase 2 — Personalization

- [x] Favorites (local)
- [x] Wishlist (local)
- [x] Collections (user lists)
- [ ] Compare Visits (chronological on eatery page — partial subtitle only)
- [ ] Custom tags on eateries
- [x] Nearby recs (haversine on eatery profile; PostGIS radius deferred)

## Phase 3 — City Archive & History

- [x] "Miss It?" closed-eatery archive (demo)
- [ ] Eatery Timeline events
- [x] Menu on eatery profile (from archive; versioned menu archive deferred)
- [x] Dishes browse (city-wide menu search)
- [ ] Dish Rankings (avg rating per dish)
- [ ] Badges (admin-assigned)

## Phase 4 — Karachi Identity Features

- [x] Food Trails (demo + progress)
- [x] Seasonal Karachi (Ramadan, mango)
- [x] Karachi Dictionary (static)
- [x] Heat Map
- [x] Food Passport + Karachi Score
- [ ] Real Area boundary polygons (OSM import)

## Phase 5 — Insights

- [x] Personal Statistics dashboard
- [x] Year in Food `/wrapped`
- [x] The Order `/order`

## Phase 6 — Admin & Moderation

- [ ] Next.js admin portal
- [ ] Eatery merge tool

## Polish backlog (journal / premium bar)

- [x] App-wide journal paper + Fraunces/Caveat typography
- [x] Book page curl + flip controls + stickers/memory photos
- [x] Screen gallery with iPhone previews
- [ ] Sync book memories to API
- [ ] iOS on-device pass (haptics, page sound, swipe-back QA)
- [ ] Real venue photo pipeline (S3 + moderation)

## Explicitly deferred — do not build without being asked

- Public social layer beyond 2-user share
- Community rating algorithms
- AI recommendations / LLM narrative
- Multi-city
- Push notifications
- Achievement badges beyond Passport/Score
