import {
  BadRequestException,
  Body,
  Controller,
  Get,
  Param,
  Post,
  Query,
} from '@nestjs/common';
import { EateriesService } from './eateries.service';

interface CreateEateryDto {
  name: string;
  areaId: string;
  venueTypeIds: string[];
  cuisineIds: string[];
  address?: string;
  description?: string;
  lng: number;
  lat: number;
  ignoreDuplicateWarning?: boolean;
}

@Controller('eateries')
export class EateriesController {
  constructor(private readonly eateries: EateriesService) {}

  @Get()
  findAll(
    @Query('q') q?: string,
    @Query('venueType') venueType?: string,
    @Query('cuisine') cuisine?: string,
    @Query('area') area?: string,
    @Query('status') status?: 'active' | 'closed',
  ) {
    return this.eateries.findAll({ q, venueType, cuisine, area, status });
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.eateries.findOne(id);
  }

  @Post()
  async create(@Body() dto: CreateEateryDto) {
    if (!dto.name?.trim()) throw new BadRequestException('name is required');
    if (!dto.areaId) throw new BadRequestException('areaId is required');
    if (typeof dto.lng !== 'number' || typeof dto.lat !== 'number') {
      throw new BadRequestException('lng and lat are required');
    }

    if (!dto.ignoreDuplicateWarning) {
      const similar = await this.eateries.findSimilar(dto.name, dto.areaId);
      if (similar.length > 0) {
        return { duplicateWarning: true, similar };
      }
    }

    return this.eateries.create({
      name: dto.name.trim(),
      areaId: dto.areaId,
      venueTypeIds: dto.venueTypeIds ?? [],
      cuisineIds: dto.cuisineIds ?? [],
      address: dto.address,
      description: dto.description,
      lng: dto.lng,
      lat: dto.lat,
    });
  }
}
