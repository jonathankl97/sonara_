import { ForbiddenException, NotFoundException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { RoomsService } from './rooms.service';
import { Room, RoomType, RoomPriceModel, BookingMode } from './room.entity';

type MockRepo = {
  create: jest.Mock;
  save: jest.Mock;
  find: jest.Mock;
  findOne: jest.Mock;
  update: jest.Mock;
  delete: jest.Mock;
};

function mockRepository(): MockRepo {
  return {
    create: jest.fn((dto: Partial<Room>) => dto),
    save: jest.fn((entity: Partial<Room>) =>
      Promise.resolve({ id: 'room-1', ...entity }),
    ),
    find: jest.fn(),
    findOne: jest.fn(),
    update: jest.fn(),
    delete: jest.fn(),
  };
}

function sampleRoom(overrides: Partial<Room> = {}): Room {
  return {
    id: 'room-1',
    providerId: 'provider-1',
    name: 'Studio A',
    description: 'Ein professioneller Aufnahmeraum.',
    roomType: RoomType.RECORDING_STUDIO,
    sizeSqm: null,
    capacity: null,
    address: 'Musterstrasse 13',
    city: 'Berlin',
    zip: '10115',
    state: 'Berlin',
    country: 'Deutschland',
    priceModel: RoomPriceModel.HOURLY,
    basePrice: 60,
    amenities: null,
    equipment: null,
    imageUrls: null,
    openingHours: null,
    bookingMode: BookingMode.ON_REQUEST,
    isActive: true,
    createdAt: new Date(),
    updatedAt: new Date(),
    ...overrides,
  };
}

describe('RoomsService', () => {
  let service: RoomsService;
  let repo: MockRepo;

  beforeEach(() => {
    repo = mockRepository();
    service = new RoomsService(repo as unknown as Repository<Room>);
  });

  describe('createRoom', () => {
    it('erstellt einen Room mit providerId', async () => {
      const dto = {
        name: 'Studio A',
        description: 'Pro Aufnahmeraum',
        roomType: RoomType.RECORDING_STUDIO,
        address: 'Musterstrasse 13',
        city: 'Berlin',
        zip: '10115',
        state: 'Berlin',
        country: 'Deutschland',
        priceModel: RoomPriceModel.HOURLY,
        basePrice: 60,
        bookingMode: BookingMode.ON_REQUEST,
      };

      await service.create(dto, 'provider-1');

      expect(repo.create).toHaveBeenCalledWith({
        ...dto,
        providerId: 'provider-1',
      });
      expect(repo.save).toHaveBeenCalled();
    });
  });

  describe('findByProvider', () => {
    it('gibt alle Rooms eines Providers zurueck', async () => {
      const rooms = [sampleRoom()];
      repo.find.mockResolvedValue(rooms);

      const result = await service.findByProvider('provider-1');

      expect(result).toEqual(rooms);
      expect(repo.find).toHaveBeenCalledWith({
        where: { providerId: 'provider-1' },
      });
    });
  });

  describe('findById', () => {
    it('gibt einen Room zurueck wenn gefunden', async () => {
      const r = sampleRoom();
      repo.findOne.mockResolvedValue(r);

      const result = await service.findById('room-1');

      expect(result).toBe(r);
    });

    it('wirft NotFoundException wenn nicht gefunden', async () => {
      repo.findOne.mockResolvedValue(null);

      await expect(service.findById('unknown')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('update', () => {
    it('aktualisiert einen eigenen Room', async () => {
      const r = sampleRoom({ providerId: 'provider-1' });
      repo.findOne.mockResolvedValue(r);

      await service.update('room-1', { name: 'Neuer Name' }, 'provider-1');

      expect(repo.update).toHaveBeenCalledWith('room-1', {
        name: 'Neuer Name',
      });
    });

    it('wirft ForbiddenException bei fremdem Room', async () => {
      const r = sampleRoom({ providerId: 'provider-1' });
      repo.findOne.mockResolvedValue(r);

      await expect(
        service.update('room-1', { name: 'Hack' }, 'provider-2'),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('remove', () => {
    it('loescht einen eigenen Room', async () => {
      const r = sampleRoom({ providerId: 'provider-1' });
      repo.findOne.mockResolvedValue(r);

      await service.remove('room-1', 'provider-1');

      expect(repo.delete).toHaveBeenCalledWith('room-1');
    });

    it('wirft ForbiddenException bei fremdem Room', async () => {
      const r = sampleRoom({ providerId: 'provider-1' });
      repo.findOne.mockResolvedValue(r);

      await expect(service.remove('room-1', 'provider-2')).rejects.toThrow(
        ForbiddenException,
      );
    });
  });
});
