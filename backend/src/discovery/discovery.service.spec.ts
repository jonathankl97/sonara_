/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { DiscoveryService } from './discovery.service';
import { User, UserRole } from '../users/user.entity';
import {
  Service,
  ServiceType,
  ServiceLocation,
  PriceModel,
  BookingMode,
} from '../services/service.entity';
import {
  Room,
  RoomType,
  RoomPriceModel,
  BookingMode as RoomBookingMode,
} from '../rooms/room.entity';

function createMockQueryBuilder(result: [any[], number] = [[], 0]) {
  const qb: any = {
    select: jest.fn().mockReturnThis(),
    where: jest.fn().mockReturnThis(),
    andWhere: jest.fn().mockReturnThis(),
    leftJoinAndSelect: jest.fn().mockReturnThis(),
    innerJoinAndSelect: jest.fn().mockReturnThis(),
    orderBy: jest.fn().mockReturnThis(),
    addOrderBy: jest.fn().mockReturnThis(),
    skip: jest.fn().mockReturnThis(),
    take: jest.fn().mockReturnThis(),
    setParameters: jest.fn().mockReturnThis(),
    getQuery: jest.fn().mockReturnValue('subquery'),
    getParameters: jest.fn().mockReturnValue({}),
    getManyAndCount: jest.fn().mockResolvedValue(result),
  };
  return qb;
}

