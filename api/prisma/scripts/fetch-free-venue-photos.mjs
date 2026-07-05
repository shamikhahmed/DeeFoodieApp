#!/usr/bin/env node
/**
 * Build free venue photo map — Wikipedia API + Wikimedia + og:image + OSM.
 * No paid APIs. Caches to data/venue-photo-map.json (commit cache after run).
 *
 * Usage: node fetch-free-venue-photos.mjs [--force]
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath, pathToFileURL } from 'url';
import { chainPhotoForName, areaPhotoForArea, isLogoUrl } from './free-karachi-photos.mjs';
import { ICONIC_VENUES } from './iconic-venues-enriched.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');
const outPath = path.join(root, 'data/venue-photo-map.json');
const force = process.argv.includes('--force');
const UA = 'DeeFoodieApp/1.0 (https://github.com/shamikhahmed/DeeFoodieApp; free archive)';
const WIKI_DELAY_MS = 2600;

const { KARACHI_EATERIES } = await import(pathToFileURL(path.join(root, 'karachi-eateries-100.ts')).href);

function sleep(ms) {
  return new Promise((r) => setTimeout(r, ms));
}

async function wikiPhoto(query) {
  const searchUrl = `https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&srsearch=${encodeURIComponent(query)}&srlimit=5`;
  const sRes = await fetch(searchUrl, { headers: { 'User-Agent': UA } });
  if (!sRes.ok) return null;
  const sText = await sRes.text();
  if (sText.startsWith('You are making')) return null;
  const sJson = JSON.parse(sText);
  const hits = sJson.query?.search ?? [];
  const pick = hits.find((h) => /karachi|burns|do darya|clifton|port grand|restaurant|food/i.test(h.title)) ?? hits[0];
  if (!pick) return null;
  await sleep(400);
  const imgUrl = `https://en.wikipedia.org/w/api.php?action=query&format=json&titles=${encodeURIComponent(pick.title)}&prop=pageimages&pithumbsize=1280`;
  const iRes = await fetch(imgUrl, { headers: { 'User-Agent': UA } });
  const iJson = await iRes.json();
  const page = Object.values(iJson.query?.pages ?? {})[0];
  const thumb = page?.thumbnail?.source;
  if (!thumb || isLogoUrl(thumb)) return null;
  return { url: thumb, source: 'wikipedia', title: pick.title };
}

async function ogPhoto(url) {
  try {
    const r = await fetch(url, { headers: { 'User-Agent': UA }, redirect: 'follow', signal: AbortSignal.timeout(15000) });
    const html = await r.text();
    const m =
      html.match(/property=["']og:image["'][^>]*content=["']([^"']+)["']/i) ||
      html.match(/content=["']([^"']+)["'][^>]*property=["']og:image["']/i);
    const img = m?.[1];
    if (!img || isLogoUrl(img)) return null;
    return { url: img, source: 'og-image' };
  } catch {
    return null;
  }
}

function loadOsmImages() {
  const rawPath = path.join(root, 'data/osm-karachi-raw.json');
  if (!fs.existsSync(rawPath)) return {};
  const data = JSON.parse(fs.readFileSync(rawPath, 'utf8'));
  const map = {};
  for (const el of data.elements ?? []) {
    const t = el.tags ?? {};
    const name = t.name || t['name:en'];
    const img = t.image;
    if (name && img && !isLogoUrl(img)) map[name] = { url: img, source: 'osm' };
  }
  return map;
}

async function photoForVenue(name, area, website) {
  const iconic = ICONIC_VENUES[name];
  if (iconic?.coverPhotoUrl && !isLogoUrl(iconic.coverPhotoUrl)) {
    return { url: iconic.coverPhotoUrl, source: 'curated' };
  }
  const chain = chainPhotoForName(name);
  if (chain) return chain;
  try {
    if (website) {
      const og = await ogPhoto(website);
      if (og) return og;
    }
    const wiki = await wikiPhoto(`${name} Karachi Pakistan`);
    if (wiki) return wiki;
  } catch {
    /* network blip — fall through */
  }
  const areaHit = areaPhotoForArea(area);
  if (areaHit) return areaHit;
  return null;
}

let cache = {};
if (fs.existsSync(outPath) && !force) {
  cache = JSON.parse(fs.readFileSync(outPath, 'utf8')).photos ?? {};
}

const osmImages = loadOsmImages();
const photos = { ...cache };
const targets = KARACHI_EATERIES.map((e) => ({ name: e.name, area: e.area, website: ICONIC_VENUES[e.name]?.website }));

let fetched = 0;
for (const t of targets) {
  if (photos[t.name]?.url && !force) continue;
  if (osmImages[t.name]) {
    photos[t.name] = osmImages[t.name];
    continue;
  }
  const hit = await photoForVenue(t.name, t.area, t.website);
  if (hit) {
    photos[t.name] = hit;
    fetched++;
    process.stdout.write(`  ${t.name} ← ${hit.source}\n`);
  }
  if (fetched % 10 === 0) {
    fs.writeFileSync(outPath, JSON.stringify({ builtAt: new Date().toISOString(), partial: true, photos }, null, 0));
  }
  await sleep(WIKI_DELAY_MS);
}

// Area + chain pass for OSM names (no Wikipedia — rate limit)
const osmPath = path.join(root, 'data/osm-karachi.json');
if (fs.existsSync(osmPath)) {
  const osm = JSON.parse(fs.readFileSync(osmPath, 'utf8')).eateries ?? [];
  for (const e of osm) {
    if (photos[e.name]?.url) continue;
    if (e.coverPhotoUrl && !isLogoUrl(e.coverPhotoUrl)) {
      photos[e.name] = { url: e.coverPhotoUrl, source: 'osm' };
      continue;
    }
    const chain = chainPhotoForName(e.name);
    if (chain) {
      photos[e.name] = chain;
      continue;
    }
    const areaHit = areaPhotoForArea(e.area);
    if (areaHit) photos[e.name] = areaHit;
  }
}

const withUrl = Object.values(photos).filter((p) => p?.url).length;
fs.writeFileSync(outPath, JSON.stringify({ builtAt: new Date().toISOString(), count: withUrl, photos }, null, 0));
console.log(`venue-photo-map: ${withUrl} URLs (${fetched} new wiki/og fetches) → ${outPath}`);
