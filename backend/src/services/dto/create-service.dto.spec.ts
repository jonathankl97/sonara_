/* eslint-disable @typescript-eslint/no-unused-vars */
import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { CreateServiceDto } from './create-service.dto';
import {
  BookingMode,
  PriceModel,
  ServiceLocation,
  ServiceType,
} from '../service.entity';

// Minimal gueltiges Payload; einzelne Tests ueberschreiben Felder gezielt.
function validPayload(overrides: Partial<CreateServiceDto> = {}) {
  return {
    title: 'Mixing & Mastering',
    description: 'Professioneller Mix fuer deinen Track.',
    serviceType: ServiceType.MIXING,
    location: ServiceLocation.REMOTE,
    priceModel: PriceModel.FIXED,
    basePrice: 150,
    bookingMode: BookingMode.ON_REQUEST,
    ...overrides,
  };
}

describe('CreateServiceDto', () => {
  it('akzeptiert ein vollstaendig gueltiges Payload', async () => {
    const dto = plainToInstance(CreateServiceDto, validPayload());
    const errors = await validate(dto);

    expect(errors).toHaveLength(0);
  });

  describe('Pflichtfelder', () => {
    it('lehnt fehlenden title ab', async () => {
      const { title, ...withoutTitle } = validPayload();
      const dto = plainToInstance(CreateServiceDto, withoutTitle);
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'title')).toBe(true);
    });

    it('lehnt einen unbekannten serviceType ab', async () => {
      const dto = plainToInstance(
        CreateServiceDto,
        validPayload({ serviceType: 'beatboxing' as ServiceType }),
      );
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'serviceType')).toBe(true);
    });
  });

  describe('description-Laenge', () => {
    it('lehnt eine Beschreibung ueber 500 Zeichen ab', async () => {
      const dto = plainToInstance(
        CreateServiceDto,
        validPayload({ description: 'a'.repeat(501) }),
      );
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'description')).toBe(true);
    });

    it('akzeptiert genau 500 Zeichen', async () => {
      const dto = plainToInstance(
        CreateServiceDto,
        validPayload({ description: 'a'.repeat(500) }),
      );
      const errors = await validate(dto);

      expect(errors).toHaveLength(0);
    });
  });

  describe('basePrice in Abhaengigkeit vom priceModel', () => {
    it('verlangt basePrice bei fixed', async () => {
      const { basePrice, ...withoutPrice } = validPayload({
        priceModel: PriceModel.FIXED,
      });
      const dto = plainToInstance(CreateServiceDto, withoutPrice);
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'basePrice')).toBe(true);
    });

    it('verlangt basePrice bei hourly', async () => {
      const { basePrice, ...withoutPrice } = validPayload({
        priceModel: PriceModel.HOURLY,
      });
      const dto = plainToInstance(CreateServiceDto, withoutPrice);
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'basePrice')).toBe(true);
    });

    it('verlangt basePrice bei perTrack', async () => {
      const { basePrice, ...withoutPrice } = validPayload({
        priceModel: PriceModel.PER_TRACK,
      });
      const dto = plainToInstance(CreateServiceDto, withoutPrice);
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'basePrice')).toBe(true);
    });

    it('erlaubt fehlenden basePrice bei inquiry', async () => {
      const { basePrice, ...withoutPrice } = validPayload({
        priceModel: PriceModel.INQUIRY,
      });
      const dto = plainToInstance(CreateServiceDto, withoutPrice);
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'basePrice')).toBe(false);
    });

    it('lehnt negativen basePrice ab', async () => {
      const dto = plainToInstance(
        CreateServiceDto,
        validPayload({ basePrice: -10 }),
      );
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'basePrice')).toBe(true);
    });
  });

  describe('addOns', () => {
    it('akzeptiert gueltige Add-ons', async () => {
      const dto = plainToInstance(
        CreateServiceDto,
        validPayload({
          addOns: [
            { title: 'Express', description: '48h Lieferung', price: 50 },
          ],
        }),
      );
      const errors = await validate(dto);

      expect(errors).toHaveLength(0);
    });

    it('lehnt ein Add-on ohne price ab', async () => {
      const dto = plainToInstance(
        CreateServiceDto,
        validPayload({
          addOns: [{ title: 'Express', description: '48h' }] as never,
        }),
      );
      const errors = await validate(dto);

      expect(errors.some((e) => e.property === 'addOns')).toBe(true);
    });
  });
});
