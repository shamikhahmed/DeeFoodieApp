/**
 * Cuisine/venue-aware food photography pool (Unsplash, free tier).
 * Assigned deterministically per eatery — not random per build.
 */

const POOLS = {
  Biryani: [
    'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=800&q=80',
    'https://images.unsplash.com/photo-1589302167528-912ddfdcf8ea?w=800&q=80',
    'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=800&q=80',
  ],
  Nihari: [
    'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800&q=80',
    'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800&q=80',
    'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=800&q=80',
  ],
  BBQ: [
    'https://images.unsplash.com/photo-1622597467836-f3285f2131b8?w=800&q=80',
    'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=800&q=80',
    'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800&q=80',
  ],
  Desi: [
    'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800&q=80',
    'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800&q=80',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80',
  ],
  Chinese: [
    'https://images.unsplash.com/photo-1525755662778-989d0520907e?w=800&q=80',
    'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=800&q=80',
  ],
  Seafood: [
    'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800&q=80',
    'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=800&q=80',
    'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800&q=80',
  ],
  Pizza: [
    'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&q=80',
    'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800&q=80',
  ],
  'Fast Food': [
    'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800&q=80',
    'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=800&q=80',
    'https://images.unsplash.com/photo-1565299507647-b455f8720ed4?w=800&q=80',
  ],
  Breakfast: [
    'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80',
    'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800&q=80',
    'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=800&q=80',
  ],
  Continental: [
    'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80',
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80',
    'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800&q=80',
  ],
  Desserts: [
    'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=800&q=80',
    'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=800&q=80',
    'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?w=800&q=80',
  ],
  'Bakery Items': [
    'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&q=80',
    'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=800&q=80',
  ],
  Cafe: [
    'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80',
    'https://images.unsplash.com/photo-1501339846604-da8993fccb0d?w=800&q=80',
    'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=800&q=80',
  ],
  'Street Food': [
    'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800&q=80',
    'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800&q=80',
    'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=800&q=80',
  ],
  'Tea Spot': [
    'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=800&q=80',
    'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=800&q=80',
  ],
  'Hotel Restaurant': [
    'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80',
    'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800&q=80',
  ],
  default: [
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80',
    'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800&q=80',
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80',
    'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800&q=80',
  ],
};

const CUISINE_TO_POOL = {
  Biryani: 'Biryani',
  Nihari: 'Nihari',
  BBQ: 'BBQ',
  Desi: 'Desi',
  Chinese: 'Chinese',
  Seafood: 'Seafood',
  Pizza: 'Pizza',
  'Fast Food': 'Fast Food',
  Breakfast: 'Breakfast',
  Continental: 'Continental',
  Desserts: 'Desserts',
  'Bakery Items': 'Bakery Items',
};

const VENUE_TO_POOL = {
  Cafe: 'Cafe',
  'Tea Spot': 'Tea Spot',
  Bakery: 'Bakery Items',
  'Street Food': 'Street Food',
  'Dessert Shop': 'Desserts',
  'Ice Cream Parlor': 'Desserts',
  'Hotel Restaurant': 'Hotel Restaurant',
  'BBQ Joint': 'BBQ',
};

function hashKey(name, salt = '') {
  let h = 0;
  const s = `${name}${salt}`;
  for (let i = 0; i < s.length; i++) h = (h * 31 + s.charCodeAt(i)) >>> 0;
  return h;
}

export function pickCoverPhoto(eatery) {
  const cuisines = eatery.cuisines ?? [];
  const venues = eatery.venueTypes ?? [];
  let poolKey = 'default';
  for (const c of cuisines) {
    if (CUISINE_TO_POOL[c]) {
      poolKey = CUISINE_TO_POOL[c];
      break;
    }
  }
  if (poolKey === 'default') {
    for (const v of venues) {
      if (VENUE_TO_POOL[v]) {
        poolKey = VENUE_TO_POOL[v];
        break;
      }
    }
  }
  const pool = POOLS[poolKey] ?? POOLS.default;
  return pool[hashKey(eatery.name, poolKey) % pool.length];
}

export function pickVisitPhoto(visit, eatery) {
  const item = visit.items?.[0]?.name?.toLowerCase() ?? '';
  if (/biryani|pulao/.test(item)) return POOLS.Biryani[0];
  if (/nihari|paya/.test(item)) return POOLS.Nihari[0];
  if (/kabab|tikka|bbq|grill/.test(item)) return POOLS.BBQ[0];
  if (/burger|fries|broast/.test(item)) return POOLS['Fast Food'][0];
  if (/cake|falooda|kulfi|dessert|jamun/.test(item)) return POOLS.Desserts[0];
  if (/chai|latte|coffee|cappuccino|flat white/.test(item)) return POOLS.Cafe[0];
  if (/fish|prawn|seafood/.test(item)) return POOLS.Seafood[0];
  if (eatery) return pickCoverPhoto(eatery);
  return POOLS.default[0];
}

export { POOLS };
