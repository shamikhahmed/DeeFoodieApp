import { Injectable, NotFoundException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';

export interface EateryFilters {
  q?: string;
  venueType?: string;
  cuisine?: string;
  area?: string;
  status?: 'active' | 'closed';
}

export interface CreateEateryInput {
  name: string;
  areaId: string;
  venueTypeIds: string[];
  cuisineIds: string[];
  address?: string;
  description?: string;
  lng: number;
  lat: number;
}

const eateryInclude = {
  area: true,
  venueTypes: { include: { venueType: true } },
  cuisines: { include: { cuisine: true } },
  badges: { include: { badge: true } },
} satisfies Prisma.EateryInclude;

@Injectable()
export class EateriesService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(filters: EateryFilters) {
    const where: Prisma.EateryWhereInput = {
      status: filters.status ?? 'active',
    };
    if (filters.q) {
      where.name = { contains: filters.q, mode: 'insensitive' };
    }
    if (filters.area) {
      where.area = { name: { equals: filters.area, mode: 'insensitive' } };
    }
    if (filters.venueType) {
      where.venueTypes = {
        some: { venueType: { name: { equals: filters.venueType, mode: 'insensitive' } } },
      };
    }
    if (filters.cuisine) {
      where.cuisines = {
        some: { cuisine: { name: { equals: filters.cuisine, mode: 'insensitive' } } },
      };
    }

    const eateries = await this.prisma.eatery.findMany({
      where,
      include: eateryInclude,
      orderBy: { name: 'asc' },
    });

    const ratings = await this.avgRatings(eateries.map((e) => e.id));
    const coords = await this.geoCoords(eateries.map((e) => e.id));
    return eateries.map((e) => this.shape(e, ratings.get(e.id), coords.get(e.id)));
  }

  async findOne(id: string) {
    const eatery = await this.prisma.eatery.findUnique({
      where: { id },
      include: {
        ...eateryInclude,
        timelineEvents: { orderBy: { year: 'asc' } },
        photos: true,
        menuVersions: {
          orderBy: { effectiveYear: 'desc' },
          take: 1,
          include: { items: { orderBy: { name: 'asc' } } },
        },
      },
    });
    if (!eatery) throw new NotFoundException(`Eatery ${id} not found`);
    const ratings = await this.avgRatings([id]);
    const coords = await this.geoCoords([id]);
    return this.shape(eatery, ratings.get(id), coords.get(id));
  }

  // Fuzzy duplicate check per locked decision: warn when similar name exists in same area.
  async findSimilar(name: string, areaId: string) {
    return this.prisma.$queryRaw<{ id: string; name: string }[]>`
      SELECT id, name FROM "Eatery"
      WHERE "areaId" = ${areaId}
        AND similarity(lower(name), lower(${name})) > 0.4
      ORDER BY similarity(lower(name), lower(${name})) DESC
      LIMIT 5
    `;
  }

  async create(input: CreateEateryInput) {
    const eatery = await this.prisma.eatery.create({
      data: {
        name: input.name,
        areaId: input.areaId,
        address: input.address,
        description: input.description,
        venueTypes: {
          create: input.venueTypeIds.map((venueTypeId) => ({ venueTypeId })),
        },
        cuisines: {
          create: input.cuisineIds.map((cuisineId) => ({ cuisineId })),
        },
      },
    });
    await this.prisma.$executeRaw`
      UPDATE "Eatery"
      SET geo = ST_SetSRID(ST_MakePoint(${input.lng}, ${input.lat}), 4326)::geography
      WHERE id = ${eatery.id}
    `;
    return this.findOne(eatery.id);
  }

  private async avgRatings(eateryIds: string[]) {
    if (eateryIds.length === 0) return new Map<string, number>();
    const rows = await this.prisma.visit.groupBy({
      by: ['eateryId'],
      where: { eateryId: { in: eateryIds } },
      _avg: { rating: true },
      _count: true,
    });
    return new Map(rows.map((r) => [r.eateryId, Number(r._avg.rating ?? 0)]));
  }

  private async geoCoords(eateryIds: string[]) {
    if (eateryIds.length === 0) return new Map<string, { lat: number; lng: number }>();
    const rows = await this.prisma.$queryRaw<{ id: string; lat: number; lng: number }[]>`
      SELECT id,
        ST_Y(geo::geometry)::float8 AS lat,
        ST_X(geo::geometry)::float8 AS lng
      FROM "Eatery"
      WHERE id = ANY(${eateryIds}::text[])
        AND geo IS NOT NULL
    `;
    return new Map(rows.map((r) => [r.id, { lat: Number(r.lat), lng: Number(r.lng) }]));
  }

  private shape(
    eatery: Prisma.EateryGetPayload<{ include: typeof eateryInclude }> & {
      timelineEvents?: unknown[];
      photos?: unknown[];
      menuVersions?: { effectiveYear: number; items: { name: string; price: Prisma.Decimal }[] }[];
    },
    avgRating?: number,
    coords?: { lat: number; lng: number },
  ) {
    const { venueTypes, cuisines, badges, menuVersions, ...rest } = eatery;
    const latestMenu = menuVersions?.[0];
    return {
      ...rest,
      venueTypes: venueTypes.map((v) => v.venueType.name),
      cuisines: cuisines.map((c) => c.cuisine.name),
      badges: badges.map((b) => b.badge.label),
      avgRating: avgRating ?? null,
      lat: coords?.lat ?? null,
      lng: coords?.lng ?? null,
      menu: latestMenu
        ? {
            effectiveYear: latestMenu.effectiveYear,
            items: latestMenu.items.map((i) => ({
              name: i.name,
              price: Number(i.price),
            })),
          }
        : null,
    };
  }
}
