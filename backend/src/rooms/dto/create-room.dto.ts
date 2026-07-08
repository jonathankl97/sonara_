import {
  IsArray,
  IsEnum,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  IsUrl,
  Max,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import {
  BookingMode,
  RoomEquipmentCategory,
  RoomPriceModel,
  RoomType,
} from '../room.entity';

class RoomEquipmentDto {
  @IsEnum(RoomEquipmentCategory)
  category!: RoomEquipmentCategory;

  @IsString()
  @MaxLength(100)
  name!: string;
}

class OpeningHoursDto {
  @IsArray()
  @IsString({ each: true })
  days!: string[];

  @IsString()
  openFrom!: string;

  @IsString()
  openTo!: string;
}

export class CreateRoomDto {
  @IsString()
  @MaxLength(120)
  name!: string;

  @IsString()
  @MaxLength(1000)
  description!: string;

  @IsEnum(RoomType)
  roomType!: RoomType;

  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(10000)
  sizeSqm?: number;

  @IsOptional()
  @IsInt()
  @Min(1)
  capacity?: number;

  @IsString()
  @MaxLength(200)
  address!: string;

  @IsString()
  @MaxLength(100)
  city!: string;

  @IsString()
  @MaxLength(20)
  zip!: string;

  @IsString()
  @MaxLength(100)
  state!: string;

  @IsString()
  @MaxLength(100)
  country!: string;

  @IsEnum(RoomPriceModel)
  priceModel!: RoomPriceModel;

  @IsNumber()
  @Min(0)
  basePrice!: number;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  amenities?: string[];

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => RoomEquipmentDto)
  equipment?: RoomEquipmentDto[];

  @IsOptional()
  @IsArray()
  @IsUrl({}, { each: true })
  imageUrls?: string[];

  @IsOptional()
  @ValidateNested()
  @Type(() => OpeningHoursDto)
  openingHours?: OpeningHoursDto;

  @IsEnum(BookingMode)
  bookingMode!: BookingMode;
}
