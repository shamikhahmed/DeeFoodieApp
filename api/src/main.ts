import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';
import { AppModule } from './app.module';

async function bootstrap() {
  if (process.env.NODE_ENV === 'production' && process.env.ALLOW_STUB_AUTH !== 'true') {
    // Fail closed: stub X-User-Id auth must never face the public internet (DFD-P0-03).
    // Set ALLOW_STUB_AUTH=true only for intentional private TestFlight backends.
    process.stderr.write(
      '[DeeFoodie API] Refusing to start: NODE_ENV=production requires real auth (or ALLOW_STUB_AUTH=true for private deploys).\n',
    );
    process.exit(1);
  }
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  app.enableCors();
  const uploadDir = process.env.UPLOAD_DIR ?? join(process.cwd(), 'uploads');
  app.useStaticAssets(uploadDir, { prefix: '/uploads/' });
  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
