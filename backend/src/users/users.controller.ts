import {
  Controller,
  Get,
  Patch,
  Param,
  Body,
  UseGuards,
  Req,
  NotFoundException,
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
    const user = await this.usersService.findByFirebaseUid(request.user!.uid);
    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  @Get(':id')
  @UseGuards(FirebaseAuthGuard)
  async getUser(@Param('id') id: string) {
    const user = await this.usersService.findById(id);
    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  @Patch('me')
  @UseGuards(FirebaseAuthGuard)
  async updateMe(@Req() request: Request, @Body() dto: UpdateUserDto) {
    const user = await this.usersService.findByFirebaseUid(request.user!.uid);
    if (!user) throw new NotFoundException('User not found');
    return this.usersService.update(user.id, dto);
  }
}
