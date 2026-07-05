#!/usr/bin/env node
/** Fast static photo map — Wikimedia area/chain rules + iconic + OSM. No API calls. */
import fs from 'fs';
import path from 'path';
import { fileURLToPath, pathToFileURL } from 'url';
import { chainPhotoForName, areaPhotoForArea, isLogoUrl } from './free-karachi-photos.mjs';
import { ICONIC_VENUES } from './iconic-venues-enriched.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');
const outPath = path.join(root, 'data/venue-photo-map.json');

const { KARACHI_EATERIES } = await import(pathToFileURL(path.join(root, 'karachi-eateries-100.ts')).href);
const osmPath = path.join(root, 'data/osm-karachi.json');
const osm = fs.existsSync(osmPath) ? JSON.parse(fs.readFileSync(osmPath, 'utf8')).eateries ?? [] : [];

const photos = {};

function assign(name, area, rawUrl) {
  if (photos[name]?.url) return;
  const iconic = ICONIC_VENUES[name];
  if (iconic?.coverPhotoUrl && !isLogoUrl(iconic.coverPhotoUrl)) {
    photos[name] = { url: iconic.coverPhotoUrl, source: 'curated' };
    return;
  }
  if (rawUrl && !isLogoUrl(rawUrl)) {
    photos[name] = { url: rawUrl, source: 'osm' };
    return;
  }
  const chain = chainPhotoForName(name);
  if (chain) {
    photos[name] = chain;
    return;
  }
  const areaHit = areaPhotoForArea(area);
  if (areaHit) photos[name] = areaHit;
}

for (const e of KARACHI_EATERIES) assign(e.name, e.area, null);
for (const e of osm) assign(e.name, e.area, e.coverPhotoUrl);

const count = Object.values(photos).filter((p) => p.url).length;
fs.writeFileSync(outPath, JSON.stringify({ builtAt: new Date().toISOString(), count, photos }, null, 0));
console.log(`Static venue-photo-map: ${count} free URLs → ${outPath}`);
