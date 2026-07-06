#!/usr/bin/env node
/**
 * Import area polygons into PostGIS Area.boundary from osm-area-boundaries.json
 * Usage: DATABASE_URL=... node api/prisma/scripts/import-area-boundaries-to-db.mjs
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { PrismaClient } from '@prisma/client';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const CACHE = path.resolve(__dirname, '../data/osm-area-boundaries.json');

const prisma = new PrismaClient();

function wktPolygon(ring) {
  const coords = ring.map((p) => `${p.lng} ${p.lat}`).join(', ');
  return `POLYGON((${coords}, ${ring[0].lng} ${ring[0].lat}))`;
}

async function main() {
  if (!fs.existsSync(CACHE)) {
    console.error('Run fetch-osm-area-boundaries.mjs first');
    process.exit(1);
  }
  const { areas } = JSON.parse(fs.readFileSync(CACHE, 'utf8'));
  let updated = 0;
  for (const a of areas) {
    if (!a.ring?.length) continue;
    const wkt = wktPolygon(a.ring);
    const n = await prisma.$executeRawUnsafe(
      `UPDATE "Area" SET boundary = ST_GeogFromText($1)::geography WHERE name = $2`,
      wkt,
      a.name,
    );
    if (n) updated++;
  }
  console.log(`Updated ${updated}/${areas.length} Area.boundary rows`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
