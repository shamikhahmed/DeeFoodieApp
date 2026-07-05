#!/usr/bin/env node
/** Build mobile/assets/demo/archive.json — 10K eateries, OSM + curated + generated */
import fs from 'fs';
import path from 'path';
import { fileURLToPath, pathToFileURL } from 'url';
import { pickCoverPhoto, pickAreaPhotoAsset, pickVisitPhoto } from './venue-photo-sources.mjs';
import { enrichEatery } from './iconic-venues-enriched.mjs';
import { formatAddress, phoneFor, hoursFor, areaPhotoAsset } from './karachi-areas.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');
const TARGET_TOTAL = 10000;

const { KARACHI_EATERIES } = await import(pathToFileURL(path.join(root, 'karachi-eateries-100.ts')).href);
const { KARACHI_EATERIES_EXTRA } = await import(pathToFileURL(path.join(root, 'karachi-eateries-extra.ts')).href).catch(() => ({ KARACHI_EATERIES_EXTRA: [] }));
const { BASE_DEMO_VISITS, EXTRA_DEMO_VISITS, ICONIC_BADGES, estimatedRating } = await import(pathToFileURL(path.join(root, 'seed-helpers.ts')).href);

const osmPath = path.join(root, 'data/osm-karachi.json');
const OSM_EATERIES = fs.existsSync(osmPath)
  ? JSON.parse(fs.readFileSync(osmPath, 'utf8')).eateries ?? []
  : [];

const MENU = {
  Biryani: [{ name: 'Chicken Biryani', price: 450 }, { name: 'Raita', price: 80 }],
  BBQ: [{ name: 'Seekh Kabab', price: 380 }, { name: 'Malai Boti', price: 520 }],
  Desi: [{ name: 'Chicken Karahi', price: 1500 }, { name: 'Naan', price: 50 }],
  Nihari: [{ name: 'Nihari', price: 400 }, { name: 'Naan', price: 50 }],
  Chinese: [{ name: 'Chow Mein', price: 650 }, { name: 'Manchurian', price: 550 }],
  Desserts: [{ name: 'Kulfi Falooda', price: 250 }, { name: 'Gulab Jamun', price: 150 }],
  'Fast Food': [{ name: 'Zinger Burger', price: 550 }, { name: 'Fries', price: 200 }],
  Continental: [{ name: 'Pasta', price: 1100 }, { name: 'Cappuccino', price: 450 }],
  Breakfast: [{ name: 'Paratha', price: 80 }, { name: 'Chai', price: 80 }],
  Seafood: [{ name: 'Grilled Fish', price: 1800 }, { name: 'Prawns', price: 1400 }],
  Pizza: [{ name: 'Margherita', price: 900 }, { name: 'Pepperoni', price: 1100 }],
  'Bakery Items': [{ name: 'Chicken Patties', price: 120 }, { name: 'Croissant', price: 250 }],
};

function menuFor(cuisines) {
  for (const c of cuisines) if (MENU[c]) return MENU[c];
  return MENU.Desi;
}

const CLOSED_NAMES = new Set(['Lal Qila Restaurant', 'Pie in the Sky', 'Ginsoy']);

function normName(n) {
  return n.toLowerCase().replace(/[^a-z0-9]+/g, ' ').trim();
}

