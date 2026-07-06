#!/usr/bin/env node
/**
 * Build mobile area_boundaries.json from OSM cache (run fetch-osm-area-boundaries.mjs first).
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { AREAS } from './karachi-areas.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const CACHE = path.resolve(__dirname, '../data/osm-area-boundaries.json');
const OUT = path.resolve(__dirname, '../../../mobile/assets/areas/area_boundaries.json');

if (!fs.existsSync(CACHE)) {
  console.error('Missing OSM cache. Run: node api/prisma/scripts/fetch-osm-area-boundaries.mjs');
  process.exit(1);
}

const cached = JSON.parse(fs.readFileSync(CACHE, 'utf8'));
const byName = new Map(cached.areas.map((a) => [a.name, a]));

const areas = AREAS.map((name) => {
  const row = byName.get(name);
  if (!row) throw new Error(`No boundary for ${name}`);
  return {
    name: row.name,
    centroid: row.centroid,
    ring: row.ring,
    source: row.source,
  };
});

const sources = areas.reduce((acc, a) => {
  acc[a.source] = (acc[a.source] ?? 0) + 1;
  return acc;
}, {});

const payload = {
  generatedAt: new Date().toISOString(),
  bbox: cached.bbox,
  sourceSummary: sources,
  note: 'Polygons from OSM Overpass/Nominatim where available; centroid-buffer fallback otherwise. Sync DB via import-area-boundaries-to-db.mjs',
  areas,
};

fs.mkdirSync(path.dirname(OUT), { recursive: true });
fs.writeFileSync(OUT, JSON.stringify(payload, null, 2));
console.log(`Wrote ${areas.length} polygons → ${OUT}`);
console.log('Sources:', sources);
