import { PrismaClient } from '@prisma/client';
import * as fs from 'fs';
import * as path from 'path';
import { KARACHI_EATERIES } from './karachi-eateries-100';
import { KARACHI_EATERIES_EXTRA } from './karachi-eateries-extra';
import { BASE_DEMO_VISITS, EXTRA_DEMO_VISITS, ICONIC_BADGES, estimatedRating, menuForCuisines, pickMustTry, type SeedVisit } from './seed-helpers';

const prisma = new PrismaClient();

const VENUE_TYPES = [
  'Cafe', 'Restaurant', 'Dhaba', 'Canteen', 'Bakery', 'Street Food',
  'Dessert Shop', 'Ice Cream Parlor', 'Tea Spot', 'Juice Bar', 'Fast Food', 'BBQ Joint',
  'Hotel Restaurant',
];

const CUISINES = [
  'Desi', 'Chinese', 'BBQ', 'Seafood', 'Pizza', 'Biryani', 'Nihari',
  'Breakfast', 'Continental', 'Fast Food', 'Bakery Items', 'Desserts',
];

const AREAS = [
  'DHA', 'DHA Phase 6', 'DHA Phase 8', 'DHA City', 'Defence View', 'Clifton', 'Clifton Block 2',
  'Clifton Block 4', 'Zamzama', 'Boat Basin', 'Do Darya', 'Keamari', 'Kemari Town', 'Manora',
  'Ibrahim Hyderi', 'Hawksbay', 'French Beach', 'Port Grand',
  'Saddar', 'Burns Road', 'Kharadar', 'Mithadar', 'Ranchore Line', 'Civil Lines', 'PIDC',
  'II Chundrigar', 'Soldier Bazaar', 'Garden East', 'Garden West', 'Lyari', 'Machar Colony',
  'SITE Area', 'Mauripur', 'Golimar',
  'PECHS', 'Tariq Road', 'Bahadurabad', 'Jamshed Town', 'Gulshan-e-Iqbal', 'Gulistan-e-Jauhar',
  'Gulshan-e-Maymar', 'Gulzar-e-Hijri', 'Safoora', 'Shahrah-e-Faisal', 'Scheme 33', 'Model Colony',
  'Shah Faisal Colony', 'Malir', 'Malir Cantonment', 'Landhi', 'Korangi', 'Korangi Creek',
  'Korangi Industrial Area', 'Super Highway',
  'North Nazimabad', 'Nazimabad', 'Federal B Area', 'Buffer Zone', 'Surjani Town', 'Orangi',
  'New Karachi', 'Baldia Town', 'Liaquatabad', 'Ayesha Manzil', 'Water Pump', 'Metroville',
  'Bahria Town Karachi',
];

async function upsertEateryTaxonomy(eateryId: string, venueTypes: string[], cuisines: string[]) {
  await prisma.eateryVenueType.deleteMany({ where: { eateryId } });
  await prisma.eateryCuisine.deleteMany({ where: { eateryId } });
  for (const vtName of venueTypes) {
    const vt = await prisma.venueType.findUniqueOrThrow({ where: { name: vtName } });
    await prisma.eateryVenueType.create({ data: { eateryId, venueTypeId: vt.id } });
  }
  for (const cName of cuisines) {
    const c = await prisma.cuisine.findUniqueOrThrow({ where: { name: cName } });
    await prisma.eateryCuisine.create({ data: { eateryId, cuisineId: c.id } });
  }
}

