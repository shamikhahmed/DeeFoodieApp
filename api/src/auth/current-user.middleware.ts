import {
  ForbiddenException,
  Injectable,
  NestMiddleware,
  UnauthorizedException,
} from '@nestjs/common';
import { createHash } from 'crypto';
import { Request, Response, NextFunction } from 'express';
import { PrismaService } from '../prisma/prisma.service';

export interface RequestWithUser extends Request {
  userId?: string;
}

function hashToken(token: string): string {
  return createHash('sha256').update(token).digest('hex');
}

function extractBearer(req: Request): string | null {
  const header = req.header('authorization');
  if (!header) return null;
  const m = /^Bearer\s+(.+)$/i.exec(header.trim());
  return m?.[1]?.trim() || null;
}

/**
 * Per-user bearer tokens (D-10 / DFD-P0-04).
 * Stub X-User-Id remains for local/dev only — refused in production (DFD-P0-03).
 */
@Injectable()
export class CurrentUserMiddleware implements NestMiddleware {
  constructor(private readonly prisma: PrismaService) {}

  async use(req: RequestWithUser, _res: Response, next: NextFunction) {
    const path = (req.path || req.url || '').split('?')[0];
    if (path === '/health' || path.endsWith('/health')) {
      return next();
    }

    const bearer = extractBearer(req);
    if (bearer) {
      const tokenHash = hashToken(bearer);
      const user = await this.prisma.user.findUnique({ where: { tokenHash } });
      if (!user) {
        throw new UnauthorizedException('Invalid access token.');
      }
      req.userId = user.id;
      return next();
    }

    const allowStub =
      process.env.NODE_ENV !== 'production' ||
      process.env.ALLOW_STUB_AUTH === 'true';

    if (!allowStub) {
      throw new ForbiddenException(
        'Authentication required. Use Authorization: Bearer <token>. Stub auth is disabled in production.',
      );
    }

    // Dev-only stub (refused in production unless ALLOW_STUB_AUTH=true).
    const headerUserId = req.header('x-user-id');
    if (headerUserId) {
      req.userId = headerUserId;
      return next();
    }
    const firstUser = await this.prisma.user.findFirst({
      orderBy: { joinedAt: 'asc' },
    });
    req.userId = firstUser?.id;
    next();
  }
}
