import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'failures.dart';

class ErrorMapper {
  const ErrorMapper._();

  static Failure fromDioError(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final message = _extractMessage(response?.data) ?? error.message ?? 'Unexpected network error';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return NetworkFailure(message: message, code: statusCode);
      case DioExceptionType.badResponse:
        return ServerFailure(message: message, code: statusCode);
      case DioExceptionType.cancel:
        return NetworkFailure(message: 'Request cancelled', code: statusCode);
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return NetworkFailure(message: message, code: statusCode);
    }
  }

  static Failure fromException(AppException exception) {
    return switch (exception) {
      ServerException(:final message, :final code) => ServerFailure(message: message, code: code),
      NetworkException(:final message, :final code) => NetworkFailure(message: message, code: code),
      CacheException(:final message, :final code) => CacheFailure(message: message, code: code),
      AppException(:final message, :final code) => ServerFailure(message: message, code: code),
    };
  }

  static String? _extractMessage(Object? data) {
    if (data is Map<String, dynamic>) {
      final dynamic message = data['message'] ?? data['error'] ?? data['detail'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    return null;
  }
}
