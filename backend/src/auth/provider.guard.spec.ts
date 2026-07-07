import {
  ExecutionContext,
  ForbiddenException,
  UnauthorizedException,
} from '@nestjs/common';
import { ProviderGuard } from './provider.guard';
import { UsersService } from '../users/users.service';
import { UserRole } from '../users/user.entity';

function mockExecutionContext(user?: { uid: string }): ExecutionContext {
  const request: Record<string, unknown> = {};
  if (user) {
    request['user'] = user;
  }
  return {
    switchToHttp: () => ({
      getRequest: () => request,
    }),
  } as unknown as ExecutionContext;
}

function mockUsersService(
  result: { id: string; role: UserRole } | null,
): UsersService {
  return {
    findByFirebaseUid: jest.fn().mockResolvedValue(result),
  } as unknown as UsersService;
}

describe('ProviderGuard', () => {
  it('laesst Provider durch und haengt appUser an', async () => {
    const user = { id: 'user-1', role: UserRole.PROVIDER };
    const service = mockUsersService(user);
    const context = mockExecutionContext({ uid: 'firebase-123' });
    const guard = new ProviderGuard(service);

    const result = await guard.canActivate(context);

    expect(result).toBe(true);
    const request = context
      .switchToHttp()
      .getRequest<Record<string, unknown>>();
    expect(request['appUser']).toBe(user);
    // eslint-disable-next-line @typescript-eslint/unbound-method
    expect(service.findByFirebaseUid).toHaveBeenCalledWith('firebase-123');
  });

  it('wirft ForbiddenException bei Artist-Rolle', async () => {
    const user = { id: 'user-2', role: UserRole.ARTIST };
    const service = mockUsersService(user);
    const context = mockExecutionContext({ uid: 'firebase-456' });
    const guard = new ProviderGuard(service);

    await expect(guard.canActivate(context)).rejects.toThrow(
      ForbiddenException,
    );
  });

  it('wirft ForbiddenException bei Admin-Rolle', async () => {
    const user = { id: 'user-3', role: UserRole.ADMIN };
    const service = mockUsersService(user);
    const context = mockExecutionContext({ uid: 'firebase-789' });
    const guard = new ProviderGuard(service);

    await expect(guard.canActivate(context)).rejects.toThrow(
      ForbiddenException,
    );
  });

  it('wirft UnauthorizedException ohne Firebase-UID', async () => {
    const service = mockUsersService(null);
    const context = mockExecutionContext();
    const guard = new ProviderGuard(service);

    await expect(guard.canActivate(context)).rejects.toThrow(
      UnauthorizedException,
    );
  });

  it('wirft UnauthorizedException wenn User nicht gefunden', async () => {
    const service = mockUsersService(null);
    const context = mockExecutionContext({ uid: 'firebase-unknown' });
    const guard = new ProviderGuard(service);

    await expect(guard.canActivate(context)).rejects.toThrow(
      UnauthorizedException,
    );
  });
});
