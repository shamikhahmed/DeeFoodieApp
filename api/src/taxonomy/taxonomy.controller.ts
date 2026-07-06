import { Controller, Get } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Controller()
export class TaxonomyController {
  constructor(private readonly prisma: PrismaService) {}

  @Get('venue-types')
  venueTypes() {
    return this.prisma.venueType.findMany({ orderBy: { name: 'asc' } });
  }

  @Get('cuisines')
  cuisines() {
    return this.prisma.cuisine.findMany({ orderBy: { name: 'asc' } });
  }

  @Get('areas')
  areas() {
    return this.prisma.area.findMany({
      orderBy: { name: 'asc' },
      select: { id: true, name: true, description: true, popularDishes: true },
    });
  }

  @Get('areas/boundaries')
  async areaBoundaries() {
    const rows = await this.prisma.$queryRaw<
      { name: string; ring: string | null; source: string }[]
    >`
      SELECT a.name,
        CASE WHEN a.boundary IS NOT NULL
          THEN ST_AsGeoJSON(a.boundary::geometry)::text
          ELSE NULL
        END AS ring,
        CASE WHEN a.boundary IS NOT NULL THEN 'postgis' ELSE 'missing' END AS source
      FROM "Area" a
      ORDER BY a.name ASC
    `;
    return rows.map((r) => ({
      name: r.name,
      source: r.source,
      geojson: r.ring ? JSON.parse(r.ring) : null,
    }));
  }
}
