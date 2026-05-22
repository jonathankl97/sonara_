import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { FirebaseAuthModule } from './firebase-auth.module';
import { User } from '../users/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User]), FirebaseAuthModule],
  controllers: [AuthController],
  providers: [AuthService],
})
export class AuthModule {}
