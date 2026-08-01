import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from '../users/user.entity';

export enum ServiceType {
  RECORDING = 'recording',
  MIXING = 'mixing',
  MASTERING = 'mastering',
  PRODUCTION = 'production',
  SONGWRITING = 'songwriting',
  TOPLINING = 'toplining',
  VOCALS = 'vocals',
  INSTRUMENTALIST = 'instrumentalist',
  ARRANGEMENT = 'arrangement',
  SOUND_DESIGN = 'soundDesign',
  OTHER = 'other',
}

export enum PriceModel {
  FIXED = 'fixed',
  HOURLY = 'hourly',
  PER_TRACK = 'perTrack',
  INQUIRY = 'inquiry',
}

export enum ServiceLocation {
  REMOTE = 'remote',
  ONSITE = 'onsite',
  HYBRID = 'hybrid',
}

export enum BookingMode {
  ON_REQUEST = 'onRequest',
  WEEKLY_AVAILABILITY = 'weeklyAvailability',
}

export interface ServiceAddOn {
  title: string;
  description: string;
  price: number;
}

@Entity('services')
export class Service {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @ManyToOne(() => User, (user) => user.services, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'providerId' })
  provider!: User;

  @Index()
  @Column({ type: 'uuid' })
  providerId!: string;

  @Column({ type: 'varchar' })
  title!: string;

  @Column({ type: 'varchar', length: 500 })
  description!: string;

  @Column({ type: 'enum', enum: ServiceType })
  serviceType!: ServiceType;

  // Maximale Laenge der Audiospuren in Minuten. Reine Anzeige, nicht filterbar.
  @Column({ type: 'int', nullable: true })
  audioLength!: number | null;

  @Column({ type: 'enum', enum: ServiceLocation })
  location!: ServiceLocation;

  // Eigenstaendige Service-Genres — NICHT von User.genres abgeleitet.
  @Column('simple-array', { nullable: true })
  genres!: string[] | null;

  // Kernleistungen ("Was beinhaltet mein Service") — freie Beschreibungstexte.
  @Column({ type: 'jsonb', nullable: true })
  coreServices!: string[] | null;

  // Optionale Extras mit eigenem Preis und Beschreibung.
  @Column({ type: 'jsonb', nullable: true })
  addOns!: ServiceAddOn[] | null;

  @Column({ type: 'boolean', default: false })
  revisionsOffered!: boolean;

  @Column({ type: 'int', nullable: true })
  revisionCount!: number | null;

  @Column({ type: 'enum', enum: PriceModel })
  priceModel!: PriceModel;

  // Pflicht im DTO ausser bei priceModel = inquiry (dort null erlaubt).
  @Column({ type: 'numeric', precision: 10, scale: 2, nullable: true })
  basePrice!: number | null;

  @Column({ type: 'boolean', default: false })
  allowCustomRequests!: boolean;

  @Column({ type: 'enum', enum: BookingMode })
  bookingMode!: BookingMode;

  @Column({ type: 'boolean', default: true })
  isActive!: boolean;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
