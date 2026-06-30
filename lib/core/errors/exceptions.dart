class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final int? code;

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

class ServerException extends AppException {
  const ServerException(super.message, {super.code});
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}
