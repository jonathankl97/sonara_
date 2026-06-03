import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiClient {
  final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl:
                'http://sonara-alb-1928425664.eu-central-1.elb.amazonaws.com',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              print('REQUEST: ${options.method} ${options.uri}');
              handler.next(options);
            },
            onResponse: (response, handler) {
              print('RESPONSE: ${response.statusCode} ${response.realUri}');
              handler.next(response);
            },
            onError: (error, handler) {
              print('ERROR type: ${error.type}');
              print('ERROR message: ${error.message}');
              print('ERROR error: ${error.error}');
              print('ERROR response: ${error.response}');
              handler.next(error);
            },
          ),
        );

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
}

final apiClient = ApiClient();
