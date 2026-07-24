import 'package:dio/dio.dart';
import 'package:sonara/core/exceptions/app_exception.dart';
import 'package:sonara/core/network/api_client.dart';

class SpotifyRepository {
  final ApiClient _apiClient;

  SpotifyRepository(this._apiClient);

  Future<void> addTrack(String spotifyUrl, String? appleMusicUrl) async {
    try {
      await _apiClient.post(
        '/spotify/tracks',
        data: {'spotifyUrl': spotifyUrl, 'appleMusicUrl': appleMusicUrl},
      );
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<void> removeTrack(List<dynamic> updatedTracks) async {
    // ← FIX: trackId entfernt
    try {
      await _apiClient.patch('/users/me', data: {'musicTracks': updatedTracks});
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }
}
