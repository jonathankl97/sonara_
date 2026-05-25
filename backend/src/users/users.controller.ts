import {
  Controller,
  Get,
  Patch,
  Param,
  Body,
  UseGuards,
  Req,
} from '@nestjs/common';
import type { Request } from 'express';
import { FirebaseAuthGuard } from '../auth/firebase-auth.guard';
import { UsersService } from './users.service';
import { UpdateUserDto } from './dto/update-user.dto';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('me')
  @UseGuards(FirebaseAuthGuard)
  async getMe(@Req() request: Request) {
    return this.usersService.findByFirebaseUid(request.user!.uid);
  }

  @Get(':id')
  @UseGuards(FirebaseAuthGuard)
  async getUser(@Param('id') id: string) {
    return this.usersService.findById(id);
  }

  @Patch('me')
  @UseGuards(FirebaseAuthGuard)
  async updateMe(@Req() request: Request, @Body() dto: UpdateUserDto) {
    const user = await this.usersService.findByFirebaseUid(request.user!.uid);
    if (!user) return null;
    return this.usersService.update(user.id, dto);
  }
}
