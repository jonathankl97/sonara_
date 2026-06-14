import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/core/models/user_model.dart';
import 'package:sonara/core/network/api_client.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  Future<UserModel?> fetchMe() async {
    final response = await _apiClient.get('/auth/me');
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    await _apiClient.patch('/users/me', data: data);
  }

  Future<void> addMusicTrack(String spotifyUrl, String? appleMusicUrl) async {
    await _apiClient.post(
      '/spotify/tracks',
      data: {'spotifyUrl': spotifyUrl, 'appleMusicUrl': appleMusicUrl},
    );
  }

  Future<void> removeMusicTrack(
    List<Map<String, dynamic>> updatedTracks,
  ) async {
    await _apiClient.patch('/users/me', data: {'musicTracks': updatedTracks});
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(apiClient);
});
