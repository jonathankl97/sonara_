import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
} from 'typeorm';

import { Review } from './review.entity';

export enum UserRole {
  ARTIST = 'artist',
  PROVIDER = 'provider',
  ADMIN = 'admin',
}

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ unique: true })
  firebaseUid!: string;

  @Column({ unique: true })
  email!: string;

  @Column({ nullable: true, type: 'varchar' })
  displayName!: string | null;

  @Column({ type: 'enum', enum: UserRole, default: UserRole.ARTIST })
  role!: UserRole;

  @Column({ nullable: true, type: 'varchar' })
  address!: string | null;

  @Column({ nullable: true, type: 'varchar' })
  zip!: string | null;

  @Column({ nullable: true, type: 'varchar' })
  city!: string | null;

  @Column({ nullable: true, type: 'varchar' })
  profileImageUrl!: string | null;

  @Column({ nullable: true, type: 'varchar' })
  bio!: string | null;

  @Column('simple-array', { nullable: true })
  roles!: string[] | null;

  @Column('simple-array', { nullable: true })
  genres!: string[] | null;

  @Column({ nullable: true, type: 'jsonb' })
  socialMedia!: {
    instagram?: string;
    youtube?: string;
    spotify?: string;
    tiktok?: string;
    soundcloud?: string;
    appleMusic?: string;
  } | null;

  @Column({ type: 'float', default: 0 })
  ratingAverage!: number;

  @Column({ type: 'int', default: 0 })
  ratingCount!: number;

  @OneToMany(() => Review, (review) => review.provider)
  receivedReviews!: Review[];

  @OneToMany(() => Review, (review) => review.author)
  writtenReviews!: Review[];

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
