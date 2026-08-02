import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { SearchRoomsDto } from './search-rooms.dto';
import { RoomType } from '../../rooms/room.entity';

function validPayload(overrides: Partial<SearchRoomsDto> = {}) {
  return {
    roomType: RoomType.RECORDING_STUDIO,
    city: 'Berlin',
    minPrice: 30,
    maxPrice: 100,
    capacity: 3,
    amenities: 'wifi,parking',
    page: 1,
    limit: 20,
    ...overrides,
  };
}

describe('SearchRoomsDto', () => {
  it('akzeptiert ein vollstaendig gueltiges Payload', async () => {
    const dto = plainToInstance(SearchRoomsDto, validPayload());
    const errors = await validate(dto);
    expect(errors).toHaveLength(0);
  });

  it('akzeptiert ein komplett leeres Payload (alle Filter optional)', async () => {
    const dto = plainToInstance(SearchRoomsDto, {});
    const errors = await validate(dto);
    expect(errors).toHaveLength(0);
  });

  it('lehnt ungueltigen roomType ab', async () => {
    const dto = plainToInstance(
      SearchRoomsDto,
      validPayload({ roomType: 'spaceship' as RoomType }),
    );
    const errors = await validate(dto);
    expect(errors.some((e) => e.property === 'roomType')).toBe(true);
  });

  it('lehnt negativen minPrice ab', async () => {
    const dto = plainToInstance(SearchRoomsDto, validPayload({ minPrice: -5 }));
    const errors = await validate(dto);
    expect(errors.some((e) => e.property === 'minPrice')).toBe(true);
  });

  it('lehnt capacity < 1 ab', async () => {
    const dto = plainToInstance(SearchRoomsDto, validPayload({ capacity: 0 }));
    const errors = await validate(dto);
    expect(errors.some((e) => e.property === 'capacity')).toBe(true);
  });

  it('lehnt limit > 100 ab', async () => {
    const dto = plainToInstance(SearchRoomsDto, validPayload({ limit: 200 }));
    const errors = await validate(dto);
    expect(errors.some((e) => e.property === 'limit')).toBe(true);
  });

  it('transformiert String-Zahlen aus Query-Params korrekt', async () => {
    const dto = plainToInstance(SearchRoomsDto, {
      minPrice: '30',
      maxPrice: '100',
      capacity: '4',
      page: '3',
      limit: '15',
    });
    const errors = await validate(dto);
    expect(errors).toHaveLength(0);
    expect(dto.minPrice).toBe(30);
    expect(dto.capacity).toBe(4);
    expect(dto.page).toBe(3);
  });
});
