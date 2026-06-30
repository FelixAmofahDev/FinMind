sealed class Failure {
  const Failure({required this.message, this.code});

  final String message;
  final int? code;

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}