function attachRichFields(raw, idx) {
  const area = raw.area ?? raw.areaName;
  const venueTypes = raw.venueTypes ?? ['Restaurant'];
  const cuisines = raw.cuisines ?? ['Desi'];
  const menu = menuFor(cuisines);
  const mustTry = menu[0];
  const enriched = enrichEatery({
    ...raw,
    areaName: area,
    venueTypes,
    cuisines,
    address: raw.address ?? formatAddress(area, raw.name, idx),
    phone: raw.phone ?? phoneFor(area, idx),
    openingHours: raw.openingHours ?? hoursFor(venueTypes),
    famousFor: raw.famousFor ?? (raw.cuisines?.[0] ? `Known for ${raw.cuisines[0].toLowerCase()} in ${area}` : null),
    dataSource: raw.dataSource ?? 'generated',
  });
  const cover = pickCoverPhoto(enriched);
  return {
    ...enriched,
    coverPhotoUrl: cover,
    areaPhotoAsset: pickAreaPhotoAsset({ ...enriched, areaName: area }),
    mustTryName: mustTry.name,
    mustTryPrice: mustTry.price,
    menu,
    badges: ICONIC_BADGES[raw.name] ?? enriched.badges ?? [],
    status: CLOSED_NAMES.has(raw.name) || enriched.status === 'closed' ? 'closed' : 'active',
  };
}

const archiveTrails = [
  { id: 'burns-road', name: 'Burns Road Legends', description: 'The old city lane where Karachi still eats like it means it.', emoji: '🔥', eateryNames: ['Burns Road Falooda', 'Delhi Nihari & Haleem', 'Waris Nihari', 'Sabri Nihari', 'Ghaffar Kabab House', 'Hanifia Mughal Biryani'] },
  { id: 'do-darya', name: 'Do Darya Sunset Row', description: 'Sea breeze, coal smoke, and the full weekend Karachi spread.', emoji: '🌊', eateryNames: ['Kolachi', 'Bar-B-Q Tonight', 'Do Darya Seafood Grill', 'Kababjees', 'Pompeii Restaurant'] },
  { id: 'bun-kabab', name: 'Bun Kabab Trail', description: 'Street buns, chutney, and late-night fuel across the city.', emoji: '🥙', eateryNames: ['Golden Bun Kabab Spot', 'Boat Basin Food Street', 'Famous Bun Kabab', 'Green Bun Kabab'] },
  { id: 'clifton-cafes', name: 'Clifton Café Circuit', description: 'Brunch, coffee, and dessert stops along the south shore.', emoji: '☕', eateryNames: ['Butlers Chocolate Cafe', 'Espresso', 'Cafe Aylanto', 'Chatterbox Cafe', 'Gloria Jean\'s Coffees'] },
  { id: 'biryani-crawl', name: 'Biryani Crawl', description: 'The debate never ends — log your own verdict at each stop.', emoji: '🍚', eateryNames: ['Student Biryani', 'Hanifia Mughal Biryani', 'Zameer Ansari Beef Biryani', 'Bundu Khan', 'Usmania Restaurant'] },
  { id: 'hotel-dining', name: 'Hotel Dining Trail', description: 'Karachi hotels — from PC Chandni to rooftop grills.', emoji: '🏨', eateryNames: ['PC Hotel — Chandni Restaurant', 'Marriott — Nadia Coffee Shop', 'Avari Towers — Dynasty Restaurant', 'Mövenpick — The Restaurant', 'Beach Luxury — Bay View Restaurant', 'Ramada — Cinnamon Restaurant'] },
];

const seen = new Set();
const sources = [];

function tryAdd(raw) {
  const key = normName(raw.name);
  if (!key || seen.has(key)) return false;
  seen.add(key);
  sources.push(raw);
  return true;
}

for (const e of KARACHI_EATERIES) tryAdd({ ...e, area: e.area, dataSource: 'curated' });
for (const e of OSM_EATERIES) tryAdd(e);
for (const e of KARACHI_EATERIES_EXTRA) {
  if (sources.length >= TARGET_TOTAL) break;
  tryAdd({ ...e, area: e.area, dataSource: 'generated' });
}

