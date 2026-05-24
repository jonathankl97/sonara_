import { Body, Controller, Get, Post, Req, UseGuards } from '@nestjs/common';
import type { Request } from 'express';
import { FirebaseAuthGuard } from './firebase-auth.guard';
import { AuthService } from './auth.service';
import { UserRole } from '../users/user.entity';
import { RegisterDto } from './dto/register.dto';

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

  @Post('register')
  @UseGuards(FirebaseAuthGuard)
  async register(@Req() request: Request, @Body() dto: RegisterDto) {
    return this.authService.register(request.user!, dto);
  }
}
