// eslint-disable @typescript-eslint/no-unsafe-assignment */
// eslint-disable @typescript-eslint/no-unsafe-argument */

import { Injectable, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, UserRole } from '../users/user.entity';
import { DecodedIdToken } from 'firebase-admin/auth';
import { RegisterDto } from './dto/register.dto';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async findOrCreateUser(
    decodedToken: DecodedIdToken,
    role?: UserRole,
  ): Promise<User> {
    let user = await this.userRepository.findOne({
      where: { firebaseUid: decodedToken.uid },
    });

    if (!user) {
      user = this.userRepository.create({
        firebaseUid: decodedToken.uid,
        email: decodedToken.email ?? '',
        displayName: (decodedToken.name as string | undefined) ?? null,
        role: role ?? UserRole.ARTIST,
      });
      await this.userRepository.save(user);
    }

    return user;
  }

  async register(
    decodedToken: DecodedIdToken,
    dto: RegisterDto,
  ): Promise<User> {
    const existing = await this.userRepository.findOne({
      where: { firebaseUid: decodedToken.uid },
    });

    if (existing) {
      throw new ConflictException('User bereits registriert');
    }

    const user = this.userRepository.create({
      firebaseUid: decodedToken.uid,
      email: dto.email,
      displayName: dto.name,
      role: dto.role,
      address: dto.address ?? null,
      zip: dto.zip ?? null,
      city: dto.city ?? null,
      roles: dto.roles ?? null,
      genres: dto.genres ?? null,
    });

    return this.userRepository.save(user);
  }
}
