import 'package:sonara/core/network/api_client.dart';

class SpotifyRepository {
  final ApiClient _apiClient;

  SpotifyRepository(this._apiClient);

  Future<void> addTrack(String spotifyUrl, String? appleMusicUrl) async {
    await _apiClient.post('/spotify/tracks', data: {
      'spotifyUrl': spotifyUrl,
      'appleMusicUrl': appleMusicUrl,
    });
  }

  Future<void> removeTrack(String trackId, List<dynamic> updatedTracks) async {
    await _apiClient.patch('/users/me', data: {'musicTracks': updatedTracks});
  }
}