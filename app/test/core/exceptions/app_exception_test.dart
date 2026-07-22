import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonara/core/exceptions/app_exception.dart';

void main() {
  final requestOptions = RequestOptions(path: '/test');

  group('AppException.fromDioException', () {
    test('connectionTimeout wird zu network', () {
      final dioException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionTimeout,
      );

      final result = AppException.fromDioException(dioException);

      expect(result.type, AppErrorType.network);
    });

    test('connectionError wird zu network', () {
      final dioException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionError,
      );

      final result = AppException.fromDioException(dioException);

      expect(result.type, AppErrorType.network);
    });

    test('badResponse 401 wird zu unauthorized', () {
      final dioException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
      );

      final result = AppException.fromDioException(dioException);

      expect(result.type, AppErrorType.unauthorized);
    });

    test('badResponse 404 wird zu notFound', () {
      final dioException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 404,
        ),
      );

      final result = AppException.fromDioException(dioException);

      expect(result.type, AppErrorType.notFound);
    });

    test('badResponse 500 wird zu server', () {
      final dioException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 500,
        ),
      );

      final result = AppException.fromDioException(dioException);

      expect(result.type, AppErrorType.server);
    });

    test('badResponse mit unerwartetem Statuscode wird zu unknown', () {
      final dioException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 418,
        ),
      );

      final result = AppException.fromDioException(dioException);

      expect(result.type, AppErrorType.unknown);
    });

    test('toString gibt die Nachricht zurück', () {
      const exception = AppException(
        type: AppErrorType.network,
        message: 'Keine Verbindung.',
      );

      expect(exception.toString(), 'Keine Verbindung.');
    });
  });
}
