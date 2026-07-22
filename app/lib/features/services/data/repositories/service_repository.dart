import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/core/exceptions/app_exception.dart';
import 'package:sonara/core/models/service_model.dart';
import 'package:sonara/core/network/api_client.dart';

class ServiceRepository {
  final ApiClient _apiClient;

  ServiceRepository(this._apiClient);

  Future<ServiceModel> createService(ServiceModel service) async {
    try {
      final response = await _apiClient.post(
        '/services',
        data: service.toCreateJson(),
      );
      return ServiceModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<List<ServiceModel>> fetchMyServices() async {
    try {
      final response = await _apiClient.get('/services/me');
      final list = response.data as List<dynamic>;
      return list
          .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<ServiceModel> updateService(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _apiClient.patch('/services/$id', data: updates);
      return ServiceModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<void> deleteService(String id) async {
    try {
      await _apiClient.delete('/services/$id');
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }
}

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository(apiClient);
});
