/**
 * Free Karachi venue photos — Wikimedia, Wikipedia, OSM, curated. No Unsplash, no paid APIs.
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { areaPhotoAsset } from './karachi-areas.mjs';
import { ICONIC_VENUES } from './iconic-venues-enriched.mjs';
import { chainPhotoForName, areaPhotoForArea, isLogoUrl } from './free-karachi-photos.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const mapPath = path.join(__dirname, '../data/venue-photo-map.json');

let PHOTO_MAP = {};
if (fs.existsSync(mapPath)) {
  PHOTO_MAP = JSON.parse(fs.readFileSync(mapPath, 'utf8')).photos ?? {};
}

export function pickCoverPhoto(eatery) {
  const name = eatery.name;
  if (eatery.coverPhotoUrl && !isLogoUrl(eatery.coverPhotoUrl)) return eatery.coverPhotoUrl;

  const mapped = PHOTO_MAP[name];
  if (mapped?.url && !isLogoUrl(mapped.url)) return mapped.url;

  const iconic = ICONIC_VENUES[name];
  if (iconic?.coverPhotoUrl && !isLogoUrl(iconic.coverPhotoUrl)) return iconic.coverPhotoUrl;

  const chain = chainPhotoForName(name);
  if (chain?.url) return chain.url;

  const area = eatery.area ?? eatery.areaName;
  const areaHit = areaPhotoForArea(area);
  if (areaHit?.url) return areaHit.url;

  return null;
}

export function pickAreaPhotoAsset(eatery) {
  return eatery.areaPhotoAsset || areaPhotoAsset(eatery.area ?? eatery.areaName);
}

export function pickVisitPhoto(visit, eatery) {
  if (visit.photoUrl && !isLogoUrl(visit.photoUrl)) return visit.photoUrl;
  const cover = pickCoverPhoto(eatery);
  if (cover) return cover;
  return null;
}

export function photoStats(eateries) {
  let remote = 0;
  let wikimedia = 0;
  for (const e of eateries) {
    const url = pickCoverPhoto(e);
    if (url) {
      remote++;
      if (url.includes('wikimedia.org')) wikimedia++;
    }
  }
  return { remote, wikimedia };
}
