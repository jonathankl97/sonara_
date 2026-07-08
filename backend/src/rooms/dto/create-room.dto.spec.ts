/* eslint-disable @typescript-eslint/no-unused-vars */
import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { CreateRoomDto } from './create-room.dto';
import {
  BookingMode,
  RoomEquipmentCategory,
  RoomPriceModel,
  RoomType,
} from '../room.entity';

function validPayload(overrides: Partial<CreateRoomDto> = {}) {
  return {
    name: 'Studio A',
    description: 'Ein professioneller Aufnahmeraum.',
    roomType: RoomType.RECORDING_STUDIO,
    address: 'Musterstrasse 13',
    city: 'Berlin',
    zip: '10115',
    state: 'Berlin',
    country: 'Deutschland',
    priceModel: RoomPriceModel.HOURLY,
    basePrice: 60,
    bookingMode: BookingMode.ON_REQUEST,
    ...overrides,
  };
}

describe('CreateRoomDto', () => {
  it('akzeptiert ein vollstaendig gueltiges Payload', async () => {
    const dto = plainToInstance(CreateRoomDto, validPayload());
    const errors = await validate(dto);

    expect(errors).toHaveLength(0);
  });

  describe('Pflichtfelder', () => {
    it('lehnt fehlenden name ab', async () => {
      const { name, ...withoutName } = validPayload();
      const dto = plainToInstance(CreateRoomDto, withoutName);
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'name')).toBe(true);
    });

    it('lehnt einen unbekannten roomType ab', async () => {
      const dto = plainToInstance(
        CreateRoomDto,
        validPayload({ roomType: 'castle' as RoomType }),
      );
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'roomType')).toBe(true);
    });

    it('lehnt fehlenden basePrice ab', async () => {
      const { basePrice, ...withoutPrice } = validPayload();
      const dto = plainToInstance(CreateRoomDto, withoutPrice);
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'basePrice')).toBe(true);
    });

    it('lehnt negativen basePrice ab', async () => {
      const dto = plainToInstance(
        CreateRoomDto,
        validPayload({ basePrice: -10 }),
      );
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'basePrice')).toBe(true);
    });

    it('lehnt fehlende Standortfelder ab', async () => {
      const { city, ...withoutCity } = validPayload();
      const dto = plainToInstance(CreateRoomDto, withoutCity);
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'city')).toBe(true);
    });
  });

  describe('description-Laenge', () => {
    it('lehnt eine Beschreibung ueber 1000 Zeichen ab', async () => {
      const dto = plainToInstance(
        CreateRoomDto,
        validPayload({ description: 'a'.repeat(1001) }),
      );
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'description')).toBe(true);
    });

    it('akzeptiert genau 1000 Zeichen', async () => {
      const dto = plainToInstance(
        CreateRoomDto,
        validPayload({ description: 'a'.repeat(1000) }),
      );
      const errors = await validate(dto);

      expect(errors).toHaveLength(0);
    });
  });

  describe('equipment (verschachtelt, Enum-Kategorie)', () => {
    it('akzeptiert gueltiges Equipment', async () => {
      const dto = plainToInstance(
        CreateRoomDto,
        validPayload({
          equipment: [
            { category: RoomEquipmentCategory.DAW, name: 'Logic Pro' },
          ],
        }),
      );
      const errors = await validate(dto);

      expect(errors).toHaveLength(0);
    });

    it('lehnt eine unbekannte Equipment-Kategorie ab', async () => {
      const dto = plainToInstance(
        CreateRoomDto,
        validPayload({
          equipment: [{ category: 'unicorn', name: 'Logic Pro' }] as never,
        }),
      );
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'equipment')).toBe(true);
    });

    it('lehnt Equipment ohne name ab', async () => {
      const dto = plainToInstance(
        CreateRoomDto,
        validPayload({
          equipment: [{ category: RoomEquipmentCategory.DAW }] as never,
        }),
      );
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'equipment')).toBe(true);
    });
  });

  describe('openingHours (verschachteltes Einzelobjekt)', () => {
    it('akzeptiert gueltige Oeffnungszeiten', async () => {
      const dto = plainToInstance(
        CreateRoomDto,
        validPayload({
          openingHours: {
            days: ['monday', 'tuesday'],
            openFrom: '09:00',
            openTo: '22:00',
          },
        }),
      );
      const errors = await validate(dto);

      expect(errors).toHaveLength(0);
    });

    it('lehnt Oeffnungszeiten mit fehlendem openFrom ab', async () => {
      const dto = plainToInstance(
        CreateRoomDto,
        validPayload({
          openingHours: {
            days: ['monday'],
            openTo: '22:00',
          } as never,
        }),
      );
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'openingHours')).toBe(true);
    });
  });

  describe('optionale Felder', () => {
    it('akzeptiert ein Payload ohne optionale Felder', async () => {
      const dto = plainToInstance(CreateRoomDto, validPayload());
      const errors = await validate(dto);

      expect(errors).toHaveLength(0);
    });

    it('akzeptiert gueltige amenities', async () => {
      const dto = plainToInstance(
        CreateRoomDto,
        validPayload({ amenities: ['wifi', 'parking'] }),
      );
      const errors = await validate(dto);

      expect(errors).toHaveLength(0);
    });

    it('lehnt ungueltige URLs in imageUrls ab', async () => {
      const dto = plainToInstance(
        CreateRoomDto,
        validPayload({ imageUrls: ['not-a-url'] }),
      );
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'imageUrls')).toBe(true);
    });
  });
});
