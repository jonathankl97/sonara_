import {
  IsArray,
  IsBoolean,
  IsEnum,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  MaxLength,
  Min,
  ValidateIf,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import {
  BookingMode,
  PriceModel,
  ServiceLocation,
  ServiceType,
} from '../service.entity';

class AddOnDto {
  @IsString()
  title!: string;

  @IsString()
  @MaxLength(500)
  description!: string;

  @IsNumber()
  @Min(0)
  price!: number;
}

export class CreateServiceDto {
  @IsString()
  @MaxLength(120)
  title!: string;

  @IsString()
  @MaxLength(500)
  description!: string;

  @IsEnum(ServiceType)
  serviceType!: ServiceType;

  // Maximale Audiospur-Laenge in Minuten. Optional.
  @IsOptional()
  @IsInt()
  @Min(0)
  audioLength?: number;

  @IsEnum(ServiceLocation)
  location!: ServiceLocation;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  genres?: string[];

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  coreServices?: string[];

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => AddOnDto)
  addOns?: AddOnDto[];

  @IsOptional()
  @IsBoolean()
  revisionsOffered?: boolean;

  // Nur sinnvoll wenn revisionsOffered true ist; Detailkopplung
  // bewusst nicht erzwungen (Provider kann Anzahl leer lassen).
  @IsOptional()
  @IsInt()
  @Min(0)
  revisionCount?: number;

  @IsEnum(PriceModel)
  priceModel!: PriceModel;

  // basePrice ist Pflicht ausser bei priceModel = inquiry.
  // @ValidateIf deaktiviert die folgenden Regeln, wenn inquiry gewaehlt ist.
  @ValidateIf((o: CreateServiceDto) => o.priceModel !== PriceModel.INQUIRY)
  @IsNumber()
  @Min(0)
  basePrice?: number;

  @IsOptional()
  @IsBoolean()
  allowCustomRequests?: boolean;

  @IsEnum(BookingMode)
  bookingMode!: BookingMode;
}
