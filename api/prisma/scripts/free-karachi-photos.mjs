/**
 * Verified free Karachi photos (Wikimedia Commons CC / GFDL).
 * upload.wikimedia.org URLs — no API key, no paid service.
 */
export const AREA_FREE_PHOTOS = {
  'Do Darya': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Seaview_%28Clifton_Beach%29_Karachi.jpg/1280px-Seaview_%28Clifton_Beach%29_Karachi.jpg',
  'DHA Phase 8': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Seaview_%28Clifton_Beach%29_Karachi.jpg/1280px-Seaview_%28Clifton_Beach%29_Karachi.jpg',
  'DHA Phase 6': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Seaview_%28Clifton_Beach%29_Karachi.jpg/1280px-Seaview_%28Clifton_Beach%29_Karachi.jpg',
  DHA: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Seaview_%28Clifton_Beach%29_Karachi.jpg/1280px-Seaview_%28Clifton_Beach%29_Karachi.jpg',
  'Defence View': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Seaview_%28Clifton_Beach%29_Karachi.jpg/1280px-Seaview_%28Clifton_Beach%29_Karachi.jpg',
  Clifton: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Seaview_%28Clifton_Beach%29_Karachi.jpg/1280px-Seaview_%28Clifton_Beach%29_Karachi.jpg',
  'Clifton Block 2': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Seaview_%28Clifton_Beach%29_Karachi.jpg/1280px-Seaview_%28Clifton_Beach%29_Karachi.jpg',
  'Boat Basin': 'https://upload.wikimedia.org/wikipedia/commons/f/f1/Port-Grand-Karachi-01.jpg',
  Keamari: 'https://upload.wikimedia.org/wikipedia/commons/f/f1/Port-Grand-Karachi-01.jpg',
  'Burns Road': 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Fresco_Chowk_BarnceRoad_-_panoramio.jpg/1280px-Fresco_Chowk_BarnceRoad_-_panoramio.jpg',
  Saddar: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Fresco_Chowk_BarnceRoad_-_panoramio.jpg/1280px-Fresco_Chowk_BarnceRoad_-_panoramio.jpg',
  Lyari: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Fresco_Chowk_BarnceRoad_-_panoramio.jpg/1280px-Fresco_Chowk_BarnceRoad_-_panoramio.jpg',
  'SITE Area': 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Fresco_Chowk_BarnceRoad_-_panoramio.jpg/1280px-Fresco_Chowk_BarnceRoad_-_panoramio.jpg',
  'Jamshed Town': 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Fresco_Chowk_BarnceRoad_-_panoramio.jpg/1280px-Fresco_Chowk_BarnceRoad_-_panoramio.jpg',
  PECHS: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  'Tariq Road': 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  Bahadurabad: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  'Gulshan-e-Iqbal': 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  'Gulistan-e-Jauhar': 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  'Shahrah-e-Faisal': 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  'Scheme 33': 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  'Federal B Area': 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  'North Nazimabad': 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  Nazimabad: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  Korangi: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  Malir: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  Landhi: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  Orangi: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  'Buffer Zone': 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
  'Surjani Town': 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg',
};

const DEFAULT_FREE_PHOTO = AREA_FREE_PHOTOS.Clifton;

/** Chain / venue name substring → free photo URL */
export const CHAIN_FREE_PHOTOS = [
  { match: /pizza hut/i, url: 'https://upload.wikimedia.org/wikipedia/commons/5/55/A_Pizza_Hut_Restaurant_in_Karachi_Pakistan.jpg', source: 'wikimedia' },
  { match: /port grand/i, url: 'https://upload.wikimedia.org/wikipedia/commons/f/f1/Port-Grand-Karachi-01.jpg', source: 'wikimedia' },
  { match: /3 coins|hill park/i, url: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Hill_Park_06%2C_Karachi%2C_Pakistan.jpg', source: 'wikimedia' },
  { match: /kolachi|do darya|sea view|seaview/i, url: AREA_FREE_PHOTOS['Do Darya'], source: 'wikimedia-area' },
  { match: /burns road|nihari|falooda|sabri|waris|delhi nihari|ghaffar/i, url: AREA_FREE_PHOTOS['Burns Road'], source: 'wikimedia-area' },
  { match: /boat basin|bun kabab/i, url: AREA_FREE_PHOTOS['Boat Basin'], source: 'wikimedia-area' },
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
