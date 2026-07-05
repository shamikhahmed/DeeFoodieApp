import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { PrismaService } from '../prisma/prisma.service';

export interface RequestWithUser extends Request {
  userId?: string;
}

// Stub auth for the 2-user MVP: real auth (Clerk) plugs in before Phase 2.
// Client sends X-User-Id; defaults to the first seeded user if absent.
@Injectable()
export class CurrentUserMiddleware implements NestMiddleware {
  constructor(private readonly prisma: PrismaService) {}

  async use(req: RequestWithUser, _res: Response, next: NextFunction) {
    const headerUserId = req.header('x-user-id');
    if (headerUserId) {
      req.userId = headerUserId;
      return next();
    }
    const firstUser = await this.prisma.user.findFirst({ orderBy: { joinedAt: 'asc' } });
    req.userId = firstUser?.id;
    next();
  }
}
