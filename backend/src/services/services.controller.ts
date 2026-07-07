import {
  Controller,
  Post,
  Get,
  Patch,
  Delete,
  Param,
  Body,
  UseGuards,
} from '@nestjs/common';
import { FirebaseAuthGuard } from '../auth/firebase-auth.guard';
import { ProviderGuard } from '../auth/provider.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { ServicesService } from './services.service';
import { CreateServiceDto } from './dto/create-service.dto';
import { UpdateServiceDto } from './dto/update-service.dto';
import type { User } from '../users/user.entity';

@Controller('services')
@UseGuards(FirebaseAuthGuard, ProviderGuard)
export class ServicesController {
  constructor(private readonly servicesService: ServicesService) {}

  @Post()
  async create(@CurrentUser() user: User, @Body() dto: CreateServiceDto) {
    return this.servicesService.create(dto, user.id);
  }

  @Get('me')
  async findMine(@CurrentUser() user: User) {
    return this.servicesService.findByProvider(user.id);
  }

  @Patch(':id')
  async update(
    @CurrentUser() user: User,
    @Param('id') id: string,
    @Body() dto: UpdateServiceDto,
  ) {
    return this.servicesService.update(id, dto, user.id);
  }

  @Delete(':id')
  async remove(@CurrentUser() user: User, @Param('id') id: string) {
    await this.servicesService.remove(id, user.id);
  }
}
