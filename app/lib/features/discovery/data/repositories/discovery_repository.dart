import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/core/exceptions/app_exception.dart';
import 'package:sonara/core/network/api_client.dart';
import 'package:sonara/features/discovery/data/models/paginated_result.dart';
import 'package:sonara/features/discovery/data/models/provider_detail_model.dart';
import 'package:sonara/features/discovery/data/models/provider_search_result.dart';
import 'package:sonara/features/discovery/data/models/room_detail_model.dart';
import 'package:sonara/features/discovery/data/models/room_search_result.dart';

class DiscoveryRepository {
  final ApiClient _apiClient;

  DiscoveryRepository(this._apiClient);

  Future<PaginatedResult<ProviderSearchResult>> searchProviders({
    String? serviceType,
    String? genres,
    String? location,
    double? minPrice,
    double? maxPrice,
    String? city,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'serviceType': ?serviceType,
        'genres': ?genres,
        'location': ?location,
        'minPrice': ?minPrice,
        'maxPrice': ?maxPrice,
        'city': ?city,
      };

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');

      final response = await _apiClient.get(
        '/discovery/providers?$queryString',
      );
      final json = response.data as Map<String, dynamic>;

      return PaginatedResult(
        data: (json['data'] as List<dynamic>)
            .map(
              (e) => ProviderSearchResult.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        total: json['total'] as int,
        page: json['page'] as int,
        limit: json['limit'] as int,
      );
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<PaginatedResult<RoomSearchResult>> searchRooms({
    String? roomType,
    String? city,
    double? minPrice,
    double? maxPrice,
    int? capacity,
    String? amenities,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'roomType': ?roomType,
        'city': ?city,
        'minPrice': ?minPrice,
        'maxPrice': ?maxPrice,
        'capacity': ?capacity,
        'amenities': ?amenities,
      };

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');

      final response = await _apiClient.get('/discovery/rooms?$queryString');
      final json = response.data as Map<String, dynamic>;

      return PaginatedResult(
        data: (json['data'] as List<dynamic>)
            .map((e) => RoomSearchResult.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: json['total'] as int,
        page: json['page'] as int,
        limit: json['limit'] as int,
      );
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<RoomDetailModel> fetchRoomDetail(String id) async {
    try {
      final response = await _apiClient.get('/discovery/rooms/$id');
      return RoomDetailModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<ProviderDetailModel> fetchProviderDetail(String id) async {
    try {
      final response = await _apiClient.get('/discovery/providers/$id');
      return ProviderDetailModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }
}

final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  return DiscoveryRepository(ref.read(apiClientProvider));
});
