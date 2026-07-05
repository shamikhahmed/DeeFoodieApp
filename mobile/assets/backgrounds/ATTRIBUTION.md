# Background Photo Attribution

Bundled + remote photos for DeeFoodieApp. **All free — Wikimedia Commons (CC), no paid APIs.**

## Bundled (offline fallback)

| File | Subject | License |
|------|---------|---------|
| `karachi_clifton_sunset.jpg` | Karachi sunset | CC BY-SA (Wikimedia) |
| `karachi_coast_aerial.jpg` | Clifton/sea area fallback | Same |
| `karachi_seafront_evening.jpg` | Do Darya area fallback | Same |
| `karachi_food_street.jpg` | Burns Road area fallback | Same |

## Archive `coverPhotoUrl` (10K eateries)

| Source | Coverage | Cost |
|--------|----------|------|
| [Wikimedia Commons](https://commons.wikimedia.org/wiki/Category:Restaurants_in_Karachi) area photos | ~9,900 venues | Free |
| Curated official URL | ~22 iconic | Free |
| OSM `image` tag | Rare | Free |
| Wikipedia API (optional enrich) | 117 base names | Free |

Area matching (real Karachi geography):
- **Do Darya / Clifton / DHA** → Seaview Clifton Beach
- **Burns Road / Saddar / Lyari** → Fresco Chowk Burns Road
- **Boat Basin / Keamari** → Port Grand Food Street
- **East Karachi areas** → Hill Park restaurant

**No Unsplash. No Google Places API.**

Regenerate: `node build-static-photo-map.mjs && node build-mobile-archive.mjs`
