#!/usr/bin/env node
/**
 * Generate karachi-eateries-extra.ts — fills to TARGET_TOTAL unique eateries.
 * Includes hotel restaurants (famous + lesser-known Karachi hotels).
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const TARGET_ARCHIVE = 10000;
const BASE_COUNT = 117;
const osmPath = path.join(__dirname, '../data/osm-karachi.json');
const osmCount = fs.existsSync(osmPath)
  ? (JSON.parse(fs.readFileSync(osmPath, 'utf8')).count ?? 0)
  : 5200;
const TARGET_TOTAL = Math.max(1000, TARGET_ARCHIVE - BASE_COUNT - osmCount + 1500);

const AREAS = [
  'DHA', 'Clifton', 'PECHS', 'Bahadurabad', 'Gulshan-e-Iqbal', 'Gulistan-e-Jauhar',
  'Saddar', 'Burns Road', 'Tariq Road', 'Shahrah-e-Faisal', 'North Nazimabad', 'Nazimabad',
  'Federal B Area', 'Korangi', 'Malir', 'Lyari', 'Keamari', 'Scheme 33', 'Defence View',
  'Boat Basin', 'Do Darya', 'Jamshed Town', 'Landhi', 'Orangi', 'SITE Area', 'Clifton Block 2',
  'DHA Phase 6', 'DHA Phase 8', 'Buffer Zone', 'Surjani Town',
];

const VENUE_TYPES = [
  ['Restaurant'], ['Cafe'], ['Dhaba'], ['Bakery'], ['Street Food'], ['Dessert Shop'],
  ['Tea Spot'], ['Fast Food'], ['BBQ Joint'], ['Ice Cream Parlor'], ['Juice Bar'],
  ['Restaurant', 'Cafe'], ['Hotel Restaurant'], ['Hotel Restaurant', 'Restaurant'],
];

const CUISINE_SETS = [
  ['Desi'], ['Biryani'], ['BBQ', 'Desi'], ['Chinese'], ['Fast Food'], ['Continental'],
  ['Breakfast'], ['Desserts'], ['Seafood'], ['Pizza'], ['Nihari'], ['Bakery Items'],
  ['BBQ'], ['Chinese', 'Desi'], ['Continental', 'Breakfast'], ['Seafood', 'BBQ'],
];

import { formatAddress, phoneFor, hoursFor } from './karachi-areas.mjs';

const PREFIXES = [
  'Al', 'New', 'Old', 'Royal', 'Karachi', 'Student', 'Super', 'Golden', 'Lahori', 'Hyderabadi',
  'Sindh', 'City', 'Metro', 'Classic', 'Famous', 'Baba', 'Chaudhry', 'Quetta', 'Lal', 'Green',
  'Blue', 'Red', 'Shah', 'Malik', 'Bukhari', 'Hussaini', 'Dehli', 'Mughal', 'Spice', 'Ocean',
];

const CORES = [
  'Biryani', 'BBQ', 'Karahi', 'Nihari', 'Haleem', 'Broast', 'Burger', 'Pizza', 'Chai', 'Paratha',
  'Falooda', 'Kunafa', 'Kabab', 'Tikka', 'Handi', 'Dhaba', 'Cafe', 'Bakery', 'Juice', 'Grill',
  'Pulao', 'Chaat', 'Roll', 'Shawarma', 'Tandoor', 'Dosa', 'Soup', 'Steak', 'Sushi', 'Karahi',
  'Cappuccino', 'Latte', 'Espresso', 'Donut', 'Croissant', 'Sandwich', 'Pasta', 'Waffle', 'Crepe',
  'Samosa', 'Pakora', 'Gol Gappay', 'Bun Kabab', 'Dahi Baray', 'Kachori', 'Lassi', 'Kulfi',
];

const CAFE_NAMES = [
  'Butlers', 'Gloria Jeans', 'Espresso', 'Chatterbox', 'Florentine', 'Cafe Flo', 'Mocca',
  'Coffee Wagera', 'Second Cup', 'Coffee Republic', 'Cafe Zouk', 'Cafe Aylanto', 'Cafe Khan',
  'Chai Wala', 'Dhaba Express', 'Student Cafe', 'Corner Cafe', 'Rooftop Cafe', 'Garden Cafe',
  'Sea View Cafe', 'Boat Basin Cafe', 'Clifton Cafe', 'DHA Cafe', 'Burns Road Cafe',
];

const CHAINS = [
  'KFC', 'McDonald\'s', 'Hardee\'s', 'Pizza Hut', 'Domino\'s', 'Subway', 'Burger Lab',
  'Kababjees', 'Optp', 'Nando\'s', 'Ginsoo', 'Pie in the Sky', 'Delizia', 'Kitchen Cuisine',
  'Lal Qila', 'Usmania', 'Student Biryani', 'Indus Biryani', 'Jans Broast', 'Kolachi Express',
];

const SUFFIXES = ['House', 'Corner', 'Point', 'Centre', 'Kitchen', 'Spot', 'Lounge', 'Express', 'Hub', 'Ghar', ''];

// Famous + lesser-known Karachi hotels — each gets multiple F&B outlets.
const HOTELS = [
  { name: 'Pearl Continental Hotel Karachi', area: 'Saddar', famous: true },
  { name: 'Marriott Hotel Karachi', area: 'Clifton', famous: true },
  { name: 'Mövenpick Hotel Karachi', area: 'Clifton', famous: true },
  { name: 'Avari Towers Karachi', area: 'Saddar', famous: true },
  { name: 'Avari Xpress Clifton', area: 'Clifton', famous: true },
  { name: 'Ramada Plaza by Wyndham Karachi', area: 'PECHS', famous: true },
  { name: 'Beach Luxury Hotel', area: 'Keamari', famous: true },
  { name: 'Hotel Mehran', area: 'Saddar', famous: true },
  { name: 'Regent Plaza Hotel & Convention Centre', area: 'Saddar', famous: true },
  { name: 'Carlton Hotel Karachi', area: 'Clifton', famous: true },
  { name: 'Nishat Hotel Clifton', area: 'Clifton', famous: true },
  { name: 'Hotel Crown Inn', area: 'Saddar', famous: false },
  { name: 'Embassy Inn Hotel', area: 'Clifton', famous: false },
  { name: 'Hotel Faran', area: 'Clifton', famous: false },
  { name: 'Hotel Galaxy', area: 'Saddar', famous: false },
  { name: 'Hotel Deep Sea', area: 'Clifton', famous: false },
  { name: 'Hotel Seaview', area: 'Clifton', famous: false },
  { name: 'Hotel Paradise', area: 'PECHS', famous: false },
  { name: 'Hotel Regency', area: 'Saddar', famous: false },
  { name: 'Hotel Crown Palace', area: 'North Nazimabad', famous: false },
  { name: 'Sarawan Hotel', area: 'Saddar', famous: false },
  { name: 'Hotel Country Inn', area: 'Gulshan-e-Iqbal', famous: false },
  { name: 'Hotel City Gate', area: 'Shahrah-e-Faisal', famous: false },
  { name: 'Best Western Plus Hotel', area: 'PECHS', famous: false },
  { name: 'Hotel Grand', area: 'Clifton', famous: false },
  { name: 'Hotel Excelsior', area: 'Saddar', famous: false },
  { name: 'Gulf Hotel Karachi', area: 'Saddar', famous: false },
  { name: 'Hotel Al Harmain', area: 'North Nazimabad', famous: false },
  { name: 'Hotel Skyways', area: 'Gulistan-e-Jauhar', famous: false },
  { name: 'Hotel Shaheen', area: 'PECHS', famous: false },
  { name: 'Hotel Al Rehman', area: 'Federal B Area', famous: false },
  { name: 'Hotel One Karachi', area: 'PECHS', famous: false },
  { name: 'Hotel Green Palace', area: 'Gulshan-e-Iqbal', famous: false },
  { name: 'Hotel Al Mumtaz', area: 'Malir', famous: false },
  { name: 'Hotel Al Safina', area: 'Keamari', famous: false },
  { name: 'Hotel Comfort Inn', area: 'Clifton', famous: false },
  { name: 'Hotel Royal Inn', area: 'Tariq Road', famous: false },
  { name: 'Hotel Al Habib', area: 'Bahadurabad', famous: false },
  { name: 'Hotel Al Noor', area: 'Nazimabad', famous: false },
  { name: 'Hotel Continental', area: 'Saddar', famous: false },
  { name: 'Grace Inn Hotel', area: 'Clifton', famous: false },
  { name: 'Hotel Crown Suites', area: 'DHA', famous: false },
  { name: 'Hotel Al Jadeed', area: 'Orangi', famous: false },
  { name: 'Hotel Al Mumtaz Residency', area: 'Korangi', famous: false },
  { name: 'Hotel Al Madina', area: 'Lyari', famous: false },
  { name: 'Hotel Al Falah', area: 'Landhi', famous: false },
  { name: 'Hotel Al Mustafa', area: 'SITE Area', famous: false },
  { name: 'Hotel Al Kareem', area: 'Jamshed Town', famous: false },
  { name: 'Hotel Al Qasim', area: 'Surjani Town', famous: false },
  { name: 'Hotel Al Rafay', area: 'Buffer Zone', famous: false },
  { name: 'Hotel Al Sadiq', area: 'Scheme 33', famous: false },
  { name: 'Hotel Al Taqwa', area: 'Defence View', famous: false },
  { name: 'Hotel Al Wahab', area: 'Boat Basin', famous: false },
  { name: 'Hotel Al Barkat', area: 'DHA Phase 6', famous: false },
  { name: 'Hotel Al Haram', area: 'DHA Phase 8', famous: false },
  { name: 'Hotel Al Iman', area: 'Clifton Block 2', famous: false },
  { name: 'Hotel Al Aziz', area: 'Gulistan-e-Jauhar', famous: false },
  { name: 'Hotel Al Basit', area: 'North Nazimabad', famous: false },
  { name: 'Hotel Al Firdous', area: 'Federal B Area', famous: false },
  { name: 'Hotel Al Huda', area: 'Malir', famous: false },
  { name: 'Hotel Al Karam', area: 'Korangi', famous: false },
  { name: 'Hotel Al Murtaza', area: 'PECHS', famous: false },
  { name: 'Hotel Al Naseeb', area: 'Bahadurabad', famous: false },
  { name: 'Hotel Al Qadir', area: 'Tariq Road', famous: false },
  { name: 'Hotel Al Rauf', area: 'Shahrah-e-Faisal', famous: false },
  { name: 'Hotel Al Salam', area: 'Gulshan-e-Iqbal', famous: false },
  { name: 'Hotel Al Tawheed', area: 'Nazimabad', famous: false },
  { name: 'Hotel Al Wali', area: 'Lyari', famous: false },
  { name: 'Hotel Al Zain', area: 'Keamari', famous: false },
  { name: 'Hotel Crown Residency', area: 'Clifton', famous: false },
  { name: 'Hotel Executive Lodge', area: 'PECHS', famous: false },
  { name: 'Hotel Fortune Inn', area: 'Saddar', famous: false },
  { name: 'Hotel Golden Sands', area: 'Clifton', famous: false },
  { name: 'Hotel Horizon', area: 'DHA', famous: false },
  { name: 'Hotel Imperial', area: 'Saddar', famous: false },
  { name: 'Hotel Indus', area: 'Clifton', famous: false },
  { name: 'Hotel Jasmine', area: 'PECHS', famous: false },
  { name: 'Hotel Kings', area: 'North Nazimabad', famous: false },
  { name: 'Hotel Lake View', area: 'Gulshan-e-Iqbal', famous: false },
  { name: 'Hotel Metro Inn', area: 'Saddar', famous: false },
  { name: 'Hotel Midway', area: 'Shahrah-e-Faisal', famous: false },
  { name: 'Hotel New City', area: 'Bahadurabad', famous: false },
  { name: 'Hotel Ocean View', area: 'Do Darya', famous: false },
  { name: 'Hotel Park Lane', area: 'Clifton', famous: false },
  { name: 'Hotel Pearl Residency', area: 'Tariq Road', famous: false },
  { name: 'Hotel Plaza Inn', area: 'Saddar', famous: false },
  { name: 'Hotel Prime', area: 'DHA', famous: false },
  { name: 'Hotel Queens', area: 'PECHS', famous: false },
  { name: 'Hotel Riviera', area: 'Clifton', famous: false },
  { name: 'Hotel Rose Palace', area: 'Gulistan-e-Jauhar', famous: false },
  { name: 'Hotel Royal Crown', area: 'North Nazimabad', famous: false },
  { name: 'Hotel Sapphire', area: 'Clifton', famous: false },
  { name: 'Hotel Serene', area: 'DHA', famous: false },
  { name: 'Hotel Silver Oaks', area: 'PECHS', famous: false },
  { name: 'Hotel Star', area: 'Saddar', famous: false },
  { name: 'Hotel Sunway', area: 'Gulshan-e-Iqbal', famous: false },
  { name: 'Hotel Top View', area: 'Clifton', famous: false },
  { name: 'Hotel Tulip', area: 'Bahadurabad', famous: false },
  { name: 'Hotel United', area: 'Saddar', famous: false },
  { name: 'Hotel Victoria', area: 'Clifton', famous: false },
  { name: 'Hotel White Palace', area: 'PECHS', famous: false },
  { name: 'Hotel Zam Zam', area: 'North Nazimabad', famous: false },
  { name: 'Indus Hotel Saddar', area: 'Saddar', famous: false },
  { name: 'Karachi Marriott Executive Apartments', area: 'Clifton', famous: true },
  { name: 'PC Hotel Executive Floor Lounge', area: 'Saddar', famous: true },
];

const HOTEL_OUTLETS = [
  { outlet: 'Chandni Restaurant', cuisines: ['Desi', 'BBQ'], venue: ['Hotel Restaurant', 'Restaurant'] },
  { outlet: 'Marco Polo Restaurant', cuisines: ['Continental'], venue: ['Hotel Restaurant'] },
  { outlet: 'Sakura Japanese', cuisines: ['Chinese'], venue: ['Hotel Restaurant', 'Restaurant'] },
  { outlet: 'Coffee Shop', cuisines: ['Breakfast', 'Continental'], venue: ['Hotel Restaurant', 'Cafe'] },
  { outlet: 'Lobby Lounge', cuisines: ['Continental'], venue: ['Hotel Restaurant', 'Cafe'] },
  { outlet: 'Poolside Grill', cuisines: ['BBQ', 'Seafood'], venue: ['Hotel Restaurant'] },
  { outlet: 'Rooftop BBQ', cuisines: ['BBQ', 'Desi'], venue: ['Hotel Restaurant', 'Restaurant'] },
  { outlet: 'All Day Dining', cuisines: ['Continental', 'Desi'], venue: ['Hotel Restaurant'] },
  { outlet: 'Executive Lounge', cuisines: ['Breakfast', 'Continental'], venue: ['Hotel Restaurant', 'Cafe'] },
  { outlet: 'Patisserie & Bakery', cuisines: ['Bakery Items', 'Desserts'], venue: ['Hotel Restaurant', 'Bakery'] },
  { outlet: 'Tea Lounge', cuisines: ['Breakfast'], venue: ['Hotel Restaurant', 'Tea Spot'] },
  { outlet: 'Room Service Kitchen', cuisines: ['Desi', 'Continental'], venue: ['Hotel Restaurant'] },
  { outlet: 'Sea View Restaurant', cuisines: ['Seafood', 'BBQ'], venue: ['Hotel Restaurant'] },
  { outlet: 'Desi Kitchen', cuisines: ['Desi', 'Biryani'], venue: ['Hotel Restaurant'] },
  { outlet: 'Continental Brasserie', cuisines: ['Continental'], venue: ['Hotel Restaurant'] },
];

// Real named hotel restaurants (iconic — deduped by name)
const NAMED_HOTEL_RESTAURANTS = [
  { name: 'PC Hotel — Chandni Restaurant', hotel: 'Pearl Continental Hotel Karachi', area: 'Saddar', cuisines: ['Desi', 'BBQ'], venue: ['Hotel Restaurant'] },
  { name: 'PC Hotel — Marco Polo Restaurant', hotel: 'Pearl Continental Hotel Karachi', area: 'Saddar', cuisines: ['Continental'], venue: ['Hotel Restaurant'] },
  { name: 'PC Hotel — Sakura', hotel: 'Pearl Continental Hotel Karachi', area: 'Saddar', cuisines: ['Chinese'], venue: ['Hotel Restaurant'] },
  { name: 'PC Hotel — The Pakistani', hotel: 'Pearl Continental Hotel Karachi', area: 'Saddar', cuisines: ['Desi'], venue: ['Hotel Restaurant'] },
  { name: 'Marriott — Nadia Coffee Shop', hotel: 'Marriott Hotel Karachi', area: 'Clifton', cuisines: ['Breakfast', 'Continental'], venue: ['Hotel Restaurant', 'Cafe'] },
  { name: 'Marriott — The Patio', hotel: 'Marriott Hotel Karachi', area: 'Clifton', cuisines: ['BBQ', 'Continental'], venue: ['Hotel Restaurant'] },
  { name: 'Marriott — Room Service', hotel: 'Marriott Hotel Karachi', area: 'Clifton', cuisines: ['Continental', 'Desi'], venue: ['Hotel Restaurant'] },
  { name: 'Mövenpick — The Restaurant', hotel: 'Mövenpick Hotel Karachi', area: 'Clifton', cuisines: ['Continental'], venue: ['Hotel Restaurant'] },
  { name: 'Mövenpick — La Maison', hotel: 'Mövenpick Hotel Karachi', area: 'Clifton', cuisines: ['Continental', 'Breakfast'], venue: ['Hotel Restaurant', 'Cafe'] },
  { name: 'Avari Towers — Dynasty Restaurant', hotel: 'Avari Towers Karachi', area: 'Saddar', cuisines: ['Chinese'], venue: ['Hotel Restaurant'] },
  { name: 'Avari Towers — The Sky BBQ', hotel: 'Avari Towers Karachi', area: 'Saddar', cuisines: ['BBQ'], venue: ['Hotel Restaurant'] },
  { name: 'Avari Towers — Fujiyama', hotel: 'Avari Towers Karachi', area: 'Saddar', cuisines: ['Chinese'], venue: ['Hotel Restaurant'] },
  { name: 'Avari Towers — Asia Live', hotel: 'Avari Towers Karachi', area: 'Saddar', cuisines: ['Desi', 'Chinese'], venue: ['Hotel Restaurant'] },
  { name: 'Ramada — Cinnamon Restaurant', hotel: 'Ramada Plaza by Wyndham Karachi', area: 'PECHS', cuisines: ['Continental', 'Desi'], venue: ['Hotel Restaurant'] },
  { name: 'Beach Luxury — Bay View Restaurant', hotel: 'Beach Luxury Hotel', area: 'Keamari', cuisines: ['Seafood', 'BBQ'], venue: ['Hotel Restaurant'] },
  { name: 'Beach Luxury — Coffee Shop', hotel: 'Beach Luxury Hotel', area: 'Keamari', cuisines: ['Breakfast'], venue: ['Hotel Restaurant', 'Cafe'] },
  { name: 'Regent Plaza — Al Hayat Restaurant', hotel: 'Regent Plaza Hotel & Convention Centre', area: 'Saddar', cuisines: ['Desi'], venue: ['Hotel Restaurant'] },
  { name: 'Carlton — The Grill Room', hotel: 'Carlton Hotel Karachi', area: 'Clifton', cuisines: ['Continental', 'BBQ'], venue: ['Hotel Restaurant'] },
  { name: 'Nishat Hotel — Nishat Kitchen', hotel: 'Nishat Hotel Clifton', area: 'Clifton', cuisines: ['Desi', 'Biryani'], venue: ['Hotel Restaurant'] },
  { name: 'Hotel Mehran — Mehran Restaurant', hotel: 'Hotel Mehran', area: 'Saddar', cuisines: ['Desi'], venue: ['Hotel Restaurant'] },
];

function coord(area, i) {
  const base = {
    DHA: [24.8, 67.04], Clifton: [24.81, 67.03], 'Do Darya': [24.81, 67.01],
    'Burns Road': [24.86, 67.01], Saddar: [24.86, 67.02], PECHS: [24.87, 67.06],
    'Gulshan-e-Iqbal': [24.91, 67.08], 'Gulistan-e-Jauhar': [24.91, 67.12],
    'North Nazimabad': [24.94, 67.04], Lyari: [24.87, 66.99], Malir: [24.9, 67.2],
    Korangi: [24.82, 67.13], 'Boat Basin': [24.82, 67.02], 'Tariq Road': [24.87, 67.05],
    Keamari: [24.82, 66.98], 'DHA Phase 6': [24.79, 67.06], 'DHA Phase 8': [24.77, 67.08],
    'Clifton Block 2': [24.81, 67.025], Bahadurabad: [24.88, 67.07], Nazimabad: [24.92, 67.03],
    'Federal B Area': [24.93, 67.07], 'Shahrah-e-Faisal': [24.88, 67.1], 'Scheme 33': [24.9, 67.11],
    Landhi: [24.84, 67.18], Orangi: [24.94, 67.0], 'SITE Area': [24.88, 66.98],
    'Jamshed Town': [24.88, 67.04], 'Buffer Zone': [24.95, 67.06], 'Surjani Town': [25.02, 67.08],
    'Defence View': [24.83, 67.05],
  };
  const [lat, lng] = base[area] ?? [24.86, 67.05];
  const jitter = ((i % 23) - 11) * 0.0018;
  return { lat: +(lat + jitter).toFixed(4), lng: +(lng + jitter * 1.1).toFixed(4) };
}

function desc(name, area, hotel) {
  if (hotel) {
    return `${name} at ${hotel}, ${area}. Hotel dining — log your visit to the Karachi archive.`;
  }
  return `${name} in ${area}. A Karachi staple — log your visit and add it to the city archive.`;
}

const raw = fs.readFileSync(path.join(__dirname, '../karachi-eateries-100.ts'), 'utf8');
const existingNames = new Set([...raw.matchAll(/"name": "([^"]+)"/g)].map((m) => m[1]));
const generated = [];
let idx = 0;

function push(entry) {
  if (existingNames.has(entry.name)) return false;
  existingNames.add(entry.name);
  generated.push(entry);
  return true;
}

// 1) Named iconic hotel restaurants
for (const r of NAMED_HOTEL_RESTAURANTS) {
  const { lat, lng } = coord(r.area, idx++);
  push({
    name: r.name,
    area: r.area,
    venueTypes: r.venue,
    cuisines: r.cuisines,
    lng,
    lat,
    description: desc(r.name, r.area, r.hotel),
    address: formatAddress(r.area, r.name, idx),
    phone: phoneFor(r.area, idx),
    openingHours: hoursFor(r.venue),
    famousFor: `${r.cuisines[0]} at ${r.hotel}`,
  });
}

// 2) Hotel × outlet matrix (famous hotels get all outlets; others get subset)
for (const hotel of HOTELS) {
  const outlets = hotel.famous ? HOTEL_OUTLETS : HOTEL_OUTLETS.filter((_, i) => i % 2 === 0 || i < 6);
  for (const o of outlets) {
    const name = `${hotel.name} — ${o.outlet}`;
    const { lat, lng } = coord(hotel.area, idx++);
    push({
      name,
      area: hotel.area,
      venueTypes: o.venue,
      cuisines: o.cuisines,
      lng,
      lat,
      description: desc(name, hotel.area, hotel.name),
      address: formatAddress(hotel.area, name, idx),
      phone: phoneFor(hotel.area, idx),
      openingHours: hoursFor(o.venue),
      famousFor: `${o.cuisines[0]} at ${hotel.name}`,
    });
    if (existingNames.size >= TARGET_TOTAL) break;
  }
  if (existingNames.size >= TARGET_TOTAL) break;
}

// 3) Named chains & cafes (area branches)
for (let c = 0; c < CHAINS.length && existingNames.size < TARGET_TOTAL; c++) {
  for (let b = 0; b < 8 && existingNames.size < TARGET_TOTAL; b++) {
    const area = AREAS[(c + b) % AREAS.length];
    const name = `${CHAINS[c]} ${area}`;
    const { lat, lng } = coord(area, idx++);
    push({
      name,
      area,
      venueTypes: ['Fast Food', 'Restaurant'],
      cuisines: ['Fast Food', 'Desi'],
      lng,
      lat,
      description: desc(name, area, null),
      address: formatAddress(area, name, idx),
      phone: phoneFor(area, idx),
      openingHours: hoursFor(['Fast Food', 'Restaurant']),
      famousFor: `Fast food branch in ${area}`,
    });
  }
}
for (let c = 0; c < CAFE_NAMES.length && existingNames.size < TARGET_TOTAL; c++) {
  for (let b = 0; b < 6 && existingNames.size < TARGET_TOTAL; b++) {
    const area = AREAS[(c * 2 + b) % AREAS.length];
    const name = `${CAFE_NAMES[c]} ${area}`;
    const { lat, lng } = coord(area, idx++);
    push({
      name,
      area,
      venueTypes: ['Cafe', 'Tea Spot'],
      cuisines: ['Breakfast', 'Continental'],
      lng,
      lat,
      description: desc(name, area, null),
      address: formatAddress(area, name, idx),
      phone: phoneFor(area, idx),
      openingHours: hoursFor(['Cafe', 'Tea Spot']),
      famousFor: `Coffee and brunch in ${area}`,
    });
  }
}

// 4) Standalone eateries to fill remainder
let n = 0;
while (existingNames.size < TARGET_TOTAL && n < 80000) {
  n++;
  const area = AREAS[n % AREAS.length];
  const prefix = PREFIXES[n % PREFIXES.length];
  const core = CORES[(n * 3) % CORES.length];
  const suffix = SUFFIXES[(n * 7) % SUFFIXES.length];
  const branch = n % 5 === 0 ? ` Branch ${1 + (n % 12)}` : '';
  const name = (suffix ? `${prefix} ${core} ${suffix}${branch}` : `${prefix} ${core}${branch}`).replace(/  +/g, ' ').trim();
  const vt = VENUE_TYPES[n % VENUE_TYPES.length];
  const cuisines = CUISINE_SETS[n % CUISINE_SETS.length];
  const { lat, lng } = coord(area, n);
  push({
    name,
    area,
    venueTypes: vt,
    cuisines,
    lng,
    lat,
    description: desc(name, area, null),
    address: formatAddress(area, name, n),
    phone: phoneFor(area, n),
    openingHours: hoursFor(vt),
    famousFor: `${cuisines[0]} spot in ${area}`,
  });
}

const out = `// Auto-generated extra Karachi eateries — ${generated.length} entries (hotels + standalone)
// Regenerate: node scripts/generate-extra-eateries.mjs
import type { SeedEatery } from './karachi-eateries-100';

export const KARACHI_EATERIES_EXTRA: SeedEatery[] = ${JSON.stringify(generated, null, 2)};
`;

fs.writeFileSync(path.join(__dirname, '../karachi-eateries-extra.ts'), out);
const baseCount = [...raw.matchAll(/"name":/g)].length;
console.log(`Wrote ${generated.length} extra → ${existingNames.size} unique names (${baseCount} base + ${generated.length} extra = ${baseCount + generated.length} total)`);
