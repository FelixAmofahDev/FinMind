import 'package:dartz/dartz.dart';
import 'package:finmind/core/errors/failures.dart';

import '../entities/auth_session.dart';
import '../entities/signup_draft.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> signup(SignupDraft draft);

  Future<Either<Failure, AuthSession>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthSession>> verifyEmail({
    required String email,
    required String code,
  });

  Future<Either<Failure, void>> resendVerification({required String email});

  Future<Either<Failure, void>> saveAuthSession(AuthSession session);

  Future<Either<Failure, AuthSession?>> getAuthSession();

  Future<Either<Failure, void>> clearAuthSession();

  Future<Either<Failure, bool>> checkOnboardingStatus();
}