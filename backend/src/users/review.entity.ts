import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
} from 'typeorm';

import { User } from './user.entity';

@Entity('reviews')
export class Review {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'int' })
  rating!: number;

  @Column({ type: 'text', nullable: true })
  comment!: string | null;

  // Der Bewerter
  @ManyToOne(() => User, (user) => user.writtenReviews, {
    onDelete: 'CASCADE',
  })
  author!: User;

  // Der bewertete User
  @ManyToOne(() => User, (user) => user.receivedReviews, {
    onDelete: 'CASCADE',
  })
  provider!: User;

  @CreateDateColumn()
  createdAt!: Date;
}
