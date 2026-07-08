import {
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Repository } from 'typeorm';
import { Room } from './room.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { CreateRoomDto } from './dto/create-room.dto';
import { UpdateRoomDto } from './dto/update-room.dto';

@Injectable()
export class RoomsService {
  constructor(
    @InjectRepository(Room) private readonly roomRepository: Repository<Room>,
  ) {}

  async create(dto: CreateRoomDto, providerId: string): Promise<Room> {
    const room = this.roomRepository.create({
      ...dto,
      providerId,
    });
    return this.roomRepository.save(room);
  }

  async findByProvider(providerId: string): Promise<Room[]> {
    return this.roomRepository.find({ where: { providerId } });
  }

  async findById(id: string): Promise<Room> {
    const room = await this.roomRepository.findOne({ where: { id } });
    if (!room) throw new NotFoundException('Room nicht gefunden');
    return room;
  }

  async update(
    id: string,
    dto: UpdateRoomDto,
    providerId: string,
  ): Promise<Room> {
    const room = await this.findById(id);
    if (room.providerId !== providerId) {
      throw new ForbiddenException(
        'Nur der Eigentuemer kann diesen Room bearbeiten',
      );
    }
    await this.roomRepository.update(id, dto);
    return this.findById(id);
  }

  async remove(id: string, providerId: string): Promise<void> {
    const room = await this.findById(id);
    if (room.providerId !== providerId) {
      throw new ForbiddenException(
        'Nur der Eigentuemer kann diesen Room loeschen',
      );
    }
    await this.roomRepository.delete(id);
  }
}
