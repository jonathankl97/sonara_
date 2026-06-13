import { Controller, Get, Post, Body, UseGuards, Req } from '@nestjs/common';
import type { Request } from 'express';
import { IsString, IsOptional } from 'class-validator';
import { SpotifyService } from './spotify.service';
import { FirebaseAuthGuard } from '../auth/firebase-auth.guard';
import { UsersService } from '../users/users.service';

type MusicTrack = {
  id: string;
  name: string;
  artists: string[];
  albumImage: string;
  spotifyUrl: string;
  appleMusicUrl: string | null;
  popularity: number;
};

class AddTrackDto {
  @IsString()
  spotifyUrl!: string;

  @IsOptional()
  @IsString()
  appleMusicUrl?: string;
}

@Controller('spotify')
export class SpotifyController {
  constructor(
    private readonly spotifyService: SpotifyService,
    private readonly usersService: UsersService,
  ) {}

  @Post('tracks')
  @UseGuards(FirebaseAuthGuard)
  async addTrack(@Req() request: Request, @Body() dto: AddTrackDto) {
    const trackId = this.spotifyService.extractTrackId(dto.spotifyUrl);
    if (!trackId) {
      return { error: 'Ungültige Spotify URL' };
    }

    const trackInfo = await this.spotifyService.getTrackInfo(trackId);
    const user = await this.usersService.findByFirebaseUid(request.user!.uid);
    if (!user) return { error: 'User nicht gefunden' };

    const currentTracks = (user.musicTracks ?? []) as MusicTrack[];
    const updatedTracks: MusicTrack[] = [
      ...currentTracks,
      {
        ...trackInfo,
        appleMusicUrl: dto.appleMusicUrl ?? null,
      },
    ];

    await this.usersService.update(user.id, { musicTracks: updatedTracks });
    return { success: true, track: trackInfo };
  }

  @Get('tracks')
  @UseGuards(FirebaseAuthGuard)
  async getTracks(@Req() request: Request) {
    const user = await this.usersService.findByFirebaseUid(request.user!.uid);
    return { tracks: (user?.musicTracks ?? []) as MusicTrack[] };
  }
}
