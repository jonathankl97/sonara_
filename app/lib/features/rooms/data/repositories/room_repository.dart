import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/core/exceptions/app_exception.dart';
import 'package:sonara/core/network/api_client.dart';
import 'package:sonara/features/rooms/data/models/room_model.dart';

class RoomRepository {
  final ApiClient _apiClient;

  RoomRepository(this._apiClient);

  Future<RoomModel> createRoom(RoomModel room) async {
    try {
      final response = await _apiClient.post(
        '/rooms',
        data: room.toCreateJson(),
      );
      return RoomModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<List<RoomModel>> fetchMyRooms() async {
    try {
      final response = await _apiClient.get('/rooms/me');
      final list = response.data as List<dynamic>;
      return list
          .map((json) => RoomModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<RoomModel> updateRoom(String id, Map<String, dynamic> updates) async {
    try {
      final response = await _apiClient.patch('/rooms/$id', data: updates);
      return RoomModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<void> deleteRoom(String id) async {
    try {
      await _apiClient.delete('/rooms/$id');
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }
}

final roomRepositoryProvider = Provider<RoomRepository>((ref) {
  return RoomRepository(ref.read(apiClientProvider));
});
