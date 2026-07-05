import { Injectable } from '@nestjs/common';
import { GalleryCategory } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { StorageService } from '../storage/storage.service';

@Injectable()
export class PhotosService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly storage: StorageService,
  ) {}

  async upload(
    buffer: Buffer,
    mime: string,
    opts: { visitId?: string; eateryId?: string; category?: GalleryCategory },
  ) {
    const ext = mime.includes('png') ? '.png' : mime.includes('webp') ? '.webp' : '.jpg';
    const url = await this.storage.saveBuffer(buffer, ext, mime);
    const photo = await this.prisma.photo.create({
      data: {
        url,
        visitId: opts.visitId,
        eateryId: opts.eateryId,
        galleryCategory: opts.category ?? GalleryCategory.food,
      },
    });
    return photo;
  }
}
