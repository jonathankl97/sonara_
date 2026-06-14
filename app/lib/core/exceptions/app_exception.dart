import 'package:dio/dio.dart';

enum AppErrorType {
  network,
  unauthorized,
  notFound,
  server,
  unknown,
}

class AppException implements Exception {
  final AppErrorType type;
  final String message;

  const AppException({
    required this.type,
    required this.message,
  });

  factory AppException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        return const AppException(
          type: AppErrorType.network,
          message: 'Keine Verbindung. Bitte überprüfe deine Internetverbindung.',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return const AppException(
            type: AppErrorType.unauthorized,
            message: 'Nicht autorisiert. Bitte melde dich erneut an.',
          );
        } else if (statusCode == 404) {
          return const AppException(
            type: AppErrorType.notFound,
            message: 'Ressource nicht gefunden.',
          );
        } else if (statusCode != null && statusCode >= 500) {
          return const AppException(
            type: AppErrorType.server,
            message: 'Serverfehler. Bitte versuche es später erneut.',
          );
        }
        return const AppException(
          type: AppErrorType.unknown,
          message: 'Ein unbekannter Fehler ist aufgetreten.',
        );
      default:
        return const AppException(
          type: AppErrorType.unknown,
          message: 'Ein unbekannter Fehler ist aufgetreten.',
        );
    }
  }

  @override
  String toString() => message;
}