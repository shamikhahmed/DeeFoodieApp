import { Injectable, NestMiddleware, ForbiddenException } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { PrismaService } from '../prisma/prisma.service';

export interface RequestWithUser extends Request {
  userId?: string;
}

// Stub auth for the 2-user MVP: real auth (Clerk) plugs in before Phase 2.
// Client sends X-User-Id; defaults to the first seeded user if absent.
// Production must not boot with stub auth (DFD-P0-03).
@Injectable()
export class CurrentUserMiddleware implements NestMiddleware {
  constructor(private readonly prisma: PrismaService) {}

  async use(req: RequestWithUser, _res: Response, next: NextFunction) {
    if (process.env.NODE_ENV === 'production' && process.env.ALLOW_STUB_AUTH !== 'true') {
      throw new ForbiddenException(
        'Stub auth is disabled in production. Configure a real auth provider.',
      );
    }
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
