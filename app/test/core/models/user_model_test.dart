import 'package:flutter_test/flutter_test.dart';
import 'package:sonara/shared/models/user_model.dart';

void main() {
  final fixedDate = DateTime.utc(2024, 1, 15, 10);

  group('UserModel.fromJson', () {
    test('parst ein vollständiges JSON korrekt', () {
      final json = {
        'id': 'user-1',
        'email': 'test@sonara.de',
        'displayName': 'Jona',
        'bio': 'Drummer aus Berlin',
        'city': 'Berlin',
        'address': 'Musterstr. 1',
        'zip': '10115',
        'profileImageUrl': 'https://example.com/img.png',
        'role': 'musician',
        'roles': ['musician'],
        'genres': ['rock', 'jazz'],
        'socialMedia': {'instagram': '@jona', 'spotify': 'jona'},
        'ratingAverage': 4.5,
        'ratingCount': 12,
        'receivedReviews': <Map<String, dynamic>>[],
        'musicTracks': <Map<String, dynamic>>[],
        'createdAt': '2024-01-15T10:00:00.000Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 'user-1');
      expect(user.email, 'test@sonara.de');
      expect(user.displayName, 'Jona');
      expect(user.bio, 'Drummer aus Berlin');
      expect(user.city, 'Berlin');
      expect(user.role, 'musician');
      expect(user.roles, ['musician']);
      expect(user.genres, ['rock', 'jazz']);
      expect(user.socialMedia, {'instagram': '@jona', 'spotify': 'jona'});
      expect(user.ratingAverage, 4.5);
      expect(user.ratingCount, 12);
      expect(user.createdAt, DateTime.parse('2024-01-15T10:00:00.000Z'));
    });

    test('setzt Defaults wenn optionale Listen/Maps fehlen', () {
      final json = {
        'id': 'user-2',
        'email': 'min@sonara.de',
        'role': 'musician',
        'createdAt': '2024-01-15T10:00:00.000Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.displayName, isNull);
      expect(user.bio, isNull);
      expect(user.city, isNull);
      expect(user.roles, isEmpty);
      expect(user.genres, isEmpty);
      expect(user.socialMedia, isEmpty);
      expect(user.receivedReviews, isEmpty);
      expect(user.musicTracks, isEmpty);
    });

    test('ratingAverage als int wird zu double konvertiert', () {
      final json = {
        'id': 'user-3',
        'email': 'r@sonara.de',
        'role': 'musician',
        'ratingAverage': 5,
        'createdAt': '2024-01-15T10:00:00.000Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.ratingAverage, 5.0);
      expect(user.ratingAverage, isA<double>());
    });

    test('ratingAverage und ratingCount defaulten auf 0 wenn null', () {
      final json = {
        'id': 'user-4',
        'email': 'z@sonara.de',
        'role': 'musician',
        'createdAt': '2024-01-15T10:00:00.000Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.ratingAverage, 0.0);
      expect(user.ratingCount, 0);
    });

    test('wirft bei fehlendem Pflichtfeld (id)', () {
      final json = {
        'email': 'x@sonara.de',
        'role': 'musician',
        'createdAt': '2024-01-15T10:00:00.000Z',
      };

      expect(() => UserModel.fromJson(json), throwsA(isA<TypeError>()));
    });
  });

  group('UserModel.toPatchJson', () {
    test('lässt null-Felder weg, behält role/roles/genres/socialMedia', () {
      final user = UserModel(
        id: 'user-1',
        email: 'test@sonara.de',
        role: 'musician',
        createdAt: fixedDate,
      );

      final patch = user.toPatchJson();

      expect(patch.containsKey('displayName'), isFalse);
      expect(patch.containsKey('bio'), isFalse);
      expect(patch.containsKey('city'), isFalse);
      expect(patch['role'], 'musician');
      expect(patch['roles'], isEmpty);
      expect(patch['genres'], isEmpty);
      expect(patch['socialMedia'], isEmpty);
    });

    test('nimmt gesetzte optionale Felder mit auf', () {
      final user = UserModel(
        id: 'user-1',
        email: 'test@sonara.de',
        displayName: 'Jona',
        bio: 'Bio',
        city: 'Berlin',
        role: 'musician',
        createdAt: fixedDate,
      );

      final patch = user.toPatchJson();

      expect(patch['displayName'], 'Jona');
      expect(patch['bio'], 'Bio');
      expect(patch['city'], 'Berlin');
    });
  });

  group('UserModel.copyWith', () {
    test('überschreibt nur die übergebenen Felder', () {
      final base = UserModel(
        id: 'user-1',
        email: 'test@sonara.de',
        displayName: 'Alt',
        role: 'musician',
        createdAt: fixedDate,
      );

      final updated = base.copyWith(displayName: 'Neu');

      expect(updated.displayName, 'Neu');
      expect(updated.email, 'test@sonara.de');
      expect(updated.role, 'musician');
    });

    test('behält id, email und createdAt immer bei', () {
      final base = UserModel(
        id: 'user-1',
        email: 'test@sonara.de',
        displayName: 'Alt',
        role: 'musician',
        createdAt: fixedDate,
      );

      final updated = base.copyWith(displayName: 'Neu', bio: 'frische Bio');

      expect(updated.id, 'user-1');
      expect(updated.email, 'test@sonara.de');
      expect(updated.createdAt, fixedDate);
      expect(updated.bio, 'frische Bio');
    });
  });
}
