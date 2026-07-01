import '../repositories/auth_repository.dart';

class ResendVerification {
  const ResendVerification(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String email}) {
    return _repository.resendVerification(email: email);
  }
}