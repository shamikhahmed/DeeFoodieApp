#!/usr/bin/env node
/**
 * Fetch Karachi neighborhood polygons from OSM (Overpass + Nominatim fallback).
 * Cache → api/prisma/data/osm-area-boundaries.json
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { AREAS, CENTROIDS } from './karachi-areas.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const CACHE = path.resolve(__dirname, '../data/osm-area-boundaries.json');
const UA = 'DeeFoodieApp/1.0 (contact: deefoodieapp; karachi-food-archive boundary import)';

const KARACHI_BBOX = { south: 24.75, west: 66.85, north: 25.12, east: 67.28 };

const NOMINATIM_ALT = {
  Zamzama: ['Zamzama Commercial Area, Karachi', 'Zamzama, Clifton, Karachi'],
  'French Beach': ['French Beach, Karachi', 'French Beach Karachi Pakistan'],
  'Burns Road': ['Burns Road, Karachi', 'Burns Road Food Street Karachi'],
  PIDC: ['PIDC, Karachi', 'Pakistan Industrial Development Corporation Karachi'],
  'II Chundrigar': ['I I Chundrigar Road, Karachi', 'Chundrigar Road Karachi'],
  'Machar Colony': ['Machar Colony, Karachi'],
  'SITE Area': ['SITE Area Karachi', 'S.I.T.E. Karachi'],
  Golimar: ['Golimar, Karachi'],
  'Tariq Road': ['Tariq Road, Karachi'],
  Bahadurabad: ['Bahadurabad, Karachi'],
  'Gulzar-e-Hijri': ['Gulzar e Hijri, Karachi'],
  Safoora: ['Safoora Goth, Karachi', 'Safoora, Karachi'],
  'Shahrah-e-Faisal': ['Shahrah e Faisal, Karachi', 'Sharae Faisal Karachi'],
  'Scheme 33': ['Scheme 33, Karachi'],
  'Shah Faisal Colony': ['Shah Faisal Colony, Karachi'],
  'Surjani Town': ['Surjani Town, Karachi'],
  'Water Pump': ['Water Pump, Karachi', 'Water Pump Chowrangi Karachi'],
  Metroville: ['Metroville, Karachi'],
};

const OSM_ALIASES = {
  'Federal B Area': ['FB Area', 'Federal B Area', 'Gulberg', 'Gulberg Town'],
  DHA: ['DHA', 'Defence Housing Authority', 'Defence', 'Defense Housing Authority'],
  'II Chundrigar': ['I.I. Chundrigar', 'II Chundrigar', 'Chundrigar Road'],
  'SITE Area': ['SITE', 'SITE Area', 'S.I.T.E.'],
  Keamari: ['Keamari', 'Kemari'],
  'Kemari Town': ['Kemari Town', 'Keamari Town'],
  'North Nazimabad': ['North Nazimabad', 'Nazimabad North'],
  'Gulshan-e-Iqbal': ['Gulshan-e-Iqbal', 'Gulshan e Iqbal', 'Gulshan'],
  'Gulistan-e-Jauhar': ['Gulistan-e-Jauhar', 'Gulistan e Jauhar'],
  'Bahria Town Karachi': ['Bahria Town Karachi', 'Bahria Town'],
  'Do Darya': ['Do Darya', 'Darya'],
  'Burns Road': ['Burns Road', 'Burns Road Food Street'],
  Saddar: ['Saddar', 'Saddar Town'],
  PECHS: ['PECHS', 'Pakistan Employees Cooperative Housing Society'],
  'Shahrah-e-Faisal': ['Shahrah-e-Faisal', 'Sharae Faisal', 'Shaheed-e-Millat Road'],
  'Port Grand': ['Port Grand'],
  Hawksbay: ['Hawke Bay', 'Hawks Bay', 'Hawksbay'],
  'French Beach': ['French Beach'],
  Orangi: ['Orangi', 'Orangi Town'],
  'New Karachi': ['New Karachi', 'New Karachi Town'],
  'Surjani Town': ['Surjani Town', 'Surjani'],
  'Buffer Zone': ['Buffer Zone'],
  'Super Highway': ['Super Highway', 'M-9 motorway'],
};

function sleep(ms) {
  return new Promise((r) => setTimeout(r, ms));
}

function norm(s) {
  return s
    .toLowerCase()
    .replace(/[.\-']/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function ringFromGeometry(geometry) {
  if (!geometry) return null;
  if (geometry.type === 'Polygon') {
    const ring = geometry.coordinates[0];
    return ring.map(([lng, lat]) => ({ lat: +lat.toFixed(6), lng: +lng.toFixed(6) }));
  }
  if (geometry.type === 'MultiPolygon') {
    let best = null;
    let bestArea = 0;
    for (const poly of geometry.coordinates) {
      const ring = poly[0];
      const area = Math.abs(ring.reduce((a, [lng, lat], i) => {
        const [lng2, lat2] = ring[(i + 1) % ring.length];
        return a + lng * lat2 - lng2 * lat;
      }, 0));
      if (area > bestArea) {
        bestArea = area;
        best = ring.map(([lng, lat]) => ({ lat: +lat.toFixed(6), lng: +lng.toFixed(6) }));
      }
    }
    return best;
  }
  return null;
}

function ringFromOsmElement(el) {
  if (el.type === 'way' && el.geometry?.length >= 4) {
    return el.geometry.map((p) => ({ lat: p.lat, lng: p.lon }));
  }
  if (el.type === 'relation' && el.members) {
    const outer = el.members.filter((m) => m.role === 'outer' && m.geometry);
    if (outer.length && outer[0].geometry?.length >= 4) {
      return outer[0].geometry.map((p) => ({ lat: p.lat, lng: p.lon }));
    }
  }
  return null;
}

function pointInRing(lat, lng, ring) {
  let inside = false;
  for (let i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    const xi = ring[i].lng;
    const yi = ring[i].lat;
    const xj = ring[j].lng;
    const yj = ring[j].lat;
    const intersect = yi > lat !== yj > lat && lng < ((xj - xi) * (lat - yi)) / (yj - yi) + xi;
    if (intersect) inside = !inside;
  }
  return inside;
}

function clipRingToBbox(ring, bbox) {
  return ring.filter(
    (p) => p.lat >= bbox.south && p.lat <= bbox.north && p.lng >= bbox.west && p.lng <= bbox.east,
  ).length >= 3
    ? ring
    : ring;
}

function circleRing(lat, lng, radiusKm, sides = 24) {
  const ring = [];
  for (let i = 0; i < sides; i++) {
    const angle = (i / sides) * 2 * Math.PI;
    const dLat = (radiusKm / 111) * Math.cos(angle);
    const dLng = (radiusKm / (111 * Math.cos((lat * Math.PI) / 180))) * Math.sin(angle);
    ring.push({ lat: +(lat + dLat).toFixed(6), lng: +(lng + dLng).toFixed(6) });
  }
  return ring;
}

function nearestCentroidRadiusKm(name) {
  const [lat, lng] = CENTROIDS[name];
  let minD = Infinity;
  for (const [other, [oLat, oLng]] of Object.entries(CENTROIDS)) {
    if (other === name) continue;
    const d = Math.hypot(lat - oLat, lng - oLng) * 111;
    if (d < minD) minD = d;
  }
  return Math.min(2.8, Math.max(0.55, minD * 0.38));
}

function osmNames(el) {
  const t = el.tags ?? {};
  return [t.name, t['name:en'], t['is_in'], t.alt_name, t.official_name].filter(Boolean);
}

function scoreOsmMatch(areaName, el) {
  const aliases = OSM_ALIASES[areaName] ?? [areaName];
  const want = new Set(aliases.map(norm));
  want.add(norm(areaName));
  let score = 0;
  for (const n of osmNames(el)) {
    const nn = norm(n);
    for (const w of want) {
      if (nn === w) score = Math.max(score, 100);
      else if (nn.includes(w) || w.includes(nn)) score = Math.max(score, 70);
    }
  }
  const [cLat, cLng] = CENTROIDS[areaName];
  const ring = ringFromOsmElement(el);
  if (ring && pointInRing(cLat, cLng, ring)) score += 25;
  return score;
}

async function fetchOverpassPool() {
  const q = `[out:json][timeout:120];
(
  way["place"~"suburb|neighbourhood|quarter"](${KARACHI_BBOX.south},${KARACHI_BBOX.west},${KARACHI_BBOX.north},${KARACHI_BBOX.east});
  relation["place"~"suburb|neighbourhood|quarter"](${KARACHI_BBOX.south},${KARACHI_BBOX.west},${KARACHI_BBOX.north},${KARACHI_BBOX.east});
  way["boundary"="administrative"]["admin_level"~"10|11"](${KARACHI_BBOX.south},${KARACHI_BBOX.west},${KARACHI_BBOX.north},${KARACHI_BBOX.east});
);
out geom;`;
  for (let attempt = 1; attempt <= 3; attempt++) {
    const res = await fetch('https://overpass-api.de/api/interpreter', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'User-Agent': UA },
      body: `data=${encodeURIComponent(q)}`,
    });
    if (res.ok) {
      const json = await res.json();
      return json.elements ?? [];
    }
    console.warn(`Overpass ${res.status}, retry ${attempt}/3…`);
    await sleep(4000 * attempt);
  }
  if (fs.existsSync(CACHE)) {
    const prev = JSON.parse(fs.readFileSync(CACHE, 'utf8'));
    if (prev.overpassPool?.length) {
      console.warn(`Using cached Overpass pool (${prev.overpassPool.length} elements)`);
      return prev.overpassPool;
    }
  }
  throw new Error('Overpass unavailable');
}

async function fetchNominatimPolygon(queryName, catalogName = queryName) {
  const q = encodeURIComponent(`${queryName}, Karachi, Sindh, Pakistan`);
  const url = `https://nominatim.openstreetmap.org/search?q=${q}&format=json&polygon_geojson=1&limit=5`;
  const res = await fetch(url, { headers: { 'User-Agent': UA } });
  if (!res.ok) return null;
  const rows = await res.json();
  const [cLat, cLng] = CENTROIDS[catalogName];
  let best = null;
  let bestD = Infinity;
  for (const row of rows) {
    const ring = ringFromGeometry(row.geojson);
    if (!ring || ring.length < 4) continue;
    const d = Math.hypot(row.lat - cLat, row.lon - cLng);
    if (d < bestD) {
      bestD = d;
      best = { ring, osmId: row.osm_id, displayName: row.display_name };
    }
  }
  return bestD < 0.35 ? best : null;
}

async function main() {
  const force = process.argv.includes('--force');
  if (!force && fs.existsSync(CACHE)) {
    const existing = JSON.parse(fs.readFileSync(CACHE, 'utf8'));
    if (existing.areas?.length === AREAS.length) {
      console.log(`Cache hit (${existing.areas.length} areas) → ${CACHE}`);
      return;
    }
  }

  console.log('Fetching Overpass OSM pool…');
  const pool = await fetchOverpassPool();
  console.log(`OSM pool: ${pool.length} elements`);

  const results = [];
  let osmHits = 0;
  let nominatimHits = 0;
  let bufferHits = 0;

  for (let i = 0; i < AREAS.length; i++) {
    const name = AREAS[i];
    const [lat, lng] = CENTROIDS[name];
    let ring = null;
    let source = 'centroid-buffer';
    let meta = {};

    let bestEl = null;
    let bestScore = 0;
    for (const el of pool) {
      const s = scoreOsmMatch(name, el);
      if (s > bestScore) {
        bestScore = s;
        bestEl = el;
      }
    }
    if (bestEl && bestScore >= 70) {
      ring = ringFromOsmElement(bestEl);
      if (ring?.length >= 4) {
        source = 'osm-overpass';
        meta = { osmType: bestEl.type, osmId: bestEl.id, score: bestScore, osmName: bestEl.tags?.['name:en'] ?? bestEl.tags?.name };
        osmHits++;
      }
    }

    if (!ring || ring.length < 4) {
      const altQueries = NOMINATIM_ALT[name] ?? [];
      for (const alt of [name, ...altQueries]) {
        await sleep(1100);
        const nom = await fetchNominatimPolygon(alt, name);
        if (nom?.ring?.length >= 4) {
          ring = nom.ring;
          source = 'osm-nominatim';
          meta = { displayName: nom.displayName, osmId: nom.osmId, query: alt };
          nominatimHits++;
          break;
        }
      }
    }

    if (!ring || ring.length < 4) {
      ring = circleRing(lat, lng, nearestCentroidRadiusKm(name));
      source = 'centroid-buffer';
      bufferHits++;
    }

    ring = clipRingToBbox(ring, KARACHI_BBOX);
    results.push({
      name,
      centroid: { lat, lng },
      ring,
      source,
      ...meta,
    });
    process.stdout.write(`\r${i + 1}/${AREAS.length} ${name} (${source})   `);
  }

  console.log(`\nOSM overpass: ${osmHits}, nominatim: ${nominatimHits}, buffer: ${bufferHits}`);

  const payload = {
    generatedAt: new Date().toISOString(),
    bbox: KARACHI_BBOX,
    overpassPool: pool,
    areas: results,
  };
  fs.mkdirSync(path.dirname(CACHE), { recursive: true });
  fs.writeFileSync(CACHE, JSON.stringify(payload, null, 2));
  console.log(`Wrote ${results.length} → ${CACHE}`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