async function main() {
  console.log('Seeding VenueTypes...');
  for (const name of VENUE_TYPES) {
    await prisma.venueType.upsert({ where: { name }, update: {}, create: { name } });
  }

  console.log('Seeding Cuisines...');
  for (const name of CUISINES) {
    await prisma.cuisine.upsert({ where: { name }, update: {}, create: { name } });
  }

  console.log('Seeding Areas...');
  for (const name of AREAS) {
    await prisma.area.upsert({ where: { name }, update: {}, create: { name } });
  }

  console.log('Seeding two shared users...');
  const you = await prisma.user.upsert({
    where: { email: 'you@deefoodie.app' },
    update: {},
    create: { name: 'You', email: 'you@deefoodie.app' },
  });
  const friend = await prisma.user.upsert({
    where: { email: 'friend@deefoodie.app' },
    update: {},
    create: { name: 'Friend', email: 'friend@deefoodie.app' },
  });
  console.log(`Users: ${you.id}, ${friend.id}`);

  const ALL_EATERIES = [...KARACHI_EATERIES, ...KARACHI_EATERIES_EXTRA];
  console.log(`Seeding ${ALL_EATERIES.length} Karachi eateries...`);
  for (const e of ALL_EATERIES) {
    const area = await prisma.area.findUniqueOrThrow({ where: { name: e.area } });
    let eatery = await prisma.eatery.findFirst({ where: { name: e.name } });

    if (!eatery) {
      eatery = await prisma.eatery.create({
        data: {
          name: e.name,
          areaId: area.id,
          status: 'active',
          description: e.description,
          coverPhotoUrl: e.coverPhotoUrl,
        },
      });
    } else {
      eatery = await prisma.eatery.update({
        where: { id: eatery.id },
        data: {
          areaId: area.id,
          description: e.description,
          coverPhotoUrl: e.coverPhotoUrl,
        },
      });
    }

    await prisma.$executeRawUnsafe(
      `UPDATE "Eatery" SET geo = ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography WHERE id = $3`,
      e.lng,
      e.lat,
      eatery.id,
    );

    await upsertEateryTaxonomy(eatery.id, e.venueTypes, e.cuisines);
  }

  console.log('Seeding menus for all eateries...');
  const allEateries = await prisma.eatery.findMany({
    include: { cuisines: { include: { cuisine: true } } },
  });
  for (const eatery of allEateries) {
    const existingMenu = await prisma.menuVersion.findFirst({ where: { eateryId: eatery.id } });
    if (existingMenu) continue;
    const cuisineNames = eatery.cuisines.map((c) => c.cuisine.name);
    const items = menuForCuisines(cuisineNames);
    const menuVersion = await prisma.menuVersion.create({
      data: { eateryId: eatery.id, effectiveYear: 2025 },
    });
    for (const item of items) {
      await prisma.menuItem.create({
        data: { menuVersionId: menuVersion.id, name: item.name, price: item.price },
      });
    }
  }
  console.log('Seeding demo visits...');
  const eateryByName = async (name: string) =>
    prisma.eatery.findFirstOrThrow({ where: { name } });

  const DEMO_VISITS: SeedVisit[] = [...BASE_DEMO_VISITS, ...EXTRA_DEMO_VISITS];

  for (const v of DEMO_VISITS) {
    const eatery = await eateryByName(v.eateryName);
    const user = await prisma.user.findUniqueOrThrow({ where: { email: v.userEmail } });
    const existing = await prisma.visit.findFirst({
      where: { userId: user.id, eateryId: eatery.id, date: new Date(v.date) },
    });
    if (existing) continue;

    await prisma.visit.create({
      data: {
        userId: user.id,
        eateryId: eatery.id,
        date: new Date(v.date),
        time: v.time,
        rating: v.rating,
        reviewText: v.reviewText,
        memoryNote: v.memoryNote,
        favoriteItem: v.favoriteItem,
        totalBill: v.totalBill,
        companions: v.companions,
        moodTags: v.moodTags,
        wouldVisitAgain: true,
        items: { create: v.items },
      },
    });
  }

  console.log('Seeding iconic badges...');
  const BADGE_LABELS = [
    'Karachi Classic', 'Since 1975', 'Local Legend', 'Family Favorite',
    'Hidden Institution', 'Hidden Gem',
  ];
  for (const label of BADGE_LABELS) {
    await prisma.badge.upsert({ where: { label }, update: {}, create: { label } });
  }
  for (const [eateryName, labels] of Object.entries(ICONIC_BADGES)) {
    const eatery = await prisma.eatery.findFirst({ where: { name: eateryName } });
    if (!eatery) continue;
    for (const label of labels) {
      const badge = await prisma.badge.findUnique({ where: { label } });
      if (!badge) continue;
      await prisma.eateryBadge.upsert({
        where: { eateryId_badgeId: { eateryId: eatery.id, badgeId: badge.id } },
        update: {},
        create: { eateryId: eatery.id, badgeId: badge.id },
      });
    }
  }

  console.log('Exporting mobile demo archive...');
  await exportMobileArchive();

  console.log('Seed complete.');
}

