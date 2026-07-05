#!/usr/bin/env node
/** Build mobile/assets/demo/archive.json from seed TS without DB */
import fs from 'fs';
import path from 'path';
import { fileURLToPath, pathToFileURL } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');

const { KARACHI_EATERIES } = await import(pathToFileURL(path.join(root, 'karachi-eateries-100.ts')).href);
const { KARACHI_EATERIES_EXTRA } = await import(pathToFileURL(path.join(root, 'karachi-eateries-extra.ts')).href).catch(() => ({ KARACHI_EATERIES_EXTRA: [] }));

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

function hashRating(name) {
  let h = 0;
  for (let i = 0; i < name.length; i++) h = (h * 31 + name.charCodeAt(i)) % 1000;
  return 3.8 + (h % 12) / 10;
}

const existingArchive = JSON.parse(
  fs.readFileSync(path.join(root, '../../mobile/assets/demo/archive.json'), 'utf8'),
);

const all = [...KARACHI_EATERIES, ...KARACHI_EATERIES_EXTRA];
let id = 0;
const eateries = all.map((e) => {
  id++;
  const menu = menuFor(e.cuisines);
  const mustTry = menu[0];
  return {
    id: `seed-${id.toString(16).padStart(8, '0')}`,
    name: e.name,
    areaName: e.area,
    venueTypes: e.venueTypes,
    cuisines: e.cuisines,
    badges: [],
    description: e.description,
    coverPhotoUrl: e.coverPhotoUrl,
    avgRating: +hashRating(e.name).toFixed(1),
    visitCount: 0,
    mustTryName: mustTry.name,
    mustTryPrice: mustTry.price,
    createdAt: new Date().toISOString(),
    lat: e.lat,
    lng: e.lng,
    menu,
    status: ['Lal Qila', 'Pie in the Sky', 'Ginsoo'].includes(e.name) ? 'closed' : 'active',
  };
});

const archiveTrails = [
  {
    id: 'burns-road',
    name: 'Burns Road Legends',
    description: 'The old city lane where Karachi still eats like it means it.',
    emoji: '🔥',
    eateryNames: ['Burns Road Falooda', 'Delhi Nihari', 'Waris Nihari', 'Sabri Nihari', 'Ghaffar Kabab House', 'Haleem Ghar Burns Road'],
  },
  {
    id: 'do-darya',
    name: 'Do Darya Sunset Row',
    description: 'Sea breeze, coal smoke, and the full weekend Karachi spread.',
    emoji: '🌊',
    eateryNames: ['Kolachi', 'Bar-B-Q Tonight', 'Sajjad Restaurant', 'Kababjees', 'Pompei'],
  },
  {
    id: 'bun-kabab',
    name: 'Bun Kabab Trail',
    description: 'Street buns, chutney, and late-night fuel across the city.',
    emoji: '🥙',
    eateryNames: ['Bun Kabab Corner Saddar', 'Dera Bun Kabab', 'Jans Bun Kabab', 'Lal Qila Bun Kabab'],
  },
  {
    id: 'clifton-cafes',
    name: 'Clifton Café Circuit',
    description: 'Brunch, coffee, and dessert stops along the south shore.',
    emoji: '☕',
    eateryNames: ['Butlers Chocolate Café', 'Esquires Coffee Clifton', 'Florentine', 'Chatterbox Cafe', 'Pie in the Sky'],
  },
  {
    id: 'biryani-crawl',
    name: 'Biryani Crawl',
    description: 'The debate never ends — log your own verdict at each stop.',
    emoji: '🍚',
    eateryNames: ['Student Biryani', 'Indus Biryani', 'Farhan Biryani', 'Cafe Khan Biryani', 'Jiddat Biryani'],
  },
  {
    id: 'hotel-dining',
    name: 'Hotel Dining Trail',
    description: 'Karachi hotels — from PC Chandni to rooftop grills.',
    emoji: '🏨',
    eateryNames: [
      'PC Hotel — Chandni Restaurant',
      'Marriott — Nadia Coffee Shop',
      'Avari Towers — Dynasty Restaurant',
      'Mövenpick — The Restaurant',
      'Beach Luxury — Bay View Restaurant',
      'Ramada — Cinnamon Restaurant',
    ],
  },
];

const archive = { eateries, visits: existingArchive.visits ?? [], trails: archiveTrails };
const out = path.join(root, '../../mobile/assets/demo/archive.json');
fs.writeFileSync(out, JSON.stringify(archive));
console.log(`Wrote ${eateries.length} eateries, ${archive.visits.length} visits → ${out}`);
