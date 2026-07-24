import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sonara/core/config/app_config.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio =
        Dio(
            BaseOptions(
              baseUrl: AppConfig.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          )
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) => handler.next(options),
              onResponse: (response, handler) => handler.next(response),
              onError: (error, handler) => handler.next(error),
            ),
          );
  }

  Future<Response<dynamic>> get(String path) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    return _dio.get(
      path,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Response<dynamic>> post(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    return _dio.post(
      path,
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Response<dynamic>> patch(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    return _dio.patch(
      path,
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Response<dynamic>> delete(String path) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    return _dio.delete(
      path,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
  }
}

final apiClient = ApiClient();