async function exportMobileArchive() {
  const eateries = await prisma.eatery.findMany({
    include: {
      area: true,
      venueTypes: { include: { venueType: true } },
      cuisines: { include: { cuisine: true } },
      badges: { include: { badge: true } },
      menuVersions: {
        orderBy: { effectiveYear: 'desc' },
        take: 1,
        include: { items: { orderBy: { name: 'asc' } } },
      },
    },
    orderBy: { createdAt: 'desc' },
  });

  const ratings = await prisma.visit.groupBy({
    by: ['eateryId'],
    _avg: { rating: true },
    _count: { id: true },
  });
  const ratingMap = new Map(ratings.map((r) => [r.eateryId, Number(r._avg.rating ?? 0)]));
  const visitCountMap = new Map(ratings.map((r) => [r.eateryId, r._count.id]));

  const coordsRows = await prisma.$queryRaw<{ id: string; lat: number; lng: number }[]>`
    SELECT id,
      ST_Y(geo::geometry)::float8 AS lat,
      ST_X(geo::geometry)::float8 AS lng
    FROM "Eatery"
    WHERE geo IS NOT NULL
  `;
  const coordMap = new Map(coordsRows.map((r) => [r.id, { lat: Number(r.lat), lng: Number(r.lng) }]));

  const visits = await prisma.visit.findMany({
    include: { user: true, eatery: true, items: true },
    orderBy: { date: 'desc' },
  });

  const archive = {
    eateries: eateries.map((e) => {
      const coords = coordMap.get(e.id);
      const menu = e.menuVersions[0]?.items ?? [];
      const menuExport = menu.map((m) => ({ name: m.name, price: Number(m.price) }));
      const mustTry = pickMustTry(menuExport, e.name);
      const visitAvg = ratingMap.get(e.id) ?? null;
      return {
        id: e.id,
        name: e.name,
        areaName: e.area.name,
        venueTypes: e.venueTypes.map((v) => v.venueType.name),
        cuisines: e.cuisines.map((c) => c.cuisine.name),
        badges: e.badges.map((b) => b.badge.label),
        description: e.description,
        coverPhotoUrl: e.coverPhotoUrl,
        avgRating: estimatedRating(e.name, visitAvg),
        visitCount: visitCountMap.get(e.id) ?? 0,
        mustTryName: mustTry?.name ?? null,
        mustTryPrice: mustTry?.price ?? null,
        createdAt: e.createdAt.toISOString(),
        lat: coords?.lat ?? null,
        lng: coords?.lng ?? null,
        menu: menuExport,
        status: e.status,
      };
    }),
    visits: visits.map((v) => ({
      id: v.id,
      eateryId: v.eateryId,
      eateryName: v.eatery.name,
      areaName: v.eatery.area.name,
      date: v.date.toISOString().split('T')[0],
      rating: Number(v.rating),
      reviewText: v.reviewText,
      moodTags: v.moodTags,
      userName: v.user.name,
      memoryNote: v.memoryNote,
      favoriteItem: v.favoriteItem,
      totalBill: v.totalBill ? Number(v.totalBill) : null,
      companions: v.companions,
      items: v.items.map((i) => ({ name: i.name, type: i.type })),
    })),
  };

  const outPath = path.join(__dirname, '../../mobile/assets/demo/archive.json');
  fs.mkdirSync(path.dirname(outPath), { recursive: true });
  fs.writeFileSync(outPath, JSON.stringify(archive));
  console.log(`Wrote ${archive.eateries.length} eateries, ${archive.visits.length} visits → mobile/assets/demo/archive.json`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