describe('DiscoveryService', () => {
  let service: DiscoveryService;
  let mockUserRepo: any;
  let mockServiceRepo: any;
  let mockRoomRepo: any;

  beforeEach(async () => {
    mockUserRepo = {
      createQueryBuilder: jest.fn(),
    };
    mockServiceRepo = {
      createQueryBuilder: jest.fn(),
    };
    mockRoomRepo = {
      createQueryBuilder: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DiscoveryService,
        { provide: getRepositoryToken(User), useValue: mockUserRepo },
        { provide: getRepositoryToken(Service), useValue: mockServiceRepo },
        { provide: getRepositoryToken(Room), useValue: mockRoomRepo },
      ],
    }).compile();

    service = module.get<DiscoveryService>(DiscoveryService);
  });

  describe('searchProviders', () => {
    it('gibt paginierte Provider mit Services zurueck', async () => {
      const mockProvider = {
        id: 'provider-1',
        displayName: 'Studio Mueller',
        city: 'Berlin',
        profileImageUrl: null,
        bio: 'Pro Studio',
        ratingAverage: 4.5,
        ratingCount: 12,
        services: [
          {
            id: 'service-1',
            title: 'Mixing',
            serviceType: ServiceType.MIXING,
            basePrice: 150,
            priceModel: PriceModel.FIXED,
            location: ServiceLocation.REMOTE,
            bookingMode: BookingMode.ON_REQUEST,
            genres: ['hiphop', 'pop'],
          },
        ],
      };

      const serviceQb = createMockQueryBuilder();
      const userQb = createMockQueryBuilder([[mockProvider], 1]);

      mockServiceRepo.createQueryBuilder.mockReturnValue(serviceQb);
      mockUserRepo.createQueryBuilder.mockReturnValue(userQb);

      const result = await service.searchProviders({
        serviceType: ServiceType.MIXING,
        page: 1,
        limit: 20,
      });

      expect(result.data).toHaveLength(1);
      expect(result.data[0].displayName).toBe('Studio Mueller');
      expect(result.data[0].services).toHaveLength(1);
      expect(result.data[0].services[0].serviceType).toBe(ServiceType.MIXING);
      expect(result.data[0].services[0].bookingMode).toBe(
        BookingMode.ON_REQUEST,
      );
      expect(result.total).toBe(1);
      expect(result.page).toBe(1);
      expect(result.limit).toBe(20);
    });

    it('gibt leere Liste wenn keine Provider matchen', async () => {
      const serviceQb = createMockQueryBuilder();
      const userQb = createMockQueryBuilder([[], 0]);

      mockServiceRepo.createQueryBuilder.mockReturnValue(serviceQb);
      mockUserRepo.createQueryBuilder.mockReturnValue(userQb);

      const result = await service.searchProviders({});

      expect(result.data).toHaveLength(0);
      expect(result.total).toBe(0);
    });

    it('wendet serviceType-Filter an', async () => {
      const serviceQb = createMockQueryBuilder();
      const userQb = createMockQueryBuilder([[], 0]);

      mockServiceRepo.createQueryBuilder.mockReturnValue(serviceQb);
      mockUserRepo.createQueryBuilder.mockReturnValue(userQb);

      await service.searchProviders({ serviceType: ServiceType.MIXING });

      expect(serviceQb.andWhere).toHaveBeenCalledWith(
        'service.serviceType = :serviceType',
        { serviceType: ServiceType.MIXING },
      );
    });

    it('wendet location-Filter an', async () => {
      const serviceQb = createMockQueryBuilder();
      const userQb = createMockQueryBuilder([[], 0]);

      mockServiceRepo.createQueryBuilder.mockReturnValue(serviceQb);
      mockUserRepo.createQueryBuilder.mockReturnValue(userQb);

      await service.searchProviders({ location: ServiceLocation.REMOTE });

      expect(serviceQb.andWhere).toHaveBeenCalledWith(
        'service.location = :location',
        { location: ServiceLocation.REMOTE },
      );
    });

    it('wendet Genre-Filter an', async () => {
      const serviceQb = createMockQueryBuilder();
      const userQb = createMockQueryBuilder([[], 0]);

      mockServiceRepo.createQueryBuilder.mockReturnValue(serviceQb);
      mockUserRepo.createQueryBuilder.mockReturnValue(userQb);

      await service.searchProviders({ genres: 'hiphop,pop' });

      expect(serviceQb.andWhere).toHaveBeenCalledWith(
        expect.stringContaining('genre0'),
        expect.objectContaining({ genre0: '%hiphop%' }),
      );
      expect(serviceQb.andWhere).toHaveBeenCalledWith(
        expect.stringContaining('genre1'),
        expect.objectContaining({ genre1: '%pop%' }),
      );
    });

    it('wendet Preis-Filter an', async () => {
      const serviceQb = createMockQueryBuilder();
      const userQb = createMockQueryBuilder([[], 0]);

      mockServiceRepo.createQueryBuilder.mockReturnValue(serviceQb);
      mockUserRepo.createQueryBuilder.mockReturnValue(userQb);

      await service.searchProviders({ minPrice: 50, maxPrice: 200 });

      expect(serviceQb.andWhere).toHaveBeenCalledWith(
        'service.basePrice >= :minPrice',
        { minPrice: 50 },
      );
      expect(serviceQb.andWhere).toHaveBeenCalledWith(
        'service.basePrice <= :maxPrice',
        { maxPrice: 200 },
      );
    });

    it('wendet City-Filter auf Provider an', async () => {
      const serviceQb = createMockQueryBuilder();
      const userQb = createMockQueryBuilder([[], 0]);

      mockServiceRepo.createQueryBuilder.mockReturnValue(serviceQb);
      mockUserRepo.createQueryBuilder.mockReturnValue(userQb);

      await service.searchProviders({ city: 'Berlin' });

      expect(userQb.andWhere).toHaveBeenCalledWith(
        'LOWER(user.city) = LOWER(:city)',
        { city: 'Berlin' },
      );
    });

    it('berechnet skip korrekt fuer Seite 3', async () => {
      const serviceQb = createMockQueryBuilder();
      const userQb = createMockQueryBuilder([[], 0]);

      mockServiceRepo.createQueryBuilder.mockReturnValue(serviceQb);
      mockUserRepo.createQueryBuilder.mockReturnValue(userQb);

      await service.searchProviders({ page: 3, limit: 10 });

      expect(userQb.skip).toHaveBeenCalledWith(20);
      expect(userQb.take).toHaveBeenCalledWith(10);
    });

    it('nutzt Defaults fuer page und limit wenn nicht angegeben', async () => {
      const serviceQb = createMockQueryBuilder();
      const userQb = createMockQueryBuilder([[], 0]);

      mockServiceRepo.createQueryBuilder.mockReturnValue(serviceQb);
      mockUserRepo.createQueryBuilder.mockReturnValue(userQb);

      const result = await service.searchProviders({});

      expect(userQb.skip).toHaveBeenCalledWith(0);
      expect(userQb.take).toHaveBeenCalledWith(20);
      expect(result.page).toBe(1);
      expect(result.limit).toBe(20);
    });
  });

  describe('searchRooms', () => {
    it('gibt paginierte Rooms mit Provider-Info zurueck', async () => {
      const mockRoom = {
        id: 'room-1',
        name: 'Studio A',
        description: 'Aufnahmeraum',
        roomType: RoomType.RECORDING_STUDIO,
        city: 'Berlin',
        address: 'Musterstrasse 13',
        basePrice: 60,
        priceModel: RoomPriceModel.HOURLY,
        bookingMode: RoomBookingMode.ON_REQUEST,
        capacity: 4,
        amenities: ['wifi', 'parking'],
        imageUrls: ['https://example.com/img.jpg'],
        provider: {
          id: 'provider-1',
          displayName: 'Studio Mueller',
          profileImageUrl: null,
        },
      };

      const roomQb = createMockQueryBuilder([[mockRoom], 1]);
      mockRoomRepo.createQueryBuilder.mockReturnValue(roomQb);

      const result = await service.searchRooms({
        roomType: RoomType.RECORDING_STUDIO,
        page: 1,
        limit: 20,
      });

      expect(result.data).toHaveLength(1);
      expect(result.data[0].name).toBe('Studio A');
      expect(result.data[0].bookingMode).toBe(RoomBookingMode.ON_REQUEST);
      expect(result.data[0].provider.displayName).toBe('Studio Mueller');
      expect(result.total).toBe(1);
    });

    it('gibt leere Liste wenn keine Rooms matchen', async () => {
      const roomQb = createMockQueryBuilder([[], 0]);
      mockRoomRepo.createQueryBuilder.mockReturnValue(roomQb);

      const result = await service.searchRooms({});

      expect(result.data).toHaveLength(0);
      expect(result.total).toBe(0);
    });

    it('wendet roomType-Filter an', async () => {
      const roomQb = createMockQueryBuilder([[], 0]);
      mockRoomRepo.createQueryBuilder.mockReturnValue(roomQb);

      await service.searchRooms({ roomType: RoomType.RECORDING_STUDIO });

      expect(roomQb.andWhere).toHaveBeenCalledWith(
        'room.roomType = :roomType',
        { roomType: RoomType.RECORDING_STUDIO },
      );
    });

    it('wendet City-Filter an', async () => {
      const roomQb = createMockQueryBuilder([[], 0]);
      mockRoomRepo.createQueryBuilder.mockReturnValue(roomQb);

      await service.searchRooms({ city: 'Hamburg' });

      expect(roomQb.andWhere).toHaveBeenCalledWith(
        'LOWER(room.city) = LOWER(:city)',
        { city: 'Hamburg' },
      );
    });

    it('wendet Preis-Filter an', async () => {
      const roomQb = createMockQueryBuilder([[], 0]);
      mockRoomRepo.createQueryBuilder.mockReturnValue(roomQb);

      await service.searchRooms({ minPrice: 30, maxPrice: 100 });

      expect(roomQb.andWhere).toHaveBeenCalledWith(
        'room.basePrice >= :minPrice',
        { minPrice: 30 },
      );
      expect(roomQb.andWhere).toHaveBeenCalledWith(
        'room.basePrice <= :maxPrice',
        { maxPrice: 100 },
      );
    });

    it('wendet Capacity-Filter an', async () => {
      const roomQb = createMockQueryBuilder([[], 0]);
      mockRoomRepo.createQueryBuilder.mockReturnValue(roomQb);

      await service.searchRooms({ capacity: 3 });

      expect(roomQb.andWhere).toHaveBeenCalledWith(
        'room.capacity >= :capacity',
        { capacity: 3 },
      );
    });

    it('wendet Amenities-Filter an', async () => {
      const roomQb = createMockQueryBuilder([[], 0]);
      mockRoomRepo.createQueryBuilder.mockReturnValue(roomQb);

      await service.searchRooms({ amenities: 'wifi,parking' });

      expect(roomQb.andWhere).toHaveBeenCalledWith(
        expect.stringContaining('amenity0'),
        expect.objectContaining({ amenity0: '%wifi%' }),
      );
      expect(roomQb.andWhere).toHaveBeenCalledWith(
        expect.stringContaining('amenity1'),
        expect.objectContaining({ amenity1: '%parking%' }),
      );
    });

    it('berechnet skip korrekt fuer Seite 2', async () => {
      const roomQb = createMockQueryBuilder([[], 0]);
      mockRoomRepo.createQueryBuilder.mockReturnValue(roomQb);

      await service.searchRooms({ page: 2, limit: 15 });

      expect(roomQb.skip).toHaveBeenCalledWith(15);
      expect(roomQb.take).toHaveBeenCalledWith(15);
    });

    it('sortiert nach Provider-Rating und dann nach createdAt', async () => {
      const roomQb = createMockQueryBuilder([[], 0]);
      mockRoomRepo.createQueryBuilder.mockReturnValue(roomQb);

      await service.searchRooms({});

      expect(roomQb.orderBy).toHaveBeenCalledWith('user.ratingAverage', 'DESC');
      expect(roomQb.addOrderBy).toHaveBeenCalledWith('room.createdAt', 'DESC');
    });
  });
});
