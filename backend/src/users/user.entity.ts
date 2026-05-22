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

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
