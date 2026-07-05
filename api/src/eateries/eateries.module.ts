import { Module } from '@nestjs/common';
import { EateriesController } from './eateries.controller';
import { EateriesService } from './eateries.service';

@Module({
  controllers: [EateriesController],
  providers: [EateriesService],
})
export class EateriesModule {}
