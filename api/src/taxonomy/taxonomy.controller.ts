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
}
