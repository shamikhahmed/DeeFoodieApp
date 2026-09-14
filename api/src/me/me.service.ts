import { Injectable, NotFoundException } from '@nestjs/common';
import { unlink } from 'fs/promises';
import { join } from 'path';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class MeService {
  constructor(private readonly prisma: PrismaService) {}

  async deleteAllUserData(userId: string) {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');

    const visits = await this.prisma.visit.findMany({
      where: { userId },
      include: { photos: true },
    });
    const photoUrls = visits.flatMap((v) => v.photos.map((p) => p.url));

    await this.prisma.$transaction(async (tx) => {
      await tx.visit.deleteMany({ where: { userId } });
      await tx.collection.deleteMany({ where: { userId } });
      await tx.wishlistEntry.deleteMany({ where: { userId } });
      await tx.userTrailProgress.deleteMany({ where: { userId } });
      await tx.user.update({
        where: { id: userId },
        data: { avatarUrl: null },
      });
    });

    const uploadDir = process.env.UPLOAD_DIR ?? join(process.cwd(), 'uploads');
    for (const url of photoUrls) {
      if (!url.startsWith('/uploads/')) continue;
      try {
        await unlink(join(uploadDir, url.replace('/uploads/', '')));
      } catch {
        // Best-effort local purge.
      }
    }

    return {
      ok: true,
      deletedVisits: visits.length,
      deletedPhotos: photoUrls.length,
    };
  }
}
