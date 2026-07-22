import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sonara/core/network/api_client.dart';
import 'package:sonara/features/auth/data/user_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late UserRepository repository;

  setUp(() {
    mockApiClient = MockApiClient();
    repository = UserRepository(mockApiClient);
  });

  final userJson = {
    'id': 'user-1',
    'email': 'test@sonara.de',
    'displayName': 'Jona',
    'role': 'musician',
    'createdAt': '2024-01-15T10:00:00.000Z',
  };

  group('UserRepository.fetchMe', () {
    test('ruft GET /auth/me und parst die Antwort zu UserModel', () async {
      when(() => mockApiClient.get('/auth/me')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/me'),
          data: userJson,
          statusCode: 200,
        ),
      );

      final user = await repository.fetchMe();

      expect(user, isNotNull);
      expect(user!.id, 'user-1');
      expect(user.email, 'test@sonara.de');
      expect(user.displayName, 'Jona');
      verify(() => mockApiClient.get('/auth/me')).called(1);
    });
  });

  group('UserRepository.updateUser', () {
    test('ruft PATCH /users/me mit den übergebenen Daten', () async {
      final data = {'displayName': 'Neuer Name', 'bio': 'Neue Bio'};
      when(() => mockApiClient.patch('/users/me', data: data)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/users/me'),
          statusCode: 200,
        ),
      );

      await repository.updateUser(data);

      verify(() => mockApiClient.patch('/users/me', data: data)).called(1);
    });
  });

  group('UserRepository.addMusicTrack', () {
    test('ruft POST /spotify/tracks mit den URLs', () async {
      when(
        () => mockApiClient.post(
          '/spotify/tracks',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/spotify/tracks'),
          statusCode: 201,
        ),
      );

      await repository.addMusicTrack('https://spotify/x', 'https://apple/y');

      final captured = verify(
        () => mockApiClient.post(
          '/spotify/tracks',
          data: captureAny(named: 'data'),
        ),
      ).captured.single as Map<String, dynamic>;

      expect(captured['spotifyUrl'], 'https://spotify/x');
      expect(captured['appleMusicUrl'], 'https://apple/y');
    });
  });
}
