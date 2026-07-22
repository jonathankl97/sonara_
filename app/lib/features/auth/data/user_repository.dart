import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/core/exceptions/app_exception.dart';
import 'package:sonara/shared/models/user_model.dart';
import 'package:sonara/core/network/api_client.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  Future<UserModel?> fetchMe() async {
    try {
      final response = await _apiClient.get('/auth/me');
      final data = response.data;
      if (data == null || data is! Map) return null;
      return UserModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    try {
      await _apiClient.patch('/users/me', data: data);
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<void> addMusicTrack(String spotifyUrl, String? appleMusicUrl) async {
    try {
      await _apiClient.post(
        '/spotify/tracks',
        data: {'spotifyUrl': spotifyUrl, 'appleMusicUrl': appleMusicUrl},
      );
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<void> removeMusicTrack(
    List<Map<String, dynamic>> updatedTracks,
  ) async {
    try {
      await _apiClient.patch('/users/me', data: {'musicTracks': updatedTracks});
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(apiClient);
});
