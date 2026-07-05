import {
  BadRequestException,
  Controller,
  Post,
  Req,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { GalleryCategory } from '@prisma/client';
import type { Request } from 'express';
import { memoryStorage } from 'multer';
import { PhotosService } from './photos.service';

@Controller('photos')
export class PhotosController {
  constructor(private readonly photos: PhotosService) {}

  @Post()
  @UseInterceptors(
    FileInterceptor('file', {
      storage: memoryStorage(),
      limits: { fileSize: 8 * 1024 * 1024 },
    }),
  )
  async upload(
    @UploadedFile() file: Express.Multer.File | undefined,
    @Req() req: Request,
  ) {
    if (!file?.buffer?.length) throw new BadRequestException('file is required');
    const visitId = typeof req.body?.visitId === 'string' ? req.body.visitId : undefined;
    const eateryId = typeof req.body?.eateryId === 'string' ? req.body.eateryId : undefined;
    const rawCategory = typeof req.body?.category === 'string' ? req.body.category : 'food';
    const category = Object.values(GalleryCategory).includes(rawCategory as GalleryCategory)
      ? (rawCategory as GalleryCategory)
      : GalleryCategory.food;

    return this.photos.upload(file.buffer, file.mimetype, { visitId, eateryId, category });
  }
}
