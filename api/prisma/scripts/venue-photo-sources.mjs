/**
 * Venue photo integrity (DFD-P0-02).
 * Remote cover photos only when linked to that venue/chain with license + attribution.
 * Otherwise coverPhotoUrl is null and the app shows a cuisine illustration.
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { areaPhotoAsset } from './karachi-areas.mjs';
import { ICONIC_VENUES } from './iconic-venues-enriched.mjs';
import { chainPhotoForName, isLogoUrl } from './free-karachi-photos.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const mapPath = path.join(__dirname, '../data/venue-photo-map.json');

let PHOTO_MAP = {};
if (fs.existsSync(mapPath)) {
  PHOTO_MAP = JSON.parse(fs.readFileSync(mapPath, 'utf8')).photos ?? {};
}

const DEFAULT_LICENSE = 'CC BY-SA 4.0 (Wikimedia Commons)';
const DEFAULT_ATTRIBUTION = 'Wikimedia Commons';

/** Cuisine illustration URLs (not claimed as venue photos). */
export const CUISINE_ILLUSTRATIONS = {
  Biryani: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Food_street%2C_Burns_Road%2C_Karachi.jpg/800px-Food_street%2C_Burns_Road%2C_Karachi.jpg',
  BBQ: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Food_street%2C_Burns_Road%2C_Karachi.jpg/800px-Food_street%2C_Burns_Road%2C_Karachi.jpg',
  Desi: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Fresco_Chowk_BarnceRoad_-_panoramio.jpg/800px-Fresco_Chowk_BarnceRoad_-_panoramio.jpg',
  Nihari: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Fresco_Chowk_BarnceRoad_-_panoramio.jpg/800px-Fresco_Chowk_BarnceRoad_-_panoramio.jpg',
  Seafood: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Seaview_%28Clifton_Beach%29_Karachi.jpg/800px-Seaview_%28Clifton_Beach%29_Karachi.jpg',
  Pizza: 'https://upload.wikimedia.org/wikipedia/commons/5/55/A_Pizza_Hut_Restaurant_in_Karachi_Pakistan.jpg',
  'Fast Food': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Food_street%2C_Burns_Road%2C_Karachi.jpg/800px-Food_street%2C_Burns_Road%2C_Karachi.jpg',
  Chinese: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  Continental: 'https://upload.wikimedia.org/wikipedia/commons/f/f1/Port-Grand-Karachi-01.jpg',
  Desserts: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Food_street%2C_Burns_Road%2C_Karachi.jpg/800px-Food_street%2C_Burns_Road%2C_Karachi.jpg',
  Breakfast: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Fresco_Chowk_BarnceRoad_-_panoramio.jpg/800px-Fresco_Chowk_BarnceRoad_-_panoramio.jpg',
  'Bakery Items': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Food_street%2C_Burns_Road%2C_Karachi.jpg/800px-Food_street%2C_Burns_Road%2C_Karachi.jpg',
};

export function cuisineIllustration(cuisines = []) {
  for (const c of cuisines) {
    if (CUISINE_ILLUSTRATIONS[c]) return CUISINE_ILLUSTRATIONS[c];
  }
  return CUISINE_ILLUSTRATIONS.Desi;
}

function meta(url, kind, license = DEFAULT_LICENSE, attribution = DEFAULT_ATTRIBUTION) {
  return { url, kind, license, attribution };
}

/**
 * Returns venue/chain photo metadata, or null (caller uses cuisine illustration).
 * Does NOT fall back to generic area photos.
 */
export function pickCoverPhotoMeta(eatery) {
  const name = eatery.name;

  const mapped = PHOTO_MAP[name];
  if (mapped?.url && !isLogoUrl(mapped.url)) {
    return meta(
      mapped.url,
      'venue',
      mapped.license ?? DEFAULT_LICENSE,
      mapped.attribution ?? mapped.source ?? DEFAULT_ATTRIBUTION,
    );
  }

  if (eatery.coverPhotoUrl && !isLogoUrl(eatery.coverPhotoUrl) && eatery.coverPhotoKind === 'venue') {
    return meta(
      eatery.coverPhotoUrl,
      'venue',
      eatery.coverPhotoLicense ?? DEFAULT_LICENSE,
      eatery.coverPhotoAttribution ?? DEFAULT_ATTRIBUTION,
    );
  }

  const iconic = ICONIC_VENUES[name];
  if (iconic?.coverPhotoUrl && !isLogoUrl(iconic.coverPhotoUrl)) {
    return meta(
      iconic.coverPhotoUrl,
      'venue',
      iconic.coverPhotoLicense ?? DEFAULT_LICENSE,
      iconic.coverPhotoAttribution ?? 'Venue / Wikimedia',
    );
  }

  const chain = chainPhotoForName(name);
  // Only accept chain hits that are not area-generic substitutes.
  if (chain?.url && chain.source !== 'wikimedia-area') {
    return meta(chain.url, 'chain', DEFAULT_LICENSE, DEFAULT_ATTRIBUTION);
  }

  return null;
}

/** @deprecated use pickCoverPhotoMeta — returns URL or null */
export function pickCoverPhoto(eatery) {
  return pickCoverPhotoMeta(eatery)?.url ?? null;
}

export function pickAreaPhotoAsset(eatery) {
  return eatery.areaPhotoAsset || areaPhotoAsset(eatery.area ?? eatery.areaName);
}

export function pickVisitPhoto(visit, eatery) {
  if (visit.photoUrl && !isLogoUrl(visit.photoUrl)) return visit.photoUrl;
  const cover = pickCoverPhotoMeta(eatery);
  if (cover) return cover.url;
  return cuisineIllustration(eatery.cuisines);
}

export function photoStats(eateries) {
  let venue = 0;
  let chain = 0;
  let placeholder = 0;
  for (const e of eateries) {
    const m = pickCoverPhotoMeta(e);
    if (!m) placeholder++;
    else if (m.kind === 'chain') chain++;
    else venue++;
  }
  return { venue, chain, placeholder, remote: venue + chain };
}
