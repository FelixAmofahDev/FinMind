import 'package:dartz/dartz.dart';
import 'package:finmind/core/errors/failures.dart';

import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class VerifyEmail {
  const VerifyEmail(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthSession>> call({
    required String email,
    required String code,
  }) {
    return _repository.verifyEmail(email: email, code: code);
  }
}