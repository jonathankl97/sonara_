import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  UseGuards,
} from '@nestjs/common';
import { FirebaseAuthGuard } from '../auth/firebase-auth.guard';
import { ProviderGuard } from '../auth/provider.guard';
import { RoomsService } from './rooms.service';
import { CurrentUser } from '../auth/current-user.decorator';
import { User } from '../users/user.entity';
import { CreateRoomDto } from './dto/create-room.dto';
import { UpdateRoomDto } from './dto/update-room.dto';

@Controller('rooms')
@UseGuards(FirebaseAuthGuard, ProviderGuard)
export class RoomsController {
  constructor(private readonly roomService: RoomsService) {}

  @Post()
  async create(
    @CurrentUser() user: User,
    @Body() createRoomDto: CreateRoomDto,
  ) {
    return this.roomService.create(createRoomDto, user.id);
  }

  @Get('me')
  async findMine(@CurrentUser() user: User) {
    return this.roomService.findByProvider(user.id);
  }

  @Patch(':id')
  async update(
    @CurrentUser() user: User,
    @Param('id') id: string,
    @Body() dto: UpdateRoomDto,
  ) {
    return this.roomService.update(id, dto, user.id);
  }

  @Delete(':id')
  async remove(@CurrentUser() user: User, @Param('id') id: string) {
    await this.roomService.remove(id, user.id);
  }
}
