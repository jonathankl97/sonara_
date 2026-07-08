import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

export enum RoomType {
  RECORDING_STUDIO = 'recordingStudio',
  REHEARSAL_ROOM = 'rehearsalRoom',
  PRODUCTION_SUITE = 'productionSuite',
  PODCAST_STUDIO = 'podcastStudio',
  VOCAL_BOOTH = 'vocalBooth',
  DJ_BOOTH = 'djBooth',
  OTHER = 'other',
}

export enum RoomPriceModel {
  HOURLY = 'hourly',
  PER_DAY = 'perDay',
}

export enum RoomEquipmentCategory {
  DAW = 'daw',
  MICROPHONE = 'microphone',
  MIXER = 'mixer',
  AUDIO_INTERFACE = 'audioInterface',
  MONITOR = 'monitor',
  HEADPHONES = 'headphones',
  INSTRUMENT = 'instrument',
  DJ_GEAR = 'djGear',
  OUTBOARD = 'outboard',
  OTHER = 'other',
}

// Dupliziert aus service.entity.ts — spaeter nach
// src/common/enums/booking-mode.enum.ts auslagern und in beiden
// Entities von dort importieren.
export enum BookingMode {
  ON_REQUEST = 'onRequest',
  WEEKLY_AVAILABILITY = 'weeklyAvailability',
}

// Strukturierte Technik-Liste (Mockup: Kategorie-Dropdown + Bezeichnung,
// z.B. { category: 'daw', name: 'Logic Pro' }).
export interface RoomEquipment {
  category: RoomEquipmentCategory;
  name: string;
}

// Statische Oeffnungszeiten (NICHT der Buchungskalender). Wochentage,
// an denen geoeffnet ist, plus ein einheitliches Zeitfenster.
export interface OpeningHours {
  days: string[]; // z.B. ['monday', 'tuesday', ...]
  openFrom: string; // "09:00"
  openTo: string; // "22:00"
}

@Entity('rooms')
export class Room {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  // FK auf den Provider (users.id). Indexiert, da GET /rooms/me und
  // spaeter die Discovery hierueber joinen.
  @Index()
  @Column({ type: 'uuid' })
  providerId!: string;

  @Column({ type: 'varchar' })
  name!: string;

  @Column({ type: 'varchar', length: 1000 })
  description!: string;

  @Column({ type: 'enum', enum: RoomType })
  roomType!: RoomType;

  // Groesse in m². Optional (ersetzt die gestrichene Unterraum-Liste).
  @Column({ type: 'int', nullable: true })
  sizeSqm!: number | null;

  // Kapazitaet in Personen. Optional.
  @Column({ type: 'int', nullable: true })
  capacity!: number | null;

  // Standort. city wird spaeter Discovery-Filter.
  @Column({ type: 'varchar' })
  address!: string;

  @Column({ type: 'varchar' })
  city!: string;

  @Column({ type: 'varchar' })
  zip!: string;

  @Column({ type: 'varchar' })
  state!: string;

  @Column({ type: 'varchar' })
  country!: string;

  @Column({ type: 'enum', enum: RoomPriceModel })
  priceModel!: RoomPriceModel;

  // Jeder Raum hat einen Preis (kein inquiry-Fall) -> non-nullable.
  @Column({ type: 'numeric', precision: 10, scale: 2 })
  basePrice!: number;

  // Ausstattungs-Chips (WIFI, Parkplatz, Kueche, Bad ...). Einfache Liste.
  @Column('simple-array', { nullable: true })
  amenities!: string[] | null;

  // Strukturierte Technik-Liste.
  @Column({ type: 'jsonb', nullable: true })
  equipment!: RoomEquipment[] | null;

  // Firebase-Storage-URLs. Client laedt hoch, Backend speichert nur URLs.
  @Column('simple-array', { nullable: true })
  imageUrls!: string[] | null;

  // Statische Oeffnungszeiten.
  @Column({ type: 'jsonb', nullable: true })
  openingHours!: OpeningHours | null;

  @Column({ type: 'enum', enum: BookingMode })
  bookingMode!: BookingMode;

  @Column({ type: 'boolean', default: true })
  isActive!: boolean;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
