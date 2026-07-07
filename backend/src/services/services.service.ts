import {
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Service } from './service.entity';
import { CreateServiceDto } from './dto/create-service.dto';
import { UpdateServiceDto } from './dto/update-service.dto';

@Injectable()
export class ServicesService {
  constructor(
    @InjectRepository(Service)
    private readonly serviceRepository: Repository<Service>,
  ) {}

  async create(dto: CreateServiceDto, providerId: string): Promise<Service> {
    const service = this.serviceRepository.create({
      ...dto,
      providerId,
    });
    return this.serviceRepository.save(service);
  }

  async findByProvider(providerId: string): Promise<Service[]> {
    return this.serviceRepository.find({ where: { providerId } });
  }

  async findById(id: string): Promise<Service> {
    const service = await this.serviceRepository.findOne({ where: { id } });
    if (!service) throw new NotFoundException('Service nicht gefunden');
    return service;
  }

  async update(
    id: string,
    dto: UpdateServiceDto,
    providerId: string,
  ): Promise<Service> {
    const service = await this.findById(id);
    if (service.providerId !== providerId) {
      throw new ForbiddenException(
        'Nur der Eigentuemer kann diesen Service bearbeiten',
      );
    }
    await this.serviceRepository.update(id, dto);
    return this.findById(id);
  }

  async remove(id: string, providerId: string): Promise<void> {
    const service = await this.findById(id);
    if (service.providerId !== providerId) {
      throw new ForbiddenException(
        'Nur der Eigentuemer kann diesen Service loeschen',
      );
    }
    await this.serviceRepository.delete(id);
  }
}
