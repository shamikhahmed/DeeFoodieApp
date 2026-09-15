# Background Photo Attribution

Bundled + remote photos for DeeFoodieApp. **Venue covers only when linked to that venue/chain with license + attribution (DFD-P0-02).** Otherwise cuisine illustrations.

## Bundled (offline fallback)

| File | Subject | License |
|------|---------|---------|
| `karachi_clifton_sunset.jpg` | Karachi sunset | CC BY-SA (Wikimedia) |
| `karachi_coast_aerial.jpg` | Clifton/sea area fallback | Same |
| `karachi_seafront_evening.jpg` | Do Darya area fallback | Same |
| `karachi_food_street.jpg` | Burns Road area fallback | Same |

## Archive covers

| Kind | Meaning |
|------|---------|
| `venue` | Photo mapped to that eatery (PHOTO_MAP / iconic) with license + attribution |
| `chain` | Chain-matched Wikimedia photo (not area-generic) |
| `placeholder` | No venue photo — UI shows `cuisineIllustrationUrl` + cuisine chip on dark scrim |

Regenerate integrity fields: `node scripts/patch-archive-photo-integrity.mjs`  
Full rebuild: `node api/prisma/scripts/build-mobile-archive.mjs`
