import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { FirebaseAuthGuard } from '../auth/firebase-auth.guard';
import { DiscoveryService } from './discovery.service';
import { SearchProvidersDto } from './dto/search-providers.dto';
import { SearchRoomsDto } from './dto/search-rooms.dto';

@Controller('discovery')
@UseGuards(FirebaseAuthGuard)
export class DiscoveryController {
  constructor(private readonly discoveryService: DiscoveryService) {}

  @Get('providers')
  async searchProviders(@Query() dto: SearchProvidersDto) {
    return this.discoveryService.searchProviders(dto);
  }

  @Get('rooms')
  async searchRooms(@Query() dto: SearchRoomsDto) {
    return this.discoveryService.searchRooms(dto);
  }
}
