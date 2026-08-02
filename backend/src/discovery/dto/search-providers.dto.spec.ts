import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { SearchProvidersDto } from './search-providers.dto';
import { ServiceType, ServiceLocation } from '../../services/service.entity';

function validPayload(overrides: Partial<SearchProvidersDto> = {}) {
  return {
    serviceType: ServiceType.MIXING,
    genres: 'hiphop,pop',
    location: ServiceLocation.REMOTE,
    minPrice: 50,
    maxPrice: 200,
    city: 'Berlin',
    page: 1,
    limit: 20,
    ...overrides,
  };
}

describe('SearchProvidersDto', () => {
  it('akzeptiert ein vollstaendig gueltiges Payload', async () => {
    const dto = plainToInstance(SearchProvidersDto, validPayload());
    const errors = await validate(dto);
    expect(errors).toHaveLength(0);
  });

  it('akzeptiert ein komplett leeres Payload (alle Filter optional)', async () => {
    const dto = plainToInstance(SearchProvidersDto, {});
    const errors = await validate(dto);
    expect(errors).toHaveLength(0);
  });

  it('lehnt ungueltigen serviceType ab', async () => {
    const dto = plainToInstance(
      SearchProvidersDto,
      validPayload({ serviceType: 'beatboxing' as ServiceType }),
    );
    const errors = await validate(dto);
    expect(errors.some((e) => e.property === 'serviceType')).toBe(true);
  });

  it('lehnt ungueltigen location ab', async () => {
    const dto = plainToInstance(
      SearchProvidersDto,
      validPayload({ location: 'mars' as ServiceLocation }),
    );
    const errors = await validate(dto);
    expect(errors.some((e) => e.property === 'location')).toBe(true);
  });

  it('lehnt negativen minPrice ab', async () => {
    const dto = plainToInstance(
      SearchProvidersDto,
      validPayload({ minPrice: -10 }),
    );
    const errors = await validate(dto);
    expect(errors.some((e) => e.property === 'minPrice')).toBe(true);
  });

  it('lehnt page < 1 ab', async () => {
    const dto = plainToInstance(SearchProvidersDto, validPayload({ page: 0 }));
    const errors = await validate(dto);
    expect(errors.some((e) => e.property === 'page')).toBe(true);
  });

  it('lehnt limit > 100 ab', async () => {
    const dto = plainToInstance(
      SearchProvidersDto,
      validPayload({ limit: 101 }),
    );
    const errors = await validate(dto);
    expect(errors.some((e) => e.property === 'limit')).toBe(true);
  });

  it('transformiert String-Zahlen aus Query-Params korrekt', async () => {
    const dto = plainToInstance(SearchProvidersDto, {
      minPrice: '50',
      maxPrice: '200',
      page: '2',
      limit: '10',
    });
    const errors = await validate(dto);
    expect(errors).toHaveLength(0);
    expect(dto.minPrice).toBe(50);
    expect(dto.page).toBe(2);
  });
});
