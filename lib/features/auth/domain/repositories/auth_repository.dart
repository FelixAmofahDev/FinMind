import '../entities/auth_session.dart';
import '../entities/onboarding_payload.dart';
import '../entities/signup_payload.dart';

abstract class AuthRepository {
  Future<String> signup({required SignupPayload payload});

  Future<void> resendVerification({required String email});

  Future<AuthSession> verifyEmail({required String email, required String code});

  Future<AuthSession> login({required String email, required String password});

  Future<AuthSession> completeOnboarding({required OnboardingPayload payload});

  Future<void> saveAuthSession(AuthSession session);

  Future<AuthSession?> restoreSession();

  Future<bool> checkOnboardingStatus();

  Future<void> clearSession();
}