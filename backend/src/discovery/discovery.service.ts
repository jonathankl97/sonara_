import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, UserRole } from '../users/user.entity';
import { Service } from '../services/service.entity';
import { Room } from '../rooms/room.entity';
import { SearchProvidersDto } from './dto/search-providers.dto';
import { SearchRoomsDto } from './dto/search-rooms.dto';

@Injectable()
export class DiscoveryService {
  constructor(
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
    @InjectRepository(Service)
    private readonly serviceRepo: Repository<Service>,
    @InjectRepository(Room)
    private readonly roomRepo: Repository<Room>,
  ) {}

  async searchProviders(dto: SearchProvidersDto) {
    const page = dto.page ?? 1;
    const limit = dto.limit ?? 20;
    const skip = (page - 1) * limit;

    // Subquery: Finde Provider-IDs die passende Services haben.
    const serviceQuery = this.serviceRepo
      .createQueryBuilder('service')
      .select('DISTINCT service.providerId')
      .where('service.isActive = true');

    if (dto.serviceType) {
      serviceQuery.andWhere('service.serviceType = :serviceType', {
        serviceType: dto.serviceType,
      });
    }

    if (dto.location) {
      serviceQuery.andWhere('service.location = :location', {
        location: dto.location,
      });
    }

    if (dto.minPrice !== undefined) {
      serviceQuery.andWhere('service.basePrice >= :minPrice', {
        minPrice: dto.minPrice,
      });
    }

    if (dto.maxPrice !== undefined) {
      serviceQuery.andWhere('service.basePrice <= :maxPrice', {
        maxPrice: dto.maxPrice,
      });
    }

    if (dto.genres) {
      const genreList = dto.genres.split(',').map((g) => g.trim());
      for (let i = 0; i < genreList.length; i++) {
        serviceQuery.andWhere(`service.genres LIKE :genre${i}`, {
          [`genre${i}`]: `%${genreList[i]}%`,
        });
      }
    }

    // Hauptquery: Provider laden die in der Subquery vorkommen,
    // MIT ihren aktiven Services.
    const providerQuery = this.userRepo
      .createQueryBuilder('user')
      .leftJoinAndSelect('user.services', 'service', 'service.isActive = true')
      .where('user.role = :role', { role: UserRole.PROVIDER })
      .andWhere(`user.id IN (${serviceQuery.getQuery()})`)
      .setParameters(serviceQuery.getParameters());

    if (dto.city) {
      providerQuery.andWhere('LOWER(user.city) = LOWER(:city)', {
        city: dto.city,
      });
    }

    providerQuery.orderBy('user.ratingAverage', 'DESC').skip(skip).take(limit);

    const [providers, total] = await providerQuery.getManyAndCount();

    return {
      data: providers.map((provider) => this.mapProvider(provider)),
      total,
      page,
      limit,
    };
  }

  async searchRooms(dto: SearchRoomsDto) {
    const page = dto.page ?? 1;
    const limit = dto.limit ?? 20;
    const skip = (page - 1) * limit;

    const query = this.roomRepo
      .createQueryBuilder('room')
      .leftJoinAndSelect('room.provider', 'user')
      .where('room.isActive = true');

    if (dto.roomType) {
      query.andWhere('room.roomType = :roomType', {
        roomType: dto.roomType,
      });
    }

    if (dto.city) {
      query.andWhere('LOWER(room.city) = LOWER(:city)', {
        city: dto.city,
      });
    }

    if (dto.minPrice !== undefined) {
      query.andWhere('room.basePrice >= :minPrice', {
        minPrice: dto.minPrice,
      });
    }

    if (dto.maxPrice !== undefined) {
      query.andWhere('room.basePrice <= :maxPrice', {
        maxPrice: dto.maxPrice,
      });
    }

    if (dto.capacity !== undefined) {
      query.andWhere('room.capacity >= :capacity', {
        capacity: dto.capacity,
      });
    }

    if (dto.amenities) {
      const amenityList = dto.amenities.split(',').map((a) => a.trim());
      for (let i = 0; i < amenityList.length; i++) {
        query.andWhere(`room.amenities LIKE :amenity${i}`, {
          [`amenity${i}`]: `%${amenityList[i]}%`,
        });
      }
    }

    query
      .orderBy('user.ratingAverage', 'DESC')
      .addOrderBy('room.createdAt', 'DESC')
      .skip(skip)
      .take(limit);

    const [rooms, total] = await query.getManyAndCount();

    return {
      data: rooms.map((room) => this.mapRoom(room)),
      total,
      page,
      limit,
    };
  }

  private mapProvider(provider: User) {
    return {
      id: provider.id,
      displayName: provider.displayName,
      city: provider.city,
      profileImageUrl: provider.profileImageUrl,
      bio: provider.bio,
      ratingAverage: provider.ratingAverage,
      ratingCount: provider.ratingCount,
      services: (provider.services ?? []).map((service) => ({
        id: service.id,
        title: service.title,
        serviceType: service.serviceType,
        basePrice: service.basePrice,
        priceModel: service.priceModel,
        location: service.location,
        bookingMode: service.bookingMode,
        genres: service.genres,
      })),
    };
  }

  private mapRoom(room: Room) {
    return {
      id: room.id,
      name: room.name,
      description: room.description,
      roomType: room.roomType,
      city: room.city,
      address: room.address,
      basePrice: room.basePrice,
      priceModel: room.priceModel,
      bookingMode: room.bookingMode,
      capacity: room.capacity,
      amenities: room.amenities,
      imageUrls: room.imageUrls,
      provider: {
        id: room.provider.id,
        displayName: room.provider.displayName,
        profileImageUrl: room.provider.profileImageUrl,
      },
    };
  }
}
