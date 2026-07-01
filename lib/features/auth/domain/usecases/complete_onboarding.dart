import '../entities/auth_session.dart';
import '../entities/onboarding_payload.dart';
import '../repositories/auth_repository.dart';

class CompleteOnboarding {
  const CompleteOnboarding(this._repository);

  final AuthRepository _repository;

  Future<AuthSession> call({required OnboardingPayload payload}) {
    return _repository.completeOnboarding(payload: payload);
  }
}