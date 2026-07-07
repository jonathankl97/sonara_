import { ForbiddenException, NotFoundException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { ServicesService } from './services.service';
import {
  Service,
  ServiceType,
  PriceModel,
  ServiceLocation,
  BookingMode,
} from './service.entity';

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
    create: jest.fn((dto: Partial<Service>) => dto),
    save: jest.fn((entity: Partial<Service>) =>
      Promise.resolve({ id: 'service-1', ...entity }),
    ),
    find: jest.fn(),
    findOne: jest.fn(),
    update: jest.fn(),
    delete: jest.fn(),
  };
}

function sampleService(overrides: Partial<Service> = {}): Service {
  return {
    id: 'service-1',
    providerId: 'provider-1',
    title: 'Test Mixing',
    description: 'Professional mixing service',
    serviceType: ServiceType.MIXING,
    audioLength: null,
    location: ServiceLocation.REMOTE,
    genres: ['hiphop'],
    coreServices: ['Leveling', 'EQ'],
    addOns: null,
    revisionsOffered: false,
    revisionCount: null,
    priceModel: PriceModel.FIXED,
    basePrice: 150,
    allowCustomRequests: false,
    bookingMode: BookingMode.ON_REQUEST,
    isActive: true,
    createdAt: new Date(),
    updatedAt: new Date(),
    ...overrides,
  };
}

describe('ServicesService', () => {
  let service: ServicesService;
  let repo: MockRepo;

  beforeEach(() => {
    repo = mockRepository();
    service = new ServicesService(repo as unknown as Repository<Service>);
  });

  describe('create', () => {
    it('erstellt einen Service mit providerId', async () => {
      const dto = {
        title: 'Mixing',
        description: 'Pro mix',
        serviceType: ServiceType.MIXING,
        location: ServiceLocation.REMOTE,
        priceModel: PriceModel.FIXED,
        basePrice: 150,
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
    it('gibt alle Services eines Providers zurueck', async () => {
      const services = [sampleService()];
      repo.find.mockResolvedValue(services);

      const result = await service.findByProvider('provider-1');

      expect(result).toEqual(services);
      expect(repo.find).toHaveBeenCalledWith({
        where: { providerId: 'provider-1' },
      });
    });
  });

  describe('findById', () => {
    it('gibt einen Service zurueck wenn gefunden', async () => {
      const s = sampleService();
      repo.findOne.mockResolvedValue(s);

      const result = await service.findById('service-1');

      expect(result).toBe(s);
    });

    it('wirft NotFoundException wenn nicht gefunden', async () => {
      repo.findOne.mockResolvedValue(null);

      await expect(service.findById('unknown')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('update', () => {
    it('aktualisiert einen eigenen Service', async () => {
      const s = sampleService({ providerId: 'provider-1' });
      repo.findOne.mockResolvedValue(s);

      await service.update('service-1', { title: 'Neuer Titel' }, 'provider-1');

      expect(repo.update).toHaveBeenCalledWith('service-1', {
        title: 'Neuer Titel',
      });
    });

    it('wirft ForbiddenException bei fremdem Service', async () => {
      const s = sampleService({ providerId: 'provider-1' });
      repo.findOne.mockResolvedValue(s);

      await expect(
        service.update('service-1', { title: 'Hack' }, 'provider-2'),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('remove', () => {
    it('loescht einen eigenen Service', async () => {
      const s = sampleService({ providerId: 'provider-1' });
      repo.findOne.mockResolvedValue(s);

      await service.remove('service-1', 'provider-1');

      expect(repo.delete).toHaveBeenCalledWith('service-1');
    });

    it('wirft ForbiddenException bei fremdem Service', async () => {
      const s = sampleService({ providerId: 'provider-1' });
      repo.findOne.mockResolvedValue(s);

      await expect(service.remove('service-1', 'provider-2')).rejects.toThrow(
        ForbiddenException,
      );
    });
  });
});
