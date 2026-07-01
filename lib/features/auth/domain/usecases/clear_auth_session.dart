import '../repositories/auth_repository.dart';

class ClearAuthSession {
  const ClearAuthSession(this._repository);

  final AuthRepository _repository;

  Future<void> call() {
    return _repository.clearSession();
  }
}