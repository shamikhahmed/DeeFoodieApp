import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { CurrentUserMiddleware } from './auth/current-user.middleware';
import { EateriesModule } from './eateries/eateries.module';
import { TaxonomyModule } from './taxonomy/taxonomy.module';
import { VisitsModule } from './visits/visits.module';
import { PhotosModule } from './photos/photos.module';

@Module({
  imports: [PrismaModule, EateriesModule, TaxonomyModule, VisitsModule, PhotosModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(CurrentUserMiddleware).forRoutes('*');
  }
}
