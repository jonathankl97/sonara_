import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sonara/core/exceptions/app_exception.dart';
import 'package:sonara/core/network/api_client.dart';
import 'package:sonara/features/services/data/enums/service_enums.dart';
import 'package:sonara/features/services/data/models/service_model.dart';
import 'package:sonara/features/services/data/repositories/service_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late ServiceRepository repository;

  setUp(() {
    mockApiClient = MockApiClient();
    repository = ServiceRepository(mockApiClient);
  });

  final serviceJson = {
    'id': 'service-1',
    'providerId': 'provider-1',
    'title': 'Mixing',
    'description': 'Pro mix',
    'serviceType': 'mixing',
    'location': 'remote',
    'priceModel': 'fixed',
    'bookingMode': 'onRequest',
    'basePrice': '150.00',
    'createdAt': '2024-01-15T10:00:00.000Z',
  };

  group('ServiceRepository.createService', () {
    test('ruft POST /services und parst die Antwort', () async {
      final service = ServiceModel(
        title: 'Mixing',
        description: 'Pro mix',
        serviceType: ServiceType.mixing,
        location: ServiceLocation.remote,
        priceModel: PriceModel.fixed,
        bookingMode: BookingMode.onRequest,
        basePrice: 150,
      );

      when(
        () => mockApiClient.post('/services', data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/services'),
          data: serviceJson,
          statusCode: 201,
        ),
      );

      final result = await repository.createService(service);

      expect(result.id, 'service-1');
      expect(result.title, 'Mixing');
      verify(
        () => mockApiClient.post('/services', data: any(named: 'data')),
      ).called(1);
    });

    test('wirft AppException bei Fehler', () async {
      final service = ServiceModel(
        title: 'Mixing',
        description: 'Pro mix',
        serviceType: ServiceType.mixing,
        location: ServiceLocation.remote,
        priceModel: PriceModel.fixed,
        bookingMode: BookingMode.onRequest,
      );

      when(
        () => mockApiClient.post('/services', data: any(named: 'data')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/services'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/services'),
            statusCode: 400,
          ),
        ),
      );

      expect(
        () => repository.createService(service),
        throwsA(isA<AppException>()),
      );
    });
  });

  group('ServiceRepository.fetchMyServices', () {
    test('ruft GET /services/me und parst die Liste', () async {
      when(() => mockApiClient.get('/services/me')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/services/me'),
          data: [serviceJson, serviceJson],
          statusCode: 200,
        ),
      );

      final result = await repository.fetchMyServices();

      expect(result, hasLength(2));
      expect(result.first.id, 'service-1');
      verify(() => mockApiClient.get('/services/me')).called(1);
    });

    test('gibt leere Liste zurueck wenn keine Services', () async {
      when(() => mockApiClient.get('/services/me')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/services/me'),
          data: [],
          statusCode: 200,
        ),
      );

      final result = await repository.fetchMyServices();

      expect(result, isEmpty);
    });
  });

  group('ServiceRepository.updateService', () {
    test('ruft PATCH /services/:id und parst die Antwort', () async {
      when(
        () => mockApiClient.patch(
          '/services/service-1',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/services/service-1'),
          data: {...serviceJson, 'title': 'Neuer Titel'},
          statusCode: 200,
        ),
      );

      final result = await repository.updateService('service-1', {
        'title': 'Neuer Titel',
      });

      expect(result.title, 'Neuer Titel');
    });
  });

  group('ServiceRepository.deleteService', () {
    test('ruft DELETE /services/:id', () async {
      when(() => mockApiClient.delete('/services/service-1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/services/service-1'),
          statusCode: 200,
        ),
      );

      await repository.deleteService('service-1');

      verify(() => mockApiClient.delete('/services/service-1')).called(1);
    });

    test('wirft AppException bei Fehler', () async {
      when(() => mockApiClient.delete('/services/service-1')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/services/service-1'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/services/service-1'),
            statusCode: 403,
          ),
        ),
      );

      expect(
        () => repository.deleteService('service-1'),
        throwsA(isA<AppException>()),
      );
    });
  });
}
