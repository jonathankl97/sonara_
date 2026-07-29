import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sonara/core/exceptions/app_exception.dart';
import 'package:sonara/core/network/api_client.dart';
import 'package:sonara/features/rooms/data/enums/room_enums.dart';
import 'package:sonara/features/rooms/data/models/room_model.dart';
import 'package:sonara/features/rooms/data/repositories/room_repository.dart';
import 'package:sonara/shared/enums/booking_mode.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late RoomRepository repository;

  setUp(() {
    mockApiClient = MockApiClient();
    repository = RoomRepository(mockApiClient);
  });

  final roomJson = {
    'id': 'room-1',
    'providerId': 'provider-1',
    'name': 'Studio A',
    'description': 'Aufnahmeraum',
    'roomType': 'recordingStudio',
    'priceModel': 'hourly',
    'bookingMode': 'onRequest',
    'basePrice': '60.00',
    'address': 'Musterstrasse 13',
    'city': 'Berlin',
    'zip': '10115',
    'state': 'Berlin',
    'country': 'Deutschland',
    'createdAt': '2024-01-15T10:00:00.000Z',
  };

  group('RoomRepository.createRoom', () {
    test('ruft POST /rooms und parst die Antwort', () async {
      final room = RoomModel(
        name: 'Studio A',
        description: 'Aufnahmeraum',
        roomType: RoomType.recordingStudio,
        priceModel: RoomPriceModel.hourly,
        bookingMode: BookingMode.onRequest,
        basePrice: 60,
        address: 'Musterstrasse 13',
        city: 'Berlin',
        zip: '10115',
        state: 'Berlin',
        country: 'Deutschland',
      );

      when(
        () => mockApiClient.post('/rooms', data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rooms'),
          data: roomJson,
          statusCode: 201,
        ),
      );

      final result = await repository.createRoom(room);

      expect(result.id, 'room-1');
      expect(result.name, 'Studio A');
      expect(result.basePrice, 60.0);
      verify(
        () => mockApiClient.post('/rooms', data: any(named: 'data')),
      ).called(1);
    });

    test('wirft AppException bei Fehler', () async {
      final room = RoomModel(
        name: 'Test',
        description: 'Test',
        roomType: RoomType.other,
        priceModel: RoomPriceModel.hourly,
        bookingMode: BookingMode.onRequest,
        basePrice: 40,
        address: 'A',
        city: 'B',
        zip: '00000',
        state: 'C',
        country: 'D',
      );

      when(
        () => mockApiClient.post('/rooms', data: any(named: 'data')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/rooms'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/rooms'),
            statusCode: 400,
          ),
        ),
      );

      expect(() => repository.createRoom(room), throwsA(isA<AppException>()));
    });
  });

  group('RoomRepository.fetchMyRooms', () {
    test('ruft GET /rooms/me und parst die Liste', () async {
      when(() => mockApiClient.get('/rooms/me')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rooms/me'),
          data: [roomJson, roomJson],
          statusCode: 200,
        ),
      );

      final result = await repository.fetchMyRooms();

      expect(result, hasLength(2));
      expect(result.first.id, 'room-1');
      verify(() => mockApiClient.get('/rooms/me')).called(1);
    });

    test('gibt leere Liste zurueck wenn keine Rooms', () async {
      when(() => mockApiClient.get('/rooms/me')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rooms/me'),
          data: [],
          statusCode: 200,
        ),
      );

      final result = await repository.fetchMyRooms();

      expect(result, isEmpty);
    });
  });

  group('RoomRepository.updateRoom', () {
    test('ruft PATCH /rooms/:id und parst die Antwort', () async {
      when(
        () => mockApiClient.patch('/rooms/room-1', data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rooms/room-1'),
          data: {...roomJson, 'name': 'Neuer Name'},
          statusCode: 200,
        ),
      );

      final result = await repository.updateRoom('room-1', {
        'name': 'Neuer Name',
      });

      expect(result.name, 'Neuer Name');
    });
  });

  group('RoomRepository.deleteRoom', () {
    test('ruft DELETE /rooms/:id', () async {
      when(() => mockApiClient.delete('/rooms/room-1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rooms/room-1'),
          statusCode: 200,
        ),
      );

      await repository.deleteRoom('room-1');

      verify(() => mockApiClient.delete('/rooms/room-1')).called(1);
    });

    test('wirft AppException bei Fehler', () async {
      when(() => mockApiClient.delete('/rooms/room-1')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/rooms/room-1'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/rooms/room-1'),
            statusCode: 403,
          ),
        ),
      );

      expect(
        () => repository.deleteRoom('room-1'),
        throwsA(isA<AppException>()),
      );
    });
  });
}
