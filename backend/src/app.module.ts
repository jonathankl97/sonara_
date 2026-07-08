import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { FirebaseAuthModule } from './auth/firebase-auth.module';
import { UsersModule } from './users/users.module';
import { User } from './users/user.entity';
import { AuthModule } from './auth/auth.module';
import { Review } from './users/review.entity';
import { SpotifyModule } from './spotify/spotify.module';
import { Service } from './services/service.entity';
import { Room } from './rooms/room.entity';
import { RoomsModule } from './rooms/rooms.module';
import { ServicesModule } from './services/services.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRoot({
      type: 'postgres' as const,
      host: process.env.DB_HOST ?? 'localhost',
      port: parseInt(process.env.DB_PORT ?? '5432', 10),
      username: process.env.DB_USER ?? 'sonara_admin',
      password: process.env.DB_PASSWORD ?? '',
      database: process.env.DB_NAME ?? 'sonara',
      entities: [User, Review, Service, Room],
      synchronize: process.env.NODE_ENV !== 'production',
      ssl:
        process.env.NODE_ENV === 'staging' ||
        process.env.NODE_ENV === 'production'
          ? { rejectUnauthorized: false }
          : false,
    }),
    FirebaseAuthModule,
    UsersModule,
    AuthModule,
    SpotifyModule,
    ServicesModule,
    RoomsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
