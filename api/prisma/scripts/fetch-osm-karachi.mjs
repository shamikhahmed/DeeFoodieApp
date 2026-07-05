#!/usr/bin/env node
/** Fetch + normalize OpenStreetMap Karachi F&B POIs (real addresses, phones, hours). */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { nearestArea, formatAddress, phoneFor, hoursFor } from './karachi-areas.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const outPath = path.join(__dirname, '../data/osm-karachi.json');
const rawPath = path.join(__dirname, '../data/osm-karachi-raw.json');

const QUERY = `[out:json][timeout:120];
(
  node["amenity"~"restaurant|cafe|fast_food|food_court|ice_cream|tea_house|biergarten"](24.75,66.85,25.15,67.35);
  way["amenity"~"restaurant|cafe|fast_food|food_court|ice_cream|tea_house|biergarten"](24.75,66.85,25.15,67.35);
);
out center tags;`;

async function fetchOsm() {
  if (fs.existsSync(rawPath) && fs.statSync(rawPath).size > 10000) {
    return JSON.parse(fs.readFileSync(rawPath, 'utf8'));
  }
  const res = await fetch('https://overpass-api.de/api/interpreter', {
    method: 'POST',
    headers: { 'User-Agent': 'DeeFoodieApp/1.0', 'Content-Type': 'application/x-www-form-urlencoded' },
    body: `data=${encodeURIComponent(QUERY)}`,
  });
  const text = await res.text();
  if (!text.startsWith('{')) throw new Error(`Overpass error: ${text.slice(0, 200)}`);
  fs.writeFileSync(rawPath, text);
  return JSON.parse(text);
}

const AMENITY_VENUE = {
  restaurant: ['Restaurant'],
  cafe: ['Cafe'],
  fast_food: ['Fast Food'],
  food_court: ['Restaurant', 'Fast Food'],
  ice_cream: ['Ice Cream Parlor', 'Dessert Shop'],
  tea_house: ['Tea Spot', 'Cafe'],
  biergarten: ['Restaurant'],
};

const CUISINE_MAP = {
  pizza: 'Pizza',
  burger: 'Fast Food',
  chinese: 'Chinese',
  indian: 'Desi',
  pakistani: 'Desi',
  biryani: 'Biryani',
  seafood: 'Seafood',
  barbecue: 'BBQ',
  bbq: 'BBQ',
  coffee: 'Breakfast',
  tea: 'Breakfast',
  ice_cream: 'Desserts',
  bakery: 'Bakery Items',
  sandwich: 'Fast Food',
  chicken: 'Fast Food',
  kebab: 'BBQ',
};

function normalize(el, i) {
  const t = el.tags ?? {};
  const name = t.name || t['name:en'];
  if (!name || name.length < 2) return null;

  const lat = el.lat ?? el.center?.lat;
  const lng = el.lon ?? el.center?.lon;
  if (lat == null || lng == null) return null;

  const area = nearestArea(+lat, +lng);
  const amenity = t.amenity ?? 'restaurant';
  const venueTypes = AMENITY_VENUE[amenity] ?? ['Restaurant'];

  const cuisines = [];
  const rawCuisine = (t.cuisine ?? '').toLowerCase().split(/[;,]/).map((s) => s.trim()).filter(Boolean);
  for (const c of rawCuisine) {
    for (const [k, v] of Object.entries(CUISINE_MAP)) {
      if (c.includes(k) && !cuisines.includes(v)) cuisines.push(v);
    }
  }
  if (cuisines.length === 0) {
    if (amenity === 'cafe') cuisines.push('Breakfast');
    else if (amenity === 'fast_food') cuisines.push('Fast Food');
    else cuisines.push('Desi');
  }

  const street = [t['addr:housenumber'], t['addr:street']].filter(Boolean).join(' ');
  const suburb = t['addr:suburb'] || t['addr:neighbourhood'] || area;
  const address = t['addr:full']
    || (street ? `${street}, ${suburb}, Karachi` : formatAddress(area, name, i));

  const phone = t.phone || t['contact:phone'] || t['contact:mobile'] || null;
  const openingHours = t.opening_hours || null;
  const website = t.website || t['contact:website'] || null;
  const coverPhotoUrl = t.image || null;

  return {
    name: name.trim(),
    area,
    venueTypes,
    cuisines,
    lat: +(+lat).toFixed(4),
    lng: +(+lng).toFixed(4),
    description: `${name.trim()} in ${area}. Listed on OpenStreetMap — Karachi city archive.`,
    address,
    phone,
    openingHours,
    website,
    coverPhotoUrl,
    dataSource: 'osm',
    osmId: `${el.type}/${el.id}`,
  };
}

function dedupe(entries) {
  const seen = new Map();
  const out = [];
  for (const e of entries) {
    const key = `${e.name.toLowerCase()}|${e.area}|${e.lat.toFixed(3)}`;
    if (seen.has(key)) continue;
    seen.set(key, true);
    out.push(e);
  }
  return out;
}

const data = await fetchOsm();
const normalized = dedupe(
  data.elements.map((el, i) => normalize(el, i)).filter(Boolean),
);
fs.writeFileSync(outPath, JSON.stringify({ fetchedAt: new Date().toISOString(), count: normalized.length, eateries: normalized }, null, 0));
console.log(`OSM Karachi: ${normalized.length} eateries → ${outPath}`);
