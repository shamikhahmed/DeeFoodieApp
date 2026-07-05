import {
  BadRequestException,
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Query,
  Req,
} from '@nestjs/common';
import type { RequestWithUser } from '../auth/current-user.middleware';
import { VisitsService } from './visits.service';
import type { CreateVisitInput } from './visits.service';

@Controller('visits')
export class VisitsController {
  constructor(private readonly visits: VisitsService) {}

  @Get()
  findAll(
    @Query('eateryId') eateryId?: string,
    @Query('userId') userId?: string,
    @Query('moodTag') moodTag?: string,
  ) {
    return this.visits.findAll({ eateryId, userId, moodTag });
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.visits.findOne(id);
  }

  @Post()
  create(@Req() req: RequestWithUser, @Body() dto: CreateVisitInput) {
    if (!req.userId) throw new BadRequestException('No user resolved');
    if (!dto.eateryId) throw new BadRequestException('eateryId is required');
    if (!dto.date) throw new BadRequestException('date is required');
    if (dto.rating === undefined || dto.rating < 0.5 || dto.rating > 5) {
      throw new BadRequestException('rating must be between 0.5 and 5');
    }
    return this.visits.create(req.userId, dto);
  }

  @Patch(':id')
  update(
    @Req() req: RequestWithUser,
    @Param('id') id: string,
    @Body() dto: Partial<CreateVisitInput>,
  ) {
    if (!req.userId) throw new BadRequestException('No user resolved');
    return this.visits.update(req.userId, id, dto);
  }

  @Delete(':id')
  remove(@Req() req: RequestWithUser, @Param('id') id: string) {
    if (!req.userId) throw new BadRequestException('No user resolved');
    return this.visits.remove(req.userId, id);
  }
}
