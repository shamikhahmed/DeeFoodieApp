import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';

export interface VisitItemInput {
  name: string;
  type: 'food' | 'drink' | 'dessert';
  dishId?: string;
}

export interface CreateVisitInput {
  eateryId: string;
  date: string;
  time?: string;
  rating: number;
  reviewText?: string;
  totalBill?: number;
  favoriteItem?: string;
  wouldVisitAgain?: boolean;
  companions?: string;
  moodTags?: string[];
  memoryNote?: string;
  bookMemory?: { stickerIds?: string[]; photoDataUrls?: string[] };
  items?: VisitItemInput[];
  photoUrls?: string[];
  subRatings?: Record<string, number>;
}

const SUB_RATING_FIELDS = [
  'ratingFood', 'ratingService', 'ratingAtmosphere', 'ratingCleanliness',
  'ratingValue', 'ratingWaitTime', 'ratingComfort', 'ratingParking',
  'ratingWifi', 'ratingStudyFriendly', 'ratingDateFriendly', 'ratingFamilyFriendly',
] as const;

const visitInclude = {
  items: true,
  photos: true,
  eatery: { select: { id: true, name: true } },
  user: { select: { id: true, name: true } },
} satisfies Prisma.VisitInclude;

@Injectable()
export class VisitsService {
  constructor(private readonly prisma: PrismaService) {}

  // Shared 2-user model: everyone sees all visits. Filters optional.
  findAll(filters: { eateryId?: string; userId?: string; moodTag?: string }) {
    const where: Prisma.VisitWhereInput = {};
    if (filters.eateryId) where.eateryId = filters.eateryId;
    if (filters.userId) where.userId = filters.userId;
    if (filters.moodTag) where.moodTags = { has: filters.moodTag };
    return this.prisma.visit.findMany({
      where,
      include: visitInclude,
      orderBy: { date: 'desc' },
    });
  }

  async findOne(id: string) {
    const visit = await this.prisma.visit.findUnique({ where: { id }, include: visitInclude });
    if (!visit) throw new NotFoundException(`Visit ${id} not found`);
    return visit;
  }

  create(userId: string, input: CreateVisitInput) {
    return this.prisma.visit.create({
      data: {
        userId,
        eateryId: input.eateryId,
        date: new Date(input.date),
        time: input.time,
        rating: input.rating,
        reviewText: input.reviewText,
        totalBill: input.totalBill,
        favoriteItem: input.favoriteItem,
        wouldVisitAgain: input.wouldVisitAgain,
        companions: input.companions,
        moodTags: input.moodTags ?? [],
        memoryNote: input.memoryNote,
        bookMemory: input.bookMemory as Prisma.InputJsonValue | undefined,
        ...this.subRatings(input.subRatings),
        items: input.items
          ? { create: input.items.map((i) => ({ name: i.name, type: i.type, dishId: i.dishId })) }
          : undefined,
        photos: input.photoUrls?.length
          ? {
              create: input.photoUrls.map((url) => ({
                url,
                galleryCategory: 'food',
              })),
            }
          : undefined,
      },
      include: visitInclude,
    });
  }

  async update(userId: string, id: string, input: Partial<CreateVisitInput>) {
    await this.assertOwner(userId, id);
    return this.prisma.visit.update({
      where: { id },
      data: {
        ...(input.date ? { date: new Date(input.date) } : {}),
        time: input.time,
        rating: input.rating,
        reviewText: input.reviewText,
        totalBill: input.totalBill,
        favoriteItem: input.favoriteItem,
        wouldVisitAgain: input.wouldVisitAgain,
        companions: input.companions,
        ...(input.moodTags ? { moodTags: input.moodTags } : {}),
        memoryNote: input.memoryNote,
        bookMemory: input.bookMemory as Prisma.InputJsonValue | undefined,
        ...this.subRatings(input.subRatings),
        ...(input.items
          ? {
              items: {
                deleteMany: {},
                create: input.items.map((i) => ({ name: i.name, type: i.type, dishId: i.dishId })),
              },
            }
          : {}),
        ...(input.photoUrls
          ? {
              photos: {
                deleteMany: {},
                create: input.photoUrls.map((url) => ({
                  url,
                  galleryCategory: 'food' as const,
                })),
              },
            }
          : {}),
      },
      include: visitInclude,
    });
  }

  async remove(userId: string, id: string) {
    await this.assertOwner(userId, id);
    await this.prisma.visit.delete({ where: { id } });
    return { deleted: true };
  }

  // Own-edit-only rule: both users see all visits, but only the author mutates theirs.
  private async assertOwner(userId: string, visitId: string) {
    const visit = await this.prisma.visit.findUnique({
      where: { id: visitId },
      select: { userId: true },
    });
    if (!visit) throw new NotFoundException(`Visit ${visitId} not found`);
    if (visit.userId !== userId) {
      throw new ForbiddenException('You can only edit your own visits');
    }
  }

  private subRatings(subRatings?: Record<string, number>) {
    if (!subRatings) return {};
    const data: Record<string, number> = {};
    for (const field of SUB_RATING_FIELDS) {
      if (subRatings[field] !== undefined) data[field] = subRatings[field];
    }
    return data;
  }
}
