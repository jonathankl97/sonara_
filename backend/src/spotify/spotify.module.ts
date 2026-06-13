import { Module } from '@nestjs/common';
import { SpotifyService } from './spotify.service';
import { SpotifyController } from './spotify.controller';
import { UsersModule } from '../users/users.module';
import { FirebaseAuthModule } from '../auth/firebase-auth.module';

@Module({
  imports: [UsersModule, FirebaseAuthModule],
  controllers: [SpotifyController],
  providers: [SpotifyService],
  exports: [SpotifyService],
})
export class SpotifyModule {}
