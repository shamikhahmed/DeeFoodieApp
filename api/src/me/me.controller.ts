import { Controller, Delete, Req, UnauthorizedException } from '@nestjs/common';
import { RequestWithUser } from '../auth/current-user.middleware';
import { MeService } from './me.service';

@Controller('me')
export class MeController {
  constructor(private readonly me: MeService) {}

  @Delete('data')
  async deleteMyData(@Req() req: RequestWithUser) {
    if (!req.userId) {
      throw new UnauthorizedException('Sign in required to delete your data.');
    }
    return this.me.deleteAllUserData(req.userId);
  }
}
