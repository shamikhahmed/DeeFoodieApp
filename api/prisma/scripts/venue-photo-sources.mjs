/**
 * Real Karachi venue/area photos only — no Unsplash, no stock food.
 * Priority: curated coverPhotoUrl → OSM image tag → null (app uses bundled area asset).
 */
import { areaPhotoAsset } from './karachi-areas.mjs';
import { ICONIC_VENUES } from './iconic-venues-enriched.mjs';

export function pickCoverPhoto(eatery) {
  if (eatery.coverPhotoUrl) return eatery.coverPhotoUrl;
  const iconic = ICONIC_VENUES[eatery.name];
  if (iconic?.coverPhotoUrl) return iconic.coverPhotoUrl;
  return null;
}

export function pickAreaPhotoAsset(eatery) {
  return eatery.areaPhotoAsset || areaPhotoAsset(eatery.area ?? eatery.areaName);
}

export function pickVisitPhoto(visit, eatery) {
  if (visit.photoUrl) return visit.photoUrl;
  const cover = pickCoverPhoto(eatery);
  if (cover) return cover;
  return null;
}
