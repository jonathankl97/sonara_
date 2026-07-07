import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { Request } from 'express';
import { UsersService } from '../users/users.service';
import { UserRole } from '../users/user.entity';

@Injectable()
export class ProviderGuard implements CanActivate {
  constructor(private readonly usersService: UsersService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<Request>();
    const firebaseUid = (request.user as { uid?: string })?.uid;

    if (!firebaseUid) {
      throw new UnauthorizedException('Not authenticated');
    }

    const user = await this.usersService.findByFirebaseUid(firebaseUid);

    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    if (user.role !== UserRole.PROVIDER) {
      throw new ForbiddenException('Only providers can access this resource');
    }

    // Den geladenen App-User an den Request haengen, damit Controller
    // und Service-Layer ihn direkt nutzen koennen (z.B. fuer Ownership-Check)
    // ohne eine zweite DB-Abfrage.
    (request as unknown as Record<string, unknown>)['appUser'] = user;
    return true;
  }
}
