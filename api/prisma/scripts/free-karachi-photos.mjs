/**
 * Verified free Karachi photos (Wikimedia Commons CC / GFDL).
 */
import { AREAS, areaPhotoGroup } from './karachi-areas.mjs';

const GROUP_URL = {
  sea: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Seaview_%28Clifton_Beach%29_Karachi.jpg/1280px-Seaview_%28Clifton_Beach%29_Karachi.jpg',
  'old-city': 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Fresco_Chowk_BarnceRoad_-_panoramio.jpg/1280px-Fresco_Chowk_BarnceRoad_-_panoramio.jpg',
  east: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  port: 'https://upload.wikimedia.org/wikipedia/commons/f/f1/Port-Grand-Karachi-01.jpg',
};

export const AREA_FREE_PHOTOS = Object.fromEntries(
  AREAS.map((a) => {
    const g = areaPhotoGroup(a);
    const url = g === 'sea' && a === 'Port Grand' ? GROUP_URL.port : GROUP_URL[g] ?? GROUP_URL.east;
    return [a, url];
  }),
);

const DEFAULT_FREE_PHOTO = GROUP_URL.sea;

export const CHAIN_FREE_PHOTOS = [
  { match: /pizza hut/i, url: 'https://upload.wikimedia.org/wikipedia/commons/5/55/A_Pizza_Hut_Restaurant_in_Karachi_Pakistan.jpg', source: 'wikimedia' },
  { match: /port grand/i, url: GROUP_URL.port, source: 'wikimedia' },
  { match: /3 coins|hill park/i, url: GROUP_URL.east, source: 'wikimedia' },
  { match: /kolachi|do darya|sea view|seaview/i, url: GROUP_URL.sea, source: 'wikimedia-area' },
  { match: /burns road|nihari|falooda|sabri|waris|delhi nihari|ghaffar|kharadar|mithadar/i, url: GROUP_URL['old-city'], source: 'wikimedia-area' },
  { match: /boat basin|bun kabab|keamari|manora|hawksbay/i, url: GROUP_URL.port, source: 'wikimedia-area' },
];

export function chainPhotoForName(name) {
  for (const c of CHAIN_FREE_PHOTOS) {
    if (c.match.test(name)) return { url: c.url, source: c.source };
  }
  return null;
}

export function areaPhotoForArea(area) {
  const url = AREA_FREE_PHOTOS[area] ?? DEFAULT_FREE_PHOTO;
  return url ? { url, source: 'wikimedia-area' } : null;
}

export function isLogoUrl(url) {
  if (!url) return true;
  const u = url.toLowerCase();
  return u.includes('logo') || u.includes('favicon') || u.includes('icon.') || u.includes('/brand/');
}
