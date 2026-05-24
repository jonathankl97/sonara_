import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

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

  @Column('simple-array', { nullable: true })
  roles!: string[] | null;

  @Column('simple-array', { nullable: true })
  genres!: string[] | null;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
