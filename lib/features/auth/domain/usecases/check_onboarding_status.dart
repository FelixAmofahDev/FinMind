import '../repositories/auth_repository.dart';

class CheckOnboardingStatus {
  const CheckOnboardingStatus(this._repository);

  final AuthRepository _repository;

  Future<bool> call() {
    return _repository.checkOnboardingStatus();
  }
}