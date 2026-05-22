import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, UserRole } from '../users/user.entity';
import { DecodedIdToken } from 'firebase-admin/auth';

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
}