const nameToEatery = new Map();
let id = 0;
const eateries = sources.slice(0, TARGET_TOTAL).map((e) => {
  id++;
  const base = attachRichFields(e, id);
  const entry = {
    id: `seed-${id.toString(16).padStart(8, '0')}`,
    name: base.name,
    areaName: base.areaName,
    venueTypes: base.venueTypes,
    cuisines: base.cuisines,
    badges: base.badges,
    description: base.description,
    address: base.address,
    phone: base.phone,
    openingHours: base.openingHours,
    famousFor: base.famousFor,
    website: base.website ?? null,
    instagramUrl: base.instagramUrl ?? null,
    googleRating: base.googleRating ?? null,
    googleReviewCount: base.googleReviewCount ?? null,
    branches: base.branches ?? [],
    externalReviews: base.externalReviews ?? [],
    promotions: base.promotions ?? [],
    coverPhotoUrl: base.coverPhotoUrl,
    areaPhotoAsset: base.areaPhotoAsset ?? areaPhotoAsset(base.areaName),
    dataSource: base.dataSource,
    avgRating: 0,
    visitCount: 0,
    mustTryName: base.mustTryName,
    mustTryPrice: base.mustTryPrice,
    createdAt: new Date().toISOString(),
    lat: base.lat,
    lng: base.lng,
    menu: base.menu,
    status: base.status,
  };
  nameToEatery.set(entry.name, entry);
  return entry;
});

const USER_NAMES = { 'you@deefoodie.app': 'You', 'friend@deefoodie.app': 'Friend' };
const rawVisits = [...BASE_DEMO_VISITS, ...EXTRA_DEMO_VISITS];
const visits = [];
let visitIdx = 0;
const ratingSum = new Map();
const ratingCount = new Map();

for (const v of rawVisits) {
  const eatery = nameToEatery.get(v.eateryName);
  if (!eatery) {
    console.warn(`skip visit — eatery not found: ${v.eateryName}`);
    continue;
  }
  visitIdx++;
  visits.push({
    id: `visit-${visitIdx.toString(16).padStart(6, '0')}`,
    eateryId: eatery.id,
    eateryName: eatery.name,
    areaName: eatery.areaName,
    date: v.date,
    rating: v.rating,
    reviewText: v.reviewText,
    moodTags: v.moodTags,
    userName: USER_NAMES[v.userEmail] ?? 'You',
    memoryNote: v.memoryNote ?? null,
    favoriteItem: v.favoriteItem ?? null,
    totalBill: v.totalBill ?? null,
    companions: v.companions ?? null,
    items: v.items,
    photoUrl: pickVisitPhoto(v, eatery),
  });
  ratingSum.set(eatery.id, (ratingSum.get(eatery.id) ?? 0) + v.rating);
  ratingCount.set(eatery.id, (ratingCount.get(eatery.id) ?? 0) + 1);
}

for (const e of eateries) {
  const count = ratingCount.get(e.id) ?? 0;
  e.visitCount = count;
  const avg = count ? (ratingSum.get(e.id) ?? 0) / count : null;
  e.avgRating = estimatedRating(e.name, avg);
}

const archive = { eateries, visits, trails: archiveTrails };
const out = path.join(root, '../../mobile/assets/demo/archive.json');
fs.writeFileSync(out, JSON.stringify(archive));
const closed = eateries.filter((e) => e.status === 'closed').length;
const withAddr = eateries.filter((e) => e.address).length;
const withPhone = eateries.filter((e) => e.phone).length;
const withReviews = eateries.filter((e) => e.externalReviews?.length).length;
const withPhoto = eateries.filter((e) => e.coverPhotoUrl).length;
const osmUsed = eateries.filter((e) => e.dataSource === 'osm').length;
const trailHits = archiveTrails.reduce((n, t) => n + t.eateryNames.filter((name) => nameToEatery.has(name)).length, 0);
const trailTotal = archiveTrails.reduce((n, t) => n + t.eateryNames.length, 0);
console.log(`Wrote ${eateries.length} eateries, ${visits.length} visits, ${closed} closed → ${out}`);
console.log(`Sources: curated+osm(${osmUsed} osm) | addr ${withAddr} | phone ${withPhone} | reviews ${withReviews} | remote photo ${withPhoto}`);
console.log(`Trail name match: ${trailHits}/${trailTotal}`);
