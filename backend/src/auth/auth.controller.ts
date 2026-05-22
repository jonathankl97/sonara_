import { Controller, Get, Req, UseGuards } from '@nestjs/common';
import type { Request } from 'express';
import { FirebaseAuthGuard } from './firebase-auth.guard';
import { AuthService } from './auth.service';
import { UserRole } from '../users/user.entity';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Get('me')
  @UseGuards(FirebaseAuthGuard)
  async getMe(@Req() request: Request) {
    return this.authService.findOrCreateUser(
      request.user!,
      request.user!.role as UserRole,
    );
  }
}
