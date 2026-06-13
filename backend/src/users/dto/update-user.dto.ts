import {
  IsOptional,
  IsString,
  IsArray,
  IsObject,
  IsUrl,
} from 'class-validator';

export class UpdateUserDto {
  @IsOptional()
  @IsString()
  displayName?: string;

  @IsOptional()
  @IsString()
  bio?: string;

  @IsOptional()
  @IsString()
  address?: string;

  @IsOptional()
  @IsString()
  zip?: string;

  @IsOptional()
  @IsString()
  city?: string;

  @IsOptional()
  @IsUrl()
  profileImageUrl?: string;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  roles?: string[];

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  genres?: string[];

  @IsOptional()
  @IsObject()
  socialMedia?: {
    instagram?: string;
    youtube?: string;
    spotify?: string;
    tiktok?: string;
    soundcloud?: string;
    appleMusic?: string;
  };

  @IsOptional()
  @IsArray()
  musicTracks?: {
    id: string;
    name: string;
    artists: string[];
    albumImage: string;
    spotifyUrl: string;
    appleMusicUrl: string | null;
    popularity: number;
  }[];
}
