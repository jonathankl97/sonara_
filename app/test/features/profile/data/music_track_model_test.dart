import 'package:flutter_test/flutter_test.dart';
import 'package:sonara/features/profile/data/music_track_model.dart';

void main() {
  final trackJson = {
    'id': 'track-1',
    'name': 'Lose Yourself',
    'artists': ['Eminem'],
    'albumImage': 'https://example.com/album.jpg',
    'spotifyUrl': 'https://open.spotify.com/track/123',
    'appleMusicUrl': 'https://music.apple.com/track/123',
  };

  group('MusicTrackModel.fromJson', () {
    test('parst ein vollstaendiges JSON korrekt', () {
      final track = MusicTrackModel.fromJson(trackJson);

      expect(track.id, 'track-1');
      expect(track.name, 'Lose Yourself');
      expect(track.artists, ['Eminem']);
      expect(track.albumImage, 'https://example.com/album.jpg');
      expect(track.spotifyUrl, 'https://open.spotify.com/track/123');
      expect(track.appleMusicUrl, 'https://music.apple.com/track/123');
    });

    test('appleMusicUrl kann null sein', () {
      final json = {...trackJson, 'appleMusicUrl': null};
      final track = MusicTrackModel.fromJson(json);

      expect(track.appleMusicUrl, isNull);
    });

    test('artists werden korrekt geparst', () {
      final json = {
        ...trackJson,
        'artists': ['Eminem', 'Dr. Dre'],
      };
      final track = MusicTrackModel.fromJson(json);

      expect(track.artists, hasLength(2));
      expect(track.artists, contains('Dr. Dre'));
    });
  });

  group('MusicTrackModel.toJson', () {
    test('erzeugt korrektes JSON mit allen Feldern', () {
      const track = MusicTrackModel(
        id: 'track-1',
        name: 'Lose Yourself',
        artists: ['Eminem'],
        albumImage: 'https://example.com/album.jpg',
        spotifyUrl: 'https://open.spotify.com/track/123',
        appleMusicUrl: 'https://music.apple.com/track/123',
      );

      final json = track.toJson();

      expect(json['id'], 'track-1');
      expect(json['name'], 'Lose Yourself');
      expect(json['artists'], ['Eminem']);
      expect(json['albumImage'], 'https://example.com/album.jpg');
      expect(json['spotifyUrl'], 'https://open.spotify.com/track/123');
      expect(json['appleMusicUrl'], 'https://music.apple.com/track/123');
    });

    test('appleMusicUrl null wird korrekt serialisiert', () {
      const track = MusicTrackModel(
        id: 'track-1',
        name: 'Test',
        artists: ['Test'],
        albumImage: 'https://example.com/img.jpg',
        spotifyUrl: 'https://spotify.com/track',
      );

      final json = track.toJson();

      expect(json['appleMusicUrl'], isNull);
    });

    test('fromJson und toJson sind symmetrisch', () {
      final original = MusicTrackModel.fromJson(trackJson);
      final json = original.toJson();
      final restored = MusicTrackModel.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.artists, original.artists);
      expect(restored.albumImage, original.albumImage);
      expect(restored.spotifyUrl, original.spotifyUrl);
      expect(restored.appleMusicUrl, original.appleMusicUrl);
    });
  });
}
