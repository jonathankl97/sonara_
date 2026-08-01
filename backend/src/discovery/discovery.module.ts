import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from '../users/user.entity';
import { Service } from '../services/service.entity';
import { Room } from '../rooms/room.entity';
import { DiscoveryController } from './discovery.controller';
import { DiscoveryService } from './discovery.service';
import { FirebaseAuthModule } from '../auth/firebase-auth.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([User, Service, Room]),
    FirebaseAuthModule,
  ],
  controllers: [DiscoveryController],
  providers: [DiscoveryService],
})
export class DiscoveryModule {}
